Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459A4304CD2
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 23:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730970AbhAZW4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 17:56:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:36024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730196AbhAZFsX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 00:48:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56BD52223D;
        Tue, 26 Jan 2021 05:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611640056;
        bh=fdSOnwAdECsh9e4D12P2TDgGGXHWz6FhwS7h3u8oCzc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WgpeeOpc+mLw6ffnHsnXuoF8Ou4IRIxe6AQ3+TWXdw+6GnnDUPMxPlxsm5qRl3Bmf
         hEt4MEnwLsGxrjZsGmVF9TeqW/o+umnJKVj10Cw8lZcYGqwOm8pDA+f6tYvK4SoomC
         egFz53UBHKe5y2SNQ2CJiZSrjalxSsTAFio4BOupRINGkES3nyX1OWzzR2I0sodni1
         dvCZa4bTWqfwezKSAurFxJICbQVnw4jRV6cCruJrVgH2JO3tN0gP5BFpC8/5mud1hf
         zHYEW2MMDbLHo6MfM6QWvGuTTDrKiUS/JlSPfja3ICHjWkhXm3mId068Wl8RGFJUL1
         ehQpusksK6z4Q==
Date:   Tue, 26 Jan 2021 07:47:32 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>, dledford@redhat.com,
        kuba@kernel.org, davem@davemloft.net, linux-rdma@vger.kernel.org,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH 21/22] RDMA/irdma: Add irdma Kconfig/Makefile and remove
 i40iw
Message-ID: <20210126054732.GP579511@unreal>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-22-shiraz.saleem@intel.com>
 <20210125185007.GU4147@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125185007.GU4147@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 02:50:07PM -0400, Jason Gunthorpe wrote:
> On Fri, Jan 22, 2021 at 05:48:26PM -0600, Shiraz Saleem wrote:
> > Add Kconfig and Makefile to build irdma driver.
> >
> > Remove i40iw driver and add an alias in irdma.
> > irdma is the replacement driver that supports X722.
> >
> > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > ---
>
> This didn't make it to patchworks or the mailing list

It arrived - https://lore.kernel.org/linux-rdma/20210125185007.GU4147@nvidia.com/
Yesterday, VGER had some weird behaviour.

Thanks
