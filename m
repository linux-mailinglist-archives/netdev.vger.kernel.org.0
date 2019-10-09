Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95537D06BE
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 06:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbfJIEtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 00:49:07 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46601 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729040AbfJIEtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 00:49:06 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 47B7022022;
        Wed,  9 Oct 2019 00:49:03 -0400 (EDT)
Received: from imap2 ([10.202.2.52])
  by compute4.internal (MEProxy); Wed, 09 Oct 2019 00:49:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aj.id.au; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type; s=fm3; bh=aNjZ/Ku1CYLS/hdwt5RKVJIsxSxD8ZD
        0Ai/GU2RrCho=; b=jzHfszd7usobDuC1Iy22OKyf2VtFKHsDBRbYgzI0AT070l7
        8RXxhmLDp98lQNAoDXXcgyrd8PHrgU9nI+pMFjFklx3RJznAipmlTtELQW7sWcPW
        Trqb6wUzasKfh2MvaudNUOxKN7qn2phqKSDPBwXTGQOjPPsBv6s1YOjWmxBKkKd8
        gLCUYMLs0mIrH+RHaHmC02p6H+ulQjvjBGzLsTSyA82RiAmnujaBAXEegvfz0ChL
        92aRnauPnwl+RKEq0to2JUIWtwAJylkxpnssDF2dqcPa+9wWLYk7ADS8NMSxUW8W
        +bXD5jUdjhGf2i+ouUhx3AA5wiZgkP0ZwhL9gqw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=aNjZ/K
        u1CYLS/hdwt5RKVJIsxSxD8ZD0Ai/GU2RrCho=; b=IbIxqoxUpgmcBs6R0mPj5k
        OausIXzqQSp6T3jO/1LD1wl3M+pY7QRPlzVrTsAiy71lVkPxtRBKMRUck+tYAtW1
        O5CKBOmTEFGnxUohQfHUwdzz13FV+xFc46ZMO6aGnleKlA0+BU7LGX5CdE7yuZQq
        tnStPmOptEg58za576E9NJqrnoRoEsJHJJNORALS9H7qINGkfFvK05nq2Xq8t6ce
        Nasm19mWel2c5qhroyXOSm+gwdEuWSLhEKRRHvfjjj2bRZ+7bbZaa3L+3H6s81Ur
        5CzbCx/HupWDixMtlQ2Bi1HsesHYBou51ejCUjEOTzc7/6ofqqyRiig0ysje/RqA
        ==
X-ME-Sender: <xms:vWadXS8PMNCj5aujTUkB36twUC0E4Auii0gXfk2PuRyw_eT1ZU2ygQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedriedtgdekjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderreejnecuhfhrohhmpedftehnughr
    vgifucflvghffhgvrhihfdcuoegrnhgurhgvfiesrghjrdhiugdrrghuqeenucfrrghrrg
    hmpehmrghilhhfrhhomheprghnughrvgifsegrjhdrihgurdgruhenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:vWadXe3fEOxoszlZOOrqqrn6It9B2T45R50rEgCpyiemUL5CJoJlUw>
    <xmx:vWadXT2SJMmYFBa3O3z2M4WBddkCFkqB6Gi7kw9XGYueT7Z__sAHgA>
    <xmx:vWadXTytjckAa55yIouYj7WRZSCgKYZa9HRFNtLab6TzjS5PyH2U8w>
    <xmx:v2adXYFEevfn8Af8BVNhxP2d_aSCtxggOUnydUn04EF9ul3Q2WnEug>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 0D1BBE00A5; Wed,  9 Oct 2019 00:49:01 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.1.7-360-g7dda896-fmstable-20191004v2
Mime-Version: 1.0
Message-Id: <6f70580a-4b4b-45e0-8899-8a74f9587002@www.fastmail.com>
In-Reply-To: <75d915aec936be64ea5ebd63402efd90bb1c29d9.camel@kernel.crashing.org>
References: <20191008115143.14149-1-andrew@aj.id.au>
 <20191008115143.14149-2-andrew@aj.id.au>
 <75d915aec936be64ea5ebd63402efd90bb1c29d9.camel@kernel.crashing.org>
Date:   Wed, 09 Oct 2019 15:19:53 +1030
From:   "Andrew Jeffery" <andrew@aj.id.au>
To:     "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        netdev <netdev@vger.kernel.org>
Cc:     "David Miller" <davem@davemloft.net>,
        "Rob Herring" <robh+dt@kernel.org>, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Joel Stanley" <joel@jms.id.au>
Subject: =?UTF-8?Q?Re:_[PATCH_1/3]_dt-bindings:_net:_ftgmac100:_Document_AST2600_?=
 =?UTF-8?Q?compatible?=
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Wed, 9 Oct 2019, at 15:08, Benjamin Herrenschmidt wrote:
> On Tue, 2019-10-08 at 22:21 +1030, Andrew Jeffery wrote:
> > The AST2600 contains an FTGMAC100-compatible MAC, although it no-
> > longer
> > contains an MDIO controller.
> 
> How do you talk to the PHY then ?

There are still MDIO controllers, they're just not in the MAC IP on the 2600.

Andrew
