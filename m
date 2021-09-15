Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948D040C39F
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 12:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbhIOKbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 06:31:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231940AbhIOKbc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 06:31:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 79AE161263;
        Wed, 15 Sep 2021 10:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631701813;
        bh=msBjurWL7d6V/Yjv/t562XYam0bdHVCR7pw5qYfM9RU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NhqZUYY/jkd2iJ3kn5f6ifbirHGzODncdHviW8OxrZFsI/puTNwGLp776iYh/1Dek
         plA9POMdpuHoFcWjQ04c8nYtAa6WXALW4HLp4+qD8Jqk2d5tTFHwRvbn0ww/pE7gvK
         OAhvmn+8/oSTyCuSDRMnaHHPMprT1p17b7aKvJ9B4ZecfTtRfh7M5OaxXREd++eogp
         kUSHEdocJT0N9UxzfGRFih//NnKMMGa5Sizbm2jlMtxIRdZoeB5r+zg0NCVZAWYQk9
         NP9yVb+P5TlAwrvRKAgh6uDkZfQDYI/7RXOcToYGGQ4lSuBbYLFYNEraurIvBju/N6
         7/KyKRe+IF5EA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6632360A9C;
        Wed, 15 Sep 2021 10:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/18] timecard updates for v13 firmware
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163170181341.3937.13909060714001694911.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Sep 2021 10:30:13 +0000
References: <20210915021636.153754-1-jonathan.lemon@gmail.com>
In-Reply-To: <20210915021636.153754-1-jonathan.lemon@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com,
        netdev@vger.kernel.org, kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 14 Sep 2021 19:16:18 -0700 you wrote:
> This update mainly deals with features for the TimeCard v13 firmware.
> 
> The signals provided from the external SMA connectors can be steered
> to different locations, and the generated SMA signals can be chosen.
> 
> Future timecard revisions will allow selectable I/O on any of the
> SMA connectors, so name the attributes appropriately, and set up
> the ABI in preparation for the new features.
> 
> [...]

Here is the summary with links:
  - [net-next,01/18] ptp: ocp: parameterize the i2c driver used
    https://git.kernel.org/netdev/net-next/c/1618df6afab2
  - [net-next,02/18] ptp: ocp: Parameterize the TOD information display.
    https://git.kernel.org/netdev/net-next/c/498ad3f4389a
  - [net-next,03/18] ptp: ocp: Skip I2C flash read when there is no controller.
    https://git.kernel.org/netdev/net-next/c/1447149d6539
  - [net-next,04/18] ptp: ocp: Skip resources with out of range irqs
    https://git.kernel.org/netdev/net-next/c/56ec44033cd7
  - [net-next,05/18] ptp: ocp: Report error if resource registration fails.
    https://git.kernel.org/netdev/net-next/c/bceff2905eff
  - [net-next,06/18] ptp: ocp: Add third timestamper
    https://git.kernel.org/netdev/net-next/c/dcf614692c6c
  - [net-next,07/18] ptp: ocp: Add SMA selector and controls
    https://git.kernel.org/netdev/net-next/c/e1daf0ec73b2
  - [net-next,08/18] ptp: ocp: Add IRIG-B and DCF blocks
    https://git.kernel.org/netdev/net-next/c/6baf2925424a
  - [net-next,09/18] ptp: ocp: Add IRIG-B output mode control
    https://git.kernel.org/netdev/net-next/c/d14ee2525d38
  - [net-next,10/18] ptp: ocp: Add sysfs attribute utc_tai_offset
    https://git.kernel.org/netdev/net-next/c/89260d878253
  - [net-next,11/18] ptp: ocp: Separate the init and info logic
    https://git.kernel.org/netdev/net-next/c/065efcc5e976
  - [net-next,12/18] ptp: ocp: Add debugfs entry for timecard
    https://git.kernel.org/netdev/net-next/c/f67bf662d2cf
  - [net-next,13/18] ptp: ocp: Add NMEA output
    https://git.kernel.org/netdev/net-next/c/e3516bb45078
  - [net-next,14/18] ptp: ocp: Add second GNSS device
    https://git.kernel.org/netdev/net-next/c/71d7e0850476
  - [net-next,15/18] ptp: ocp: Enable 4th timestamper / PPS generator
    https://git.kernel.org/netdev/net-next/c/a62a56d04e63
  - [net-next,16/18] ptp: ocp: Have FPGA fold in ns adjustment for adjtime.
    https://git.kernel.org/netdev/net-next/c/6d59d4fa1789
  - [net-next,17/18] ptp: ocp: Add timestamp window adjustment
    https://git.kernel.org/netdev/net-next/c/1acffc6e09ed
  - [net-next,18/18] docs: ABI: Add sysfs documentation for timecard
    https://git.kernel.org/netdev/net-next/c/d7050a2b85ff

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


