Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7583AF5FC
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 21:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhFUTW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 15:22:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231481AbhFUTWT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 15:22:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EF7D461351;
        Mon, 21 Jun 2021 19:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624303205;
        bh=r+ZdvtoFNtsAffyGlL8zVimZ7LoCVJMtdCcgQNyKqzA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Kdx+LCDlw3JusP5FoPCSfkN2mBkb7kaI15ualiKjamTvnO34MDZLEP2xsA1CVHSoZ
         vxon2D2cqjeBIPF4LKD2HFqNeQHJaek2ld8U8dbiZgeqz9bEOPAEwl9tqlfONkZcaY
         DThf09MhTgXA/mgrQ696O9VsJOLy6vh7i/j69PgGTi7DykQn+/Alx4Uwt2Q7Klc9l6
         W2wuJrqsDvzdkEPSl2t6KAZg6fCv3NivX5bAxLpD0368i9n2SwOT9+0fmQS97hR+eL
         DfG6Y4TPkW8b5WqASX4j9Emm4J/tUrXeTIFAtzDi4XbPhtPdWqpmoVe6+uzUGUzOXB
         XqqMTdQW+jDuQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E8F806094F;
        Mon, 21 Jun 2021 19:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/2] net: hns3: fix different snprintf() limit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162430320494.6988.10698969626781207552.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Jun 2021 19:20:04 +0000
References: <YM31etbBvDRf+bgS@mwanda>
In-Reply-To: <YM31etbBvDRf+bgS@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, kuba@kernel.org, huangguangbin2@huawei.com,
        moyufeng@huawei.com, tanhuazhong@huawei.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 19 Jun 2021 16:47:38 +0300 you wrote:
> This patch doesn't affect runtime at all, it's just a correctness issue.
> 
> The ptp->info.name[] buffer has 16 characters but the snprintf() limit
> was capped at 32 characters.  Fortunately, HCLGE_DRIVER_NAME is "hclge"
> which isn't close to 16 characters so we're fine.
> 
> Fixes: 0bf5eb788512 ("net: hns3: add support for PTP")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: hns3: fix different snprintf() limit
    https://git.kernel.org/netdev/net-next/c/faebad853455
  - [net-next,2/2] net: hns3: fix a double shift bug
    https://git.kernel.org/netdev/net-next/c/956c3ae411b2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


