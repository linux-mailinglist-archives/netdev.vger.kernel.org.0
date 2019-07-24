Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20F097342E
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 18:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387730AbfGXQs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 12:48:27 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:48937 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387551AbfGXQsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 12:48:25 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7CEF21B52;
        Wed, 24 Jul 2019 12:48:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 24 Jul 2019 12:48:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=N8XBSp
        cn1o6ObMkZcAZBtxueL9hPgfrdRzH2GqT5roc=; b=zixQy8pltzELc0g3ftqs4F
        G1pAXVTF7s9RoKW2hh5CQbXR9rWMpqTWfTQ1+U6JZFHUT5FDCsTw03jqHNuQ4vrh
        lZOQbXPsTb8B9WhbgW/4c2o+eA9mey7x4NHpkoNsqo/+jktcrccrbqEj8yfROGjQ
        LLInbNkP0HqIW8zTmDWkUM6kEWzq3x6JYRmHPFbu5cgzGBMOT7kN00/Zwz4mZGo7
        zQlBNcHD/UPWXDmJ5+Xz47MkB/rlSG6MybmeI2OusIpmq5xqaFKdzlK/rJ7rEwJa
        CBOpCoOBbSDZQUinz5ek9Sj9MS0r9dhtGOXydaQsXVujLCvtI/8/ORQmcaCtk6Ug
        ==
X-ME-Sender: <xms:1os4Xc3S4eFUffv_fvx8Bg_gJLuyTN2koLzrFAdR79XkXSqArgBizQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkedtgddutddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:1os4XRd0_R8Nz1dT6wtBE9jqVxMzLwOQtpiZ6Q2yIYtkC7vnjm9Vyw>
    <xmx:1os4XVpT7JFWZXwRoXdCPxo1uCUlHAlO-eFFq4Yopqw-4fTsLm7_mw>
    <xmx:1os4XTVsFEJwuEdOVac_Uuf5HRPh5Ye3NaD6uIPdTrFtbfE_N_wVEQ>
    <xmx:2Is4XR--pFjmc3tIvKVcZvUEHMuSohWrF6RKqcZ5yF6jLEZzFEXsIQ>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0EF15380084;
        Wed, 24 Jul 2019 12:48:21 -0400 (EDT)
Date:   Wed, 24 Jul 2019 19:48:20 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 00/12] drop_monitor: Capture dropped packets
 and metadata
Message-ID: <20190724164820.GA20252@splinter>
References: <20190722183134.14516-1-idosch@idosch.org>
 <87imrt4zzg.fsf@toke.dk>
 <20190723064659.GA16069@splinter>
 <875znt3pxu.fsf@toke.dk>
 <20190723151423.GA10342@splinter>
 <20190724125851.GD2225@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724125851.GD2225@nanopsycho>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 02:58:51PM +0200, Jiri Pirko wrote:
> Shouldn't the queue len be configurable?

Yes, it will be configurable in v1. I will use a sane limit as default.
