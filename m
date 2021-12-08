Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A7046DE73
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 23:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhLHWlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 17:41:08 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46514 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbhLHWlH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 17:41:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=T4PJVH5Vd9hIKMEs7WOAN0OlJlipSh2EUPvNoIpwRkM=; b=PRNoo4xbyPMm1hUFE6GtEY9hLA
        1PPWIRoFLbopD5u9VrVrUr+bLeoFVu1u7uuaDol1SibY5r6geEavRhzHuFNzWeER+8P7L9aewte65
        8rfMATTEsyD48eIeaORnEuGJWl2pe4jbNUYUtIUoJMGVZEiWKz5GBuQiSMstwysFIi58=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mv5Yz-00FvWD-8f; Wed, 08 Dec 2021 23:37:25 +0100
Date:   Wed, 8 Dec 2021 23:37:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        James Prestwood <prestwoj@gmail.com>,
        Justin Iurman <justin.iurman@uliege.be>,
        Praveen Chaudhary <praveen5582@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v4 1/3] seg6: export get_srh() for ICMP handling
Message-ID: <YbEzpTFGl06FXGAS@lunn.ch>
References: <20211208173831.3791157-1-andrew@lunn.ch>
 <20211208173831.3791157-3-andrew@lunn.ch>
 <CA+FuTScGS_s=PCYnXzJbkABOQ7nirg4aa-HwzHjk4crp9vic1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTScGS_s=PCYnXzJbkABOQ7nirg4aa-HwzHjk4crp9vic1w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 04:24:56PM -0500, Willem de Bruijn wrote:
> On Wed, Dec 8, 2021 at 12:38 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > From 387a5e9d6b2749d0457ccc760a5b785c2df8f799 Mon Sep 17 00:00:00 2001
> > From: Andrew Lunn <andrew@lunn.ch>
> > Date: Sat, 20 Nov 2021 12:51:07 -0600
> > Subject: [PATCH net-next v4 2/3] icmp: ICMPV6: Examine invoking packet for
> >  Segment Route Headers.
> 
> Something went wrong when sending this patch series.
> 
> The above header is part of the commit message, and this patch is
> marked as 1/3. See also in
> https://patchwork.kernel.org/project/netdevbpf

Now that is odd. I just did the usual git format-patch ; git
send-email.

I will try out v5 sending it just to myself first.

Thanks
	Andrew
