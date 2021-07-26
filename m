Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D4B3D688A
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 23:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233468AbhGZUjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 16:39:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232788AbhGZUjo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 16:39:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1023760F94;
        Mon, 26 Jul 2021 21:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627334413;
        bh=G1p25avqGfyWyg8DRY7MOjFOMVYQc0IHpJA9Sl0ihSg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QqillQYygjstWVA6oc8RP2vDz+e6ccZAvxrw/r1SqIC3pn5Hy/NCPfB871DpQ1ExM
         jzE3cpNyT5S6YL+kh8/UA/iYM2xaAgzVn7lnQWldHWP7S9+OyFdAOVkNKDz7yDwYTJ
         ADaf2vzt4AE3ulU7d/UoX0h3mZWU2xJ3BVl/ifrB7NDYbNxP6zhL381Z4JNbKc268p
         HAEJZiIEWzapX+hLsotY37ryCCFFpZqgNDLN4oTV623UAJ0QnnR1ZfWTWtrv7VlOGD
         n2JGaZox41N4raTsVnTdfioRFsAo2uuFl2/K4LpjG6h8KiohNwRe1YjHH1vBwJsOJm
         FFy9PMLovvGKw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0429C60972;
        Mon, 26 Jul 2021 21:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can-next 2021-07-25
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162733441301.18684.10819552730140170023.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Jul 2021 21:20:13 +0000
References: <20210726141144.862529-1-mkl@pengutronix.de>
In-Reply-To: <20210726141144.862529-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Mon, 26 Jul 2021 16:10:58 +0200 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 46 patches for net-next/master.
> 
> The first 6 patches target the CAN J1939 protocol. One is from
> gushengxian, fixing a grammatical error, 5 are by me fixing a checkpatch
> warning, make use of the fallthrough pseudo-keyword, and use
> consistent variable naming.
> 
> [...]

