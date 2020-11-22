Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3602BC2CB
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 01:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgKVAB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 19:01:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:60874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbgKVAB4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 19:01:56 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1F8B20BED;
        Sun, 22 Nov 2020 00:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606003316;
        bh=eOI8bH5V5jGEvjSLw/KcrnwY3zWgvqBRBDD10/wLwLU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tA+PuGrnnIQoeECNIiOCk455GTIs3jwuiG25tDdMdjqavtaIVEFefkRRBCa30Pn53
         uT37nNtVKNGVL0vL4t1CRaDqnRhKTwj/rkD8b7ZsGHUyTokOs6T0jnk35+KzOwoF8G
         Lq8yv0DxH3eZBxyEfERw92VvUrDJx2Y9n0yAGNPg=
Date:   Sat, 21 Nov 2020 16:01:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, Eli Cohen <eli@mellanox.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH mlx5-next 11/16] net/mlx5: Add VDPA priority to NIC RX
 namespace
Message-ID: <20201121160155.39d84650@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201120230339.651609-12-saeedm@nvidia.com>
References: <20201120230339.651609-1-saeedm@nvidia.com>
        <20201120230339.651609-12-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 15:03:34 -0800 Saeed Mahameed wrote:
> From: Eli Cohen <eli@mellanox.com>
> 
> Add a new namespace type to the NIC RX root namespace to allow for
> inserting VDPA rules before regular NIC but after bypass, thus allowing
> DPDK to have precedence in packet processing.

How does DPDK and VDPA relate in this context?
