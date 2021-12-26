Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305CA47F6EF
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 14:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbhLZNPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 08:15:21 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:43943 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231607AbhLZNPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 08:15:20 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id D56C03200FA2;
        Sun, 26 Dec 2021 08:15:19 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 26 Dec 2021 08:15:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ewS9Y6
        zfsDCNVouJffoozMYtYaRKsLwDMoYG8T6kP5c=; b=mGowdhqTI+bkXMOplPvhlU
        PpebYwam8wo9acpGuSqtSDsDA2EiOKnHEKoT5OpSDobRzIDgF33jvzMEm7Hbx8bt
        S6LL+fi/jEgCwyCRxULLGHxxTO3HVxzTfgp9Kt+a5o5N5+1NW4D2+dB8i3cUXByf
        xYQSVtwwUb3OE6V2IVb7lc2UnyHe8eKcQZ/bZ6iZoOHOWi+GZjsVw4FEDPeilcwf
        q3mNqB7KxnPSB/kyICByJfmA0SQu6B3QHCOZvP5FpZmOk66YZY4urOMsKNUNLoQ6
        HQJ6OSOaD7NW6KVc6yDLtvEDjGXRZk7o/37MxAOlNlLGH6ty7e56ppdUJeaizAtw
        ==
X-ME-Sender: <xms:52rIYcyPbRuNOTrPHCXfYVkdCewD4IJjVXI62fOmvxBlrpxanseNbA>
    <xme:52rIYQSe3dzVlYdLteArs-sTz7-BSDvBFbBimt7SnMRHtcN6LBErS9fwMjwmf_vpy
    pLuKKSS1a7hRsE>
X-ME-Received: <xmr:52rIYeU3ZEHwc4cGd60idZ2hHwjb470lTjVUOZC_fDsOA9WK62wkEFdoyXihcviH4OBXabicsicVOzIP-0Dj10ZJhHVG9w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddugedgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:52rIYaj24kM96H_jBxw3VKTINb3zMC2zPMayuOgiHqDbrBJa2cEMCw>
    <xmx:52rIYeC5YSCFUtFIA2mDjYm4XyU1QVB8hCUtFeWROGxztptpYFxHlg>
    <xmx:52rIYbIAArJnjrqRCbhxfSBaOQjmDDVh-GG34GU93RO12qi32Ad3fg>
    <xmx:52rIYZMKE75fLVEho9ZDAYx475ui3JjknhtdqGqD48MtrR4icuyR8w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 26 Dec 2021 08:15:18 -0500 (EST)
Date:   Sun, 26 Dec 2021 15:15:14 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@kernel.org, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net-next v2] ipv6: ioam: Support for Queue depth data
 field
Message-ID: <Ychq4ggTdpVG24Zp@shredder>
References: <20211224135000.9291-1-justin.iurman@uliege.be>
 <YcYJD2trOaoc5y7Z@shredder>
 <331558573.246297129.1640519271432.JavaMail.zimbra@uliege.be>
 <Ychiyd0AgeLspEvP@shredder>
 <462116834.246327590.1640523548154.JavaMail.zimbra@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462116834.246327590.1640523548154.JavaMail.zimbra@uliege.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 26, 2021 at 01:59:08PM +0100, Justin Iurman wrote:
> On Dec 26, 2021, at 1:40 PM, Ido Schimmel idosch@idosch.org wrote:
> > On Sun, Dec 26, 2021 at 12:47:51PM +0100, Justin Iurman wrote:
> >> On Dec 24, 2021, at 6:53 PM, Ido Schimmel idosch@idosch.org wrote:
> >> > Why 'qlen' is used and not 'backlog'? From the paragraph you quoted it
> >> > seems that queue depth needs to take into account the size of the
> >> > enqueued packets, not only their number.
> >> 
> >> The quoted paragraph contains the following sentence:
> >> 
> >>    "The queue depth is expressed as the current amount of memory
> >>     buffers used by the queue"
> >> 
> >> So my understanding is that we need their number, not their size.
> > 
> > It also says "a packet could consume one or more memory buffers,
> > depending on its size". If, for example, you define tc-red limit as 1M,
> > then it makes a lot of difference if the 1,000 packets you have in the
> > queue are 9,000 bytes in size or 64 bytes.
> 
> Agree. We probably could use 'backlog' instead, regarding this
> statement:
> 
>   "It should be noted that the semantics of some of the node data fields
>    that are defined below, such as the queue depth and buffer occupancy,
>    are implementation specific.  This approach is intended to allow IOAM
>    nodes with various different architectures."
> 
> It would indeed make more sense, based on your example. However, the
> limit (32 bits) could be reached faster using 'backlog' rather than
> 'qlen'. But I guess this tradeoff is the price to pay to be as close
> as possible to the spec.

At least in Linux 'backlog' is 32 bits so we are OK :)
We don't have such big buffers in hardware and I'm not sure what
insights an operator will get from a queue depth larger than 4GB...

I just got an OOO auto-reply from my colleague so I'm not sure I will be
able to share his input before next week. Anyway, reporting 'backlog'
makes sense to me, FWIW.
