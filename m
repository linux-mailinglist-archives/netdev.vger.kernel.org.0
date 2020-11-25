Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81192C4B20
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 23:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgKYWzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 17:55:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:59686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgKYWzY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 17:55:24 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBD8B206B5;
        Wed, 25 Nov 2020 22:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606344924;
        bh=j/hvd3cjK873DDM5cl/Tgva2Dec5RgrhacDW63mFRCs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W9Li1a7Dh3PBYUL+1Nk0vfZDTCmC66yL2iX6H5qEZF4Pg0me0wwU/BtA/aBsk8/nC
         X1lRh/a9Hz+jg5HJz9unLHdc2+geSxeuYGJVw5HQIEzBhVQltlgjQi/0SUrZ+U3DxB
         R8dtihxGfFr+h4qlldU4h/JDFE1JAxeqbhfw64E4=
Date:   Wed, 25 Nov 2020 14:55:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 0/2] enetc: Clean endianness warnings up
Message-ID: <20201125145523.4cfa4ecd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201118095435.633a6e2e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20201117182004.27389-1-claudiu.manoil@nxp.com>
        <20201118095258.4f129839@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201118095435.633a6e2e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 09:54:35 -0800 Jakub Kicinski wrote:
> On Wed, 18 Nov 2020 09:52:58 -0800 Jakub Kicinski wrote:
> > On Tue, 17 Nov 2020 20:20:02 +0200 Claudiu Manoil wrote:  
> > > Cleanup patches to address the outstanding endianness issues
> > > in the driver reported by sparse.    
> > 
> > Build bot says this doesn't apply to net-next, could you double check?  
> 
> Hm, not sure what happened there, it does seem to apply now.

Ah, I figured it out now. Apparently Patchwork orders the patches by
date / its own patch ID (assigned at arrival time).

When mbox for the series is downloaded things work correctly, but build
bot tries to fetch patches one by one, and there if patches arrived at
the mailing list out of order - they don't apply.

This wasn't as evident here with just two patches seemingly in the
right order but Randy just posted a 10 patch series which has the same
issue.

I reported it upstream [1] and tried to work around it in the bot.

Fingers crossed.

[1] https://github.com/getpatchwork/patchwork/issues/386
