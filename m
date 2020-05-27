Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220D01E3ABE
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 09:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbgE0HjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 03:39:04 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33275 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729052AbgE0HjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 03:39:04 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 997685C015B;
        Wed, 27 May 2020 03:39:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 27 May 2020 03:39:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=f5aJS9QDbAD/hyEHrks1T9hZMof+S7ywS5O69RY4a
        lk=; b=PFek1m0zs+VxsPfMKxUAKYsG/kxkgMZ8NA1H/BxuPeY7LmUZgSKk0xFzz
        HcrYbCrXBien7PFyGikJ1twStn9/xznEZTJgeh5r8mo+9dd4UvGRTQaanZVNwCCl
        gX+g7UY7LcO2o5qAbCF3IqWGweN9mMCGqScrfUkn9taTXIaycJflZLy2woK4ZawE
        nNdAeBDjm+UNDXR95OpuJHKjPD64oJA0sQpj50Xq0chTYedh7LtTqRlL7bcTQobO
        5voo3ALeaxzP12+sw3FZCrhT80/lgOp/1hYct2K9rYGa/9Rid1WPWfMcGbhyXSFI
        GXNwpbeEvXsIDW6W3S7wWbatkd8QA==
X-ME-Sender: <xms:FhnOXtl5G9zvlQvlqmU0wUUqcPFuQFfh8luv9MJ04JgC0DvH4DSqAQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvfedgudduiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtugfgjgesth
    ekredttddtjeenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehi
    ughoshgthhdrohhrgheqnecuggftrfgrthhtvghrnheptefgvdefudehteegudeuhfetvd
    duheetgfefgffhkeetleeiueefueehfeekffevnecuffhomhgrihhnpehgihhthhhusgdr
    tghomhdpsghoohhtlhhinhdrtghomhenucfkphepuddtledrieehrddufeelrddukedtne
    cuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhs
    tghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:FhnOXo3zLTGhwSpEH513aA86ypeTOPwi4GGyyHHhABwjnkRUbgoFkQ>
    <xmx:FhnOXjq5vfxs9r0ZPuBeT6Um08JIOhll-Z_QrGRD2l5MTHSJ0np9rQ>
    <xmx:FhnOXtlljWPN1RiZUNc0NUMfQJ1l0FKAHM6_i39BQTbcBQZj_fEXwg>
    <xmx:FhnOXk_zL0InA13GaX0Fl4qRGTccDi8MRv1Cm-3a9uq8wRrHRz3clA>
