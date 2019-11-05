Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E404DF0735
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 21:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729399AbfKEUsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 15:48:42 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37087 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727401AbfKEUsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 15:48:41 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 7801221E5B;
        Tue,  5 Nov 2019 15:48:38 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 05 Nov 2019 15:48:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=PP9n3Q
        k64hHnb1/w3YKYTzY0eAucah16Foqb0fE2mTE=; b=BBDBDNPwMpEOguD6j8jxkZ
        3rWlYfuR+22mIU4f6EebtCs9t036j71RJcWKlwZ8XsQ5d4yPp++c9UoX1qxdV1cY
        DY2+hqhfMtr4TQJL7sQ7i3XfbS/N434bL0snj4J+hZvAzjKc4XHXKkaN1BBregx1
        H/hL4s3Zh7F+BrdKOTdwYzaT5s+uOKG+LDE8whuFuA2TABEaOHcAeam+MwqamJtx
        HW0MgQc3OfqPo2o6TpkXUzMIj3SuP8bzh91yc7n7X0wPwo1Ea6tMXKdKex/ioOGu
        cTh9vTM1OMYNtakHdt1uz2r8zWCd5ZO/waxhR67yk+FhsLjHLrSfdcdr6LSUgSoA
        ==
X-ME-Sender: <xms:JuDBXZTjoBD5sn5xRUroehdldZSb_evZGtDdiMOjUscdIc4vEGLfzw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudduhedgudegvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepje
    ejrddufeekrddvgeelrddvtdelnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgt
    hhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:JuDBXdXrUTMi5YVQWsjFLbGIrThN_UVGlRWNrQucsA6Onc6PiW9D2g>
    <xmx:JuDBXbbVPms47XkzRFsSYULyx_u0Cj8aPgb1PjsIJIXvwTaX_tDr9g>
    <xmx:JuDBXT24y6LX0sYJWibSCzVIMPCe-y-vI617WN89GoJMJ_0pihmdnA>
    <xmx:JuDBXQO50p-LRvHaO8SFfuE-XU1GF8Bbv9799VwX3PDUaWbq1FxKAQ>
Received: from localhost (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8E90A306005B;
        Tue,  5 Nov 2019 15:48:37 -0500 (EST)
Date:   Tue, 5 Nov 2019 22:48:26 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        shalomt@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 0/6] mlxsw: Add extended ACK for EMADs
Message-ID: <20191105204826.GA15513@splinter>
References: <20191103083554.6317-1-idosch@idosch.org>
 <20191104123954.538d4574@cakuba.netronome.com>
 <20191104210450.GA10713@splinter>
 <20191104144419.46e304a9@cakuba.netronome.com>
 <20191104232036.GA12725@splinter>
 <20191104153342.36891db7@cakuba.netronome.com>
 <20191105074650.GA14631@splinter>
 <20191105095448.1fbc25a5@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105095448.1fbc25a5@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 05, 2019 at 09:54:48AM -0800, Jakub Kicinski wrote:
> On Tue, 5 Nov 2019 09:46:50 +0200, Ido Schimmel wrote:
> > On Mon, Nov 04, 2019 at 03:33:42PM -0800, Jakub Kicinski wrote:
> > > On Tue, 5 Nov 2019 01:20:36 +0200, Ido Schimmel wrote:  
> > > > On Mon, Nov 04, 2019 at 02:44:19PM -0800, Jakub Kicinski wrote:  
> > > > > On Mon, 4 Nov 2019 23:04:50 +0200, Ido Schimmel wrote:    
> > > > > > I don't understand the problem. If we get an error from firmware today,
> > > > > > we have no clue what the actual problem is. With this we can actually
> > > > > > understand what went wrong. How is it different from kernel passing a
> > > > > > string ("unstructured data") to user space in response to an erroneous
> > > > > > netlink request? Obviously it's much better than an "-EINVAL".    
> > > > > 
> > > > > The difference is obviously that I can look at the code in the kernel
> > > > > and understand it. FW code is a black box. Kernel should abstract its
> > > > > black boxiness away.    
> > > > 
> > > > But FW code is still code and it needs to be able to report errors in a
> > > > way that will aid us in debugging when problems occur. I want meaningful
> > > > errors from applications regardless if I can read their code or not.  
> > > 
> > > And the usual way accessing FW logs is through ethtool dumps.  
> > 
> > I assume you're referring to set_dump() / get_dump_flag() /
> > get_dump_data() callbacks?
> > 
> > In our case it's not really a dump. These are errors that are reported
> > inline to the driver for a specific erroneous operation. We currently
> > can't retrieve them from firmware later on. Using ethtool means that we
> > need to store these errors in the driver and then push them to user
> > space upon get operation. Seems like a stretch to me. Especially when
> > we're already reporting the error code today and this set merely
> > augments it with more data to make the error more specific.
> 
> Hm, the firmware has no log that it keeps? Surely FW runs a lot of
> periodic jobs etc which may encounter some error conditions, how do 
> you deal with those?

There are intrusive out-of-tree modules that can get this information.
It's currently not possible to retrieve this information from the
driver. We try to move away from such methods, but it can't happen
overnight. This set and the work done in the firmware team to add this
new TLV is one step towards that goal.

> Bottom line is I don't like when data from FW is just blindly passed
> to user space.

The same information will be passed to user space regardless if you use
ethtool / devlink / printk.

> Printing to the logs is perhaps the smallest of this sort of
> infractions but nonetheless if there is no precedent for doing this
> today I'd consider not opening this box.

The mlx5 driver prints a 32-bit number that represents a unique error
code from firmware. As a user it tells you nothing, but internally
engineers can correlate it to a specific error.

I think it would be unfortunate to give up on this set due to personal
preferences alone. Just last week it proved its usefulness twice when I
tried to utilize a new firmware API and got it wrong.
