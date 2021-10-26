Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2075743BB5F
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 22:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239089AbhJZUHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 16:07:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235867AbhJZUHo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 16:07:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75F0160F9D;
        Tue, 26 Oct 2021 20:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635278720;
        bh=jhURzkmwcnADUAxZi7K5TPlLGMcgCunPMfgI+YflCH8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uPSOtjPPDuhzy9qkAMcnJj/odcm2Hlsg+5edI7TLsglMUcrso/ImS39sMbllExypG
         fBT30iFMmCiM7QxYiI7tOU/x7POAKzibqEkjqFgnHet/gK4RULjsoHKFwLhVgKS+gS
         B6GYk88TEvJfR4OPJHh7KuVDMkn0M3EprgyXssCM=
Date:   Tue, 26 Oct 2021 22:05:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Manish Chopra <manishc@marvell.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, stable@vger.kernel.org,
        aelior@marvell.com, skalluru@marvell.com, malin1024@gmail.com,
        smalin@marvell.com, okulkarni@marvell.com, njavali@marvell.com,
        GR-everest-linux-l2@marvell.com
Subject: Re: [PATCH net-next 1/2] bnx2x: Utilize firmware 7.13.20.0
Message-ID: <YXhfe1+HMyPJECJ3@kroah.com>
References: <20211026193717.2657-1-manishc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026193717.2657-1-manishc@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 12:37:16PM -0700, Manish Chopra wrote:
> Commit 0050dcf3e848 ("bnx2x: Add FW 7.13.20.0") added a new .bin
> firmware file to linux-firmware.git tree. This new firmware addresses
> few important issues and enhancements as mentioned below -
> 
> - Support direct invalidation of FP HSI Ver per function ID, required for
>   invalidating FP HSI Ver prior to each VF start, as there is no VF start
> - BRB hardware block parity error detection support for the driver
> - Fix the FCOE underrun flow
> - Fix PSOD during FCoE BFS over the NIC ports after preboot driver
> 
> This patch incorporates this new firmware 7.13.20.0 in bnx2x driver.
> 
> Signed-off-by: Manish Chopra <manishc@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
