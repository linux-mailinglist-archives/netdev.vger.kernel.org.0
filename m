Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B8B2B26F5
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 22:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgKMVdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 16:33:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:45400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbgKMVdm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 16:33:42 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A02AD2224D;
        Fri, 13 Nov 2020 21:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605303221;
        bh=ZIvrNpZasZ0L90zdqbEp2JFFn0c/CGA7RTE7jW54axA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FONQHPNCbt2q2jKuqhDOAgeT+vPxfTGnQ9BQ/4wgA/w1IMNSWYoxkpx2UsVIHaMdh
         GW2mKcJuLJxzly9/CO11AoKQXmVnT+nPoa2YNVc0Y2iVFX/rPROZmraI0rGX/d6ra6
         d00ij2m51aPiOTcEi5Usnp5ydRJqm2eaPubjXwuE=
Date:   Fri, 13 Nov 2020 13:33:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] Add support for sending RFC8335 PROBE messages
Message-ID: <20201113133340.6d18c186@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <368dca70e518a9576a80fbd629ea7dc3583cc597.camel@gmail.com>
References: <cover.1605238003.git.andreas.a.roeseler@gmail.com>
        <20201113073230.3ecd6f0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <368dca70e518a9576a80fbd629ea7dc3583cc597.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 12:53:00 -0800 Andreas Roeseler wrote:
> On Fri, 2020-11-13 at 07:32 -0800, Jakub Kicinski wrote:
> > On Thu, 12 Nov 2020 21:02:27 -0800 Andreas Roeseler wrote:  
> > > The popular utility ping has several severe limitations such as
> > > an inability to query specific interfaces on a node and requiring
> > > bidirectional connectivity between the probing and the probed
> > > interfaces. RFC 8335 attempts to solve these limitations by
> > > creating the
> > > new utility PROBE which is an ICMP message that makes use of the
> > > ICMP
> > > Extension Structure outlined in RFC 4884.
> > > 
> > > This patchset adds define statments for the probe ICMP message
> > > request
> > > and reply types for both IPv4 and IPv6. It also expands the list of
> > > supported ICMP messages to accommodate probe messages.  
> > 
> > Did you mean to CC netdev?  
> 
> Thank you for catching that. I'm new to kernel development and I'm still
> trying to get my bearings.

You should repost the series, with the mailing list CCed.
