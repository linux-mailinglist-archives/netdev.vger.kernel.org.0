Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24FC1CC656
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 05:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgEJDyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 23:54:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgEJDyB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 23:54:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B17E206A3;
        Sun, 10 May 2020 03:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589082841;
        bh=uEOFvI75ubNLIeb36hNA+MTOA1PJZymcXZrD8EgPkPQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TLdP1s5T0Oy6cwa4XRtPJCvIt2TOADZdcB/F+LlfXdiTBdXbEPOkeQhexYCLmkSZA
         hTbNJ8OyOyMN/n3NInx9aHkNAuXfaAcIpjj6RiWR1OEqFDRp9Vk5zkZ6TPEI4dNdAS
         Y7uVlGFpnF9ymoMIyAGVAWF7J+J9jSEw6FF+PoTY=
Date:   Sat, 9 May 2020 20:53:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5: Replace zero-length array with flexible-array
Message-ID: <20200509205359.22d8b389@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <fb46eb601f979d5d8d95ec5749ae06c1bc86d469.camel@mellanox.com>
References: <20200507185935.GA15169@embeddedor>
        <20200508163642.273bda4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <fb46eb601f979d5d8d95ec5749ae06c1bc86d469.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 May 2020 23:43:08 +0000 Saeed Mahameed wrote:
> > Saeed, I'm expecting you to take this and the mlx4 patch via your
> > trees.  
> 
> Yes for the mlx5 patch, but usually Dave takes mlx4 patches directly.

Ack, it said IB on it, but looks like the patch can as well be applied
to net-next, so I took it.
