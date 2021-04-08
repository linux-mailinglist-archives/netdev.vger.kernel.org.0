Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C393C3582AC
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 14:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhDHMED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 08:04:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229837AbhDHMEC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 08:04:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A81E610C7;
        Thu,  8 Apr 2021 12:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617883431;
        bh=hlFBeorZ9AegEwLeMoklzxzN6tgZwYSuxQSshLWDofk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZsBwDGDM1bsC5j6rmjdYexr4Lzhv5xXQGQpZ/FkP/E1Vr0fSaAOrOcLE8E4vIPtBL
         wHV8AFD2JtMdFAUlxGQEYWa7HrJF0heJeKD3ql9BFQBkApqzat9FA5PtFN6oEXefq8
         DvEB5hQJFVWmj0esvFIhGxll4cVTnMwXVIt0HtgyrfXJcn1e3hBD3r6Z3crgToP/Sb
         SrfCSzSEG5otsyPojh6HeQigjEvYGoZoeu5LDTevr7yqwvqxM0OribLXAGoiUIyMYa
         zXLCOddIL3MsWob09uzJBxA6MJR93xA+E6fUZi01bigwuxRSpk2sqaCiO0Jw2D62df
         JG5EIj4MgW8MQ==
Date:   Thu, 8 Apr 2021 15:03:47 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Devesh Sharma <devesh.sharma@broadcom.com>,
        Doug Ledford <dledford@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Netdev <netdev@vger.kernel.org>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Subject: Re: [PATCH rdma-next v2 0/5] Get rid of custom made module dependency
Message-ID: <YG7xI51hbm4JNX8K@unreal>
References: <20210401065715.565226-1-leon@kernel.org>
 <CANjDDBiuw_VNepewLAtYE58Eg2JEsvGbpxttWyjV6DYMQdY5Zw@mail.gmail.com>
 <YGhUjarXh+BEK1pW@unreal>
 <CANjDDBiC-8pL+-ma1c0n8vjMaorm-CasV_D+_8q2LGy-AYuTVg@mail.gmail.com>
 <YG7srVMi8IEjuLfF@unreal>
 <20210408115347.GO7405@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408115347.GO7405@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 08, 2021 at 08:53:47AM -0300, Jason Gunthorpe wrote:
> On Thu, Apr 08, 2021 at 02:44:45PM +0300, Leon Romanovsky wrote:
> 
> > > In my internal testing, I am seeing a crash using the 3rd patch. I am
> > > spending a few cycles on debugging it. expect my input in a day or so.
> > 
> > Can you please post the kernel crash report here?
> > I don't see how function rename in patch #3 can cause to the crash.
> 
> I looked too, I'm also quite surprised that 1,2,3 alone have a
> bug.. Is there some condition where ulp_probe can be null?

My speculative guess that they are testing not upstream kernel/module.

> 
> Ugh the is_bnxt_re_dev() is horribly gross too

The whole bnxt* code is very creative. The function bnxt_re_from_netdev()
below is junk too.

It is interesting to see how my review skills from 2017 improved over years :).

Thanks

> 
> Jason
