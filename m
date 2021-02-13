Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B1331ADE9
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 21:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhBMUQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 15:16:58 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:48329 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229649AbhBMUQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 15:16:51 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 96B86779;
        Sat, 13 Feb 2021 15:16:05 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 13 Feb 2021 15:16:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=gTsPkI
        JEkw/ab5dBAAYN9FyBUTJtf28GjjW9hPDu7EI=; b=WfoSzU3eiRJpPuFF/sHLeG
        RtIOOvCf7mCRLelgXqaGkqkVIGcrs5zZRBi4eOaWT+bfNo6SKTVL0KfJEvVrYN1V
        BPo+EuwdPCZaJmkNZwFau718BHm7RfbWaSYCW5luh0l9jlEVJAY/2P4bokNvN16S
        m7rB8QC/My07Rc8bLJPeWEOKmKT/2Jy+B/L0ED3WI1jWhIxcTbBLBOgMRkV1xnlo
        SdddtJksOyaN34jiZN7Nrqb4S6INHoTcaiFJIqvYLHRIcUXENWeyMUk0QAXMPy3t
        iYPyqCjbldVNq+JAt4d/HjmZf52a1sIVCtSaCElWxYrT/5ZkHrJ77etfDfRc8YQg
        ==
X-ME-Sender: <xms:hDMoYNJZShT7kEjUGtCp_lEZijx8JO6fWPH8HYH3WBON9rXBkdEWbw>
    <xme:hDMoYJIG6aFRJ3kq5Od0Vdru4pJVBN-NDGGcrmu4XgUrZEELY3cXgGyXypCYUpiJY
    t7LlPeiMGGov3E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrieefgddufedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:hTMoYFtQF-5P5dCKK1gbb_XoxoZ2xtFcRq9bJzyD5lArqmCcPTWNSA>
    <xmx:hTMoYOZk5pS7ABjwBytAVBu4UVGdrIhRr-e7TGMPRGrETz6fxWja1Q>
    <xmx:hTMoYEZeCxkmcdwkWud4IuWAMExSX_D8PLxQ93MkSaC8Pyd9YKD7gQ>
    <xmx:hTMoYMFtRalMkHQC_oHbgYtXJPWfzmltE1WXYd5GmePn9vA4X5q3KQ>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7F0E1108005C;
        Sat, 13 Feb 2021 15:16:04 -0500 (EST)
Date:   Sat, 13 Feb 2021 22:16:01 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH 00/13] nexthop: Resilient next-hop groups
Message-ID: <20210213201601.GA401513@shredder.lan>
References: <cover.1612815057.git.petrm@nvidia.com>
 <e15bfcec-7d1f-baea-6a9d-7bcc77104d8e@gmail.com>
 <20210213191619.GA399200@shredder.lan>
 <3ece022f-ec32-ab38-d2cf-a699c17bbcc7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ece022f-ec32-ab38-d2cf-a699c17bbcc7@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 13, 2021 at 12:17:54PM -0700, David Ahern wrote:
> On 2/13/21 12:16 PM, Ido Schimmel wrote:
> > On Sat, Feb 13, 2021 at 11:57:03AM -0700, David Ahern wrote:
> >> On 2/8/21 1:42 PM, Petr Machata wrote:
> >>> To illustrate the usage, consider the following commands:
> >>>
> >>>  # ip nexthop add id 1 via 192.0.2.2 dev dummy1
> >>>  # ip nexthop add id 2 via 192.0.2.3 dev dummy1
> >>>  # ip nexthop add id 10 group 1/2 type resilient \
> >>> 	buckets 8 idle_timer 60 unbalanced_timer 300
> >>>
> >>> The last command creates a resilient next hop group. It will have 8
> >>> buckets, each bucket will be considered idle when no traffic hits it for at
> >>> least 60 seconds, and if the table remains out of balance for 300 seconds,
> >>> it will be forcefully brought into balance. (If not present in netlink
> >>> message, the idle timer defaults to 120 seconds, and there is no unbalanced
> >>> timer, meaning the group may remain unbalanced indefinitely.)
> >>
> >> How did you come up with the default timer of 120 seconds?
> > 
> > It is the default in the Cumulus Linux implementation (deployed for
> > several years already), so we figured it should be OK.
> > 
> 
> Add that to the commit log.

OK, will add
