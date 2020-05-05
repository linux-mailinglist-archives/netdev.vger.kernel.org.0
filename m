Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD491C5D48
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 18:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729561AbgEEQUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 12:20:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729289AbgEEQUM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 12:20:12 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC4AD206B9;
        Tue,  5 May 2020 16:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588695612;
        bh=UMDwU909vupsjtahcTxzxLjvsqMmXgYUqSOmkhh7xpA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DIq6Exya23je/ToZ+mHXBR9NzdJ+3so6e80FQZhm9lLwJXB2hNhUExQlpMlvbzY+N
         zQd+AMN5WdNslcdj0OhEpv+60ibuJ2qdbaI4bLYaOOmLhbykKEXQ5Wl4+a5OnQwRjZ
         +AF0QMKrbnlVk64Q0IO2kDgyQ7v1PmY+iuuaIXxk=
Date:   Tue, 5 May 2020 09:20:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     davem@davemloft.net, jiri@resnulli.us, netdev@vger.kernel.org,
        kernel-team@fb.com, jacob.e.keller@intel.com
Subject: Re: [PATCH iproute2-next v3] devlink: support kernel-side snapshot
 id allocation
Message-ID: <20200505092009.1cfe01c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <af7fae65-1187-65c5-9c40-0b0703cf4053@gmail.com>
References: <20200430175759.1301789-1-kuba@kernel.org>
        <20200430175759.1301789-5-kuba@kernel.org>
        <af7fae65-1187-65c5-9c40-0b0703cf4053@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 May 2020 10:14:24 -0600 David Ahern wrote:
> On 4/30/20 11:57 AM, Jakub Kicinski wrote:
> > Make ID argument optional and read the snapshot info
> > that kernel sends us.
> > 
> > $ devlink region new netdevsim/netdevsim1/dummy
> > netdevsim/netdevsim1/dummy: snapshot 0
> > $ devlink -jp region new netdevsim/netdevsim1/dummy
> > {
> >     "regions": {
> >         "netdevsim/netdevsim1/dummy": {
> >             "snapshot": [ 1 ]
> >         }
> >     }
> > }
> > $ devlink region show netdevsim/netdevsim1/dummy
> > netdevsim/netdevsim1/dummy: size 32768 snapshot [0 1]
> > 
> > v3: back to v1..
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >  devlink/devlink.c | 26 +++++++++++++++++++++++---
> >  1 file changed, 23 insertions(+), 3 deletions(-)  
> 
> this does not apply to current iproute2-next

Hm. This was on top of Jake's patch, but Stephen took that one into
iproute2, since the kernel feature is in 5.7 already. What is the
protocol here? Can you merge iproute2 into iproute2-next? :S
