Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B351DDA48
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 00:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730381AbgEUWct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 18:32:49 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59487 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730041AbgEUWct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 18:32:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id DB0A15C008C;
        Thu, 21 May 2020 18:32:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 21 May 2020 18:32:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=JBonbJ
        VlhbUrxk/mga2s/IAopmJBNiYVOTzv+GLtif0=; b=AMrIHwv8laysB/kgSDBV4m
        FfNJfqjOVgd1re+LW6fs5c4Ff7V8wj5q4ouWLsSSGB597jF5o/bSN83I8EJ++yjQ
        DOpBwAUOusORvOeQ/F5JS1cHdyp3y/GyhvusZUyh3mrI8XsArsAZGkykozi7PkCa
        HYvVHN/Qd07txIlWKACTztkV4mFGkxEOZ8uFmmshvHYXtQUJcvn2r3TQHhMLzJQv
        Ae6/9QxvgZmKju6kCb61/WUT1eTYrz/J+Ddk1tG+mIu1Yu8uPD4ilCq4d20SXGc2
        sapHbwqCMZCgJ8Su876psBvVvVOsE+mLrqY5N2yeFgwx3qurDJhjNQfqyilPaSiw
        ==
X-ME-Sender: <xms:jwHHXtx4uPgrUo2g0U57KLM4iTb37-72-unza4pVbNwZq7L75mXC-A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudduvddguddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpefgvefgveeuudeuffeiffehieffgfejleevtdetueetueffkeevgffgtddugfek
    veenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeejledrudejiedrvdegrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:jwHHXtQ55x1FgeWIbL46kISMfhbasT85zgqc8rwovJS_Oh7HaeAOJQ>
    <xmx:jwHHXnVvOJjB0u2vn_pbdlkJrmEEsBCeG7NAoskSuHVYQcHRbiZ-xA>
    <xmx:jwHHXvj-6f7iqwzQ_naPpR1uFGeoQL3guDbbl4duKrgEiggiwvfL9w>
    <xmx:jwHHXk7xtC6xi6Aenapwm34NUqW3b_kdwUwKx_2FhZnZjtAIX9iTjQ>
Received: from localhost (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 225C83066406;
        Thu, 21 May 2020 18:32:47 -0400 (EDT)
Date:   Fri, 22 May 2020 01:32:44 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        petrm@mellanox.com, amitc@mellanox.com
Subject: Re: devlink interface for asynchronous event/messages from firmware?
Message-ID: <20200521223244.GA1104013@splinter>
References: <fea3e7bc-db75-ce15-1330-d80483267ee2@intel.com>
 <20200520171655.08412ba5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b0435043-269b-9694-b43e-f6740d1862c9@intel.com>
 <20200521205213.GA1093714@splinter>
 <239b02dc-7a02-dcc3-a67c-85947f92f374@intel.com>
 <20200521145113.21f772bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <0d96e75a-64ee-b7be-786c-7015f65625a3@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d96e75a-64ee-b7be-786c-7015f65625a3@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 03:09:57PM -0700, Jacob Keller wrote:
> 
> 
> On 5/21/2020 2:51 PM, Jakub Kicinski wrote:
> > On Thu, 21 May 2020 13:59:32 -0700 Jacob Keller wrote:
> >>>> So the ice firmware can optionally send diagnostic debug messages via
> >>>> its control queue. The current solutions we've used internally
> >>>> essentially hex-dump the binary contents to the kernel log, and then
> >>>> these get scraped and converted into a useful format for human consumption.
> >>>>
> >>>> I'm not 100% of the format, but I know it's based on a decoding file
> >>>> that is specific to a given firmware image, and thus attempting to tie
> >>>> this into the driver is problematic.  
> >>>
> >>> You explained how it works, but not why it's needed :)  
> >>
> >> Well, the reason we want it is to be able to read the debug/diagnostics
> >> data in order to debug issues that might be related to firmware or
> >> software mis-use of firmware interfaces.
> >>
> >> By having it be a separate interface rather than trying to scrape from
> >> the kernel message buffer, it becomes something we can have as a
> >> possibility for debugging in the field.
> > 
> > For pure debug/tracing perhaps trace_devlink_hwerr() is the right fit?
> > 
> > Right Ido?
> > 
> 
> Hm, yes that might be more suitable for this purpose. I'll take a look
> at it!

Jacob, here is more context that might help:

https://lore.kernel.org/netdev/20191103083554.6317-1-idosch@idosch.org/
https://lore.kernel.org/netdev/20191112064830.27002-1-idosch@idosch.org/

> 
> Thanks,
> Jake
