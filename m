Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAF4F5AC90
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 18:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfF2Q3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 12:29:52 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35875 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726837AbfF2Q3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 12:29:51 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8ADF821B6B;
        Sat, 29 Jun 2019 12:29:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 29 Jun 2019 12:29:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=0/mmxi
        Ky9/ZbjOwnteYsdrM6KDXjUQ6NpKi66xp9rts=; b=P9blHm0PqRQQMJhFyl33rE
        KRWMVBiEHm0tGkNy2hX+EY/lFmatIF+V8X5bhC4gjerWzfCXisX7y9nysDZ5TorJ
        oj3JP1jCF4tKfIG7DP3H+pKtFhTII/g7w5TPEhPVRaHFC9g7q59r/ljg2l8svO7a
        VpQ2jErhZ4Q6R7nxSkOBa2347a4TRCpr0g5U+K3DdLrhXLa3lYJdfMbUxyi2ak+9
        SNIj6z48a4NyQSnCk9P6GItfLllt8hPVAsIPJrOwgwGmXrA9KbmdUpaD2zgd0Unn
        +cmoJHT7WrEqB6VHRd8xUxxWO7hdrqMhi+ZOs5pVsqucnR6ElGUbO90kmqH7y2Ag
        ==
X-ME-Sender: <xms:_JEXXatlglaSE_NdnPyk5BX8PcglF4RPkOUKYzKQ-VoOdpZ0BLHzTw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvddvgddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedutd
    elrdeihedrieefrddutddunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:_JEXXd8pB-Akyf8VQv0ukrekitHQ3Hy-Oxy5QlRjlPUjbw9eRcl9ew>
    <xmx:_JEXXclJO0Rz2fHD_QHO96TFBK45f81UXd6RoBDlA05MPylwFfL78A>
    <xmx:_JEXXVNMO3akauuad61oZg-pwebkSW5ewP_KwInwZCHK8JOqu2l4pA>
    <xmx:_pEXXR_YQteuOsSe15b7-QT9KC2wmd9jnQAFX_0K1uXIUInOdohReg>
Received: from localhost (bzq-109-65-63-101.red.bezeqint.net [109.65.63.101])
        by mail.messagingengine.com (Postfix) with ESMTPA id CA4CC380079;
        Sat, 29 Jun 2019 12:29:47 -0400 (EDT)
Date:   Sat, 29 Jun 2019 19:29:45 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        nikolay@cumulusnetworks.com, linus.luessing@c0d3.blue
Cc:     Ido Schimmel <idosch@mellanox.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC net-next] net: dsa: add support for MC_DISABLED attribute
Message-ID: <20190629162945.GB17143@splinter>
References: <20190620235639.24102-1-vivien.didelot@gmail.com>
 <5d653a4d-3270-8e53-a5e0-88ea5e7a4d3f@gmail.com>
 <20190621172952.GB9284@t480s.localdomain>
 <20190623070949.GB13466@splinter>
 <20190623072605.2xqb56tjydqz2jkx@shell.armlinux.org.uk>
 <20190623074427.GA21875@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190623074427.GA21875@splinter>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 23, 2019 at 10:44:27AM +0300, Ido Schimmel wrote:
> On Sun, Jun 23, 2019 at 08:26:05AM +0100, Russell King - ARM Linux admin wrote:
> > On Sun, Jun 23, 2019 at 07:09:52AM +0000, Ido Schimmel wrote:
> > > When multicast snooping is enabled unregistered multicast traffic should
> > > only be flooded to mrouter ports.
> > 
> > Given that IPv6 relies upon multicast working, and multicast snooping
> > is a kernel configuration option, and MLD messages will only be sent
> > when whenever the configuration on the target changes, and there may
> > not be a multicast querier in the system, who does that ensure that
> > IPv6 can work on a bridge where the kernel configured and built with
> > multicast snooping enabled?
> 
> See commit b00589af3b04 ("bridge: disable snooping if there is no
> querier"). I think that's unfortunate behavior that we need because
> multicast snooping is enabled by default. If it weren't enabled by
> default, then anyone enabling it would also make sure there's a querier
> in the network.

Linus, Nik,

I brought this problem in the past, but we didn't reach a solution, so
I'll try again :)

The problem:

Even if multicast snooping is enabled, the bridge driver will flood
multicast packets to all the ports if no querier was detected on the
link. The querier states (IPv4 & IPv6) are not currently reflected to
switchdev drivers which means that the hardware data path will only
flood unregistered multicast packets to mrouter ports (which can be an
empty list).

In default configurations (where multicast snooping is enabled and the
bridge querier is disabled), this can prevent IPv6 ping from passing, as
there are no mrouter ports and there is no MDB entry corresponding to
the solicited-node multicast address.

Is there anything we can do about it? Enable the bridge querier if no
other querier was detected? Commit c5c23260594c ("bridge: Add
multicast_querier toggle and disable queries by default") disabled
queries by default, but I'm only suggesting to turn them on if no other
querier was detected on the link. Do you think it's still a problem?

I would like to avoid having drivers take the querier state into account
as it will only complicate things further.

Thanks
