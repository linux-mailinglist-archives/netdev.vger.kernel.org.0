Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C363E5AAA
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241100AbhHJNFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:05:38 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46971 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240830AbhHJNFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 09:05:36 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A602C5C01A4;
        Tue, 10 Aug 2021 09:05:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 10 Aug 2021 09:05:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=rCPqKr
        fnYquYrxMqcFVHE+TjzW9BdXot3tDNviGkHYs=; b=DhCkrLuaO+R5eV/kgRYGGX
        2jsA5nR0PJubTnUEg3uvMBxm7Gp0OcBLsRJXSbIf39nXJUhn0EBQUvQ04zcbpHA8
        SEFMyxqqkbsRB480Zr6z7qgxgEWFGhSj2amxpMrN7G0vIB5beeqvsbE8A62Aizl3
        OGQFsb3YQIn4U8/sbOOJOeZ6AJTQmj1ZaiTk9F0w4oeQioeKvNLCWdP0lJ3jJLl9
        Lf4q8FuKvne28zb3WGwdFFaQtUY+OH+7O7pMSt4WytwzNibZCGGLY66WmFJ+bfNR
        qvSlSs0OsmvrTKEMie1uOS/zUFWvUgWfjscpb4uuoT+dZ4GKe5PG7FC583IHoCrA
        ==
X-ME-Sender: <xms:iHkSYZS-OidK-YJtX2S3vYH-LXsHFo1Rryutsh9-mZuquJ-2PI0nUw>
    <xme:iHkSYSw5osv5xNo8MeI9WVaX64LE-rQWrJ9QQ8ec_-VK-GXgxaURRM6zCggdWUZiv
    HfE6C7f0drDv-w>
X-ME-Received: <xmr:iHkSYe03YEeEEOYn_0EJFDrzYeOtjXV62OC_ZPNBCgDWRKJUxQc4Oxi9LZHOzkvjSKDcFU-bLm13HWGvzPp4ZpBIEF6PUA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeelgdeiudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:iHkSYRAqli-IOGYq_PXPdBC-X0VfBU2rg44h1LCgu1o4GaR0mA7l2Q>
    <xmx:iHkSYSgNvg-L1_17qRpU21rDi0sId3p9v-jeoI7z4Gf5dYi9RriM4A>
    <xmx:iHkSYVomhMV2RNK47Yjd7oQ3PSB1vlRlLQcf6N8NVgAYeBKmo6ZjCg>
    <xmx:iXkSYdXw5PFRgDX1LDm1k6tnT9Q6YmusYKA_s2owwHNkQ_vduLNnvA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Aug 2021 09:05:12 -0400 (EDT)
Date:   Tue, 10 Aug 2021 16:05:07 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mkubecek@suse.cz, pali@kernel.org, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 2/8] ethtool: Add ability to reset
 transceiver modules
Message-ID: <YRJ5g/W11V0mjKHs@shredder>
References: <20210809102152.719961-1-idosch@idosch.org>
 <20210809102152.719961-3-idosch@idosch.org>
 <YRF+a6C/wHa7+2Gs@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRF+a6C/wHa7+2Gs@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 09:13:47PM +0200, Andrew Lunn wrote:
> On Mon, Aug 09, 2021 at 01:21:46PM +0300, Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > Add a new ethtool message, 'ETHTOOL_MSG_MODULE_RESET_ACT', which allows
> > user space to request a reset of transceiver modules. A successful reset
> > results in a notification being emitted to user space in the form of a
> > 'ETHTOOL_MSG_MODULE_RESET_NTF' message.
> > 
> > Reset can be performed by either asserting the relevant hardware signal
> > ("Reset" in CMIS / "ResetL" in SFF-8636) or by writing to the relevant
> > reset bit in the module's EEPROM (page 00h, byte 26, bit 3 in CMIS /
> > page 00h, byte 93, bit 7 in SFF-8636).
> > 
> > Reset is useful in order to allow a module to transition out of a fault
> > state. From section 6.3.2.12 in CMIS 5.0: "Except for a power cycle, the
> > only exit path from the ModuleFault state is to perform a module reset
> > by taking an action that causes the ResetS transition signal to become
> > TRUE (see Table 6-11)".
> > 
> > To avoid changes to the operational state of the device, reset can only
> > be performed when the device is administratively down.
> > 
> > Example usage:
> > 
> >  # ethtool --reset-module swp11
> >  netlink error: Cannot reset module when port is administratively up
> >  netlink error: Invalid argument
> > 
> >  # ip link set dev swp11 down
> > 
> >  # ethtool --reset-module swp11
> > 
> > Monitor notifications:
> > 
> >  $ ethtool --monitor
> >  listening...
> > 
> >  Module reset done for swp11
> 
> Again, i'm wondering, why is user space doing the reset? Can you think
> of any other piece of hardware where Linux relies on user space
> performing a reset before the kernel can properly use it?
> 
> How long does a reset take? Table 10-1 says the reset pulse must be
> 10uS and table 10-2 says the reset should not take longer than
> 2000ms.

Takes about 1.5ms to get an ACK on the reset request and another few
seconds to ensure module is in a valid operational state (will remove
RTNL in next version).

> So maybe reset it on ifup if it is in a bad state?

We can have multiple ports (split) using the same module and in CMIS
each data path is controlled by a different state machine. Given the
complexity of these modules and possible faults, it is possible to
imagine a situation in which a few ports are fine and the rest are
unable to obtain a carrier.

Resetting the module on ifup of swp1s0 is not intuitive and it shouldn't
affect other split ports (e.g., swp1s1). With the dedicated reset
command we have the ability to enforce all the required restrictions
from the start instead of changing the behavior of existing commands.

> I assume the driver/firmware is monitoring the SFP and if it goes into
> a state which requires a reset it indicates carrier down? Wasn't there
> some patches which added link down reasons? It would make sense to add
> enum ethtool_link_ext_substate_sfp_fault? You can then use ethtool to
> see what state the module is in, and a down/ip should reset it?

I will look into extending the interface with more reasons and parse the
CMIS ModuleFaultCause (see table 8-15) in ethtool(8).
