Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762F943AA39
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 04:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbhJZCWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 22:22:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233920AbhJZCWc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 22:22:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4CA1560FC2;
        Tue, 26 Oct 2021 02:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635214809;
        bh=SdzyhnrNlokA9cUEQK86B9cUJdkWdIodpJPGT4PY9z4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F6N8FgfcTdkvRZAgHUOsNGwbT47Jrja8gmH+n/AWEQaEcAN9qXrTwcsy/yu083R2p
         tXtphfVAB9n6aa9lTbktXp4fJzYkFDUGPXcj2iEOSvOhe3MUPkZNIl905bpdH/hWyi
         BNuiPFpzpnPvDDRLoNABzxSR5e+H+wSs1HKQhZSLFEsPI3QrjAXVKlEt8BO9NhmM01
         SIaxNb9am+tA4/4MpbSWtC0NtW/zLO8jvhPveZJAxPVA0gM5gzSBjYxW03sLy9pP5s
         jkXeMEAcHkZmTOUIQ4X9r2k8FJS1nr7e6zJm8CJOhrKZ+zFBWGA89qdH80ozJVmtgB
         xoRZ/gLiNonMg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 40AEE60BBF;
        Tue, 26 Oct 2021 02:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Small fixes for true expression checks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163521480925.2466.11111204303685468190.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Oct 2021 02:20:09 +0000
References: <cover.1634974124.git.sakiwit@gmail.com>
In-Reply-To: <cover.1634974124.git.sakiwit@gmail.com>
To:     =?utf-8?q?J=CE=B5an_Sacren_=3Csakiwit=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 23 Oct 2021 03:26:16 -0600 you wrote:
> From: Jean Sacren <sakiwit@gmail.com>
> 
> This series fixes checks of true !rc expression.
> 
> Jean Sacren (2):
>   net: qed_ptp: fix check of true !rc expression
>   net: qed_dev: fix check of true !rc expression
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: qed_ptp: fix check of true !rc expression
    https://git.kernel.org/netdev/net-next/c/165f8e82c2f1
  - [net-next,2/2] net: qed_dev: fix check of true !rc expression
    https://git.kernel.org/netdev/net-next/c/036f590fe572

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


