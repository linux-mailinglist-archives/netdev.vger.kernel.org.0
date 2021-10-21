Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF05D436014
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 13:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbhJULWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 07:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230117AbhJULWY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 07:22:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6CB0C60EFE;
        Thu, 21 Oct 2021 11:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634815208;
        bh=gpYC4W/vc6iei6pO1QVdAL68XIi7HrwTRlwyJ0HdRmE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DCZ6Ys3NshCF3FSUE6ViErbeqT/XtVkPbaniZZ22fmow/RtQzdLd0FotE3bdfOehT
         r1k/c6PNkdqUgG/x3+czWjCrfsW8CCe9dkE0i5/AUCw/a0qYxZP691YxCSmqy/jBal
         YSgHqcKB6kkRGfSS3IaNYov7eUGHkKnCeUE2a4WNpi6Iv8kYjAuRrurt8IdBEktMf+
         j06PTI9uJ62FpKpj49MngcarTgW3zwsedKUh06dcY2sqn3ltyZx5uFJpmh7lbxajr/
         FLd6imvSWHD2olt0mVN5+CLKpr1Sx0q7i1Cr7A6SBQ73c2MACIBiTYsK7KhfI34NTp
         sSFMmPPDw+Suw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 61C6660A21;
        Thu, 21 Oct 2021 11:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 1/5] net/mlx5: Lag,
 change multipath and bonding to be mutually exclusive
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163481520839.3134.5213936585053196317.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Oct 2021 11:20:08 +0000
References: <20211020175627.269138-2-saeed@kernel.org>
In-Reply-To: <20211020175627.269138-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        maord@nvidia.com, roid@nvidia.com, mbloch@nvidia.com,
        saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Wed, 20 Oct 2021 10:56:23 -0700 you wrote:
> From: Maor Dickman <maord@nvidia.com>
> 
> Both multipath and bonding events are changing the HW LAG state
> independently.
> Handling one of the features events while the other is already
> enabled can cause unwanted behavior, for example handling
> bonding event while multipath enabled will disable the lag and
> cause multipath to stop working.
> 
> [...]

Here is the summary with links:
  - [net,1/5] net/mlx5: Lag, change multipath and bonding to be mutually exclusive
    https://git.kernel.org/netdev/net/c/14fe2471c628
  - [net,2/5] net/mlx5: E-switch, Return correct error code on group creation failure
    https://git.kernel.org/netdev/net/c/a6f74333548f
  - [net,3/5] net/mlx5e: Fix vlan data lost during suspend flow
    https://git.kernel.org/netdev/net/c/68e66e1a69cd
  - [net,4/5] net/mlx5e: IPsec: Fix a misuse of the software parser's fields
    https://git.kernel.org/netdev/net/c/d10457f85d4a
  - [net,5/5] net/mlx5e: IPsec: Fix work queue entry ethernet segment checksum flags
    https://git.kernel.org/netdev/net/c/1d0003239401

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


