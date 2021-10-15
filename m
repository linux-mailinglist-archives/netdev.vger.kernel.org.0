Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD5442FCB7
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 22:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242875AbhJOUD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 16:03:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233148AbhJOUDy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 16:03:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6622E61151;
        Fri, 15 Oct 2021 20:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634328107;
        bh=ctO402j9ZcTDswg/tC5VZ9JtJsnYGKeSNU1z+S8cQto=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nlurdUFhl4DLeUE5I8iZ/eCVajQ7Vq+luCa0YsVk82jTVfY1oKBoU2pDfY8aGS8Li
         RmbKhUHSOPYsVnRr8HhDAJ6/zdy4ITuq4g9KmBCzheDFAvv6Re2fuNWwnovlPQMdXP
         NmHJZgR4MIYbYMAlMVJXtmaxrEltl8+NYXiURWwCLHcmzjw1hs9cxDiljWo4kE1rFR
         GwCX+9zaBASfV7Dc+v0m3tmGmwSgrb6PLu0ikirfXhEj7Tz+u30MrEseu+NmkiMclx
         fjr25QaqHOb9c3EA9lzLrCcRuc6qRZ+ScSr3zj3vzjxNlneyNhGVQ2E9ob9H1/jGI0
         X7hymRp95id1A==
Date:   Fri, 15 Oct 2021 13:01:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net] ipv6: When forwarding count rx stats on the orig
 netdev
Message-ID: <20211015130141.66db253b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1e07d35a-50f5-349e-3634-b9fd73fca8ea@gmail.com>
References: <20211014130845.410602-1-ssuryaextr@gmail.com>
        <1a83de45-936e-483c-0176-c877d8548d70@gmail.com>
        <20211015022241.GA3405@ICIPI.localdomain>
        <1e07d35a-50f5-349e-3634-b9fd73fca8ea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Oct 2021 20:27:38 -0600 David Ahern wrote:
> On 10/14/21 8:22 PM, Stephen Suryaputra wrote:
> > On Thu, Oct 14, 2021 at 08:15:34PM -0600, David Ahern wrote:  
> >> [ added Ido for the forwarding tests ]
> >>  
> > [snip]  
> >>
> >> This seems fine to me, but IPv4 and IPv6 should work the same.  
> > 
> > But we don't have per if ipv4 stats. Remember that I tried to get
> > something going but wasn't getting any traction?
> >   
> oh right, ipv4 is per net-namespace.

Is that an ack? :)
