Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A33723EDCA
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 15:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgHGNNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 09:13:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbgHGNNL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 09:13:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5077F221E2;
        Fri,  7 Aug 2020 13:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596805990;
        bh=RIROhGCUr6NfNZISR9NQfCWS8Ha9p5SdQ9TURZQvdCE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0FO90bdO6KMgNNPYC5unU8kW23VZcvv0qZiXLzMRtq/EIGVuKxkE31J3KUpFyerys
         TgprBZL/lMT43rGUKLf4CqL/Ng77OEg02Rq3M0BSD5MfvFodS5jQXh3IBMqnGeDZaN
         52TUuviux1KmHWP+1Z71F2PqFUfikXg79I/dlHFk=
Date:   Fri, 7 Aug 2020 15:13:23 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        netdev@vger.kernel.org, Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH 4.19] net/mlx5e: Don't support phys switch id if not in
 switchdev mode
Message-ID: <20200807131323.GA664450@kroah.com>
References: <20200807020542.636290-1-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200807020542.636290-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 06, 2020 at 07:05:42PM -0700, Saeed Mahameed wrote:
> From: Roi Dayan <roid@mellanox.com>
> 
> Support for phys switch id ndo added for representors and if
> we do not have representors there is no need to support it.
> Since each port return different switch id supporting this
> block support for creating bond over PFs and attaching to bridge
> in legacy mode.
> 
> This bug doesn't exist upstream as the code got refactored and the
> netdev api is totally different.
> 
> Fixes: cb67b832921c ("net/mlx5e: Introduce SRIOV VF representors")
> Signed-off-by: Roi Dayan <roid@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
> Hi Greg,
> 
> Sorry for submitting a non upstream patch, but this bug is
> bothering some users on 4.19-stable kernels and it doesn't exist
> upstream, so i hope you are ok with backporting this one liner patch.

Also queued up to 4.9.y and 4.14.y.

thanks,

greg k-h
