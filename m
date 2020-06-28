Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6320220C7C6
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 13:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgF1L4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 07:56:03 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42871 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726246AbgF1L4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 07:56:03 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id F2A2D5C0109;
        Sun, 28 Jun 2020 07:56:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 28 Jun 2020 07:56:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=y29/H1
        4/cyeLVmm8GiH+Lz7Zbn8PUrdWO7fcFJUdA5U=; b=HsHggmq22R0l1kyLdqLa6K
        me/YSB4rj0Y93RBt4H5IZ7rzckFaxt6msrB6Dm41iZWwBm3yQ5x5AkfK9CRZ+hXe
        rSHa9NSeCSUm92c2CsgIUckJApcF2vOjhRxjL+Oij2E9xEZX4B8xQO70ODzntHsb
        F+xqmWeeIXarQ+Z+j/z/Q6R83Y7CfX4KKG0gBdXpQtg3B2Myom7FVIH8q6wM14Ql
        h1+XjLVWaU5FJ3Njdj87H4cxsL3O6PugQPoqttjUHMlapIfwYPzIaiBa+ogpv+uO
        NafJFFl62YTckeiKMLIXNU6tUGYNAFPCZayUBx7E4M3q8TUfdbxH54wzxxNvJQrg
        ==
X-ME-Sender: <xms:UYX4Xhyrc8Mj1kEtlzr7AwLEzBqucB-Q46_U7rRGfwafzGHW_oZD4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeliedggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtudevffevleefleelvdeghedtieevgfeuffeghfegteeghedvhfffkeeivddv
    gfenucffohhmrghinhepqhhsfhhpqdguugdrtghomhenucfkphepuddtledrieeirddule
    drudeffeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:UYX4XhQfwXH3bBfW7pm-PYa3WeWJFDiDIGpPHozjWqigdDUlZIwm1g>
    <xmx:UYX4XrWL9ubG-0UW5JPOVHtP8DmZW5X-22rQ-kQg3xWNmzcNki6FIg>
    <xmx:UYX4XjiGPd4TOQbt-WOyuBymvj-zlq3g-qLXqximdPLuxvvM_Kwd1A>
    <xmx:UYX4Xu88ToYbasfxiGlNvcC-rCyIsbwuFTV3leOVzo9Y26rFhJQMVQ>
Received: from localhost (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2935D3067B73;
        Sun, 28 Jun 2020 07:56:00 -0400 (EDT)
Date:   Sun, 28 Jun 2020 14:55:57 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Adrian Pop <popadrian1996@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 1/2] mlxsw: core: Add ethtool support for
 QSFP-DD transceivers
Message-ID: <20200628115557.GA273881@shredder>
References: <20200626144724.224372-1-idosch@idosch.org>
 <20200626144724.224372-2-idosch@idosch.org>
 <20200626151926.GE535869@lunn.ch>
 <CAL_jBfT93picGGoCNWQDY21pWmo3jffanhBzqVwm1kVbyEb4ow@mail.gmail.com>
 <20200626190716.GG535869@lunn.ch>
 <CAL_jBfQMQbMAFeHji2_Y_Y_gC20S_0QL33wjPgPBaKeVRLg1SQ@mail.gmail.com>
 <20200627191648.GA245256@shredder>
 <CAL_jBfTKW_T-Pf2_shLm7N-ve_eg3G=nTD+6Fc3ZN4aHncm9YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_jBfTKW_T-Pf2_shLm7N-ve_eg3G=nTD+6Fc3ZN4aHncm9YQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 27, 2020 at 09:42:10PM +0100, Adrian Pop wrote:
> >
> > Hi Adrian, Andrew,
> >
> > Not sure I understand... You want the kernel to always pass page 03h to
> > user space (potentially zeroed)? Page 03h is not mandatory according to
> > the standard and page 01h contains information if page 03h is present or
> 
> Hi Ido!
> 
> Andrew was thinking of having 03h after 02h (potentially zeroed) just
> for the purpose of having a similar layout for QSFP-DD the same way we
> do for QSFP. But as you said, it is not mandatory according to the
> standard and I also don't know the entire codebase for ethtool and
> where it might be actually needed. I think Andrew can argue for its
> presence better than me.
> 
> > not. So user space has the information it needs to determine if after
> > page 02h we have page 03h or page 10h. Why always pass page 03h then?
> >
> 
> If we decide to add 03h but only sometimes, I think we will add an
> extra layer of complexity. Sometimes after 02h we would have 03h and
> sometimes 10h. In qsfp-dd.h (following the convention from qsfp.h) in
> my patch there are a lot of different constants defined with respect
> to the offset of the parent page in the memory layout and "dynamic
> offsets" don't sound very good, at least for me. So even if there's a
> way of checking in the user space which page is after 02h, a more
> stable memory layout works better on the long run.

Adrian,

Thanks for the detailed response. I don't think the kernel should pass
fake pages only to make it easier for user space to parse the
information. What you are describing is basic dissection and it's done
all the time by wireshark / tcpdump.

Anyway, even we pass a fake page 03h, page 11h can still be at a
variable offset. See table 8-28 [1], bits 1-0 at offset 142 in page 01h
determine the size of pages 10h and 11h:

0 - each page is 128 bytes in size
1 - each page is 256 bytes in size
2 - each page is 512 bytes in size

So a completely stable layout (unless I missed something) will entail
the kernel sending 1664 bytes to user space each time. This looks
unnecessarily rigid to me. The people who wrote the standard obviously
took into account the fact that the page layout needs to be discoverable
from the data and I think we should embrace it and only pass valid
information to user space.

Regardless, can Andrew and you let us know if you have a problems with
current patch set which only exposes pages 00h-02h? I see it's marked as
"Changes Requested", so I will need to re-submit.

Thanks

[1] http://www.qsfp-dd.com/wp-content/uploads/2019/05/QSFP-DD-CMIS-rev4p0.pdf
