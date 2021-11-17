Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1D1454514
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 11:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236460AbhKQKkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 05:40:09 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36005 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231862AbhKQKkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 05:40:08 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 459555C0126;
        Wed, 17 Nov 2021 05:37:09 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 17 Nov 2021 05:37:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=oJ3M8i
        FnN/eVx8ApaJIY/YBgEMknUmiuqb/bqsAPcww=; b=ORifq43zkQVx5cJkr/jHTQ
        DHP4rnF0AbuTkySHeYieTNOkuUUJSzkvh0MOrwYZUIRNWByHETXoN1+0Wv5YH3T7
        Nwex94qnvkreBS/xXvhpYXhdZb9oH6Tci1j18+LATkDgMSUO/2W9TGXi0M9uyGd/
        EYrkgY22Fk1ImxFBXZ7vpvJWTq5OUD0rf/uqcejMsLNwHfzJjgc1zb4UGgSzEkqb
        u4D19oy/nokjV8pJx6/Q9NB9iXRhNJr7x5M26NESorfKPjZueiVZ8sBtWXEK5QsJ
        kExFiVOuaKtpSHEERcKa9+f1KJXwv62rK6tYUkiDnewGoZON/bCkBwhZZizPx6cQ
        ==
X-ME-Sender: <xms:VNuUYeEZo-wTSaVeh-pcR5eAiJ0tFoCdpsZ9QjnXank3l1grUAp9YQ>
    <xme:VNuUYfVGFIxU0NLTLAEBEUUhPQ0SMv6_aBV0z6nzbY5mqyOpKSB2JQ5BKDZAWXSmG
    CAaKS4Fk1Xhx7A>
X-ME-Received: <xmr:VNuUYYKsnrPFbm8hWhL-tkfZQ0aEnpoyT9e9YE94eiAZBxZZyRMVGZ8Il6GzlfA_TRhZd_nC05b2i-HOeehdO6BrwX77nA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrfeeggddufecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:VNuUYYGrRxL6ExwIBWQLfJZy2zAcuNs-9GOAeNvmeapBb8nPfKAstg>
    <xmx:VNuUYUWwyWF7cbsbifaujtNXvuH76NlopitwKZlujrFHHundnC12jQ>
    <xmx:VNuUYbOnwK275C_fQtSqBBLel3LqqHGZukhnKvL5iHXON4ERgXDdhA>
    <xmx:VduUYSwU-1Gx8Tkr5KZ_3F4nwAx6-KVd-Kqn5Gd4CUhfMflCJqvHKQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 17 Nov 2021 05:37:08 -0500 (EST)
Date:   Wed, 17 Nov 2021 12:37:05 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH ethtool-next 00/14] ethtool: Use memory maps for EEPROM
 parsing
Message-ID: <YZTbUVAvmR4hmOXl@shredder>
References: <20211012132525.457323-1-idosch@idosch.org>
 <20211027203045.sfauzpf3rarx5iro@lion.mk-sys.cz>
 <YXnMG6e7mglldHIZ@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXnMG6e7mglldHIZ@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 01:01:05AM +0300, Ido Schimmel wrote:
> On Wed, Oct 27, 2021 at 10:30:45PM +0200, Michal Kubecek wrote:
> > On Tue, Oct 12, 2021 at 04:25:11PM +0300, Ido Schimmel wrote:
> > > From: Ido Schimmel <idosch@nvidia.com>
> > > 
> > > This patchset prepares ethtool(8) for retrieval and parsing of optional
> > > and banked module EEPROM pages, such as the ones present in CMIS. This
> > > is done by better integration of the recent 'MODULE_EEPROM_GET' netlink
> > > interface into ethtool(8).
> > 
> > I still need to take a closer look at some of the patches but just to be
> > sure: the only reason to leave this series for 5.16 cycle is that it's
> > rather big and intrusive change (i.e. it does not depend on any kernel
> > functionality not present in 5.15), right?
> 
> Right, it does not depend on any kernel functionality not present in
> 5.15

Can the patchset be applied to ethtool-next please? It is marked as
"Under Review" for over a month now and I would like to make progress
with other patches I have in the queue.

Thanks
