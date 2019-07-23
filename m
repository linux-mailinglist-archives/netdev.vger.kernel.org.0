Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E74D71217
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 08:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732352AbfGWGrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 02:47:04 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:54159 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729552AbfGWGrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 02:47:04 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9937F1B68;
        Tue, 23 Jul 2019 02:47:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 23 Jul 2019 02:47:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=Pvm6a3akhSiREaVFZjMlHJTj/hfGaOe8D6Hc039sH
        no=; b=LRVH9ymgXihu5zmhsBgr/a5ycd0LQEEEYrWYPehUnDPAfOsQPDl4mfsr2
        8m7qeCgm9/d989gBQw533HUFucdz4721W15Z3eqpyu9wKWZ5Djlo5LCOdH3jlJaL
        PbMohg3fXULZo0i9SIl3HEqP7MGjdc4ms8SHPQNJtP8UHM2AHc8eOIF2/Y0p7YMT
        yIbKwUxVIf6w3ogVtryJhxWsrO96JLr7kHIuak85r5MGfSl/kyIqCFJBfztsOjhI
        UWiSQ8FZ9nRe6L81HF7nQmvm8BYUmBetj0gKm5nqLISZPVXOOqdKwb67mw774jLz
        dNZud2q/JFVR9QtoVhAMVvXzlqiTg==
X-ME-Sender: <xms:Za02XWyxPe-GYQB0Rld0fb9xEcLkHqCEGH8LTQVEOoMFkvH3hPfIXQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeejgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjfgesthekredttderudenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuffhomhgrih
    hnpehgihhthhhusgdrtghomhenucfkphepudelfedrgeejrdduieehrddvhedunecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluh
    hsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Za02XSC-Che6WnPt61MtrsNw9ajA-IlZd1FCayGFzkdnrbcUf6CIxg>
    <xmx:Za02Xa1XK9hPXulxCPFjk8RKAJwYW0Fv7IGjY98DuJUg6GJVtdazig>
    <xmx:Za02Xb3EW6tkk6fTYIMH5PILo5RGU4PN-wxZWBTJ3Y4c291TSRE1Jg>
    <xmx:Z602Xc3wPoNgLxMjHgHftkUKGliCpBgsFvwp8lWb5_Kw5EvfGgrnrA>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 167D280061;
        Tue, 23 Jul 2019 02:47:00 -0400 (EDT)
Date:   Tue, 23 Jul 2019 09:46:59 +0300
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
Message-ID: <20190723064659.GA16069@splinter>
References: <20190722183134.14516-1-idosch@idosch.org>
 <87imrt4zzg.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87imrt4zzg.fsf@toke.dk>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 22, 2019 at 09:43:15PM +0200, Toke Høiland-Jørgensen wrote:
> Is there a mechanism for the user to filter the packets before they are
> sent to userspace? A bpf filter would be the obvious choice I guess...

Hi Toke,

Yes, it's on my TODO list to write an eBPF program that only lets
"unique" packets to be enqueued on the netlink socket. Where "unique" is
defined as {5-tuple, PC}. The rest of the copies will be counted in an
eBPF map, which is just a hash table keyed by {5-tuple, PC}.

I think it would be good to have the program as part of the bcc
repository [1]. What do you think?

> For integrating with XDP the trick would be to find a way to do it that
> doesn't incur any overhead when it's not enabled. Are you envisioning
> that this would be enabled separately for the different "modes" (kernel,
> hardware, XDP, etc)?

Yes. Drop monitor have commands to enable and disable tracing, but they
don't carry any attributes at the moment. My plan is to add an attribute
(e.g., 'NET_DM_ATTR_DROP_TYPE') that will specify the type of drops
you're interested in - SW/HW/XDP. If the attribute is not specified,
then current behavior is maintained and all the drop types are traced.
But if you're only interested in SW drops, then overhead for the rest
should be zero.

For HW drops I'm going to have devlink call into drop monitor. The
function call will just be a NOP in case user is not interested in HW
drops. I'm not sure if for XDP you want to register a probe on a
tracepoint or call into drop monitor. If you want to use the former,
then you can just have drop monitor unregister its probe from the
tracepoint, which is what drop monitor is currently doing with the
kfree_skb() tracepoint.

Thanks!

[1] https://github.com/iovisor/bcc/tree/master/examples/networking
