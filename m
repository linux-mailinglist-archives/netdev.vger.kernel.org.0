Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402C6481D40
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 15:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236261AbhL3Ora (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 09:47:30 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:51615 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231320AbhL3Ora (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 09:47:30 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id E6D243201A17;
        Thu, 30 Dec 2021 09:47:28 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 30 Dec 2021 09:47:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=57dHqV
        yHv8lZVITJ8UlcUlQXPS1xJBApe4kt8G+rfV4=; b=irjRxB8DGwaHfUxVTBnwhj
        7RoF1CnEmtalKrmKibxF/HsmYRU2Z9nJ4mvRuo7gWFpr9L7G5BIZkhZdNWA7TFOv
        fo+wnnvM7MCrtrAI00m0ZhhZXtXwNueR5euatUysqwEM+3m0rBwG6pjSeX8BfxiN
        hWYQOKOhOrHq66aKBpeiwUTycRHf0RdXgCVE4801s+6uU0eL9+nEJ7xg7Qt/6lKK
        ZSuSCu4eyUcXIBFjWCYwE3/X0bIFgCA8HTaeGE8MceFWei13N5SEfaJ0wOrKiNm2
        HUhwQhBRogwtiFZmpKQCE/q0ZkgpFN9bomzem8D6N22YU7gz28ShZkQn2ek69n9w
        ==
X-ME-Sender: <xms:f8bNYSzskpotpP-KvDLHw-bWjyiC6m6qgB_Os5vTr0B1Y9SdPa8Rmw>
    <xme:f8bNYeQyRPke3BdteFYlnZ14Ro9Q2Fv7_axiBtr37Niu0DtcwRA96lhk53mV7R6le
    TQRhk3ij1MVQUA>
X-ME-Received: <xmr:f8bNYUXbUgHFKM5Y6shKc21WWZVTeFSjYpYzQYU4uwuWxjEVB9b0DW6O8cTjsEgac80c6N3qW_TeqD1yba9EwZuWB37mow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddvfedgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:f8bNYYjGxj9GWi7TFY6freHvnmDax433R8mOC7jvQfuzq70e5dbPgA>
    <xmx:f8bNYUB8pO_NQBHL5IFUpC0iPuEX-skSwAWKjRClQ8CXKlKj1Cj6Yg>
    <xmx:f8bNYZIDkVzLGLsxEtaWXEaZEFo_EPbRGfsxLL8islBnsST2C9kpxQ>
    <xmx:gMbNYXOJqxc5X1RL-wVMgE7UewVE8aaUwon1qDfgmWL783ydr300ug>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Dec 2021 09:47:27 -0500 (EST)
Date:   Thu, 30 Dec 2021 16:47:23 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@kernel.org, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net-next v2] ipv6: ioam: Support for Queue depth data
 field
Message-ID: <Yc3GeyeVliLWC7El@shredder>
References: <20211224135000.9291-1-justin.iurman@uliege.be>
 <YcYJD2trOaoc5y7Z@shredder>
 <331558573.246297129.1640519271432.JavaMail.zimbra@uliege.be>
 <Ychiyd0AgeLspEvP@shredder>
 <462116834.246327590.1640523548154.JavaMail.zimbra@uliege.be>
 <Ychq4ggTdpVG24Zp@shredder>
 <751671897.247201108.1640614002305.JavaMail.zimbra@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <751671897.247201108.1640614002305.JavaMail.zimbra@uliege.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 27, 2021 at 03:06:42PM +0100, Justin Iurman wrote:
> On Dec 26, 2021, at 2:15 PM, Ido Schimmel idosch@idosch.org wrote:
> > On Sun, Dec 26, 2021 at 01:59:08PM +0100, Justin Iurman wrote:
> >> On Dec 26, 2021, at 1:40 PM, Ido Schimmel idosch@idosch.org wrote:
> >> > On Sun, Dec 26, 2021 at 12:47:51PM +0100, Justin Iurman wrote:
> >> >> On Dec 24, 2021, at 6:53 PM, Ido Schimmel idosch@idosch.org wrote:
> >> >> > Why 'qlen' is used and not 'backlog'? From the paragraph you quoted it
> >> >> > seems that queue depth needs to take into account the size of the
> >> >> > enqueued packets, not only their number.
> >> >> 
> >> >> The quoted paragraph contains the following sentence:
> >> >> 
> >> >>    "The queue depth is expressed as the current amount of memory
> >> >>     buffers used by the queue"
> >> >> 
> >> >> So my understanding is that we need their number, not their size.
> >> > 
> >> > It also says "a packet could consume one or more memory buffers,
> >> > depending on its size". If, for example, you define tc-red limit as 1M,
> >> > then it makes a lot of difference if the 1,000 packets you have in the
> >> > queue are 9,000 bytes in size or 64 bytes.
> >> 
> >> Agree. We probably could use 'backlog' instead, regarding this
> >> statement:
> >> 
> >>   "It should be noted that the semantics of some of the node data fields
> >>    that are defined below, such as the queue depth and buffer occupancy,
> >>    are implementation specific.  This approach is intended to allow IOAM
> >>    nodes with various different architectures."
> >> 
> >> It would indeed make more sense, based on your example. However, the
> >> limit (32 bits) could be reached faster using 'backlog' rather than
> >> 'qlen'. But I guess this tradeoff is the price to pay to be as close
> >> as possible to the spec.
> > 
> > At least in Linux 'backlog' is 32 bits so we are OK :)
> > We don't have such big buffers in hardware and I'm not sure what
> > insights an operator will get from a queue depth larger than 4GB...
> 
> Indeed :-)
> 
> > I just got an OOO auto-reply from my colleague so I'm not sure I will be
> > able to share his input before next week. Anyway, reporting 'backlog'
> > makes sense to me, FWIW.
> 
> Right. I read that Linus is planning to release a -rc8 so I think I can
> wait another week before posting -v3.

The answer I got from my colleagues is that they expect the field to
either encode bytes (what Mellanox/Nvidia is doing) or "cells", which is
an "allocation granularity of memory within the shared buffer" (see man
devlink-sb).
