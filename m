Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78F3872956
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 09:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfGXH5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 03:57:07 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:53581 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725776AbfGXH5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 03:57:07 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 206171653;
        Wed, 24 Jul 2019 03:57:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 24 Jul 2019 03:57:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=Nchtg20XnRRPPTpLglX1CXMA9ZJug6lV7ROuJ89M6
        U4=; b=Ty4r9bE84OiAVKC/P3tYETM035eOUJQVHfE0gFoWWu8vlso1LYyQRiHiT
        C3siUt/ZE1RUHAEGOXJ/udAkW2WSyd7m9rvodQoINHQunZ1oy+Khj09KozSIQsD9
        16yYcF2LBqQFxe2y+19fnohLlC679cyEXuDlFubl5DXu5hSQS7eV1eZVqSJ87arN
        Dhb0pwX1YArgO5LTKVvK+Urfh2Z4v/6OGhWidbbg5Pcf+0OwjQNohMpvpqOkKnwP
        FrcXBPvs1CB96AyxL+guwZ/0CCaqDkv1n/dTOrhOYNfzO3qlNvXJK5MoRP7wY9+w
        rHGI9QvXbkq4AKYv0O7NL7L1LIbPg==
X-ME-Sender: <xms:Tg84XQPq11QlIQvU-H5Z9Fh9lXu9FpQR66IKPDEuf6EFH83_E_6bBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeelgdduvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjggfsehtkeertddtredunecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepud
    elfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgt
    hhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Tg84XbNKFhK4gTucNTD0eW-HfAe3xkLGmCEYJ5t7hihs9oOj_fml6w>
    <xmx:Tg84XSSNSZOo7XATPsbHdG7JtH1ZdorT_h_zUa4718a313CZWWGLZQ>
    <xmx:Tg84XdB5Ti_1EAsYX5WdMF2b1EZWihFufeBiT2qpDfY3k6Y2nOd3UA>
    <xmx:Ug84XRL6tRAjNXKPjzxE6mjDRRTySyUlnqev03oj9d0X-FyGrq2yKA>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0B8D5380075;
        Wed, 24 Jul 2019 03:57:01 -0400 (EDT)
Date:   Wed, 24 Jul 2019 10:57:00 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        jakub.kicinski@netronome.com, andy@greyhouse.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 00/12] drop_monitor: Capture dropped packets
 and metadata
Message-ID: <20190724075700.GA15878@splinter>
References: <20190722183134.14516-1-idosch@idosch.org>
 <87imrt4zzg.fsf@toke.dk>
 <20190723064659.GA16069@splinter>
 <875znt3pxu.fsf@toke.dk>
 <20190723151423.GA10342@splinter>
 <c02f9b6a-f343-89ee-1047-79c1fb4e3436@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c02f9b6a-f343-89ee-1047-79c1fb4e3436@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 08:47:57AM -0700, David Ahern wrote:
> On 7/23/19 8:14 AM, Ido Schimmel wrote:
> > On Tue, Jul 23, 2019 at 02:17:49PM +0200, Toke Høiland-Jørgensen wrote:
> >> Ido Schimmel <idosch@idosch.org> writes:
> >>
> >>> On Mon, Jul 22, 2019 at 09:43:15PM +0200, Toke Høiland-Jørgensen wrote:
> >>>> Is there a mechanism for the user to filter the packets before they are
> >>>> sent to userspace? A bpf filter would be the obvious choice I guess...
> >>>
> >>> Hi Toke,
> >>>
> >>> Yes, it's on my TODO list to write an eBPF program that only lets
> >>> "unique" packets to be enqueued on the netlink socket. Where "unique" is
> >>> defined as {5-tuple, PC}. The rest of the copies will be counted in an
> >>> eBPF map, which is just a hash table keyed by {5-tuple, PC}.
> >>
> >> Yeah, that's a good idea. Or even something simpler like tcpdump-style
> >> filters for the packets returned by drop monitor (say if I'm just trying
> >> to figure out what happens to my HTTP requests).
> > 
> > Yep, that's a good idea. I guess different users will use different
> > programs. Will look into both options.
> 
> Perhaps I am missing something, but the dropmon code only allows a
> single user at the moment (in my attempts to run 2 instances the second
> one failed).

Yes, you're correct. By "different users" I meant users on different
systems with different needs. For example, someone trying to monitor
dropped packets on a laptop versus someone trying to do the same on a
ToR switch.

> If that part stays with the design

This stays the same.

> it afford better options for the design. e.g., attributes that control
> the enqueued packets when the event occurs as opposed to bpf filters
> which run much later when the message is enqueued to the socket.

I'm going to add an attribute that will control the number of packets
we're enqueuing on the per-CPU drop list. I'm not sure, but are you
suggesting to add even more attributes? If so, how do you imagine these
will look like?

> 
> > 
> >>> I think it would be good to have the program as part of the bcc
> >>> repository [1]. What do you think?
> >>
> >> Sure. We could also add it to the XDP tutorial[2]; it could go into a
> >> section on introspection and debugging (just added a TODO about that[3]).
> > 
> > Great!
> > 
> >>>> For integrating with XDP the trick would be to find a way to do it that
> >>>> doesn't incur any overhead when it's not enabled. Are you envisioning
> >>>> that this would be enabled separately for the different "modes" (kernel,
> >>>> hardware, XDP, etc)?
> >>>
> >>> Yes. Drop monitor have commands to enable and disable tracing, but they
> >>> don't carry any attributes at the moment. My plan is to add an attribute
> >>> (e.g., 'NET_DM_ATTR_DROP_TYPE') that will specify the type of drops
> >>> you're interested in - SW/HW/XDP. If the attribute is not specified,
> >>> then current behavior is maintained and all the drop types are traced.
> >>> But if you're only interested in SW drops, then overhead for the rest
> >>> should be zero.
> >>
> >> Makes sense (although "should be" is the key here ;)).
> 
> static_key is used in other parts of the packet fast path.
> 
> Toke/Jesper: Any reason to believe it is too much overhead for this path?
> 
> >>
> >> I'm also worried about the drop monitor getting overwhelmed; if you turn
> >> it on for XDP and you're running a filtering program there, you'll
> >> suddenly get *a lot* of drops.
> >>
> >> As I read your patch, the current code can basically queue up an
> >> unbounded number of packets waiting to go out over netlink, can't it?
> > 
> > That's a very good point. Each CPU holds a drop list. It probably makes
> > sense to limit it by default (to 1000?) and allow user to change it
> > later, if needed. I can expose a counter that shows how many packets
> > were dropped because of this limit. It can be used as an indication to
> > adjust the queue length (or flip to 'summary' mode).
> > 
> 
> And then with a single user limit, you can have an attribute that
> controls the backlog.

Yep, already on my list of changes for v1 :)

Thanks, David.
