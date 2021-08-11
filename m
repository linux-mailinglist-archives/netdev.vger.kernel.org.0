Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71D83E8F7C
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 13:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237334AbhHKLdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 07:33:36 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33769 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237279AbhHKLdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 07:33:36 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 5AE8E5C0110;
        Wed, 11 Aug 2021 07:33:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 11 Aug 2021 07:33:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ozgImg
        yU0rlvuqOdnXitCz5fP8pOuEYfkJSfl9hkmuA=; b=aTRCn3CJhUcnIQY7KEX9lC
        1q1prm5u59n/7MdD0qRe1FML9uT3boTZMnwWxcuozwiwmPZcIGPIRliR1FyWlELb
        uT4P4MvDIg8ktQ0v7mLrLjjFfdlDAQJapmY8GjO/9BHwOpWagJgHiXWre+SWVPWw
        f7BJcUjYqurPLUh+mAbHtw1UNacJp3JFn7nQpXKZ4u/mrb9nccd44CRngl4rialO
        Dpk/Gn+7pj9WZvIRmsmk38Jzh9gWjMh7aU05iCKwoW13ob58Eo8pi4YauiqmJeo5
        OrSb0nDV9ANuYIPRAqNRzmVWfu7SSP5Nw3ezCJJYw8g5GUsVqeAgEULnE3PJORhw
        ==
X-ME-Sender: <xms:drUTYUWLLhlnuNrTvExQwB8msnwPVzcQHAlAsjbGA_7fkQYHeIXpVA>
    <xme:drUTYYlmgwvFbJBP1SBS22hiqzkAdgJ-mcB_d_0CqFCPprNZxV20CUzcN7reaLsoa
    UcVXYGOifnr_Qg>
X-ME-Received: <xmr:drUTYYYWvkCEbmgNAgAShnezMb52ut8hYkKaHYOpobu1wbJUWVJm3lFOJNY6YI8FB7dke_qB-eZjh7WSCX1Ai42jh3YKuw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrkedugdegtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepjeehudefleekfeevkeeiieeifeefteejieegudevieekvdetieelkefghffgledv
    necuffhomhgrihhnpehmvghllhgrnhhogidrtghomhenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:drUTYTVnl5XIx95Uupoozt9Kl2h1cN1gAGRec1lF5u6NdZS3TCV-YA>
    <xmx:drUTYelTUA8NOoJ1bc1iojxEHyD7BfunItHS5J7lFy7M3GhtEP9mSA>
    <xmx:drUTYYesSZpd5jChFAw7ZTxgvXrm22Sbor0EqT4u8A8Jz1szoll6vA>
    <xmx:eLUTYQWlp7tZ67tUWPp-oFLCMTs0935Hi196XxVdB-XCybzc4TzT1Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Aug 2021 07:33:09 -0400 (EDT)
Date:   Wed, 11 Aug 2021 14:33:06 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz,
        pali@kernel.org, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 1/8] ethtool: Add ability to control
 transceiver modules' low power mode
Message-ID: <YRO1ck4HYWTH+74S@shredder>
References: <20210809102152.719961-1-idosch@idosch.org>
 <20210809102152.719961-2-idosch@idosch.org>
 <YRE7kNndxlGQr+Hw@lunn.ch>
 <YRIqOZrrjS0HOppg@shredder>
 <YRKElHYChti9EeHo@lunn.ch>
 <20210810065954.68036568@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRLlpCutXmthqtOg@shredder>
 <20210810150544.3fec5086@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810150544.3fec5086@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 03:05:44PM -0700, Jakub Kicinski wrote:
> On Tue, 10 Aug 2021 23:46:28 +0300 Ido Schimmel wrote:
> > On Tue, Aug 10, 2021 at 06:59:54AM -0700, Jakub Kicinski wrote:
> > > On Tue, 10 Aug 2021 15:52:20 +0200 Andrew Lunn wrote:  
> > > > O.K. Thanks for the better explanation. Some of this should go into
> > > > the commit message.
> > > > 
> > > > I suggest it gets a different name and semantics, to avoid
> > > > confusion. I think we should consider this the default power mode for
> > > > when the link is administratively down, rather than direct control
> > > > over the modules power mode. The driver should transition the module
> > > > to this setting on link down, be it high power or low power. That
> > > > saves a lot of complexity, since i assume you currently need a udev
> > > > script or something which sets it to low power mode on link down,
> > > > where as you can avoid this be configuring the default and let the
> > > > driver do it.  
> > > 
> > > Good point. And actually NICs have similar knobs, exposed via ethtool
> > > priv flags today. Intel NICs for example. Maybe we should create a
> > > "really power the port down policy" API?  
> > 
> > See below about Intel. I'm not sure it's the same thing...
> > 
> > I'm against adding a vague "really power the port down policy" API. The
> > API proposed in the patch is well-defined, its implementation is
> > documented in standards, its implications are clear and we offer APIs
> > that give user space full observability into its operation.
> > 
> > A vague API means that it is going to be abused and user space will get
> > different results over different implementations. After reading the
> > *commit messages* about the private flags, I'm not sure what the flags
> > really do, what is their true motivation, implications or how do I get
> > observability into their operation. I'm not too hopeful about the user
> > documentation.
> > 
> > Also, like I mentioned in the cover letter, given the complexity of
> > these modules and as they become more common, it is likely that we will
> > need to extend the API to control more parameters and expose more
> > diagnostic information. I would really like to keep it clean and
> > contained in 'ETHTOOL_MSG_MODULE_*' messages and not spread it over
> > different APIs.
> 
> The patch is well defined but it doesn't provide user with the answer
> to the question "why is the SFP still up if I asked it to be down?"

