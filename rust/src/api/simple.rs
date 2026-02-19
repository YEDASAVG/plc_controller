use tokio_modbus::prelude::*;
use tokio_modbus::client::tcp;
use std::net::SocketAddr;

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}

// test function -verifying the FFI works
#[flutter_rust_bridge::frb(sync)] // Synchronous mode for simplicity of the demo
pub fn greet(name: String) -> String {
    format!("Hello, {}! Controller is ready", name)
}

pub async fn set_coil(ip: String, address: u16, value: bool) -> Result<(), String> {
    let socket_addr: SocketAddr = ip
    .parse()
    .map_err(|e| format!("Invalid IP address: {}", e))?;

    let mut ctx = tcp::connect(socket_addr)
    .await
    .map_err(|e| format!("Connection failed: {}", e))?;

    ctx.write_single_coil(address, value)
    .await
    .map_err(|e| format!("Write failed: {}", e))?
    .map_err(|e| format!("Modbus exception: {:?}", e))?;
    Ok(())
}

// read the state of multiple relays 

pub async fn read_coils(ip: String, start: u16, count: u16) -> Result<Vec<bool>, String> {
    let socket_addr: SocketAddr = ip
    .parse()
    .map_err(|e| format!("Invalid IP address: {}", e))?;

    let mut ctx = tcp::connect(socket_addr)
    .await
    .map_err(|e| format!("Connection failed: {}", e))?;

    let response = ctx.read_coils(start, count)
    .await
    .map_err(|e| format!("Read failed: {}", e))?
    .map_err(|e| format!("Modbus exception: {:?}", e))?;

    Ok(response)
}