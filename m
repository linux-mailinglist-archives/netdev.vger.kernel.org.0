Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B420D34507C
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhCVUKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:10:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230159AbhCVUKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:10:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 61F9C6196C;
        Mon, 22 Mar 2021 20:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616443810;
        bh=MkJIdi4I6iyFKtAXF7DlsFFuYm/QqiMZKRpbZUHb9Gc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vEJEnI/ygop528F40+yjP2oUgGxZ8871LlE3mogmA+Q8wN8HzG2cPa+Rlj6QymY/B
         XWbxKUk0zZoLW/Rt4o7nM59F+6bt8fKFOVkHmT/3G5kuncYVMRPxgmlyNWOjLAqsVA
         5sUDstaQbaim20UVH2BKf3HsOat1lP8dmc7UQdqVtAAv7HGc4f4S1kWQv/thyzgX9f
         YxobwRyvtnFaoOo8PVxe6PYw++JDtR0JVVzns+emIikMMQRHU1cD2nCI33jcRd9pm4
         ulC5GGJff+h+w3VLRyLZ1Yz2Rnaya97oStWBlb6SzrwEFv7Ngsmw/prT6Qerj+bthc
         dTvqNHvzy0Eww==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 53B94609F6;
        Mon, 22 Mar 2021 20:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] bnxt_en: Error recovery improvements.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161644381033.22637.703509462046482473.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Mar 2021 20:10:10 +0000
References: <1616396925-16596-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1616396925-16596-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 22 Mar 2021 03:08:38 -0400 you wrote:
> This series contains some improvements for error recovery.  The main
> changes are:
> 
> 1. Keep better track of the health register mappings with the
> "status_reliable" flag.
> 
> 2. Don't wait for firmware responses if firmware is not healthy.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] bnxt_en: Improve the status_reliable flag in bp->fw_health.
    https://git.kernel.org/netdev/net-next/c/43a440c4007b
  - [net-next,2/7] bnxt_en: Improve wait for firmware commands completion
    https://git.kernel.org/netdev/net-next/c/80a9641f09f8
  - [net-next,3/7] bnxt_en: don't fake firmware response success when PCI is disabled
    https://git.kernel.org/netdev/net-next/c/a2f3835cc68a
  - [net-next,4/7] bnxt_en: check return value of bnxt_hwrm_func_resc_qcaps
    https://git.kernel.org/netdev/net-next/c/15a7deb89549
  - [net-next,5/7] bnxt_en: Set BNXT_STATE_FW_RESET_DET flag earlier for the RDMA driver.
    https://git.kernel.org/netdev/net-next/c/2924ad95cb51
  - [net-next,6/7] bnxt_en: Remove the read of BNXT_FW_RESET_INPROG_REG after firmware reset.
    https://git.kernel.org/netdev/net-next/c/bae8a00379f4
  - [net-next,7/7] bnxt_en: Enhance retry of the first message to the firmware.
    https://git.kernel.org/netdev/net-next/c/861aae786f2f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


