Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5EA0A6118
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 08:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfICGNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 02:13:31 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:32921 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725888AbfICGNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 02:13:30 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id B2E372ADE;
        Tue,  3 Sep 2019 02:13:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 03 Sep 2019 02:13:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=WsBdGL
        PtmaM6MSH9coelJlBJ4FZ7Hzc7Dzf0YZFPgy4=; b=wserly1Bhz0LmmcOl/brqN
        ybDGSCkwc6ymsOVBdkTDE8AQhl62rSZJtRgJd+ikVqCZpBVW+0wOtnlFb/EOPr0G
        ydGf2GZ4lx87S8klfNEn6s0Iq3/xNgaCW66HTh7tf6LYK2/oXzA/N8I59ojOLR8m
        pCxHjYZbutbAMmyq79m5zwhvda53SFWKu99i5jGr2tj8N77Nm8T4P6WhJSH/4UQq
        oq72qlDYlxWj+JPSjlR+ibt4+3pw1AWf+WPRdohmf6nN1kZs5UF2X8PmA+8qxaOA
        t6VpsD1M8lMZtuiVoJh3Q5t+DJM+pF2HAdyjlTPKZYjGEtqoLFnw6BIbpX61LZLw
        ==
X-ME-Sender: <xms:hwRuXYQoAUzoJfO5G7QDItEHleVn4L-VJcOUlV4manlOt6DBYEWfyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejuddguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepud
    elfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgt
    hhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:hwRuXVEGvlmWJGpAKzD72YrisRKEm1emrPbb7YaGD-yYazu8eVqHfg>
    <xmx:hwRuXcwwijQfOfpF1oi-7yOUoTv6x3toBG8u4LMwJlnd-ObDXoyjJg>
    <xmx:hwRuXXXUYooL3QFFDo-4_l9sKYse6f53cqGLCIQPjBK3qgku2wzX-w>
    <xmx:iQRuXcpyXC_DdNKFlNG-CNNdSr7hta0vo8CvyqukHlst9yRkXP7azw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id A733C80060;
        Tue,  3 Sep 2019 02:13:26 -0400 (EDT)
Date:   Tue, 3 Sep 2019 09:13:24 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, David Miller <davem@davemloft.net>,
        andrew@lunn.ch, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ivecera@redhat.com, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to dev->promiscuity.
Message-ID: <20190903061324.GA6149@splinter>
References: <20190829193613.GA23259@splinter>
 <20190829.151201.940681219080864052.davem@davemloft.net>
 <20190830053940.GL2312@nanopsycho>
 <20190829.230233.287975311556641534.davem@davemloft.net>
 <20190830063624.GN2312@nanopsycho>
 <20190902174229.uur7r7duq4dvbnqq@lx-anielsen.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190902174229.uur7r7duq4dvbnqq@lx-anielsen.microsemi.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 02, 2019 at 07:42:31PM +0200, Allan W. Nielsen wrote:
> I have been reading through this thread several times and I still do not get it.

Allan,

I kept thinking about this and I want to make sure that I correctly
understand the end result.

With these patches applied I assume I will see the following traffic
when running tcpdump on one of the netdevs exposed by the ocelot driver:

- Ingress: All
- Egress: Only locally generated traffic and traffic forwarded by the
  kernel from interfaces not belonging to the ocelot driver

The above means I will not see any offloaded traffic transmitted by the
port. Is that correct? I see that the driver is setting
'offload_fwd_mark' for any traffic trapped from bridged ports, which
means the bridge will drop it before it traverses the packet taps on
egress.

Large parts of the discussion revolve around the fact that switch ports
are not any different than other ports. Dave wrote "Please stop
portraying switches as special in this regard" and Andrew wrote "[The
user] just wants tcpdump to work like on their desktop."

But if anything, this discussion proves that switch ports are special in
this regard and that tcpdump will not work like on the desktop.

Beside the fact that I don't agree (but gave up) with the new
interpretation of promisc mode, I wonder if we're not asking for trouble
with this patchset. Users will see all offloaded traffic on ingress, but
none of it on egress. This is in contrast to the sever/desktop, where
Linux is much more dominant in comparison to switches (let alone hw
accelerated ones) and where all the traffic is visible through tcpdump.
I can already see myself having to explain this over and over again to
confused users.

Now, I understand that showing egress traffic is inherently difficult.
It means one of two things:

1. We allow packets to be forwarded by both the software and the
hardware
2. We trap all ingressing traffic from all the ports

Both options can have devastating effects on the network and therefore
should not be triggered by a supposedly innocent invocation of tcpdump.

I again wonder if it would not be wiser to solve this by introducing two
new flags to tcpdump for ingress/egress (similar to -Q in/out) capturing
of offloaded traffic. The capturing of egress offloaded traffic can be
documented with the appropriate warnings.

Anyway, I don't want to hold you up, I merely want to make sure that the
above (assuming it's correct) is considered before the patches are
applied.

Thanks