Here is the summary with links:
  - pull-request: can-next 2021-07-25
    https://git.kernel.org/netdev/net-next/c/d20e5880fe9d
  - [net-next,02/46] can: j1939: fix checkpatch warnings
    https://git.kernel.org/netdev/net-next/c/333128737955
  - [net-next,03/46] can: j1939: replace fall through comment by fallthrough pseudo-keyword
    https://git.kernel.org/netdev/net-next/c/641ba6ded234
  - [net-next,04/46] can: j1939: j1939_session_completed(): use consistent name se_skb for the session skb
    https://git.kernel.org/netdev/net-next/c/7ac56e40d054
  - [net-next,05/46] can: j1939: j1939_session_tx_dat(): use consistent name se_skcb for session skb control buffer
    https://git.kernel.org/netdev/net-next/c/78b77c760f71
  - [net-next,06/46] can: j1939: j1939_xtp_rx_dat_one(): use separate pointer for session skb control buffer
    https://git.kernel.org/netdev/net-next/c/a08ec5fe709f
  - [net-next,07/46] can: rx-offload: add skb queue for use during ISR
    https://git.kernel.org/netdev/net-next/c/c757096ea103
  - [net-next,08/46] can: rx-offload: can_rx_offload_irq_finish(): directly call napi_schedule()
    https://git.kernel.org/netdev/net-next/c/1e0d8e507ea4
  - [net-next,09/46] can: rx-offload: can_rx_offload_threaded_irq_finish(): add new function to be called from threaded interrupt
    https://git.kernel.org/netdev/net-next/c/30bfec4fec59
  - [net-next,10/46] can: bittiming: fix documentation for struct can_tdc
    https://git.kernel.org/netdev/net-next/c/8345a3307381
  - [net-next,11/46] can: netlink: clear data_bittiming if FD is turned off
    https://git.kernel.org/netdev/net-next/c/e3b0a4a47064
  - [net-next,12/46] can: netlink: remove redundant check in can_validate()
    https://git.kernel.org/netdev/net-next/c/6b6bd1999267
  - [net-next,13/46] dt-bindings: net: can: Document transceiver implementation as phy
    https://git.kernel.org/netdev/net-next/c/9c0e7ccd831b
  - [net-next,14/46] can: m_can: Add support for transceiver as phy
    https://git.kernel.org/netdev/net-next/c/d836cb5fe045
  - [net-next,15/46] can: m_can: use devm_platform_ioremap_resource_byname
    https://git.kernel.org/netdev/net-next/c/9808dba1bbcb
  - [net-next,16/46] can: m_can: remove support for custom bit timing
    https://git.kernel.org/netdev/net-next/c/0ddd83fbebbc
  - [net-next,17/46] can: mcp251xfd: mcp251xfd_probe(): try to get crystal clock rate from property
    https://git.kernel.org/netdev/net-next/c/74f89cf17e44
  - [net-next,18/46] can: mcp251xfd: Fix header block to clarify independence from OF
    https://git.kernel.org/netdev/net-next/c/71520f85f908
  - [net-next,19/46] can: mcp251xfd: mcp251xfd_open(): request IRQ as shared
    https://git.kernel.org/netdev/net-next/c/cb6adfe27680
  - [net-next,20/46] can: esd_usb2: use DEVICE_ATTR_RO() helper macro
    https://git.kernel.org/netdev/net-next/c/681e4a764521
  - [net-next,21/46] can: janz-ican3: use DEVICE_ATTR_RO/RW() helper macro
    https://git.kernel.org/netdev/net-next/c/f731707c5667
  - [net-next,22/46] can: at91_can: use DEVICE_ATTR_RW() helper macro
    https://git.kernel.org/netdev/net-next/c/42b9fd6ec7c9
  - [net-next,23/46] net: at91_can: remove redundant blank lines
    https://git.kernel.org/netdev/net-next/c/822a99c41fb4
  - [net-next,24/46] net: at91_can: add blank line after declarations
    https://git.kernel.org/netdev/net-next/c/933850c4b912
  - [net-next,25/46] net: at91_can: fix the code style issue about macro
    https://git.kernel.org/netdev/net-next/c/57bca980bad4
  - [net-next,26/46] net: at91_can: use BIT macro
    https://git.kernel.org/netdev/net-next/c/8ed1661cf21e
  - [net-next,27/46] net: at91_can: fix the alignment issue
    https://git.kernel.org/netdev/net-next/c/ccc5f1c994df
  - [net-next,28/46] net: at91_can: add braces {} to all arms of the statement
    https://git.kernel.org/netdev/net-next/c/02400533bb70
  - [net-next,29/46] net: at91_can: remove redundant space
    https://git.kernel.org/netdev/net-next/c/fc1d97d4fbfd
  - [net-next,30/46] net: at91_can: fix the comments style issue
    https://git.kernel.org/netdev/net-next/c/5bbe60493a21
  - [net-next,31/46] can: peak_pci: convert comments to network style comments
    https://git.kernel.org/netdev/net-next/c/9b69aff9fd1a
  - [net-next,32/46] can: peak_pci: fix checkpatch warnings
    https://git.kernel.org/netdev/net-next/c/fe1fa1387a15
  - [net-next,33/46] can: peak_pci: Add name and FW version of the card in kernel buffer
    https://git.kernel.org/netdev/net-next/c/805ff68c8e7f
  - [net-next,34/46] can: peak_usb: pcan_usb_get_device_id(): read value only in case of success
    https://git.kernel.org/netdev/net-next/c/1d0214a0f5db
  - [net-next,35/46] can: peak_usb: PCAN-USB: add support of loopback and one-shot mode
    https://git.kernel.org/netdev/net-next/c/3a7939495ce8
  - [net-next,36/46] can: peak_usb: pcan_usb_encode_msg(): add information
    https://git.kernel.org/netdev/net-next/c/1763c547648d
  - [net-next,37/46] can: peak_usb: pcan_usb_decode_error(): upgrade handling of bus state changes
    https://git.kernel.org/netdev/net-next/c/c11dcee75830
  - [net-next,38/46] can: etas_es58x: fix three typos in author name and documentation
    https://git.kernel.org/netdev/net-next/c/58fb92a517b5
  - [net-next,39/46] can: etas_es58x: use error pointer during device probing
    https://git.kernel.org/netdev/net-next/c/45cb13963df3
  - [net-next,40/46] can: etas_es58x: use devm_kzalloc() to allocate device resources
    https://git.kernel.org/netdev/net-next/c/6bde4c7fd845
  - [net-next,41/46] can: etas_es58x: add es58x_free_netdevs() to factorize code
    https://git.kernel.org/netdev/net-next/c/004653f0abf2
  - [net-next,42/46] can: etas_es58x: use sizeof and sizeof_field macros instead of constant values
    https://git.kernel.org/netdev/net-next/c/7fcecf51c18f
  - [net-next,43/46] can: etas_es58x: rewrite the message cast in es58{1,_fd}_tx_can_msg to increase readability
    https://git.kernel.org/netdev/net-next/c/f4f5247daa45
  - [net-next,44/46] can: flexcan: add platform data header
    https://git.kernel.org/netdev/net-next/c/896e7f3e7424
  - [net-next,45/46] can: flexcan: add mcf5441x support
    https://git.kernel.org/netdev/net-next/c/d9cead75b1c6
  - [net-next,46/46] can: flexcan: update Kconfig to enable coldfire
    https://git.kernel.org/netdev/net-next/c/8dad5561c13a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


