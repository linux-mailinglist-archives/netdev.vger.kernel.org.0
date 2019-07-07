Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4BB8614AC
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 12:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727371AbfGGK2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 06:28:50 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46999 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727125AbfGGK2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 06:28:49 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 627762134B;
        Sun,  7 Jul 2019 06:28:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 07 Jul 2019 06:28:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=aaMt57
        yZYfyil/RreBDqceJPqRXy35bdrymaxqJSnG0=; b=JJ1AE9s7DWlohY0kD+lIAU
        N0ROSJOzMtfx+PJcACFCxvV30Rvz9uawSSTRdxVRED1GHj0MLU+GK5tRyuaZnMOV
        uRapzg48IzwAzjY3RzMspym7FI6qzUaU8WGjWsBFAvIHK6LxiU3zfTu//ti0p/ON
        f0u0o6OXK1WvKkHpaMbkcTrWBQgC/H8CC8zy6Xeo/5UWfBT/TKKPoiqqLaJ2venY
        7xteTbB1/lRDu6MtRvcGhZtfo6v+cqqLhUF7sinU63JCpboDlqIHInHSWft29vcQ
        3PmKjV1xxc4hoQNuuOwjJU7ZxHVM+ccVekZOQpRuUt0xD6/qfiRBInvRn27WdhkA
        ==
X-ME-Sender: <xms:XskhXU7pRXDy-25UglLzLCMed0cpNMd7_KUDB5rA6KCrsuvsJ54m8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeekgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:X8khXUWH2fIz3CKSbrvH-_qjhSsS-66wHu7MWsa8_6Gh5E9c-iNFYQ>
    <xmx:X8khXWFGko-gGKALZLspX-yVswH7Q53QWWlfu9bhpjUIem4fkdoGMA>
    <xmx:X8khXUczZJYmnnSxatnzt2IQx8cPkNatk-rizb6IgzMBMGR6vBLoAA>
    <xmx:YMkhXUi65k6X11Nqw9yjWz874i2Myh1XuEQfZJ8FqHBa5jLy2cCLhw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 83D6B8005A;
        Sun,  7 Jul 2019 06:28:46 -0400 (EDT)
Date:   Sun, 7 Jul 2019 13:28:44 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Ido Schimmel <idosch@mellanox.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC net-next] net: dsa: add support for MC_DISABLED attribute
Message-ID: <20190707102844.GA8487@splinter>
References: <20190620235639.24102-1-vivien.didelot@gmail.com>
 <5d653a4d-3270-8e53-a5e0-88ea5e7a4d3f@gmail.com>
 <20190621172952.GB9284@t480s.localdomain>
 <20190623070949.GB13466@splinter>
 <20190705120149.GB17996@t480s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190705120149.GB17996@t480s.localdomain>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 05, 2019 at 12:01:49PM -0400, Vivien Didelot wrote:
> Hi Ido,
> 
> On Sun, 23 Jun 2019 07:09:52 +0000, Ido Schimmel <idosch@mellanox.com> wrote:
> > > Russell, Ido, Florian, so far I understand that a multicast-unaware
> > > bridge must flood unknown traffic everywhere (CPU included);
> > > and a multicast-aware bridge must only flood its ports if their
> > > mcast_flood is on, and known traffic targeting the bridge must be
> > > offloaded accordingly. Do you guys agree with this?
> > 
> > When multicast snooping is enabled unregistered multicast traffic should
> > only be flooded to mrouter ports.
> 
> I've figured out that this is what I need to prevent the flooding of undesired
> multicast traffic to the CPU port of the switch. The bridge itself has a
> multicast_router attribute which can be disabled, that is when I should drop
> unknown multicast traffic.
> 
> However with SWITCHDEV_ATTR_ID_BRIDGE_MROUTER implemented, this
> attribute is always called with .mrouter=0, regardless the value of
> /sys/class/net/br0/bridge/multicast_router. Do I miss something here?

Hi Vivien,

I just checked this and it seems to work as expected:

# echo 2 > /sys/class/net/br0/bridge/multicast_router

We get a notification with mrouter=1 to mlxsw

# echo 0 > /sys/class/net/br0/bridge/multicast_router

We get a notification with mrouter=0 to mlxsw
