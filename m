Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E123D6901
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 23:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhGZVMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 17:12:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233006AbhGZVL7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 17:11:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 18A3560F6C;
        Mon, 26 Jul 2021 21:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627336348;
        bh=St7M0uzHk0I4lTEj39LCS4wqSI/lYSteDwmEGiFjVAQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qJJ0hOiAmqitprFgRWwqTGyNd63kKAA0aZZoP657mEunw2kGAOXepe7o5gtCE31tx
         wZKbUgd+n55s6ospAbZdRFY+dp8RMbxFjAZZ7Dn5jDjzSbcunPR5n/+cLZZjRMAPHO
         T749K2jnmQd7dPPLFa+2zzp+XOK0jlhYr2c5lirogQbIF7dm2iOZjMbAU6UXe2Szap
         Ttws5x4xNkPluoy/7nLmk/9z46BPuuY8m1EYeY1ibKNgnK4uEGeUzcMuVKH1bdF8Ua
         IrwMAH6ZbPnHzabBhBDVS5oVQLVS2XOx+drCUXJCeNX0DWQFCP/q7jrW6w5ODCrzSe
         vTaNCoWXK3ANw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0CAF860A59;
        Mon, 26 Jul 2021 21:52:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bnxt_en: Fix static checker warning in
 bnxt_fw_reset_task()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162733634804.1437.336980992801330035.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Jul 2021 21:52:28 +0000
References: <1627325568-9135-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1627325568-9135-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com, dan.carpenter@oracle.com,
        somnath.kotur@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 26 Jul 2021 14:52:48 -0400 you wrote:
> From: Somnath Kotur <somnath.kotur@broadcom.com>
> 
> Now that we return when bnxt_open() fails in bnxt_fw_reset_task(),
> there is no need to check for 'rc' value again before invoking
> bnxt_reenable_sriov().
> 
> Fixes: 3958b1da725a ("bnxt_en: fix error path of FW reset")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Somnath Kotur <somnath.kotur@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> 
> [...]

Here is the summary with links:
  - [net] bnxt_en: Fix static checker warning in bnxt_fw_reset_task()
    https://git.kernel.org/netdev/net/c/758684e49f4c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


