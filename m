Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B41F2EC3C5
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 20:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbhAFTRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 14:17:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbhAFTRv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 14:17:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EE1C23134;
        Wed,  6 Jan 2021 19:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609960631;
        bh=0Pu7adIfx+TshVDqWxzrK/3Kiozb9CEx1BrNKGluJGc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BkL1BOXDR9NlSer9BHA764flsukyNjoaXtCqTd3anMOepMb+TWRtRt2fyO1Da+wQC
         GJpS20S1E2NuJp0/PDcMa4MKfoTygeqZay9jV3CIbw8hB0v7Zbh7Wwzx5vTC5WdoKR
         uc3cZaGvwYYV/7nVv3twhIP8vaI/v2LMoB9fYUCDd6NbmrM6WIwosela1toweNq+R2
         Vtw688OaygsOjaikyG+X1uZTyn7PWu2D2jQelf/Ev9NgIAXPPccEsgP7b5o9C/Aq/a
         TI4KsKeewURMVmqlYvLVkMiU0IJaHKbNh24HWhrRHqSDWm7yes0W7HZajKtHiTECJ/
         Ht//2fapQdcig==
Date:   Wed, 6 Jan 2021 11:17:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [net] net: feature check mandating HW_CSUM is wrong
Message-ID: <20210106111710.34ab4eab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210106175327.5606-1-rohitm@chelsio.com>
References: <20210106175327.5606-1-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 Jan 2021 23:23:27 +0530 Rohit Maheshwari wrote:
> Mandating NETIF_F_HW_CSUM to enable TLS offload feature is wrong.
> And it broke tls offload feature for the drivers, which are still
> using NETIF_F_IP_CSUM or NETIF_F_IPV6_CSUM. We should use
> NETIF_F_CSUM_MASK instead.
> 
> Fixes: ae0b04b238e2 ("net: Disable NETIF_F_HW_TLS_TX when HW_CSUM is disabled")
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>

Please use Tariq's suggestion.

Please learn to CC appropriate reviewers.
