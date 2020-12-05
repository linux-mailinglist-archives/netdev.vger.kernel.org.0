Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDA12CFFC8
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 00:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbgLEXg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 18:36:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:50720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727020AbgLEXg1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 18:36:27 -0500
Date:   Sat, 5 Dec 2020 15:35:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607211346;
        bh=XpAe6t11BXfs5EsPOMWcWZWDJUoklZacyMPKJNVjtIU=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=PAhd3J8PEOTuV+wjZx3gIWm+n6kD5GO4wZHTywgYgb+riorIc1e9vy6Za7arhfr1Z
         GBTQEa1yjJ9tch/BIBmBRNJ2qDhNAthD1PfnNLuDeJXHFT37NHWMchPZMLSmVb2ohX
         9g/YQbeC9A0YPGj9JWL5TlOYwffH0lf0OxgWohW76JUm58Fk/0kHcyGR09cyfY3YBu
         Dgo0d9UuNCLotIkJ6c88iuvXJQlb+LBE1C9nMTYAXTdmj5E34oU2d6fOF/rC9M5o6j
         23ZKdKGy63iFFTCl7rXYYdAwcsRsU6xMabUGm+qmw4uDWjN7r3Juat8prNB0cKaEwp
         zHNiKOX3CF6sA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [pull request][for-next] mlx5-next auxbus support
Message-ID: <20201205153545.3d30536b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201204182952.72263-1-saeedm@nvidia.com>
References: <20201204182952.72263-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Dec 2020 10:29:52 -0800 Saeed Mahameed wrote:
> This pull request is targeting net-next and rdma-next branches.
> 
> This series provides mlx5 support for auxiliary bus devices.
> 
> It starts with a merge commit of tag 'auxbus-5.11-rc1' from
> gregkh/driver-core into mlx5-next, then the mlx5 patches that will convert
> mlx5 ulp devices (netdev, rdma, vdpa) to use the proper auxbus
> infrastructure instead of the internal mlx5 device and interface management
> implementation, which Leon is deleting at the end of this patchset.
> 
> Link: https://lore.kernel.org/alsa-devel/20201026111849.1035786-1-leon@kernel.org/
> 
> Thanks to everyone for the joint effort !

Pulled, thanks! (I'll push out after build finishes so may be an hour)
