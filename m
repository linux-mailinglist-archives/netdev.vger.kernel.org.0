Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA43230CE27
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 22:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbhBBVoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 16:44:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233348AbhBBVn7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 16:43:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FA8464F6A;
        Tue,  2 Feb 2021 21:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612302198;
        bh=vBTm+lkvftWM64dtgpUUjGGkJ2T+5eu9cUKdfsqzH/A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PVujA1Avn9iAVJDWU9P29f5IzclKZgViBpx370DlVLicmIlfSU4uBGEJtk6q2DLLY
         YGrkMHf3AyocRd37mAbjEmSQqL0PLNx9aTNtzUwjLbei827x/fvICIsCvSBd9BESfV
         9SyT5NBLzyYfeVdRJKy+r1vgTk00tKF1Gj6U81wdpi10gD6yEnqhxnMXblzSQK5naH
         FwSPwWG+MrhaIC6IASOUyZZTnOzcyvsHEFA4l4cCGDhnHsdbo/Pb8Rhj8stO4Et3fo
         iy1jSH/ODlCZ3S4U6iS2J4bTvy40g+kkl/IPJTczSgA1MhjM7dQRTqrYSlOdqQsZrL
         XVLS24/bJh/NA==
Message-ID: <033388a2b5cd97d879c5dea20c24c1f7a825d812.camel@kernel.org>
Subject: Re: [PATCH net-next v6] net: psample: Introduce stubs to remove NIC
 driver dependency
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Chris Mi <cmi@nvidia.com>, netdev@vger.kernel.org, jiri@nvidia.com,
        kernel test robot <lkp@intel.com>,
        Ido Schimmel <idosch@idosch.org>
Date:   Tue, 02 Feb 2021 13:43:17 -0800
In-Reply-To: <20210202132446.11d3af03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210201020412.52790-1-cmi@nvidia.com>
         <20210201171441.46c0edaa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <2dbcb5f51fd2ad1296c4391d45a854fef3438420.camel@kernel.org>
         <20210202132446.11d3af03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-02-02 at 13:24 -0800, Jakub Kicinski wrote:
> On Mon, 01 Feb 2021 23:31:15 -0800 Saeed Mahameed wrote:

...

> > 
> > Jakub, it is not only about installation dependencies, the issue is
> > more critical than this, 
> > 
> > We had some other issues with similar dependency problem where
> > mlx5_core had hard dependency with netfilter, firewalld when
> > disabled,
> > removes netfilter and all its dependencies including mlx5, this is
> > a no
> > go for our users.
> > 
> > Again, having a hard dependency between a hardware driver and a
> > peripheral module in the kernel is a bad design.
> 
> That is not the point.
> 
> The technical problem is minor, and it's a problem for _your_ driver.
> Yet, it appears to be my responsibility to make sure the patch even
> compiles.
> 

I understand your frustration, We should have been more professional
with this patch submission, 

> I believe there should be a limit to the ignorance a community
> volunteer is expected to put up with when dealing with patches 
> from and for the benefit of a commercial vendor.
> 

totally agree, we have the tools internally to avoid clutter in mailing
list and we do this for pure mlx5 patches, but for net patches, people
tend to hurry and skip the queue so they get feedback ASAP.. 
this doesn't make it right, I will work to improve this.

> This is up for discussion, if you disagree let's talk it out. I'm 
> not particularly patient (to put it mildly), but I don't understand 
> how v5 could have built, and yet v6 gets posted with the same exact
> problem :/
> 

given the circumstance i would've done the same, even on v4.. 
sorry for the inconvenience .. :(.. thanks for your patience. 

> So from my perspective it seems like the right step to push back.

And I back you up !

> If you, Tariq, Jiri, Ido or any other seasoned kernel contributor
> reposts this after making sure it's up to snuff themselves I will
> most certainly take a look / apply.

My point wasn't about psample, it's about hw drivers vs stack/modules
dependency in general, maybe I used the wrong patch to discuss this
matter :D.. 

I will post a separate RFC for discussion later not related to psample
at all. this patch smells so bad we can't even discuss the general
issue here ..

Again thanks for your review and patience.



