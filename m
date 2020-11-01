Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971292A1F2B
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 16:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgKAPjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 10:39:12 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:33681 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726637AbgKAPjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 10:39:11 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 2EF0E58060C;
        Sun,  1 Nov 2020 10:39:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 01 Nov 2020 10:39:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=6hDl7J
        hbg9XXnjroHNxSvD1BGTLNVMaeg1/EgrPhb28=; b=ezL7t5JSKNSJI9ioGXkbjL
        oUhQSga8m51lojolTMGwwOvf6l1UfAap/NLDHzco12VZ9KN9FzeAw8OLugYvWkMX
        WaYdadELZARieX1wKI8/gz0CkLtkydggkcPu6qaSecmkT/kG0V2YLgGWT5sxUCUO
        gUeajxEZ5JUGDs3r1KcFpS3QD0E3LZBsZfhb1rqKu/+d1JVtcZUVieBYPC58qBcS
        Mg7iMslXLVqxUIc5doUYIZ/WYnD8oqb2ngaoJZx4tBs/jLXH+h7vHZPNoMTHaxrc
        RscTmeGMpxCcJp8iZe/kCjo46AHHH+xOlthfwu6Nh1SiomqPJOgJVrHCKzGBMslQ
        ==
X-ME-Sender: <xms:ndaeX-nrybUXnK9AiowRMWbibOUpYy7jgAcx0SHtG8_5UhpkUXTu8Q>
    <xme:ndaeX13krqE9Uo0mKZ_Q8sSfwnMrcpvnVgFVAWUhA1nBaYpWP3n-Dg0vBxZSriN93
    4UBOMTxJtW2L7U>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleelgdekudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehhedrudekvdenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:ndaeX8ohvxvMFMR2Mn3KdNzx7Q_RETjB2WU2Eg-UI4_ZcT7KFMVANg>
    <xmx:ndaeXylL2B9COKmsfS2rdfx3NKvlJAP3ciHK5eJE32SkB65-5GEB-A>
    <xmx:ndaeX82arvYvEWj_OgMKxSGTRdl6OchCs2EE91mxIFoig130YDUrKA>
    <xmx:ntaeXyyIKlJnUdDZKUhlIB7bjO5bR94_RH1HKMiBf-kCPhSRjn45nQ>
Received: from localhost (igld-84-229-155-182.inter.net.il [84.229.155.182])
        by mail.messagingengine.com (Postfix) with ESMTPA id A0F5E3280064;
        Sun,  1 Nov 2020 10:39:08 -0500 (EST)
Date:   Sun, 1 Nov 2020 17:39:06 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Ivan Vecera <ivecera@redhat.com>, vyasevich@gmail.com,
        netdev <netdev@vger.kernel.org>, UNGLinuxDriver@microchip.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: Re: [PATCH RFC net-next 00/13] RX filtering for DSA switches
Message-ID: <20201101153906.GA720451@shredder>
References: <20200528143718.GA1569168@splinter>
 <20200720100037.vsb4kqcgytyacyhz@skbuf>
 <20200727165638.GA1910935@shredder>
 <20201027115249.hghcrzomx7oknmoq@skbuf>
 <20201028144338.GA487915@shredder>
 <20201028184644.p6zm4apo7v4g2xqn@skbuf>
 <20201101112731.GA698347@shredder>
 <20201101120644.c23mfjty562t5xue@skbuf>
 <20201101144217.GA714146@shredder>
 <20201101150442.as7qfa2qh7figmsn@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201101150442.as7qfa2qh7figmsn@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 01, 2020 at 05:04:42PM +0200, Vladimir Oltean wrote:
> On Sun, Nov 01, 2020 at 04:42:17PM +0200, Ido Schimmel wrote:
> > If the goal of this thread is to get packet sockets to work with
> > offloaded traffic, then I think you need to teach these sockets to
> > instruct the bound device to trap / mirror incoming traffic to the CPU.
> > Maybe via a new ndo.
> 
> A new ndo that does what? It would be exclusively called by sockets?
> We have packet traps with tc, packet traps with devlink, a mechanism for
> switchdev host MDBs, and from the discussion with you I also gather that
> there should be an equivalent switchdev object for host FDBs, that the
> bridge would use. So we would need yet another mechanism to extract
> packets from the hardware data path? I am simply lacking the clarity
> about what the new ndo you're talking about should do.

You indicated that you want packet sockets to work without any user
space changes:

"I think that user space today is expecting that when it uses the
*_ADD_MEMBERSHIP API, it is sufficient in order to see that traffic over
a socket. Switchdev and DSA are kernel-only concepts, they have no
user-facing API. I am not sure that it is desirable to change that."

So tc is irrelevant. And it should work regardless if the socket is
bound to an interface that is bridged:

"For PACKET_ADD_MEMBERSHIP, this should work as-is on swpN even if it's
bridged."

So anything related to the bridge is irrelevant as well.

You also wondered which indication you would get down to the driver that
eventually needs to program the hardware to get the packets:

"Who will notify me of these multicast addresses if I'm bridged and I
need to terminate L2 or L4 PTP through the data path of the slave
interfaces and not of the bridge."

Which kernel entity you want to get the notification from? The packet
socket wants the packets, so it should notify you. The kernel is aware
that traffic is offloaded and can do whatever it needs (e.g., calling
the ndo) in order to extract packets from the hardware data path to the
CPU and to the socket.
