Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD86A4642
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 22:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbfHaUrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 16:47:18 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:41903 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728534AbfHaUrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 16:47:18 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id BFAA51FD4;
        Sat, 31 Aug 2019 16:47:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 31 Aug 2019 16:47:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+frLwa
        9As/r3CWMEqGvhe3Btzq5dsH8oIjUQ64CaE+0=; b=i91qLrrysYTub8GLpdBSIK
        yM1d7+n425L4qomN3cysHKHjbWvOEvdY6QZ5KFklDCwKCA+S2glM0WP7FQaZyEw4
        1GEtDzT/qWdAhm1obh+xzJIkvSyKnnz3siVCNdB3gfY2/9jd0lmRMjTTLYAaaBgu
        azaYRfKfRE604t3bJkeElrFQ/rHnTep2XilAKvT6w1409ys1gDYGDGsAst7P+uce
        dBRgL1w2FI4Wp4vG0tiYx5E3btZ0dlFkv/smbRYY9SpB8SCE7PV4FX0tkAVLjuh2
        s3MbTZKkW3AZpn/k1q12kMr4FXI/watD2i5k2onmj0LRJjuhlX+kKHTmwbESfvAA
        ==
X-ME-Sender: <xms:0txqXfr9YZxVppTgEUM2ndWTKesZcHSSVbglD87gJEEl6LmBx08BEg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeiiedguddvjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepje
    ejrddufeekrddvgeelrddvtdelnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgt
    hhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:0txqXSfNGQ3CJIP359BUsh1AgzGxmazTmuzl3jzGNcY10Wx8hnXTnw>
    <xmx:0txqXdgUE1IfFhihWSrcx6RM35825lvji4IWxoXSP3XAHTSdWvN_FQ>
    <xmx:0txqXYL0KDmtPY_iHWxBgTvqjOPSHWo58RuTwDfXXM-vrgXscZoK1g>
    <xmx:1NxqXaPK9pxVQVPIDfEsIjnTGTcU4hTO0J7I4BPFxnAKQD6xh3WEpQ>
Received: from localhost (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id 34415D60057;
        Sat, 31 Aug 2019 16:47:14 -0400 (EDT)
Date:   Sat, 31 Aug 2019 23:47:05 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>, jiri@resnulli.us,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, allan.nielsen@microchip.com,
        ivecera@redhat.com, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to dev->promiscuity.
Message-ID: <20190831204705.GA28380@splinter>
References: <20190829175759.GA19471@splinter>
 <20190829182957.GA17530@lunn.ch>
 <20190829193613.GA23259@splinter>
 <20190829.151201.940681219080864052.davem@davemloft.net>
 <20190830094319.GA31789@splinter>
 <20190831193556.GB2647@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190831193556.GB2647@lunn.ch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 31, 2019 at 09:35:56PM +0200, Andrew Lunn wrote:
> > Also, what happens when I'm running these application without putting
> > the interface in promisc mode? On an offloaded interface I would not be
> > able to even capture packets addressed to my interface's MAC address.
> 
> Sorry for rejoining the discussion late. I've been travelling and i'm
> now 3/4 of the way to Lisbon.

Hi Andrew,

Have fun!

> That statement i don't get. 

What about the other statements?

> If the frame has the MAC address of the interface, it has to be
> delivered to the CPU. 

So every packet that needs to be routed should be delivered to the CPU?
Definitely not.

> And so pcap will see it when running on the interface. I can pretty
> much guarantee every DSA driver does that.

I assume because you currently only consider L2 forwarding.

> But to address the bigger picture. My understanding is that we want to
> model offloading as a mechanism to accelerate what Linux can already
> do. The user should not have to care about these accelerators. The
> interface should work like a normal Linux interface. I can put an IP
> address on it and ping a peer. I can run a dhcp client and get an IP
> address from a dhcp server. I can add the interface to a bridge, and
> packets will get bridged. I as a user should not need to care if this
> is done in software, or accelerated by offloading it. I can add a
> route, and if the accelerate knows about L3, it can accelerate that as
> well. If not, the kernel will route it.

Yep, and this is how it's all working today.

> So if i run wireshark on an interface, i expect the interface will be
> put into promisc mode and i see all packets ingressing the interface.
> What the accelerator needs to do to achieve this, i as a user don't
> care.
> 
> I can follow the argument that i won't necessarily see every
> packet. But that is always true. For many embedded systems, the CPU is
> too slow to receive at line rate, even when we are talking about 1G
> links. Packets do get dropped. And i hope tcpdump users understand
> that.
> 
> For me, having tcpdump use tc trap is just wrong. It breaks the model
> that the user should not care about the accelerator. If anything, i
> think the driver needs to translate cBPF which pcap passes to the
> kernel to whatever internal format the accelerator can process. That
> is just another example of using hardware acceleration.

Look, this again boils down to what promisc mode means with regards to
hardware offload. You want it to mean punt all traffic to the CPU? Fine.
Does not seem like anyone will be switching sides anyway, so lets move
forward. But the current approach is not good. Each driver needs to have
this special case logic and the semantics of promisc mode change not
only with regards to the value of the promisc counter, but also with
regards to the interface's uppers. This is highly fragile and confusing.

The approach taken in v2 makes much more sense. Add a new flag to
accelerators and have the networking stack check it before putting the
interface in promisc mode. Then the only thing drivers need to do is to
instruct the accelerator to trap all traffic to the CPU.
