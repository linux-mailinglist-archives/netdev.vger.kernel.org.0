Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBB93067D1
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 00:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbhA0XYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 18:24:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233575AbhA0XBW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 18:01:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55FAE64DCC;
        Wed, 27 Jan 2021 22:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611786141;
        bh=d/HomjGm/Ofz7qdBNNFuasnYZnYIWYSXkBkDkCmZbJE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ILpmXW/ZhYhGt89/9UnoYdPQ5xTaLQplddUGGgujz23SHU80iCXOXroJDgKT6cHnT
         n6vfhVlzyv/esO+3HoWqu9ubZHKyom93UhNobA8jFAzBpqRBPyKaF4mrNAHR6nfL3U
         tlkvackRIXelKS41HXV+FzAN9GOSlT1aSxYRuGlH53iqFchDjxwx+ZwCwYqqsX6VTK
         LUSnjTmSYeohJ3Kxdzi2X5re2jhDThxgrwZnoG//mjYBvpXT75748XiVOPsargQDgT
         Dw8Ko5hfE3k+5phSFbGiAwSC/HEfOjHqif957BL5QEQWE7VFyUdX1EGJVs84i2KJSg
         8YkENomTZ+Q3w==
Date:   Wed, 27 Jan 2021 14:22:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Chris Mi <cmi@nvidia.com>, netdev@vger.kernel.org, jiri@nvidia.com
Subject: Re: [PATCH net-next] net: psample: Introduce stubs to remove NIC
 driver dependency
Message-ID: <20210127142220.43aecad8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <46273ca40983f3cdabe6bfe552cabf22a788b02b.camel@kernel.org>
References: <20210126145929.7404-1-cmi@nvidia.com>
        <20210126184955.5f61784a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <46273ca40983f3cdabe6bfe552cabf22a788b02b.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jan 2021 20:50:28 -0800 Saeed Mahameed wrote:
> On Tue, 2021-01-26 at 18:49 -0800, Jakub Kicinski wrote:
> > On Tue, 26 Jan 2021 22:59:29 +0800 Chris Mi wrote:  
> > > In order to send sampled packets to userspace, NIC driver calls
> > > psample api directly. But it creates a hard dependency on module
> > > psample. Introduce psample_ops to remove the hard dependency.
> > > It is initialized when psample module is loaded and set to NULL
> > > when the module is unloaded.
> > > 
> > > Signed-off-by: Chris Mi <cmi@nvidia.com>
> > > Reviewed-by: Jiri Pirko <jiri@nvidia.com>  
> > 
> > This adds a bunch of sparse warnings.
> > 
> > MelVidia has some patch checking infra, right? Any reason this was
> > not
> > run through it?  
> 
> we do but we don't test warnings on non mlnx files, as we rely on the
> fact that our mlnx files are clean, We simply don't check for
> "added/diff" warnings, we check that mlnx files are kept clean, easier
> :) ..
> 
> Anyway I am working internally to clone/copy nipa into our CI.. hope it
> will work smoothly .. 

Exciting! :)
