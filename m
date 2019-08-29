Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73205A22E4
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 19:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbfH2R6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 13:58:09 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:35993 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727525AbfH2R6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 13:58:09 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 1B81C2BAE;
        Thu, 29 Aug 2019 13:58:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 29 Aug 2019 13:58:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=kDDkxG
        owHlH6KIqyJNRgu3bEQq+Z/NDS52i1KXVzXBI=; b=hdc6S/a+ShbnTuDAB/k1ra
        np1rNCfDPdje0nUXlJhUfue82KH/j54Aeu5/cE/aX6PyEwJ75V+2X8bAEiK9N3/p
        YYTq1LQ3d9be3zS6JKebudyVWLw51GJ11G8MOaWGyFddkQwsPpRpVfNoFxFHbg5v
        cEIA+Nfj0A729Ul4qxKSOGKMkDg4bvkpyySZhL3Txx36MG1x3rl8KrbDn6G2UB2m
        KP0CHX98Ly1P+Acsx7WVsAyC3ZDuW4xiWDVCRqk0fkbbc7vrUyUzJ3zqoUuv8TPl
        ihNLcMqDEbt/BiTZ0Rwz0BexFW0zE1nrdHi+PX+56gLGCp3Apk5eGvrpcD1Pchrg
        ==
X-ME-Sender: <xms:LxJoXYnQYsoVMd1_7s6t-tsIrJyyYbGFzgb0nV8OVOImMiORp4KiqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeivddgudduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepud
    dtledrieejrdeiuddrvddvgeenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:LxJoXSF-9bmPJoSa21HBtmR3y4smJX5g0Em74rIZ_3h5zob97UG08w>
    <xmx:LxJoXYYoRo4phBgt0TLhBENIrCjyBkgiwgB06SawDBtrA_5_P6cfpA>
    <xmx:LxJoXZLq9RZnU4hfqqjjCsQ3cZlcryzdi-iV0aClkeGG-B7n_cLvUA>
    <xmx:MBJoXf2DaHVDULsj32i03t-x9JsBvc6Li9vjHq6HQXRW-5A-BkWA-w>
Received: from localhost (bzq-109-67-61-224.red.bezeqint.net [109.67.61.224])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8A83E80065;
        Thu, 29 Aug 2019 13:58:06 -0400 (EDT)
Date:   Thu, 29 Aug 2019 20:57:59 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, allan.nielsen@microchip.com,
        ivecera@redhat.com, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to dev->promiscuity.
Message-ID: <20190829175759.GA19471@splinter>
References: <1567070549-29255-1-git-send-email-horatiu.vultur@microchip.com>
 <1567070549-29255-2-git-send-email-horatiu.vultur@microchip.com>
 <20190829095100.GH2312@nanopsycho>
 <20190829132611.GC6998@lunn.ch>
 <20190829134901.GJ2312@nanopsycho>
 <20190829143732.GB17864@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829143732.GB17864@lunn.ch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 29, 2019 at 04:37:32PM +0200, Andrew Lunn wrote:
> > Wait, I believe there has been some misundestanding. Promisc mode is NOT
> > about getting packets to the cpu. It's about setting hw filters in a way
> > that no rx packet is dropped.
> > 
> > If you want to get packets from the hw forwarding dataplane to cpu, you
> > should not use promisc mode for that. That would be incorrect.
> 
> Hi Jiri
> 
> I'm not sure a wireshark/tcpdump/pcap user would agree with you. They
> want to see packets on an interface, so they use these tools. The fact
> that the interface is a switch interface should not matter. The
> switchdev model is that we try to hide away the interface happens to
> be on a switch, you can just use it as normal. So why should promisc
> mode not work as normal?

Hi Andrew,

What happens when you run tcpdump on a routed interface without putting
it in promiscuous mode ('-p')? If it is a pure software switch, then you
see all unicast packets addressed to your interface's MAC address. What
happens when the same is done on a hardware switch? With the proposed
solution you will not get the same result.

On a software switch, when you run tcpdump without '-p', do you incur
major packet loss? No. Will this happen when you punt several Tbps to
your CPU on the hardware switch? Yes.

Extending the definition of promiscuous mode to mean punt all traffic to
the CPU is wrong, IMO. You will not be able to capture all the packets
anyway. If you have both elephant and mice flows, then it is very likely
you will not be able to see any packets from the mice flows. The way
this kind of monitoring is usually done is by either sampling packets
(see tc-sample) or mirroring it to capable server. Both options are
available in Linux today.

> > If you want to get packets from the hw forwarding dataplane to cpu, you
> > should use tc trap action. It is there exactly for this purpose.
> 
> Do you really think a wireshark/tcpdump/pcap user should need to use
> tc trap for the special case the interface is a switch port? Doesn't that
> break the switchdev model?

I do not object to the overall goal, but I believe to implementation is
wrong. Instead, it would be much better to extend tshark/tcpdump and
with another flag that will instruct libpcap to install a rule that will
trap all traffic to the CPU. You can do that on either ingress or egress
using matchall and trap action.

If you want to do it without specifying a special flag (I think it's
very dangerous due to the potential packet loss), you can add a flag to
the interface that will indicate to libpcap that installing a tc filter
with trap action is required.

> tc trap is more about fine grained selection of packets.

Depends on the filter you associate with the action. If it's matchall,
then it's not fine grained at all :)

> Also, it seems like trapped packets are not forwarded, which is not
> what you would expect from wireshark/tcpdump/pcap.

How do you mean? Not forwarded by the HW? Right. But the trapped packets
are forwarded by the kernel. We can also add another action that means
both trap and forward. In mlxsw terminology it's called mirror.
