Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F324A308241
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 01:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbhA2AMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 19:12:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:33306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229530AbhA2AMM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 19:12:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 863B864E00;
        Fri, 29 Jan 2021 00:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611879092;
        bh=U2G/4+anSuoivbTG6gBrrR2upHQ7Nmu4KR3DvShYR8g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oUhHl8M/O4g8iy2fye2tykA+kNYqh27s8YW7fm2qPgBjZoMfDxfCKE9kn1ETwMxwj
         vvUDroI9ZxXSIMAE2ppnFweZLE7EJqA3UjYkcUef/J6devwdtht1QX0/jAh1NOtWlE
         RaisfacJ8mObMaIruGr7/InWp9MpOdCniztWY0JEi2Hf9uhsZz4iBMxdhcPD7lMukD
         ZjMwZsdxALDvm4crr5BftOjWbPHrxlL+TiBQDcWIZlTCaBF6F+sYSpQriA8G0BWy5T
         Q9qCi41Jwk575SFd7QvEZn5h2mebsXMRhfOpLpRBvobM4IT3qRvVjchYG4Zn6mzLXm
         jB7q1k5Rw+o3A==
Date:   Thu, 28 Jan 2021 16:11:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     sridhar.samudrala@intel.com, edwin.peer@broadcom.com,
        jacob.e.keller@intel.com, "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, alexander.duyck@gmail.com,
        dsahern@kernel.org, kiran.patil@intel.com,
        david.m.ertman@intel.com, dan.j.williams@intel.com
Subject: Re: [pull request][net-next V10 00/14] Add mlx5 subfunction support
Message-ID: <20210128161130.73cf3847@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d6fa72b34eb65e17847463bf7084f5a25c8ad492.camel@kernel.org>
References: <20210122193658.282884-1-saeed@kernel.org>
        <20210126173417.3123c8ea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d6fa72b34eb65e17847463bf7084f5a25c8ad492.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 16:03:02 -0800 Saeed Mahameed wrote:
> On Tue, 2021-01-26 at 17:34 -0800, Jakub Kicinski wrote:
> > On Fri, 22 Jan 2021 11:36:44 -0800 Saeed Mahameed wrote:  
> > > This series form Parav was the theme of this mlx5 release cycle,
> > > we've been waiting anxiously for the auxbus infrastructure to make
> > > it into
> > > the kernel, and now as the auxbus is in and all the stars are
> > > aligned, I
> > > can finally submit this patchset of the devlink and mlx5
> > > subfunction support.
> > > 
> > > For more detailed information about subfunctions please see
> > > detailed tag
> > > log below.  
> > 
> > Are there any further comments, objections or actions that need to be
> > taken on this series, anyone?
> > 
> > Looks like the discussion has ended. Not knowing any users who would
> > need this I'd like to at least make sure we have reasonable consensus
> > among vendors.  
> 
> Hey Jakub, sorry to nag, but I need to make some progress, can we move
> on please ? my submission queue is about to explode :) !

I'll pull it in by the end of the day, just need to do some backports
and then it'll be on top of my list.
