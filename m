Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5A01A9A72
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 12:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408622AbgDOK2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 06:28:47 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:33373 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408614AbgDOK2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 06:28:33 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 509158FE;
        Wed, 15 Apr 2020 06:21:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 15 Apr 2020 06:21:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=NvSNXk
        M9bSR9UeyX+Uc1Y3NhztPOVa2DeQZJYFKHAJ8=; b=egZs/zGVSR/Uu+l3k2+Yrk
        cuI5mhqGSg8F2qnxxBzTh3jx9S5FlgKArnOGRCeqfNq7ICxA9cZAZVNlz8qF9RfV
        J7iOrkVBTFy6p1v6VzC1slJlQ2lm/QWKfnImh99bGgOGQBQumspHOvnt9edFIxpv
        gydXDz51MantyiBmRQVVq+01FwV2inDGkO+S/z5Ci0c0T2V2wzP4FPaUZPXcUOEA
        ON+cWMO9UKmLCVCJOWjUoY9eimJSZ7udZmIc63GnRczjrl77HahfW6KcqzSk1xv+
        IpVTjzKj73SeFarO4MSLkoUUUDlmfUu6RDFGFEDLU/EvkEC3bU6K4376AyjrdjYg
        ==
X-ME-Sender: <xms:LuCWXuzx661jkXqKeYBYcGP7kIM4J5bN1uEsOPAl0tU3uJXN4_AF2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgdduiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuffhomhgrihhnpe
    hgihhthhhusgdrtghomhenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiug
    hoshgthhdrohhrgh
X-ME-Proxy: <xmx:LuCWXsUlRNiPSc3T6wMPrRse-6IS2qlmX70eMseopfIdjkIMlCVYnA>
    <xmx:LuCWXg3IMMEWjTnIMWxS96ggTmjTeD1nPLEYu76ZwIHFfPJOqCmo2A>
    <xmx:LuCWXpSOq0G3HTQZ_rxldiZiwTPfNVPPVXRc_BoBnu2ZzgkDdqK8TQ>
    <xmx:LuCWXkORl_aS_4eclcCFURXXCwuoxyBea0lFp6RhlC3hqDG3Lb7gUQ>
Received: from localhost (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id ABDE83060061;
        Wed, 15 Apr 2020 06:21:33 -0400 (EDT)
Date:   Wed, 15 Apr 2020 13:21:31 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Russell Strong <russell@strong.id.au>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: vxlan mac address generation
Message-ID: <20200415102131.GA3145613@splinter>
References: <20200415100524.1ed7f9f9@strong.id.au>
 <20200414211206.40a324b4@hermes.lan>
 <20200415172800.50a3acc7@strong.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415172800.50a3acc7@strong.id.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 05:28:00PM +1000, Russell Strong wrote:
> I tried debian ( 4.19.0-8-amd64 ) and got the same result as you.  I am
> using Fedora 31 ( 5.5.15-200.fc31.x86_64 ).  I have discovered a
> difference:
> 
> On fedora /sys/class/net/v0/addr_assign_type = 3
> On debian /sys/class/net/v0/addr_assign_type = 1
> 
> The debian value is what I would expect (NET_ADDR_RANDOM).  I thought
> addr_assign_type was controlled by the driver.  Do you think this could
> be a Fedora bug, or perhaps something has changed between 4.19 and 5.5?

I assume you're using systemd 242 or later. I also hit this issue.
Documented the solution here:

https://github.com/Mellanox/mlxsw/wiki/Persistent-Configuration#required-changes-to-macaddresspolicy
