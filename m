Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6993357EED
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 11:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbhDHJRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 05:17:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229600AbhDHJRl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 05:17:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 785BD61139;
        Thu,  8 Apr 2021 09:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617873451;
        bh=BL5ONyxMkyZ0JDNLF0/KGTXxejLggZKA1i2touSW/Lo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H2kO/NV0cOemarRn8dQRmy2JVmre7kLc+iSpTRx5Qeq5XqdBrp4YnuFZD6eecYAkm
         PPkyPBzpbD87zxP0gxF1IL6W8WET2WR3avFXfnhTZ4qNuKGNXd3qE8zZ5X+O7C9m1h
         p8E+ywKKe7mW3RAKDwKQwcC9tNhfRAb7bpFNKWdA=
Date:   Thu, 8 Apr 2021 11:17:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, jasowang@redhat.com, parav@nvidia.com,
        si-wei.liu@oracle.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 0/5] VDPA mlx5 fixes
Message-ID: <YG7KKI+8Z6ocGwNf@kroah.com>
References: <20210408091047.4269-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408091047.4269-1-elic@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 08, 2021 at 12:10:42PM +0300, Eli Cohen wrote:
> Hi Michael,
> 
> The following series contains fixes to mlx5 vdpa driver.  Included first
> is Siwei's fix to queried MTU was already reviewed a while ago and is
> not in your tree.
> 
> Patches 2 and 3 are required to allow mlx5_vdpa run on sub functions.
> 
> This series contains patches that were included in Parav's series
> http://lists.infradead.org/pipermail/linux-mtd/2016-January/064878.html
> but that series will be sent again at a later time.
> 
> Eli Cohen (4):
>   vdpa/mlx5: Use the correct dma device when registering memory
>   vdpa/mlx5: Retrieve BAR address suitable any function
>   vdpa/mlx5: Fix wrong use of bit numbers
>   vdpa/mlx5: Fix suspend/resume index restoration
> 
> Si-Wei Liu (1):
>   vdpa/mlx5: should exclude header length and fcs from mtu
> 
>  drivers/vdpa/mlx5/core/mlx5_vdpa.h |  4 +++
>  drivers/vdpa/mlx5/core/mr.c        |  9 +++++--
>  drivers/vdpa/mlx5/core/resources.c |  3 ++-
>  drivers/vdpa/mlx5/net/mlx5_vnet.c  | 40 ++++++++++++++++++------------
>  4 files changed, 37 insertions(+), 19 deletions(-)
> 
> -- 
> 2.30.1
> 


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
