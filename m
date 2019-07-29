Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9542784D6
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 08:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfG2GJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 02:09:29 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:33007 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725934AbfG2GJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 02:09:29 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B022721BA9;
        Mon, 29 Jul 2019 02:09:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 29 Jul 2019 02:09:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=/SBTOk
        cbxtFVR/CQbarJXCkuOQOjrMyBPaPW6M0UaOY=; b=tU5hGH3MbArrHjbFBCxnyN
        sLwoXsz5UlH8fSkija53SDNKpwKyPmwLL7Q77iRj6oep4VVras9IhIY7B1Lh2Q9v
        Xlxr19rUz3fWZxt2yb+gj9YAib0kv06C6KrIDKQmwkCJTO39eMNIUGMJ+O1yHjFX
        TKFan5XnAtpVvarDGVGGLYjS3SDbe45WOPY0UFaIDVMT+cIClG3XbqqpFYgivyvR
        3wI90SEMVIWAD9WcWtzmYmGXhHTlOy0cAamegbz7XLhK29Epy0o4mjayLrSMIFvD
        AwhdDJkiGyAGCK46262UZXarz/0kS3EBU+ls0ITFWz5mkajFWbGKd6GYrG9FRBrg
        ==
X-ME-Sender: <xms:lY0-XeRFLxc_89Ovi38c5c_4U18LY6x5fm8VPMYK5X3eHaL9qagLzg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrledtgddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:lY0-Xd2kBRcEYGfdOM8_THMJW0L6ZW9vqSdM5B44LGtdTnWIN37btw>
    <xmx:lY0-XQwM7I5k4jx9ZTP45nbw-0EhJq7RqtoOOiPtEo7yvX75kVceGQ>
    <xmx:lY0-XRzMUeoucuNzVH_GhHIT6y8K0XE7AkeCd_uf7V3MVCZtJySAMg>
    <xmx:l40-XQI3KeEhB6FjU7hI4CPYZNNBhBX9ZcxHhLknPV5foPv5GHOioQ>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 63E4D80061;
        Mon, 29 Jul 2019 02:09:25 -0400 (EDT)
Date:   Mon, 29 Jul 2019 09:09:23 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bridge: Allow bridge to joing multicast groups
Message-ID: <20190729060923.GA16938@splinter>
References: <7e7a7015-6072-d884-b2ba-0a51177245ab@cumulusnetworks.com>
 <eef063fe-fd3a-7e02-89c2-e40728a17578@cumulusnetworks.com>
 <20190725142101.65tusauc6fzxb2yp@soft-dev3.microsemi.net>
 <b9ce433a-3ef7-fe15-642a-659c5715d992@cumulusnetworks.com>
 <e6ad982f-4706-46f9-b8f0-1337b09de350@cumulusnetworks.com>
 <20190726120214.c26oj5vks7g5ntwu@soft-dev3.microsemi.net>
 <20190726134613.GD18223@lunn.ch>
 <20190726195010.7x75rr74v7ph3m6m@lx-anielsen.microsemi.net>
 <20190727030223.GA29731@lunn.ch>
 <20190728191558.zuopgfqza2iz5d5b@lx-anielsen.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190728191558.zuopgfqza2iz5d5b@lx-anielsen.microsemi.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 28, 2019 at 09:15:59PM +0200, Allan W. Nielsen wrote:
> If we assume that the SwitchDev driver implemented such that all multicast
> traffic goes to the CPU, then we should really have a way to install a HW
> offload path in the silicon, such that these packets does not go to the CPU (as
> they are known not to be use full, and a frame every 3 us is a significant load
> on small DMA connections and CPU resources).
> 
> If we assume that the SwitchDev driver implemented such that only "needed"
> multicast packets goes to the CPU, then we need a way to get these packets in
> case we want to implement the DLR protocol.

I'm not familiar with the HW you're working with, so the below might not
be relevant.

In case you don't want to send all multicast traffic to the CPU (I'll
refer to it later), you can install an ingress tc filter that traps to
the CPU the packets you do want to receive. Something like:

# tc qdisc add dev swp1 clsact
# tc filter add dev swp1 pref 1 ingress flower skip_sw dst_mac \
	01:21:6C:00:00:01 action trap

If your HW supports sharing the same filter among multiple ports, then
you can install your filter in a tc shared block and bind multiple ports
to it.

Another option is to always send a *copy* of multicast packets to the
CPU, but make sure the HW uses a policer that prevents the CPU from
being overwhelmed. To avoid packets being forwarded twice (by HW and
SW), you will need to mark such packets in your driver with
'skb->offload_fwd_mark = 1'.

Now, in case user wants to allow the CPU to receive certain packets at a
higher rate, a tc filter can be used. It will be identical to the filter
I mentioned earlier, but with a 'police' action chained before 'trap'.

I don't think this is currently supported by any driver, but I believe
it's the right way to go: By default the CPU receives all the traffic it
should receive and user can fine-tune it using ACLs.
