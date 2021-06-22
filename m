Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B9D3B0F84
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 23:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbhFVVlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 17:41:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229501AbhFVVlD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 17:41:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F2756128E;
        Tue, 22 Jun 2021 21:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624397927;
        bh=z1g0VAGANwPeUAqNQcogHM1/8gPB2g8iknW3WucZ0IQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WpGDn4sVC+SMSNx8DS0zGW4S26xRXDzLNzRb6P2Y7m+Ln9T7xdiQ4fdJvGI5587HP
         GT4+OKbM9uDChV9HZL2478KdI8ZCmwrDNaEELfToie9F1EjCnx1bY6ncrJ33wgXZMZ
         eCEK2WZs1Kr0YMXfK0N08IBPgclmqx4TtF9gCSbm9FA5Ol0iHdLHe6JzFpdWiBjind
         WFWoyj9o9pyT1Oxm0wRv+DxPXBj6dkF/9elLnqTnEGAKsnnFuqaauwA2kG+N7o4Udu
         O84/HmY/mjEaeRaaKi7X+AVQVjWVN+8PSWZXQEl5jr6UWCVR+SXxEbQY5KlD+1w1wP
         ieXj66aSOtVaQ==
Message-ID: <bb1dc5a6fb960f622107d832de3fc44a337a3b42.camel@kernel.org>
Subject: Re: [PATCH v2] net/mlx5: Fix missing error code in mlx5_init_fs()
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     leon@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 22 Jun 2021 14:38:46 -0700
In-Reply-To: <1624342161-84389-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1624342161-84389-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-06-22 at 14:09 +0800, Jiapeng Chong wrote:
> The error code is missing in this code scenario, add the error code
> '-ENOMEM' to the return value 'err'.
> 
> Eliminate the follow smatch warning:
> 
> drivers/net/ethernet/mellanox/mlx5/core/fs_core.c:2973 mlx5_init_fs()
> warn: missing error code 'err'.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Fixes: 4a98544d1827 ("net/mlx5: Move chains ft pool to be used by all
> firmware steering").
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
> Changes in v2:
>   - For the follow advice:
> https://lore.kernel.org/patchwork/patch/1446816/
> 


Applied to net-next-mlx5
Thanks!

