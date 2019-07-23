Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBAC771B32
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 17:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390754AbfGWPO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 11:14:29 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:58167 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729004AbfGWPO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 11:14:28 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id B4B8B188A;
        Tue, 23 Jul 2019 11:14:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 23 Jul 2019 11:14:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=8SIQChd2YcKlCwCvDWAnnWXwA7ChIbD5wbWLh03Zg
        MQ=; b=LN4Om0D9Apn2uQhQ2CzdfmVNGZ5bpie2XU9ukk7KxGrM9tAMrCCnH3iqK
        lykODT1qPNvM0JnEKwDjmD6tOcLkbmYpl+oKJ+38tKVaRDWFPEsvkh/c1tfFeWom
        JhRAGCdAGA10hvfktNMqy+OJy1yMlehkfCX+Qtgm8w/qi/RM3F/aBBmdRj7lSuyV
        SBikB2ezVXqASPvFdILJd7k7roLuplJ9mnEJQTOajYQiKFOg3ftBeEbi0QV55Gzq
        JNiQwnPPMJWNiLjsk6gNArZrXqVzHw0JCn5Jhex4VcyeQyPNBrZ8t3uKSWYgEQXZ
        HSN4CyLEHV+Nfc9Y3kA2Fu4703cLg==
X-ME-Sender: <xms:USQ3XRnGTyjBKE0FND4Kiy06JcSNesOazEbgkNRoau9t6wlfkRwtPA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdekiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjfgesthekredttderudenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:USQ3XQyOtL4-VdNT0VoB7lvPRZq5tKm_MvP0eqFz-4lxY7aSeDjqcg>
    <xmx:USQ3XcP5hcnMqfA52Nld8n8iWPiTVcjPfmGrNwtzbNRRNnB06eiihg>
    <xmx:USQ3XZiT2pvFUBMp5i9ZIIQN7ZkRYUf72PnbZH1I1YdbZngbmKUbsw>
    <xmx:UyQ3XebCzjdokGL48n016NuottsIYJ8qjrpjQVKFZHML3GAdzyckjQ>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id EA09E380086;
        Tue, 23 Jul 2019 11:14:24 -0400 (EDT)
Date:   Tue, 23 Jul 2019 18:14:23 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 00/12] drop_monitor: Capture dropped packets
 and metadata
Message-ID: <20190723151423.GA10342@splinter>
References: <20190722183134.14516-1-idosch@idosch.org>
 <87imrt4zzg.fsf@toke.dk>
 <20190723064659.GA16069@splinter>
 <875znt3pxu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <875znt3pxu.fsf@toke.dk>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 02:17:49PM +0200, Toke Høiland-Jørgensen wrote:
> Ido Schimmel <idosch@idosch.org> writes:
> 
> > On Mon, Jul 22, 2019 at 09:43:15PM +0200, Toke Høiland-Jørgensen wrote:
> >> Is there a mechanism for the user to filter the packets before they are
> >> sent to userspace? A bpf filter would be the obvious choice I guess...
> >
> > Hi Toke,
> >
> > Yes, it's on my TODO list to write an eBPF program that only lets
> > "unique" packets to be enqueued on the netlink socket. Where "unique" is
> > defined as {5-tuple, PC}. The rest of the copies will be counted in an
> > eBPF map, which is just a hash table keyed by {5-tuple, PC}.
> 
> Yeah, that's a good idea. Or even something simpler like tcpdump-style
> filters for the packets returned by drop monitor (say if I'm just trying
> to figure out what happens to my HTTP requests).

Yep, that's a good idea. I guess different users will use different
programs. Will look into both options.

> > I think it would be good to have the program as part of the bcc
> > repository [1]. What do you think?
> 
> Sure. We could also add it to the XDP tutorial[2]; it could go into a
> section on introspection and debugging (just added a TODO about that[3]).

Great!

> >> For integrating with XDP the trick would be to find a way to do it that
> >> doesn't incur any overhead when it's not enabled. Are you envisioning
> >> that this would be enabled separately for the different "modes" (kernel,
> >> hardware, XDP, etc)?
> >
> > Yes. Drop monitor have commands to enable and disable tracing, but they
> > don't carry any attributes at the moment. My plan is to add an attribute
> > (e.g., 'NET_DM_ATTR_DROP_TYPE') that will specify the type of drops
> > you're interested in - SW/HW/XDP. If the attribute is not specified,
> > then current behavior is maintained and all the drop types are traced.
> > But if you're only interested in SW drops, then overhead for the rest
> > should be zero.
> 
> Makes sense (although "should be" is the key here ;)).
> 
> I'm also worried about the drop monitor getting overwhelmed; if you turn
> it on for XDP and you're running a filtering program there, you'll
> suddenly get *a lot* of drops.
> 
> As I read your patch, the current code can basically queue up an
> unbounded number of packets waiting to go out over netlink, can't it?

That's a very good point. Each CPU holds a drop list. It probably makes
sense to limit it by default (to 1000?) and allow user to change it
later, if needed. I can expose a counter that shows how many packets
were dropped because of this limit. It can be used as an indication to
adjust the queue length (or flip to 'summary' mode).
