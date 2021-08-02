Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6256B3DDAB7
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237100AbhHBOUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:20:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236635AbhHBOUP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 10:20:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 71A3260F4B;
        Mon,  2 Aug 2021 14:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627914006;
        bh=nJdjfr/gQuxAg8xmqNfgSwU5ufzC7xrwZa6z+aTtzIQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J5JL5vDIIODwsJrmV6k3/b4GTxebRzoneUTxBVNVcDcMiAmJWkDBe1PzYYsSgbKtW
         zGzh+TEfSh7AyDm11KKJ4IecEoXMPCZaazTaaHY79uUVTJ1d22wF5UwdhXFsmDSYlc
         qJ+TfnC4q2G0JKCgcVSW1kn76Y+p5MYGHJhwUrgoouCYWZQnrppk4slMW5bU0GoSNv
         /6GLcbUR5/Ssls2oivPBSB5419ha2Aj1l/IeheC3MNyyMaVFxlv+BwU4pJFEVrO/9f
         0fkA1XTwZFEdwks5vQ4n6JUa5IJ0TouCokoP8b/QYfm/wMKMLac4/8uXDaUNq2D7II
         37DH1J1VZGZsg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6990760A44;
        Mon,  2 Aug 2021 14:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] docs: operstates: document IF_OPER_TESTING
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162791400642.18419.16804426516481917225.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Aug 2021 14:20:06 +0000
References: <20210731144052.1000147-1-kuba@kernel.org>
In-Reply-To: <20210731144052.1000147-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, corbet@lwn.net,
        linux-doc@vger.kernel.org, andrew@lunn.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 31 Jul 2021 07:40:52 -0700 you wrote:
> IF_OPER_TESTING is in fact used today.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  Documentation/networking/operstates.rst | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net] docs: operstates: document IF_OPER_TESTING
    https://git.kernel.org/netdev/net/c/7a7b8635b622

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


