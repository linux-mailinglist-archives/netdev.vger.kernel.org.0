Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C411B46AF8E
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357084AbhLGBNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 20:13:41 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49136 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243579AbhLGBNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 20:13:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4DC8B81648;
        Tue,  7 Dec 2021 01:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7F717C341CD;
        Tue,  7 Dec 2021 01:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638839409;
        bh=PuIqe6GW2pYb2QfLQkfJepAKx7llRzTMxpRR9uA3xmw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uaG/lDdgKbtKU3PMTeXNUKNAXEjExgETEYhWrra7nodnygbgzCuVcRh0ODyMVk0iS
         epz2KkT8IfyA73mDMZ3P0pZxUs4rxz/TdCaujfO959jKm8NwzjIHtavILCUVhosslO
         qACbQYNsng7d/HmmHA7HtdRpQA6SlXs9z9Tqj5WPZuE3JSoMDCMlfHBZCMRSDv61g+
         UaKAujhzMA0mRy5vFV0wgFAy2LOlbKLQr36LbVVRnlHLCvWCs3yJa1l00oiLeZ9HtJ
         lSAB1JKd8RwSg2lkt9RkaPQ3jzJmbFCraAmQHPrFY4W/6/PKoo1Spt1SZq1toXCPlC
         P+HBcYAw4SHtg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6AEB760A4D;
        Tue,  7 Dec 2021 01:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/smc: Clear memory when release and reuse buffer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163883940943.24390.11317200690336644085.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Dec 2021 01:10:09 +0000
References: <20211203113331.2818873-1-kgraul@linux.ibm.com>
In-Reply-To: <20211203113331.2818873-1-kgraul@linux.ibm.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  3 Dec 2021 12:33:31 +0100 you wrote:
> From: Tony Lu <tonylu@linux.alibaba.com>
> 
> Currently, buffers are cleared when smc connections are created and
> buffers are reused. This slows down the speed of establishing new
> connections. In most cases, the applications want to establish
> connections as quickly as possible.
> 
> [...]

Here is the summary with links:
  - [net-next] net/smc: Clear memory when release and reuse buffer
    https://git.kernel.org/netdev/net-next/c/1c5526968e27

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


