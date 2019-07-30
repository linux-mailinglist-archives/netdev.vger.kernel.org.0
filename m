Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 898927A56F
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 12:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732201AbfG3KEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 06:04:21 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60059 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725947AbfG3KEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 06:04:21 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id ED71922008;
        Tue, 30 Jul 2019 06:04:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 30 Jul 2019 06:04:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=4x/UZ/
        xEBDLMoUYduJWBoXB4D8gSXgfle7LDtguVQOU=; b=yl+ByKipshbQWlcGGWaZ7A
        G05dGg7yl/WKB0u+14NYk1HCjPyecJosakRL2pjT3GVEYVXJk4F8HuNpNZ6DbDGY
        9K91qA0mvLCx2Dlvvv9SdQ5FwK00TbLKyruezdCr/YFZEHQYRG/OCgjprFMsIqaS
        GmwkjaKzeG1jgILzFJJbWkaubUbV21+Kj5CXeaeUY4Eq5rZAeVdFbav+n2nPLJxT
        gqdBZzSvZamOxYw/FDtc3a53iZiZYzgOIpwlnxtyuCBJfvMmwKlltmBd43xjz9US
        jJm2UyHN9Xeu5R0o/Hxw81T+idqcHp5K4gFXcAvPdSpAbL0rSy4E3kB9m0MocVYA
        ==
X-ME-Sender: <xms:IxZAXbeWMqnU2swpdCtKedZnHJQIK7lPPYKkb17JmSpI9AansB-4WA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrleefgddvvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:IxZAXaL0ChDvMwGR4S1FpLnYDpVt8BTJRI9h68OW5uSeVQxHYh69Ng>
    <xmx:IxZAXR0jhE9ElSUfUVggxCgnOmTnIoMqPtWRx_ArjfbWyggTk8mm9Q>
    <xmx:IxZAXQq0KAaSWXYsx7HLqhfl6RrCon0-Imem2GaXThjU6Gm4ysdHCw>
    <xmx:IxZAXajkh7oW-fYMdHL1Zn1ievzh8XZS60ESayIVm2eMLdws0k3lzg>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B1BB9380086;
        Tue, 30 Jul 2019 06:04:18 -0400 (EDT)
Date:   Tue, 30 Jul 2019 13:04:16 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bridge: Allow bridge to joing multicast groups
Message-ID: <20190730100416.GA13250@splinter>
References: <95315f9e-0d31-2d34-ba50-11e1bbc1465c@cumulusnetworks.com>
 <20190729131420.tqukz55tz26jkg73@lx-anielsen.microsemi.net>
 <3cc69103-d194-2eca-e7dd-e2fa6a730223@cumulusnetworks.com>
 <20190729135205.oiuthcyesal4b4ct@lx-anielsen.microsemi.net>
 <e4cd0db9-695a-82a7-7dc0-623ded66a4e5@cumulusnetworks.com>
 <20190729143508.tcyebbvleppa242d@lx-anielsen.microsemi.net>
 <20190729175136.GA28572@splinter>
 <20190730062721.p4vrxo5sxbtulkrx@lx-anielsen.microsemi.net>
 <20190730070626.GA508@splinter>
 <20190730083027.biuzy7h5dbq7pik3@lx-anielsen.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730083027.biuzy7h5dbq7pik3@lx-anielsen.microsemi.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 10:30:28AM +0200, Allan W. Nielsen wrote:
> The 07/30/2019 10:06, Ido Schimmel wrote:
> > As a bonus, existing drivers could benefit from it, as MDB entries are already
> > notified by MAC.
> Not sure I follow. When FDB entries are added, it also generates notification
> events.

I meant the switchdev notification sent to drivers:

/* SWITCHDEV_OBJ_ID_PORT_MDB */
struct switchdev_obj_port_mdb {
	struct switchdev_obj obj;
	unsigned char addr[ETH_ALEN];
	u16 vid;
};

By extending MDB entries to also be keyed by MAC you basically get a lot
of things for free without duplicating the same code for multicast FDBs.

AFAICS, then only change in the fast path is in br_mdb_get() where you
need to use DMAC as key in case Ethertype is not IPv4/IPv6.
