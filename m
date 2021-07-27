Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFE23D73EC
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 13:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236460AbhG0LAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 07:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236387AbhG0LAb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 07:00:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 43FB8619EB;
        Tue, 27 Jul 2021 11:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627383631;
        bh=A+LWYg9DaR/z+IOdBMQEXzG9mh4MOvcaxmVrCms1/vI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E+EjNM6fdnr9rwCXCV/KoVFoCEk1LN6TyhRw170dypxdnZFXjdSiSmzYuf9teXCAl
         FXHXao/ZVRzWrhhzJua9K3JFqw89BKQldyJWxsWTR9esNEOc+vS2z5qc7nqRE1ySTx
         Un4jzSTkxovpH6pKr8DxxSi2e21IpHkQgTuNd464W6M+lmK64hOTkjICC8MgQ1XkQa
         6XkW6JsmvJL+7gbVHs5g5lIrEcxrxAKjPkFwGizh+hO7FBUYiz6AxnNL70j1ROfXic
         QT2hrLeA04Z4ATMmSPouCn7WrIE+/CIn8wKR+TFluI70I1OhMrbuiyzIgwTEObuRgG
         76n671Yfk7ttA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3EF4B60A56;
        Tue, 27 Jul 2021 11:00:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] docs: networking: dpaa2: add documentation for
 the switch driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162738363125.18831.8681201931839546135.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Jul 2021 11:00:31 +0000
References: <20210723084244.950197-1-ciorneiioana@gmail.com>
In-Reply-To: <20210723084244.950197-1-ciorneiioana@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        corbet@lwn.net, linux-doc@vger.kernel.org, ioana.ciornei@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 23 Jul 2021 11:42:44 +0300 you wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> Add a documentation entry for the DPAA2 switch listing its
> requirements, features and some examples to go along them.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] docs: networking: dpaa2: add documentation for the switch driver
    https://git.kernel.org/netdev/net-next/c/d4b996f9ef1f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


