Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DBE3DFE5F
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 11:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237177AbhHDJuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 05:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:44032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235522AbhHDJuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 05:50:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 921E460F58;
        Wed,  4 Aug 2021 09:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628070605;
        bh=7YJpI9/TSk3vynR7O7VuT5wMV7YSKsDG881xC2mqZB8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K6AJtAAlJRxtkV2bS43s9OlpVJlT/NzJQfsqfPurWCEZqZE0p4OgtczftROdlRvB1
         /I+1lFa5hzE1FAI6oDg6BOghHlJRl+M0/C0PIxNSRskalpWSk0R/isKhn5ko0q6+7s
         d0If6iTnKEY+6fmz+K03VqIJPjeWoXW+YqvDJPcw/b5D5l0UXR5Y9/yQW+LOT2KcGx
         R+jtkD0/26i+ByJcr9n1Z84tXtt1tyDABRmbBvdpxAxLxCnwamw1wQKgUilVAiWzCd
         VNvBeFYgIa4f8vGxngrlmre035jeYJIqi+zIME6uZ4STAKuYUIDfKp/uaJWnCmVU7/
         ucNDFJWfwaJCw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8610860A6A;
        Wed,  4 Aug 2021 09:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/2] net: usb: pegasus: better error checking and
 DRIVER_VERSION removal
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162807060554.2454.11275939650106746794.git-patchwork-notify@kernel.org>
Date:   Wed, 04 Aug 2021 09:50:05 +0000
References: <20210803172524.6088-1-petko.manolov@konsulko.com>
In-Reply-To: <20210803172524.6088-1-petko.manolov@konsulko.com>
To:     Petko Manolov <petko.manolov@konsulko.com>
Cc:     netdev@vger.kernel.org, paskripkin@gmail.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        petkan@nucleusys.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue,  3 Aug 2021 20:25:22 +0300 you wrote:
> From: Petko Manolov <petkan@nucleusys.com>
> 
> v3:
> 
> Pavel Skripkin again: make sure -ETIMEDOUT is returned by __mii_op() on timeout
> condition;
> 
> [...]

Here is the summary with links:
  - [net,v3,1/2] net: usb: pegasus: Check the return value of get_geristers() and friends;
    https://git.kernel.org/netdev/net/c/8a160e2e9aeb
  - [net,v3,2/2] net: usb: pegasus: Remove the changelog and DRIVER_VERSION.
    https://git.kernel.org/netdev/net/c/bc65bacf239d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


