Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1439F2BC2C8
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 00:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgKUX6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 18:58:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:60010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbgKUX6x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 18:58:53 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8ECE208B6;
        Sat, 21 Nov 2020 23:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606003133;
        bh=NguiQML7DP2UKGGce/Au7HpsoxG+V5xLQC4ZV49v6Gc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=y2nTtQ/hve+FNZlA50fKeB+9na+LjoCZThjjhGbz5QaoqFTxDTdKY4MBYxOzWPe7I
         rytGtftWsk4onFC5FKnS/ANaM2MJ5td1j5zu8o2YcXMrC1f+qapj8p/zD72Ziv6be/
         36Hzm/ETMYYo7orliveqb+WUhfsSjGAX8uLLp4eA=
Date:   Sat, 21 Nov 2020 15:58:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [PATCH mlx5-next 09/16] net/mlx5: Expose IP-in-IP TX and RX
 capability bits
Message-ID: <20201121155852.4ca8eb68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201120230339.651609-10-saeedm@nvidia.com>
References: <20201120230339.651609-1-saeedm@nvidia.com>
        <20201120230339.651609-10-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 15:03:32 -0800 Saeed Mahameed wrote:
> From: Aya Levin <ayal@nvidia.com>
> 
> Expose FW indication that it supports stateless offloads for IP over IP
> tunneled packets per direction. In some HW like ConnectX-4 IP-in-IP
> support is not symmetric, it supports steering on the inner header but
> it doesn't TX-Checksum and TSO. Add IP-in-IP capability per direction to
> cover this case as well.

What's the use for the rx capability in Linux? We don't have an API to
configure that AFAIK.