But you didn't ask the module to be "down", you asked the MAC. See more
below.

> It's good to match specs closely but Linux may need to reconcile
> multiple policies.
> 
> IIUC if Intel decides to keep the SFP up for "other" reasons the
> situation will look like this:

Intel did not decide to keep the module "up", it decided to keep both
the MAC and the module up. If one of them was down, the peer would
notice it, but it didn't (according to Jake's reply). This is a very
problematic behavior as you are telling your peer that everything is
fine, but in practice you are dropping all of its packets. I hit the
exact same issue with mlx5 a few years ago and when I investigated the
reason for this behavior I was referred to multi-host systems where you
don't want one host to take down the shared link for all the rest. See:

https://www.mellanox.com/sites/default/files/doc-2020/sb-externally-connected-multi-host.pdf

> 
>  $ ethtool --show-module eth0
>  Module parameters for eth0:
>  low-power true
> 
>  # ethtool -m eth0
>  Module State                              : 0x03 (ModuleReady)
>  LowPwrAllowRequestHW                      : Off
>  LowPwrRequestSW                           : Off

This output is wrong. In Intel's case "ip link show" will report the
link as down (according to Jake's reply) despite the MAC being up. On
the other hand, the output of "ethtool --show-module eth0" will show
that the module is not in low power mode and it will be correct.

> 
> 
> IOW the low-power mode is a way for user to express preference to
> shut down/keep up the SFP,

Yes, it controls the module, not the MAC. If you want to get a carrier,
both the module and the MAC need to be operational. See following
example where swp13 and swp14 are connected to each other:

$ ip link show dev swp13
127: swp13: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 1c:34:da:18:55:49 brd ff:ff:ff:ff:ff:ff

$ ip link show dev swp14
128: swp14: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 1c:34:da:18:55:4d brd ff:ff:ff:ff:ff:ff

# ip link set dev swp13 down

# ethtool --set-module swp13 low-power on

$ ethtool --show-module swp13
Module parameters for swp13:
low-power true

# ip link set dev swp13 up

$ ip link show dev swp13
127: swp13: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state DOWN mode DEFAULT group default qlen 1000
    link/ether 1c:34:da:18:55:49 brd ff:ff:ff:ff:ff:ff

$ ip link show dev swp14
128: swp14: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state DOWN mode DEFAULT group default qlen 1000
    link/ether 1c:34:da:18:55:4d brd ff:ff:ff:ff:ff:ff

# ip link set dev swp13 down

# ethtool --set-module swp13 low-power off

$ ethtool --show-module swp13
Module parameters for swp13:
low-power false

# ip link set dev swp13 up

$ ip link show dev swp13
127: swp13: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 1c:34:da:18:55:49 brd ff:ff:ff:ff:ff:ff

$ ip link show dev swp14
128: swp14: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 1c:34:da:18:55:4d brd ff:ff:ff:ff:ff:ff

> but it's not necessarily going to be the only "policy" that matters.
> If other policies (e.g. NC-SI) express preference to keep the
> interface up it will stay up, right?
> 
> The LowPwrRequestSW is not directly controlled by low-power && IF_UP.
> 
> What I had in mind was something along the lines of a bitmap of reasons
> which are allowed to keep the interface up, and for your use case
> the reason would be something like SFP_ALWAYS_ON, but other reasons
> (well defined) may also keep the ifc up.
> 
> That's just to explain what I meant, if it's going to be clear to
> everyone that low-power != LowPwrRequestSW I'm fine either way.

I think we mixed two different use cases here. The first is a way to
make sure the link is fully operational (both MAC and module). In this
case, contrary to the expected behavior, "ip link set dev eth0 down"
will not take the MAC down and the peer will not lose its carrier. This
is most likely motivated by special hardware designs or exotic use cases
like I mentioned above.

The use case for this patch is completely different. Today, when you do
"ip link set dev eth0 up" you expect to gain a carrier which means that
both the MAC and the module are operational. The latter can be made
operational following the user request (e.g., SFP driver) or as soon as
it was plugged-in, by the device's firmware.

When you do "ip link set dev eth0 down" you expect the reverse to happen
and this is what happens today. In implementations where the module is
always operational, it stays in high power mode and continues to get
warm and consume unnecessary amount of power.

Some users might not be OK with that and would like more control, which
is exactly what this patch is doing. This patch does not change existing
behavior, the API has clear semantics and implications and user space
has full observability into its operation.

If in the future someone sees the need to add 'protoup', it can be done:

# ip link set dev eth0 up  # MAC and module are operational
# ip link set dev eth0 protoup on
# ip link set dev eth0 down # returns an error / ignore
# ethtool --set-module eth0 low-power on # returns an error because of admin up

You can obviously engineer situations that do not make any sense. Like
this:

# ethtool --set-module eth0 low-power on
# ip link set dev eth0 up
# ip link set dev eth0 protoup on

The MAC is operational and you can't take it down, but you will never
get a carrier because you explicitly asked the module to stay in low
power mode.
