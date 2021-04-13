Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2D235E8AC
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 00:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347039AbhDMWAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 18:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239106AbhDMWAc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 18:00:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CED6161246;
        Tue, 13 Apr 2021 22:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618351211;
        bh=yXepo/CXGSuxBSnJ2LY0zGvCaeq9yuK2cgMirQ59gP0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oLSn3LVZC0ZHRn9qf/iesgu0Apn+YDxbn1w1eJ1KvTSZ+RHVrw5ey9kT92OBTmd4s
         aL/Sg2NxS2DVcSlQCUveQjuUWOe7Yd6wL/YfHmt6h7UqbUxtbetQxJQNZN/BA8Ddxw
         9nduhxt/hIM6ECip/YPzCwQSDzyYpjcewtQTwoQiLPqkEbsPxZg3yIMU35htKQgGT+
         d7ejt5UbfAu3TC0OMplIJKwKTJat/MhDgrSTnDZqSM/A3BHnbHUy+/5tBqcjS5egN0
         Q4EruWX4H2sA+EIzDJfS40q6JsdAXQNQMNchmSwnXHiYd+Yrro0FBoEy2oZX460W/2
         JaSYT9ICqv+Ww==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C9C9D60CCF;
        Tue, 13 Apr 2021 22:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can-next 2021-04-13
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161835121182.27588.18074844196687546550.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Apr 2021 22:00:11 +0000
References: <20210413095201.2409865-1-mkl@pengutronix.de>
In-Reply-To: <20210413095201.2409865-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Tue, 13 Apr 2021 11:51:47 +0200 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 14 patches for net-next/master.
> 
> The first patch is by Yoshihiro Shimoda and updates the DT bindings
> for the rcar_can driver.
> 
> [...]

Here is the summary with links:
  - pull-request: can-next 2021-04-13
    https://git.kernel.org/netdev/net-next/c/9fb434bcf825
  - [net-next,02/14] can: etas_es58x: add core support for ETAS ES58X CAN USB interfaces
    https://git.kernel.org/netdev/net-next/c/8537257874e9
  - [net-next,03/14] can: etas_es58x: add support for ETAS ES581.4 CAN USB interface
    https://git.kernel.org/netdev/net-next/c/1dfb6005a60b
  - [net-next,04/14] can: etas_es58x: add support for the ETAS ES58X_FD CAN USB interfaces
    https://git.kernel.org/netdev/net-next/c/c664e2137a27
  - [net-next,05/14] can: peak_usb: fix checkpatch warnings
    https://git.kernel.org/netdev/net-next/c/bc256b95971f
  - [net-next,06/14] can: peak_usb: pcan_usb_pro.h: remove double space in indention
    https://git.kernel.org/netdev/net-next/c/fa34e0a18f8a
  - [net-next,07/14] can: peak_usb: remove unused variables from struct peak_usb_device
    https://git.kernel.org/netdev/net-next/c/c779e1271a9e
  - [net-next,08/14] can: peak_usb: remove write only variable struct peak_usb_adapter::ts_period
    https://git.kernel.org/netdev/net-next/c/1a5a5eedf807
  - [net-next,09/14] can: peak_usb: peak_usb_probe(): make use of driver_info
    https://git.kernel.org/netdev/net-next/c/592bf5a09d19
  - [net-next,10/14] can: peak_usb: pcan_usb_{,pro}_get_device_id(): remove unneeded check for device_id
    https://git.kernel.org/netdev/net-next/c/426718f3fe0e
  - [net-next,11/14] can: peak_usb: pcan_usb_get_serial(): remove error message from error path
    https://git.kernel.org/netdev/net-next/c/5e164a4f0aae
  - [net-next,12/14] can: peak_usb: pcan_usb_get_serial(): make use of le32_to_cpup()
    https://git.kernel.org/netdev/net-next/c/0a7d6cdf90c0
  - [net-next,13/14] can: peak_usb: pcan_usb_get_serial(): unconditionally assign serial_number
    https://git.kernel.org/netdev/net-next/c/b7a29d35a984
  - [net-next,14/14] can: peak_usb: pcan_usb: replace open coded endianness conversion of unaligned data
    https://git.kernel.org/netdev/net-next/c/bd573ea57204

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


