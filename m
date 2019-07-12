Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 704926708E
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 15:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfGLNwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 09:52:45 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:36895 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726724AbfGLNwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 09:52:45 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 26C3F1B97;
        Fri, 12 Jul 2019 09:52:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 12 Jul 2019 09:52:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=kChmcX
        0QC8EQQkMhdJTtjC0XomTgoANLyu7EqLF8+Zk=; b=PELKlWmC841E4i9gIgU/1Z
        qFkpy06SxCdzmxhjsczfncbbzykYDRgJygRosJdc/kqq/DXLHQiNzhG1/lw0LI5Y
        F9frxf5wk2VCjqwOTEl7O4ujfAbD7l4NUR1hDK6PChxirRI3QKzPoRrDALSUIcE4
        kEtYLA5gHhNgEP/LcwiIEWGPWcKPiS2qp/OLXWL3GV3vDY7Xri4COCdQs8mQ3cjh
        pJz+nG0etOgpWpvmtXna0U7G1YzojvpAhVk6MZ7SM45ibIVvJqbDwzkbXH+WVT9f
        8j6g5HnILrIRWdZ9M2y+DsuBG+p0vGGaRRAPHqiwEJqLchxpiOWPZiv0VMdvxkrg
        ==
X-ME-Sender: <xms:p5AoXbx76ujThkNR6tltRKm6FfkfyM5Y8K3BKDfEaGKnF2DpMG161w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrhedtgdeilecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucffohhmrghinh
    epmhgrrhgtrdhinhhfohenucfkphepjeelrddujeekrddvledrgeelnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrh
    fuihiivgeptd
X-ME-Proxy: <xmx:p5AoXcWswxWesiucnhl4CoySo61gf1OI-HJ3oXmSKaKE7VVIQAlH6w>
    <xmx:p5AoXYSkxh_t0cxPmzVK4xX4CHMDuMQni_pgEHRWott0akHj2UO16A>
    <xmx:p5AoXSm0wIOpMrDEZzx9aflkoRBvAnENl8MfxAj0oc6GLsJXMJF4-A>
    <xmx:qpAoXaFuG_p0u8Tyuv24b8l-ujq6lGQPFlDDH0tmEfF9v4w8u1ERPA>
Received: from localhost (bzq-79-178-29-49.red.bezeqint.net [79.178.29.49])
        by mail.messagingengine.com (Postfix) with ESMTPA id DF1F880059;
        Fri, 12 Jul 2019 09:52:38 -0400 (EDT)
Date:   Fri, 12 Jul 2019 16:52:30 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        jiri@mellanox.com, mlxsw@mellanox.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andy@greyhouse.net, pablo@netfilter.org,
        jakub.kicinski@netronome.com, pieter.jansenvanvuuren@netronome.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next 00/11] Add drop monitor for offloaded data paths
Message-ID: <20190712135230.GA13108@splinter>
References: <20190707075828.3315-1-idosch@idosch.org>
 <20190707.124541.451040901050013496.davem@davemloft.net>
 <20190711123909.GA10978@splinter>
 <20190711235354.GA30396@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711235354.GA30396@hmswarspite.think-freely.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 07:53:54PM -0400, Neil Horman wrote:
> A few things here:
> IIRC we don't announce individual hardware drops, drivers record them in
> internal structures, and they are retrieved on demand via ethtool calls, so you
> will either need to include some polling (probably not a very performant idea),
> or some sort of flagging mechanism to indicate that on the next message sent to
> user space you should go retrieve hw stats from a given interface.  I certainly
> wouldn't mind seeing this happen, but its more work than just adding a new
> netlink message.

Neil,

The idea of this series is to pass the dropped packets themselves to
user space along with metadata, such as the drop reason and the ingress
port. In the future more metadata could be added thanks to the
extensible nature of netlink.

In v1 these packets were notified to user space as devlink events
and my plan for v2 is to send them as drop_monitor events, given it's an
existing generic netlink channel used to monitor SW drops. This will
allow users to listen on one netlink channel to diagnose potential
problems in either SW or HW (and hopefully XDP in the future).

Please note that the packets I'm talking about are packets users
currently do not see. They are dropped - potentially silently - by the
underlying device, thereby making it hard to debug whatever issues you
might be experiencing in your network.

The control path that determines if these packets are even sent to the
CPU from the HW needs to remain in devlink for the reasons I outlined in
my previous reply. However, the monitoring of these drops will be over
drop_monitor. This is similar to what we are currently doing with
tc-sample, where the control path that triggers the sampling and
determines the sampling rate and truncation is done over rtnetlink (tc),
but the sampled packets are notified over the generic netlink psample
channel.

To make it more real, you can check the example of the dissected devlink
message that notifies the drop of a packet due to a multicast source
MAC: https://marc.info/?l=linux-netdev&m=156248736710238&w=2

I will obviously have to create another Wireshark dissector for
drop_monitor in order to get the same information.

> Thats an interesting idea, but dropwatch certainly isn't currently setup for
> that kind of messaging.  It may be worth creating a v2 of the netlink protocol
> and really thinking out what you want to communicate.

I don't think we need a v2 of the netlink protocol. My current plan is
to extend the existing protocol with: New message type (e.g.,
NET_DM_CMD_HW_ALERT), new multicast group and a set of attributes to
encode the information that is currently encoded in the example message
I pasted above.

Thanks
