Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F96A45D25E
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 02:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348108AbhKYBPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 20:15:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:56856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236229AbhKYBNT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 20:13:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B4726610A8;
        Thu, 25 Nov 2021 01:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637802608;
        bh=3uQo6Cli/nv39dBU8DRP7NU45m396rvpbu/fElm2pvg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NGFhEFDe5Gg+TgbCW2p7euqvCbq5FFcK88Kwx4hZJOkz/MCqvVNojvRq2YrkRUt7c
         T4jOI52jEoXqeg90MFjT/FwdWJzpxTckmQFUijDiTwCLu6XGt1InAoIxtAd/fKaWg8
         tCGu/niEuFlkWWRtGBKd/y0qECj3q7RgJDNoZHfSGTFKNsoLzBVl2UTjEEt8hv+vTm
         Qlwtc4eUB4aVvKXXM2NiraembGfeE5k5+U0RNp+BVGbyqv2fNbwn1QOjK5LxT0/ANS
         l4pTQWBCX+Gb6ASPGsHtfMZDEzQtrko+QG9nGXVImJW8HWnE6kZbA0BILvXIl+gH3X
         3zRnKoAYlh2rA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A63AC60A0A;
        Thu, 25 Nov 2021 01:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: ieee802154 for net 2021-11-24
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163780260867.28659.7876356954925087127.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Nov 2021 01:10:08 +0000
References: <20211124150934.3670248-1-stefan@datenfreihafen.org>
In-Reply-To: <20211124150934.3670248-1-stefan@datenfreihafen.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Nov 2021 16:09:34 +0100 you wrote:
> Hello Dave, Jakub.
> 
> An update from ieee802154 for your *net* tree.
> 
> A fix from Alexander which has been brought up various times found by
> automated checkers. Make sure values are in u32 range.
> 
> [...]

Here is the summary with links:
  - pull-request: ieee802154 for net 2021-11-24
    https://git.kernel.org/netdev/net/c/48a78f501f45

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


