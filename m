Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52FFB42E66E
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 04:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234921AbhJOCWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 22:22:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229648AbhJOCWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 22:22:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 673FD610E8;
        Fri, 15 Oct 2021 02:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634264408;
        bh=KswJUkdEiL4Krr7vlY5opvIuYtULjYcRFQmnEPlZm4k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TfS+T3fOQQ/35MKQXKAZgiU3mN7dIy8sijJ61Q8H3tANRaSrKU6hLVwSQ7QGpyTAm
         z5OWksos40E02PwYgB4On3JJik1WZtnS2Z4ucfy9n6ExVLcafMciyuhnumz39z453p
         JSQvDiVATvcEkLS/xw0RM6KfeLdvp5UHsydmli/fjT8K51e+4kOOax4+xuCv1Kr4df
         CDg3eg79fIWTgubymnux6Se7p/F69f1VJBDd5Qw/VgfrXVGkqtorMeNfm3+lyJMK9o
         Wi/2jJQRoMxywjLXY9oaLdVqy3xFOfyg5m+6rghum0KNkUmb282H2AyIGybwaQ0DFn
         wS/Yi6vhnaJqQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5A86260A38;
        Fri, 15 Oct 2021 02:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: phy: micrel: make *-skew-ps check more lenient
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163426440836.28081.5382655272516843843.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Oct 2021 02:20:08 +0000
References: <20211012103402.21438-1-matthias.schiffer@ew.tq-group.com>
In-Reply-To: <20211012103402.21438-1-matthias.schiffer@ew.tq-group.com>
To:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 12 Oct 2021 12:34:02 +0200 you wrote:
> It seems reasonable to fine-tune only some of the skew values when using
> one of the rgmii-*id PHY modes, and even when all skew values are
> specified, using the correct ID PHY mode makes sense for documentation
> purposes. Such a configuration also appears in the binding docs in
> Documentation/devicetree/bindings/net/micrel-ksz90x1.txt, so the driver
> should not warn about it.
> 
> [...]

Here is the summary with links:
  - net: phy: micrel: make *-skew-ps check more lenient
    https://git.kernel.org/netdev/net-next/c/67ca5159dbe2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


