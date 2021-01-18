Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A824F2FAA75
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 20:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437541AbhARTpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 14:45:39 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:47025 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437168AbhARTaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 14:30:04 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id 8222B1952;
        Mon, 18 Jan 2021 14:28:48 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 18 Jan 2021 14:28:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Am1EzT
        0lYy87Rf7z2SsJNrFfStwFrgALVONG5Hl9Ym8=; b=IMWbCZqgFV5vOAsDPBUPSl
        86jyVm9ojDPTbXy+BKK0Yg5Y0JUSPMSZU72+ztcFbPkoCydhpYyLL3CH6pmK2Pfs
        GgISh4Jm0d8WBhVW9Bl/Ku/8gwD0egm0rv0rGaO82LW0YQrppcOqnnjeEbJJgkJg
        1E2EbP8aYfcB1XjjX4thPufd8PvUw6g+LK9ThDeYaUgsAhp4DiMOurIGJJLIHqUr
        mM6DwPdeNGkYdZY5HoXwt8o6eu9UVagF+ebNVF6amyY0FmwlPvpLi159vTitC4DE
        4fGzYSrxjBbvyhfrZlqWfdRQ81ptQ8ZLuXL2GAVGWJ365SBg6fhD+vDLv1Cyltew
        ==
X-ME-Sender: <xms:beEFYO2TOinGGlGyf9-4vz0-EfYQU1jduXKeBY-V6LDq853nRIQrdg>
    <xme:beEFYBEGSlsC6BlhFRG6DDOHxuW857JMe--uh3aKE4kfCugcGsfYTmP94_UCVnoCJ
    MVJFE9NHs0syBA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdekgdduvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:beEFYG4zBK21xtCMCx45UEwyqv-W6sud019gHwRSXRkMlANqeJYRNg>
    <xmx:beEFYP0lSoMEqlM_erXeDyMKdfWyVhRzi_2Qwt0mxFq9t3YGGJvv2w>
    <xmx:beEFYBE_MyywoY_a3GhNm4g-9XEChk4PnDntIabio9oiKMlBHR6YNA>
    <xmx:cOEFYHbT_rvTzNmPHu9nhuf1PxJ1p1b_agyBoqe2kwsw2j8fW1CKvDz57yw>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 31F8424005B;
        Mon, 18 Jan 2021 14:28:45 -0500 (EST)
Date:   Mon, 18 Jan 2021 21:28:42 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        netdev@vger.kernel.org, jiri@resnulli.us,
        stephen@networkplumber.org
Subject: Re: [RFC net-next 2/7] net: bridge: switchdev: Include local flag in
 FDB notifications
Message-ID: <20210118192842.GA2396253@shredder.lan>
References: <20210116012515.3152-1-tobias@waldekranz.com>
 <20210116012515.3152-3-tobias@waldekranz.com>
 <20210117193009.io3nungdwuzmo5f7@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210117193009.io3nungdwuzmo5f7@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 17, 2021 at 09:30:09PM +0200, Vladimir Oltean wrote:
> Hi Tobias,
> 
> On Sat, Jan 16, 2021 at 02:25:10AM +0100, Tobias Waldekranz wrote:
> > Some switchdev drivers, notably DSA, ignore all dynamically learned
> > address notifications (!added_by_user) as these are autonomously added
> > by the switch. Previously, such a notification was indistinguishable
> > from a local address notification. Include a local bit in the
> > notification so that the two classes can be discriminated.
> >
> > This allows DSA-like devices to add local addresses to the hardware
> > FDB (with the CPU as the destination), thereby avoiding flows towards
> > the CPU being flooded by the switch as unknown unicast.
> >
> > Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> > ---
> 
> In an ideal world, the BR_FDB_LOCAL bit of an FDB entry is what you
> would probably want to use as an indication that the packet must be
> delivered upstream by the hardware, considering that this is what the
> software data path does:
> 
> br_handle_frame_finish:
> 		if (test_bit(BR_FDB_LOCAL, &dst->flags))
> 			return br_pass_frame_up(skb);
> 
> However, we are not in an ideal world, but in a cacophony of nonsensical
> flags that must be passed to the 'bridge fdb add' command. For example,
> I noticed this usage pattern in your patch 6/7:

Thanks for adding me. Reflecting FDB flags is a very much needed change.
I will take a look tomorrow or the day after.