Received: from localhost (bzq-109-65-139-180.red.bezeqint.net [109.65.139.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id 952BB3061CB6;
        Wed, 27 May 2020 03:39:01 -0400 (EDT)
Date:   Wed, 27 May 2020 10:38:57 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 00/14] mlxsw: Various trap changes - part 2
Message-ID: <20200527073857.GA1511819@splinter>
References: <20200525230556.1455927-1-idosch@idosch.org>
 <20200526151437.6fc3fb67@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20200526231905.GA1507270@splinter>
 <20200526164323.565c8309@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200526164323.565c8309@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 04:43:23PM -0700, Jakub Kicinski wrote:
> On Wed, 27 May 2020 02:19:05 +0300 Ido Schimmel wrote:
> > On Tue, May 26, 2020 at 03:14:37PM -0700, Jakub Kicinski wrote:
> > > On Tue, 26 May 2020 02:05:42 +0300 Ido Schimmel wrote:  
> > > > From: Ido Schimmel <idosch@mellanox.com>
> > > > 
> > > > This patch set contains another set of small changes in mlxsw trap
> > > > configuration. It is the last set before exposing control traps (e.g.,
> > > > IGMP query, ARP request) via devlink-trap.  
> > > 
> > > When traps were introduced my understanding was that they are for
> > > reporting frames which hit an expectation on the datapath. IOW the
> > > primary use for them was troubleshooting.
> > > 
> > > Now, if I'm following things correctly we have explicit DHCP, IGMP,
> > > ARP, ND, BFD etc. traps. Are we still in the troubleshooting realm?  
> > 
> > First of all, we always had them. This patch set mainly performs some
> > cleanups in mlxsw.
> > 
> > Second, I don't understand how you got the impression that the primary
> > use of devlink-trap is troubleshooting. I was very clear and transparent
> > about the scope of the work from the very beginning and I don't wish to
> > be portrayed as if I wasn't.
> > 
> > The first two paragraphs from the kernel documentation [1] explicitly
> > mention the ability to trap control packets to the CPU:
> > 
> > "Devices capable of offloading the kernel’s datapath and perform
> > functions such as bridging and routing must also be able to send
> > specific packets to the kernel (i.e., the CPU) for processing.
> > 
> > For example, a device acting as a multicast-aware bridge must be able to
> > send IGMP membership reports to the kernel for processing by the bridge
> > module. Without processing such packets, the bridge module could never
> > populate its MDB."
> > 
> > In my reply to you from almost a year ago I outlined the entire plan for
> > devlink-trap [2]:
> > 
> > "Switch ASICs have dedicated traps for specific packets. Usually, these
> > packets are control packets (e.g., ARP, BGP) which are required for the
> > correct functioning of the control plane. You can see this in the SAI
> > interface, which is an abstraction layer over vendors' SDKs:
> > 
> > https://github.com/opencomputeproject/SAI/blob/master/inc/saihostif.h#L157
> > 
> > We need to be able to configure the hardware policers of these traps and
> > read their statistics to understand how many packets they dropped. We
> > currently do not have a way to do any of that and we rely on hardcoded
> > defaults in the driver which do not fit every use case (from
> > experience):
> > 
> > https://elixir.bootlin.com/linux/v5.2/source/drivers/net/ethernet/mellanox/mlxsw/spectrum.c#L4103
> > 
> > We plan to extend devlink-trap mechanism to cover all these use cases. I
> > hope you agree that this functionality belongs in devlink given it is a
> > device-specific configuration and not a netdev-specific one.
> > 
> > That being said, in its current form, this mechanism is focused on traps
> > that correlate to packets the device decided to drop as this is very
> > useful for debugging."
> > 
> > In the last cycle, when I added the ability to configure trap policers
> > [3] I again mentioned under "Future plans" that I plan to "Add more
> > packet traps.  For example, for control packets (e.g., IGMP)".
> > 
> > If you worry that packets received via control traps will be somehow
> > tunneled to user space via drop_monitor, then I can assure you this is
> > not the case. You can refer to this commit [4] from the next submission.
> 
> Perhaps the troubleshooting is how I justified the necessity of having
> devlink traps to myself. It's much harder to get visibility into what
> HW is doing and therefore we need this special interface.
> 
> But we should be able to configure a DHCP daemon without any special
> sauce. What purpose does the DHCP trap serve?
> 
> What's the packet flow for BFD? How does the HW case differ from a SW
> router?

There is no special sauce required to get a DHCP daemon working nor BFD.
It is supposed to Just Work. Same for IGMP / MLD snooping, STP etc. This
is enabled by the ASIC trapping the required packets to the CPU.

However, having a 3.2/6.4/12.8 Tbps ASIC (it keeps growing all the time)
send traffic to the CPU can very easily result in denial of service. You
need to have hardware policers and classification to different traffic
classes ensuring the system remains functional regardless of the havoc
happening in the offloaded data path.

This control plane policy has been hard coded in mlxsw for a few years
now (based on sane defaults), but it obviously does not fit everyone's
needs. Different users have different use cases and different CPUs
connected to the ASIC. Some have Celeron / Atom while others have more
high-end Xeon CPUs, which are obviously capable of handling more packets
per second. You also have zero visibility into how many packets were
dropped by these hardware policers.

By exposing these traps we allow users to tune these policers and get
visibility into how many packets they dropped. In the future also
changing their traffic class, so that (for example), packets hitting
local routes are scheduled towards the CPU before packets dropped due to
ingress VLAN filter.

If you don't have any special needs you are probably OK with the
defaults, in which case you don't need to do anything (no special
sauce).
