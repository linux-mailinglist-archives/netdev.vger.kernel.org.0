Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 603AFA275F
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 21:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfH2TgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 15:36:20 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:38323 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726245AbfH2TgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 15:36:19 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 47974464A;
        Thu, 29 Aug 2019 15:36:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 29 Aug 2019 15:36:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xmU6E4
        8DKOwP2FQfgqIDSv+MxdVCcx/DD2LgIHy+uZU=; b=r8SRpyJC3NulyXSOTZDWru
        fFsO1biSg/6Bqz4M7in33mualV/qJRSu4d0b0IA/1cHIGMEPWzTlwjIN+XB3XTvY
        766RAzn3/GE7aF2GPpJJM6jKmmYmCbUFt8dMiWh/Z38Mr5+bE1OoRPtzVS9AULvf
        h4NO+pm4pZIpEQM6HAXekoNpIEIqhCuG22YUgwb1Ed8Zk+LoQ6ctPD5wslFyaS1j
        6kx23Onke4S8I5WMO8qk65XcuJxkNH4+vVedX9hjtnIBXrrXsWdjxDTFrudkYxmG
        MCQJj0P5Mdi7iNRrHJnTlgKUaq8S7RjDWYTIgEHoL7DkR5qRJ/UtM9OkB9Wfa/cg
        ==
X-ME-Sender: <xms:MSloXYqh8vp4Ocu_SmOG0R9fVmecAtIo2TU24Y_KuWFCW448CNojiw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeivddgudefiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepud
    dtledrieejrdeiuddrvddvgeenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:MSloXQQjuLFW5cPit1MzG-brtynqptFNUXF5PItq8eHbpBvkZJjKaQ>
    <xmx:MSloXb4qfn6cQOddI1Qz9QhIWpxPy7qxUUyQXExIgeHPCtylc5Ly-Q>
    <xmx:MSloXYY-Phlg6N7p5oGBUI_EBwNI1jvnucDJ21KGxKnk-cA9z-9rIw>
    <xmx:MiloXRwYa6ib7vtOiNskj43meL8X3voepza9RyrAOTcpTMmWLbui4Q>
Received: from localhost (bzq-109-67-61-224.red.bezeqint.net [109.67.61.224])
        by mail.messagingengine.com (Postfix) with ESMTPA id 71B328005B;
        Thu, 29 Aug 2019 15:36:16 -0400 (EDT)
Date:   Thu, 29 Aug 2019 22:36:13 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, allan.nielsen@microchip.com,
        ivecera@redhat.com, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to dev->promiscuity.
Message-ID: <20190829193613.GA23259@splinter>
References: <1567070549-29255-1-git-send-email-horatiu.vultur@microchip.com>
 <1567070549-29255-2-git-send-email-horatiu.vultur@microchip.com>
 <20190829095100.GH2312@nanopsycho>
 <20190829132611.GC6998@lunn.ch>
 <20190829134901.GJ2312@nanopsycho>
 <20190829143732.GB17864@lunn.ch>
 <20190829175759.GA19471@splinter>
 <20190829182957.GA17530@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829182957.GA17530@lunn.ch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 29, 2019 at 08:29:57PM +0200, Andrew Lunn wrote:
> > Hi Andrew,
> > 
> > What happens when you run tcpdump on a routed interface without putting
> > it in promiscuous mode ('-p')? If it is a pure software switch, then you
> > see all unicast packets addressed to your interface's MAC address. What
> > happens when the same is done on a hardware switch? With the proposed
> > solution you will not get the same result.
> > 
> > On a software switch, when you run tcpdump without '-p', do you incur
> > major packet loss? No. Will this happen when you punt several Tbps to
> > your CPU on the hardware switch? Yes.
> 
> Hi Ido
> 
> Please think about the general case, not your hardware. A DSA switch
> generally has 1G ports. And the connection to the host is generally
> 1G, maybe 2.5G. So if i put one interface into promisc mode, i will
> probably receive the majority of the traffic on that port, so long as
> there is not too much traffic from other ports towards the CPU.
> 
> I also don't expect any major packet loss in the switch. It is still
> hardware switching, but also sending a copy to the CPU. That copy will
> have the offload_fwd_mark bit set, so the bridge will discard the
> frame. The switch egress queue towards the CPU might overflow, but
> that means tcpdump does not get to see all the frames, and some
> traffic which is actually heading to the CPU is lost. But that can
> happen anyway.

The potential packet loss was only one example why using promiscuous
mode as an indication to punt all traffic to the CPU is wrong. I also
mentioned that you will not capture any traffic (besides
control/exception) when '-p' is specified.

> We should also think about the different classes of users. Somebody
> using a TOR switch with a NOS is very different to a user of a SOHO
> switch in their WiFi access point. The first probably knows tc very
> well, the second has probably never heard of it, and just wants
> tcpdump to work like on their desktop.

I fully agree that we should make it easy for users to capture offloaded
traffic, which is why I suggested patching libpcap. Add a flag to
capable netdevs that tells libpcap that in order to capture all the
traffic from this interface it needs to add a tc filter with a trap
action. That way zero familiarity with tc is required from users.

I really believe that instead of interpreting IFF_PROMISC in exotic ways
and pushing all this logic into the kernel, we should instead teach user
space utilities to capture offloaded traffic.
