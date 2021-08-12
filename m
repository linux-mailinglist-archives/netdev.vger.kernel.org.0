Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136C33EA405
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 13:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236999AbhHLLud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 07:50:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236983AbhHLLuc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 07:50:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6290760FC4;
        Thu, 12 Aug 2021 11:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628769007;
        bh=N1/IfY3McvGR0w97BQlpt9Pa2Z0dK/BuEy3qcT0arKg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=upxe6f6q2Fthg9FTPfglvg3EEUYmvULAOMVFr8PRKDIgxYG19ATQAfdSmQ5myqJd3
         UGlC37y17DDzcNC+1w2RzMCKzVixjy5GknxNetcSObRbqV5PSJZJ8sqsKCULXiXau2
         5jLHHBTKECmDP/UUK/dCxWjK8xPQRGaUKKL6U2Jr4c0JzUANNbvikkenHYKtEkr/U4
         62SiFpOhsvy7gijyt4dcjN0VIzvSqjDzIikbCtcl+YLvGoBBT+8rw6u8tL5vU93/s8
         ZFcJulIDXq0vKQfmCImce9cd68WMxbowRwqrtRGTt4SYKTqPa0gxmXY3rHeXEuy+Ds
         OSDSUHDYmj4zw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 57669608FA;
        Thu, 12 Aug 2021 11:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/12] net/mlx5: Fix typo in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162876900735.27021.12432200314262641667.git-patchwork-notify@kernel.org>
Date:   Thu, 12 Aug 2021 11:50:07 +0000
References: <20210811181658.492548-2-saeed@kernel.org>
In-Reply-To: <20210811181658.492548-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tariqt@nvidia.com, leonro@nvidia.com, caihuoqing@baidu.com,
        saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 11 Aug 2021 11:16:47 -0700 you wrote:
> From: Cai Huoqing <caihuoqing@baidu.com>
> 
> Fix typo:
> *vectores  ==> vectors
> *realeased  ==> released
> *erros  ==> errors
> *namepsace  ==> namespace
> *trafic  ==> traffic
> *proccessed  ==> processed
> *retore  ==> restore
> *Currenlty  ==> Currently
> *crated  ==> created
> *chane  ==> change
> *cannnot  ==> cannot
> *usuallly  ==> usually
> *failes  ==> fails
> *importent  ==> important
> *reenabled  ==> re-enabled
> *alocation  ==> allocation
> *recived  ==> received
> *tanslation  ==> translation
> 
> [...]

Here is the summary with links:
  - [net-next,01/12] net/mlx5: Fix typo in comments
    https://git.kernel.org/netdev/net-next/c/39c538d64479
  - [net-next,02/12] net/mlx5: Fix inner TTC table creation
    https://git.kernel.org/netdev/net-next/c/90b85d4e313c
  - [net-next,03/12] net/mlx5: Delete impossible dev->state checks
    https://git.kernel.org/netdev/net-next/c/8e792700b994
  - [net-next,04/12] net/mlx5: Align mlx5_irq structure
    https://git.kernel.org/netdev/net-next/c/211f4f99edc0
  - [net-next,05/12] net/mlx5: Change SF missing dedicated MSI-X err message to dbg
    https://git.kernel.org/netdev/net-next/c/68fefb70898a
  - [net-next,06/12] net/mlx5: Refcount mlx5_irq with integer
    https://git.kernel.org/netdev/net-next/c/2d0b41a37679
  - [net-next,07/12] net/mlx5: SF, use recent sysfs api
    https://git.kernel.org/netdev/net-next/c/4445abbd13cd
  - [net-next,08/12] net/mlx5: Reorganize current and maximal capabilities to be per-type
    https://git.kernel.org/netdev/net-next/c/5958a6fad623
  - [net-next,09/12] net/mlx5: Allocate individual capability
    https://git.kernel.org/netdev/net-next/c/48f02eef7f76
  - [net-next,10/12] net/mlx5: Initialize numa node for all core devices
    https://git.kernel.org/netdev/net-next/c/44f66ac981fa
  - [net-next,11/12] net/mlx5: Fix variable type to match 64bit
    https://git.kernel.org/netdev/net-next/c/979aa51967ad
  - [net-next,12/12] net/mlx5e: Make use of netdev_warn()
    https://git.kernel.org/netdev/net-next/c/61b6a6c395d6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


