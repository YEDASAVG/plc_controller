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

pub async fn set_relay(ip: String, index: u16, value: bool) -> Result<(), String> {
    let socket_addr: SocketAddr = ip
    .parse()
    .map_err(|e| format!("Invalid IP address: {}", e))?;

    let mut ctx = tcp::connect(socket_addr)
    .await
    .map_err(|e| format!("Connection failed: {}", e))?;

    let register_address = 1024 + index; // %MW0 = 1024, %MW1 = 1025, etc. most imp
    let register_value: u16 = if value { 1 } else { 0 };

    ctx.write_single_register(register_address, register_value)
    .await
    .map_err(|e| format!("Write failed: {}", e))?
    .map_err(|e| format!("Modbus Exception: {:?}", e))?;
    Ok(())
}

// read the state of multiple relays 

pub async fn read_relays(ip: String, count: u16) -> Result<Vec<bool>, String> {
    let socket_addr: SocketAddr = ip
    .parse()
    .map_err(|e| format!("Invalid IP address: {}", e))?;

    let mut ctx = tcp::connect(socket_addr)
    .await
    .map_err(|e| format!("Connection failed: {}", e))?;

    let response = ctx.read_holding_registers(1028, count)  // %MW4-7 = actual state feedback
    .await
    .map_err(|e| format!("Read failed: {}", e))?
    .map_err(|e| format!("Modbus exception: {:?}", e))?;

    // Convert register values (u16) to booleans: 0=false, anything else=true
    let states: Vec<bool> = response.iter().map(|v| *v > 0).collect();
    Ok(states)
}