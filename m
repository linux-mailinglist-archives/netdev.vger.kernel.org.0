Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D2D483E89
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 09:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiADI5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 03:57:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53000 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiADI5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 03:57:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 084E2B80CF7
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 08:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F35C36AE9;
        Tue,  4 Jan 2022 08:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641286653;
        bh=m1KmYo4QOQIeD+BwO4vEktFQbaMfGdIJVajIiLSoyVM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dw9aoh25QEQC1q+ZNyp8Uctij5rt4SWeBAvyhVoR5cFKycW60k0UWTq2cHZySNtTi
         KD4bmal71oeWYr3XFInXPTOd4CCg0sZi5lyx5JNtsazIUPs1kjbeh4OyDeJvxhFf6H
         UT+hRDFpiCbEi7Ge5WyRCCwYMrUwfqRxIvSqh2MN4QYU1wn29RG8p6+PqPMCHWC76T
         Ud2FffQICdiYeB1+nVE964cZhEtxwVkKMnoPeEWRMi6r0eue07PUxM/B0157zutxCl
         oxl+jgsuzvb8mW6XEPjTy0BWHIeZkwpoX1dTS0YqBym6Uwfd7OTcrG3yKlJw9Ek2uM
         YjP7WO0Wf7NqA==
Date:   Tue, 4 Jan 2022 10:57:29 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: Re: [PATCH net-next] net: vertexcom: default to disabled on kbuild
Message-ID: <YdQL+Rc3ItCYpN/D@unreal>
References: <20220102221126.354332-1-saeed@kernel.org>
 <20220103084321.48236cfa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220103084321.48236cfa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 03, 2022 at 08:43:21AM -0800, Jakub Kicinski wrote:
> On Sun,  2 Jan 2022 14:11:26 -0800 Saeed Mahameed wrote:
> > Sorry for being rude but new vendors/drivers are supposed to be disabled
> > by default, otherwise we will have to manually keep track of all vendors
> > we are not interested in building.
> 
> Vendors default to y, drivers default to n. Vendors don't build
> anything, hence the somewhat unusual convention. Are you saying
> you want to change all the Kconfigs... including Mellanox?

I would love to see such patch. It will help me to manage build configs
to their minimum without worrying to press "N" every time I switch from
builds of net-next to any other tree without newly introduced vendor.

https://lore.kernel.org/netdev/20200930095526.GM3094@unreal/
https://lore.kernel.org/netdev/20200930104459.GO3094@unreal/

And yes, including Mellanox.

Thanks 
