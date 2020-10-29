Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBAD29E9E2
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 12:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgJ2LCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 07:02:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbgJ2LCc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 07:02:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4008E2072D;
        Thu, 29 Oct 2020 11:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603969311;
        bh=5ohHGgOU0GJJt6kXAqIi0aDDZtxgSeUQSguJlV/VLQY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i5bv54YL6HL6hhUpVryFoeFiiZqyYnTTwjBrQBcDFEswgJ9uYbZfviDib11iLKa5N
         POAs/1YlMYaSALMoDbd000e4PSAzGB6/MHkvszXMlUaKxDb7njsGuTvEJr0jFZu044
         h1gcFRki3vAgGqaNPJm9Re6n67ZWwq2Jc/i4jYwA=
Date:   Thu, 29 Oct 2020 12:02:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH linux-5.9 1/1] net: netfilter: fix KASAN:
 slab-out-of-bounds Read in nft_flow_rule_create
Message-ID: <20201029110241.GB3840801@kroah.com>
References: <20201019172532.3906-1-saeed.mirzamohammadi@oracle.com>
 <20201020115047.GA15628@salvia>
 <28C74722-8F35-4397-B567-FA5BCF525891@oracle.com>
 <3BE1A64B-7104-4220-BAD1-870338A33B15@oracle.com>
 <566D38F7-7C99-40F4-A948-03F2F0439BBB@oracle.com>
 <20201027062111.GD206502@kroah.com>
 <20201027081922.GA5285@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027081922.GA5285@salvia>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 09:19:22AM +0100, Pablo Neira Ayuso wrote:
> Hi Greg,
> 
> On Tue, Oct 27, 2020 at 07:21:11AM +0100, Greg KH wrote:
> > On Sun, Oct 25, 2020 at 04:31:57PM -0700, Saeed Mirzamohammadi wrote:
> > > Adding stable.
> > 
> > What did that do?
> 
> Saeed is requesting that stable maintainers cherry-picks this patch:
> 
> 31cc578ae2de ("netfilter: nftables_offload: KASAN slab-out-of-bounds
> Read in nft_flow_rule_create")
> 
> into stable 5.4 and 5.8.

5.9 is also a stable kernel :)

Will go queue it up everywhere...

thanks,

greg k-h
