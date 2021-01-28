Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E2F306AE2
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 03:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbhA1CBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 21:01:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:41994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231171AbhA1CAw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 21:00:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8ED3664DBD;
        Thu, 28 Jan 2021 02:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611799211;
        bh=H2uapBZxjmfYA8ImlsDuPdkVNm6+p3NzmG3musjHeFY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RJj9+RCGT0w39ylWSy5GgfahmsSXU9tZ+/HaFv5nPcZy4Fnpmd39llO/xR7IQi4Tf
         03O2SHmhGwXBfe5FooCuig5sZqEws0M27eG1pcDMZMOLrUI4zF13ptrNQUYFvK+C1H
         sbcLJin7IbQ2x+QhdYQyZidWHeGYELbT3qqsKyMC2iXTNgunfqi9+JmxemZL2HPV6K
         7e+Hk/2pYn2jHD6VGeudJQZrBZl30P75V8s4LiGehmUoRP6dogpCU0U09HHVHWjjQZ
         stVQLS7c0RG6QzUKz4U/ZEBOx34FQaHycgIdGWlnl+RyfyMYqJpfDvrhrdKztMeOEu
         EEBoI+u10kUSQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7F212613AE;
        Thu, 28 Jan 2021 02:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can 2021-01-27
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161179921151.8807.16384789975827841325.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 02:00:11 +0000
References: <20210127094028.2778793-1-mkl@pengutronix.de>
In-Reply-To: <20210127094028.2778793-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Wed, 27 Jan 2021 10:40:27 +0100 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 1 patch for net/master.
> 
> The patch is by Dan Carpenter and fixes a potential information leak in
> can_fill_info().
> 
> [...]

Here is the summary with links:
  - pull-request: can 2021-01-27
    https://git.kernel.org/netdev/net/c/45a81464819a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


