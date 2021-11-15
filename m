Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4384506A7
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbhKOOYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:24:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:38568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236388AbhKOOXE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 09:23:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 81F9163238;
        Mon, 15 Nov 2021 14:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636986009;
        bh=cyHE5p8Y4sjP3if4JM9tAdaYp0AWm0Up2nJZuIp7ZfE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=euzcwfDa3v1rSJCy/UGwzgwHHyOnHnNdlBA8jsRw4ke2DKR5G7nX7noq3qJDvm9+a
         q8cRmKeNzkhlBEX+nh3tWAW7QKo+0ED2ncqkgOKbwL1G3m/FaoIh6qNs5sdeyFn1Lc
         KODo5oJ69lRXUZXQ9L5nvcUUl+1h2iO1gwb32BOhog/L4Y0VGdBuWTmmNHmZR3/prM
         fgdW9aaFlBVxeJWs2IJ9THrPJYxyQfBFv/zKAZ09Rtb5bFHW8yCv1ak6yxHlK6bBOn
         zfXq4u9ELfAtnnDLcJJq0rDZpDAMqb1FEwdoWhKXOpFm4Xkeud84zs3dJr8UobgY08
         MUqV9X+QcgHcQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 748C160A49;
        Mon, 15 Nov 2021 14:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] bnxt_en: Bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163698600947.19991.5182218507188070700.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Nov 2021 14:20:09 +0000
References: <1636961881-17824-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1636961881-17824-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edwin.peer@broadcom.com, gospo@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 15 Nov 2021 02:37:58 -0500 you wrote:
> This series includes 3 fixes.  The first one fixes a race condition
> between devlink reload and SR-IOV configuration.  The second one
> fixes a type mismatch warning in devlink fw live patching.  The
> last one fixes unwanted OVS TC dmesg error logs when tc-hw-offload is
> disabled on bnxt_en.
> 
> Edwin Peer (2):
>   bnxt_en: extend RTNL to VF check in devlink driver_reinit
>   bnxt_en: fix format specifier in live patch error message
> 
> [...]

Here is the summary with links:
  - [net,1/3] bnxt_en: extend RTNL to VF check in devlink driver_reinit
    https://git.kernel.org/netdev/net/c/46d08f55d24e
  - [net,2/3] bnxt_en: fix format specifier in live patch error message
    https://git.kernel.org/netdev/net/c/b68a1a933fe4
  - [net,3/3] bnxt_en: reject indirect blk offload when hw-tc-offload is off
    https://git.kernel.org/netdev/net/c/b0757491a118

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


