Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42251276EA1
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 12:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbgIXKYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 06:24:20 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:17189 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbgIXKYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 06:24:20 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f6c73740000>; Thu, 24 Sep 2020 03:22:44 -0700
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 24 Sep
 2020 10:24:17 +0000
Date:   Thu, 24 Sep 2020 13:24:13 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        <virtualization@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH v3 -next] vdpa: mlx5: change Kconfig depends to fix build
 errors
Message-ID: <20200924102413.GD170403@mtl-vdi-166.wap.labs.mlnx>
References: <73f7e48b-8d16-6b20-07d3-41dee0e3d3bd@infradead.org>
 <20200918082245.GP869610@unreal>
 <20200924052932-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200924052932-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600942964; bh=xFEXTrh+NFdeK1/P8HCH4+uK/KDiUSTWNwiqN+Dfnco=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=Z6aKkXsqj6CePgZSTh5BKLnR3ekfwpY1807/Dnnp5tf+EovMIDHB+hGzJBrJuHNF6
         6hi5AG4mRMBN2WBVwPfVNe7p4Qwzz++whYxjyt4w/+wqp+Wtu0IKEOaHGunw34otQQ
         SAqByaskjPdhWMiu/1bYh/zdv4WjAmDL/ZBeF5szOK+wKQS3GLEuONnY343PlmU5A2
         B2TzYzjPsYgUWgqLsvBAmgrPDnPp1RSfjQqR+jWAJPmxYTyFvNXsMrNf/nBmVXoEbd
         78iGy79noz7Ey2hRR2IvNh+UbH5y94Mm8aHUKdU+vIFKF1N6peBQHjImumvZIksdhl
         2UI97+VI86Kwg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 05:30:55AM -0400, Michael S. Tsirkin wrote:
> > > --- linux-next-20200917.orig/drivers/vdpa/Kconfig
> > > +++ linux-next-20200917/drivers/vdpa/Kconfig
> > > @@ -31,7 +31,7 @@ config IFCVF
> > >
> > >  config MLX5_VDPA
> > >  	bool "MLX5 VDPA support library for ConnectX devices"
> > > -	depends on MLX5_CORE
> > > +	depends on VHOST_IOTLB && MLX5_CORE
> > >  	default n
> > 
> > While we are here, can anyone who apply this patch delete the "default n" line?
> > It is by default "n".

I can do that

> > 
> > Thanks
> 
> Hmm other drivers select VHOST_IOTLB, why not do the same?

I can't see another driver doing that. Perhaps I can set dependency on
VHOST which by itself depends on VHOST_IOTLB?
> 
> 
> > >  	help
> > >  	  Support library for Mellanox VDPA drivers. Provides code that is
> > >
> 
