Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821B341E27A
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 21:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346859AbhI3T4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 15:56:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229798AbhI3T4a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 15:56:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 681166115C;
        Thu, 30 Sep 2021 19:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633031687;
        bh=/33EgpV94xJVAeFkqApfhDklJr1f3S3DZ/6O6O8hiFo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cbo0S5H5Vigjd6HNkkVGvXZ1vv1DOu1NusfSf7rRdcEUnxdN6ZOxrIVuSNO+awMVj
         OHp+2TdyyE9M3E42QtLXqt8twBSX+zFGq9twb/jZdUe7BsCE5Sn/U70Bmd38ELXW4C
         GLusYlBJOJ++Rayxwlprf4UvVaiVHB95V393Rr0JB2iyLNJbBcxp3eQ/SYH2M8hNbU
         BBG0sd+iTbzUqYtscyBm+JxMRaU7KizGiSEzncC+4cZ2y7QFDMJGY9b0P6wDsLj4EA
         W4YWvcLwVXunmgGZ9H8LITFY+Y0emgRZtmDpEbaqaUQri4fmweixSrBYvx35aDbQ26
         +S8gbd553npeQ==
Date:   Thu, 30 Sep 2021 14:58:53 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][net-next] net/mlx5: Use struct_size() helper in
 kvzalloc()
Message-ID: <20210930195853.GA820136@embeddedor>
References: <20210928221157.GA278221@embeddedor>
 <c121c9b4a21066eed32351e3324919df1c14d1c2.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c121c9b4a21066eed32351e3324919df1c14d1c2.camel@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 07:06:32PM +0000, Saeed Mahameed wrote:
> On Tue, 2021-09-28 at 17:11 -0500, Gustavo A. R. Silva wrote:
> > Make use of the struct_size() helper instead of an open-coded
> > version,
> > in order to avoid any potential type mistakes or integer overflows
> > that,
> > in the worse scenario, could lead to heap overflows.
> > 
> > Link: https://github.com/KSPP/linux/issues/160
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> applied to net-next-mlx5

Thanks, Saeed.
--
Gustavo
