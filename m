Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FACB4A6ABF
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 05:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244239AbiBBEKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 23:10:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50576 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiBBEKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 23:10:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D7DB616D5
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 04:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED4DBC340EB;
        Wed,  2 Feb 2022 04:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643775010;
        bh=zTE01aw9/Bi8ENOWVrceNGlrCTZMEr0aa39JLOtnCY8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A8pgYMTWlCn8uuWEAcQHuFdootX1aBvhwj5e7KZUBFJCXVzuKukVneI/ij23hAIi7
         7pGsdzGgPwK8gT71aD/MpEDUC7l8Y4RYbmRFYCTBp203uURUCQbc6d9ummBUTrJuQH
         TKSIc5ucQoNFIHW2Xk1cbNCEbVDtW9bNVTk7rIuSkL1Me8RnC/UHHX6zIGrU8In2TF
         K0D3rI+RNlmgKqOtmIqAcozV1VSsYkIvn3JTb1+WiHxmKOvUMtv/KOouUB5jA4VMvm
         kweAUk8xpa1hy3S6T6ErUGQ4nlhkM6DJ+/l1OpxN1GC590kL2ncnhvfq4Oc5jN2OJ0
         qsvSKJrt8dN3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CE9AEE5D09D;
        Wed,  2 Feb 2022 04:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ethernet: smc911x: fix indentation in get/set EEPROM
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164377500984.4092.8939335292381872297.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Feb 2022 04:10:09 +0000
References: <20220131211730.3940875-1-kuba@kernel.org>
In-Reply-To: <20220131211730.3940875-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 31 Jan 2022 13:17:30 -0800 you wrote:
> Build bot produced a smatch indentation warning,
> the code looks correct but it mixes spaces and tabs.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/ethernet/smsc/smc911x.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [net] ethernet: smc911x: fix indentation in get/set EEPROM
    https://git.kernel.org/netdev/net/c/6dde7acdb3dc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


