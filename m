Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E817481818
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 02:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233914AbhL3BaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 20:30:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36722 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbhL3BaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 20:30:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D027B81A5B;
        Thu, 30 Dec 2021 01:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C8EE6C36AEA;
        Thu, 30 Dec 2021 01:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640827813;
        bh=vTYXJ1PIodgQGW9LUSsQ90ucDvpi2eEEcWHZxdggAwg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DcbfzhA5rgX694b5litE2Tpz+yZfJnujprHGPOrFlsS+3cF/B2nb1noyxn8fU3n4r
         Ot/iaJW06iCSb5aThaTOYjAVWguVVFCktaS1rXabl6Cznu29MeVBYnP/DLAOPSQK2s
         BNly0Wzb8cBeSADPLLWiRE9QHTrihBcx0IIip3TXV9yyTS5oB8/RSQDBvkfI0x5Bd8
         IvSiaaFyPzEpjG9msr4+IGcobFJc39XrvyiIclztGxbp1DOP0P1pOgQcHCP/uSI269
         WZc/RF7piImAVvOP9AfxOwJjyzACOYCb63KoaA96zCZdKvUjn/+mflEWLK74FfcxQx
         sgU6II2MCPQSg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B4972C395E4;
        Thu, 30 Dec 2021 01:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request: bluetooth 2021-12-29
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164082781373.16372.13690549960957422792.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Dec 2021 01:30:13 +0000
References: <20211229211258.2290966-1-luiz.dentz@gmail.com>
In-Reply-To: <20211229211258.2290966-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Dec 2021 13:12:58 -0800 you wrote:
> The following changes since commit d156250018ab5adbcfcc9ea90455d5fba5df6769:
> 
>   Merge branch 'hns3-next' (2021-11-24 14:12:26 +0000)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2021-12-29
> 
> [...]

Here is the summary with links:
  - pull request: bluetooth 2021-12-29
    https://git.kernel.org/netdev/net-next/c/e2dfb94f27f7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


