Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014913FC66F
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 13:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241460AbhHaLLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 07:11:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241394AbhHaLLD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 07:11:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3543761029;
        Tue, 31 Aug 2021 11:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630408208;
        bh=2zzrh9a57gW2PPL0pcOX8O6NaM2z5BKHHBkY1k+K2t8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IoXBlifFTtkHVlJSm1mSlAQ2HMxsHR987sk2dlwfQOXfmlIYGrPqkoIqoqKwkb/r3
         kmVgvGQJKnM7kWeG/XkuirEIDF5IIApQOBIe/9wQSBmYrXrDfzEn/0JuOlaHKaCy1j
         qCZcwG3XOmzGg8wXzDn1BDMnfhve7MdHSidc5hj+ThFdWrLe1/vRhXUHm96pB1un4+
         ALBlKN5rXzH6DCmyL/+eu2pte9Y3kBwsf4vv9h3/HUN7lJoSJRhAcgaUtVdtQFWzXh
         691InUctBGGM8/61Eg9kGXorECirPwDugdTIDVGksCar+uxyw0eRRM1bBN2NJ7dFM/
         v0/+vfrr1l7/Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2E3A160A94;
        Tue, 31 Aug 2021 11:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: qualcomm: fix QCA7000 checksum handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163040820818.5377.12294527428834922847.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Aug 2021 11:10:08 +0000
References: <20210828142315.7971-1-stefan.wahren@i2se.com>
In-Reply-To: <20210828142315.7971-1-stefan.wahren@i2se.com>
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     davem@davemloft.net, kuba@kernel.org, michael.heimpold@in-tech.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 28 Aug 2021 16:23:15 +0200 you wrote:
> Based on tests the QCA7000 doesn't support checksum offloading. So assume
> ip_summed is CHECKSUM_NONE and let the kernel take care of the checksum
> handling. This fixes data transfer issues in noisy environments.
> 
> Reported-by: Michael Heimpold <michael.heimpold@in-tech.com>
> Fixes: 291ab06ecf67 ("net: qualcomm: new Ethernet over SPI driver for QCA7000")
> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
> 
> [...]

Here is the summary with links:
  - [net] net: qualcomm: fix QCA7000 checksum handling
    https://git.kernel.org/netdev/net-next/c/429205da6c83

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


