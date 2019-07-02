Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCE25D50B
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 19:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfGBRMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 13:12:09 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:59469 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726046AbfGBRMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 13:12:09 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id D5179152D;
        Tue,  2 Jul 2019 13:12:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 02 Jul 2019 13:12:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=krs+o9ys1kfgZirsSN1pcrC0I3jHz0Mn7Be5Y0gG6
        lo=; b=HYBguTwLTRqnIkjzCKfF8/VmR6YOsqboT0LKe2MvxWL67kOcDLaUtG1UY
        8kk9SjNsZ03MX0K6xLb5pMigohIOvR/7iSj0e9fVTTZMDFbNifTBXoOHzHlV1G7K
        LWPXw+baOarihRZYROAj0dTX2YnE8RoRmlX+qkiJlkjGsSdo+UA10AelHSsGtukL
        SqvbLukQlWsjS9htTGKaodqXVikEVKjy9x5AV34+CKL0UqjxhEMnLOR6F1W9x7r8
        c7NN24l/vul4dDyhoBRNPaQMH8t2WlDvbmnnLU2ioh279nz5+tWsnBz1PizxdF75
        XnfoKojIjYjYpNYuSkzwZ0o0EAsHw==
X-ME-Sender: <xms:Y5AbXbffuu-YpmpLoQ1i_MOkzmeZWH8Ea43iqFX8udOUbBP0ZYINdw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvdekgdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjggfsehtkeertddtredunecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepud
    dtledrieehrdeifedruddtudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:Y5AbXT40YI0BEcITb6eg-nClY_5DCV2O7yjnk1eDtyUeD1evR0w2ZA>
    <xmx:Y5AbXQXWMcGXV8m_I_kbpNN2-LJxoyvvMVCT8AFqAeI-cR_xhILXeg>
    <xmx:Y5AbXTaq4_y5U0vNxKUJ3dKsWwaKq51X84sISqAvyM-239rmeKPAzQ>
    <xmx:ZpAbXUpEJboYFifzYt71-NJ_c_v5BDT326jm9udPGK14c8R8CqK3TQ>
Received: from localhost (bzq-109-65-63-101.red.bezeqint.net [109.65.63.101])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3E5A380064;
        Tue,  2 Jul 2019 13:12:02 -0400 (EDT)
Date:   Tue, 2 Jul 2019 20:11:58 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Linus =?iso-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        nikolay@cumulusnetworks.com, Ido Schimmel <idosch@mellanox.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [RFC net-next] net: dsa: add support for MC_DISABLED attribute
Message-ID: <20190702171158.GA7182@splinter>
References: <20190620235639.24102-1-vivien.didelot@gmail.com>
 <5d653a4d-3270-8e53-a5e0-88ea5e7a4d3f@gmail.com>
 <20190621172952.GB9284@t480s.localdomain>
 <20190623070949.GB13466@splinter>
 <20190623072605.2xqb56tjydqz2jkx@shell.armlinux.org.uk>
 <20190623074427.GA21875@splinter>
 <20190629162945.GB17143@splinter>
 <20190630165601.GC2500@otheros>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190630165601.GC2500@otheros>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 30, 2019 at 06:56:01PM +0200, Linus Lüssing wrote:
> > On Sun, Jun 23, 2019 at 10:44:27AM +0300, Ido Schimmel wrote:
> > > See commit b00589af3b04 ("bridge: disable snooping if there is no
> > > querier"). I think that's unfortunate behavior that we need because
> > > multicast snooping is enabled by default. If it weren't enabled by
> > > default, then anyone enabling it would also make sure there's a querier
> > > in the network.
> 
> I do not quite understand that point. In a way, that's what we
> have right now, isn't it? By default it's disabled, because by
> default there is no querier on the link. So anyone wanting to use
> multicast snooping will need to make sure there's a querier in the
> network.

Hi Linus,

Querier state is not reflected to drivers ATM, so drivers believe the
bridge is multicast aware and unregistered multicast packets are only
flooded to mrouter ports. Hosts that are silent (because there is no
querier) never get the traffic addressed to them (f.e., IPv6 neighbour
solicitation).

> Overall I think the querier (election) mechanism in the standards could
> need an update. While the lowest-address first might have
> worked well back then, in uniform, fully wired networks where the
> position of the querier did not matter, this is not a good
> solution anymore in networks involving wireless, dynamic connections.
> Especially in wireless mesh networks this is a bit of an issue for
> us. Ideally, the querier mechanism were dismissed in favour of simply
> unsolicited, periodic IGMP/MLD reports...
> 
> But of course, updating IETF standards is no solution for now. 
> 
> While more complicated, it would not be impossible to consider the
> querier state, would it? I mean you probably already need to
> consider the case of a user disabling multicast snooping during
> runtime, right? 

Sure, this is implemented.

> So similarly, you could react to appearing or disappearing queriers?

Yes, but it's a bit more complicated since we need to differentiate
between IPv4 and IPv6. If the bridge is multicast aware, but there is
only IPv4 querier on the link, then:

1. All the IPv6 MDB entries need to be removed from the device. At least
in mlxsw, we do not have a way to ignore only IPv6 entries. From the
device's perspective, an MDB entry is just a multicast DMAC with a
bitmap of ports packets should be replicated to.

2. We need to split the flood tables used for IPv4 and IPv6 unregistered
multicast packets. For IPv4, packets should only be flooded to mrouter
ports whereas for IPv6 packets should be flooded to all the member
ports.

Do you differentiate between IPv4 and IPv6 in batman-adv?

> Cheers, Linus

Thanks for the feedback!
