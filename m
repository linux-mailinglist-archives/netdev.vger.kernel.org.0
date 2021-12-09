Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6E046ECCC
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 17:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235758AbhLIQNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 11:13:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34876 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhLIQNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 11:13:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 410FDB8254F;
        Thu,  9 Dec 2021 16:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 123C0C341D1;
        Thu,  9 Dec 2021 16:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639066210;
        bh=313oE8ncnVkSHaqOqb0Ooa37efTe8AorfINszEhFpSY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=teB4XlSx+Md4gWNUDIcTnaBpqxftaGHnT4ooAKCFnWqyfHaHPSI59Eif5EgKVqrtS
         Fe9qXnYzOkWmWS5YubvpdKCAPKMECbEf1F2u0k/Mm8PfO2SbeqBWfqjRndHeZUE8gk
         xfaUcxhD7MrbjAZsOfS5E806GztRGUmF3gOqmaYyBWBZHOE+vfoX59+I0sQGmb1MFq
         5mBQZ1KQqfUFTxhE5r0MsG/4cIPQ3IwY+Vd1XUM9EuQlC37bzLov56ZLfr1C5l7oeS
         VbBtfCvESS1Lc2GfkXzNj/1iDq+5NbPM+8E+JqReFsmy/nrzwYdoNGR/2oi8SObO+O
         4wp5ezjfkiaoQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E867560BCF;
        Thu,  9 Dec 2021 16:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] MAINTAINERS: s390/net: remove myself as maintainer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163906620994.18129.12816326820488386776.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 16:10:09 +0000
References: <20211209153546.1152921-1-jwi@linux.ibm.com>
In-Reply-To: <20211209153546.1152921-1-jwi@linux.ibm.com>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, wintera@linux.ibm.com,
        wenjia@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Dec 2021 16:35:46 +0100 you wrote:
> I won't have access to the relevant HW and docs much longer.
> 
> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
> ---
>  MAINTAINERS | 2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - MAINTAINERS: s390/net: remove myself as maintainer
    https://git.kernel.org/netdev/net/c/37ad4e2a7718

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


