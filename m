Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECFD81E3399
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 01:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403841AbgEZXTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 19:19:17 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:37579 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389998AbgEZXTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 19:19:16 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 326FA5C0078;
        Tue, 26 May 2020 19:19:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 26 May 2020 19:19:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=J80TbBMbLJ83VMcxF2JmlNC+VW320oxM+94XN4Lzj
        wk=; b=qIu9JzjEwNg4ebAepj5O6RCHzDMcT3sJAk17y3zmx4C/UAi3E3bCUz/Sw
        Vm8iUbp7vxv0czuVIcUr4UdzqqxhkHNg662d+lt+lFR08gSVAncT25/+bcsbmnBk
        1aFB/AyBxcDFjIRlm90Hs2YjPZl7IqzqLKoBMPZRD1FKPzyJEt6CbeJ7DUFhNrTS
        V5PBczBdYOXd19nOQvmYTP0yDHIQnvnecbwNZL/Y/VLreuIgok+bM3WcDSrBP221
        6qcw/gXc0M8/4r33fR4BtIdYFc3Z7WEjvIHL45TgDwJdxvh1qqFDSgFy/ElN+n8w
        CxtPm346afpBBJcLj/DqwKf4iCXjQ==
X-ME-Sender: <xms:8qPNXmAa_8Q-DzG3gTtoJqZOj3BRcVmZWtpHIq-UK-5CUy7xgtkSYg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvfedgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggugfgjsehtke
    ertddttdejnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpefgveeghfeugfdvteeuhfdvkeefue
    ffveejtdekfefhhefgtdekgfdvfeffiedttdenucffohhmrghinhepghhithhhuhgsrdgt
    ohhmpdgsohhothhlihhnrdgtohhmpdhkvghrnhgvlhdrohhrghdplhifnhdrnhgvthenuc
    fkphepjeelrddujeeirddvgedruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:86PNXgiXxuoZslhh3DtVnQCvLgNevTK8mZuhHOFEiyIOhKGNORnyKw>
    <xmx:86PNXpnW_4Sic4NW5DEiA5hxO4EZxy9GcCSHU8HSSbYxt5RX-e52sw>
    <xmx:86PNXkxBq0OHdHpxvbybc7ofT0P1R0SgeKgYjsXOaBDA8TiAoZZMTQ>
    <xmx:86PNXiKq9NWECzi1CUjgsNjfgkWw0hryohVTGsYdfGOe3GOtdf3yGg>
Received: from localhost (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 828233280065;
        Tue, 26 May 2020 19:19:14 -0400 (EDT)
Date:   Wed, 27 May 2020 02:19:05 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 00/14] mlxsw: Various trap changes - part 2
Message-ID: <20200526231905.GA1507270@splinter>
References: <20200525230556.1455927-1-idosch@idosch.org>
 <20200526151437.6fc3fb67@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200526151437.6fc3fb67@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 03:14:37PM -0700, Jakub Kicinski wrote:
> On Tue, 26 May 2020 02:05:42 +0300 Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@mellanox.com>
> > 
> > This patch set contains another set of small changes in mlxsw trap
> > configuration. It is the last set before exposing control traps (e.g.,
> > IGMP query, ARP request) via devlink-trap.
> 
> When traps were introduced my understanding was that they are for
> reporting frames which hit an expectation on the datapath. IOW the
> primary use for them was troubleshooting.
> 
> Now, if I'm following things correctly we have explicit DHCP, IGMP,
> ARP, ND, BFD etc. traps. Are we still in the troubleshooting realm?

First of all, we always had them. This patch set mainly performs some
cleanups in mlxsw.

Second, I don't understand how you got the impression that the primary
use of devlink-trap is troubleshooting. I was very clear and transparent
about the scope of the work from the very beginning and I don't wish to
be portrayed as if I wasn't.

The first two paragraphs from the kernel documentation [1] explicitly
mention the ability to trap control packets to the CPU:

"Devices capable of offloading the kernel’s datapath and perform
functions such as bridging and routing must also be able to send
specific packets to the kernel (i.e., the CPU) for processing.

For example, a device acting as a multicast-aware bridge must be able to
send IGMP membership reports to the kernel for processing by the bridge
module. Without processing such packets, the bridge module could never
populate its MDB."

In my reply to you from almost a year ago I outlined the entire plan for
devlink-trap [2]:

"Switch ASICs have dedicated traps for specific packets. Usually, these
packets are control packets (e.g., ARP, BGP) which are required for the
correct functioning of the control plane. You can see this in the SAI
interface, which is an abstraction layer over vendors' SDKs:

https://github.com/opencomputeproject/SAI/blob/master/inc/saihostif.h#L157

We need to be able to configure the hardware policers of these traps and
read their statistics to understand how many packets they dropped. We
currently do not have a way to do any of that and we rely on hardcoded
defaults in the driver which do not fit every use case (from
experience):

https://elixir.bootlin.com/linux/v5.2/source/drivers/net/ethernet/mellanox/mlxsw/spectrum.c#L4103

We plan to extend devlink-trap mechanism to cover all these use cases. I
hope you agree that this functionality belongs in devlink given it is a
device-specific configuration and not a netdev-specific one.

That being said, in its current form, this mechanism is focused on traps
that correlate to packets the device decided to drop as this is very
useful for debugging."

In the last cycle, when I added the ability to configure trap policers
[3] I again mentioned under "Future plans" that I plan to "Add more
packet traps.  For example, for control packets (e.g., IGMP)".

If you worry that packets received via control traps will be somehow
tunneled to user space via drop_monitor, then I can assure you this is
not the case. You can refer to this commit [4] from the next submission.

Thanks

[1] https://www.kernel.org/doc/html/latest/networking/devlink/devlink-trap.html
[2] https://lore.kernel.org/netdev/20190709123844.GA27309@splinter/
[3] https://lwn.net/Articles/815948/
[4] https://github.com/jpirko/linux_mlxsw/commit/4a5f0a8034f0f10301680fe68559e3debacf534d 
