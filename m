Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37DB3B371C
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 21:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbhFXTky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 15:40:54 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:58585 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232370AbhFXTkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 15:40:52 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 48BF358072A;
        Thu, 24 Jun 2021 15:38:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 24 Jun 2021 15:38:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=O3iewC
        V4YQyd50ozoEa/7eh0M34Wa+ZJZ9fIfYJOeU4=; b=R0g4n7KwXajEhoBurjVECO
        QGxMy60PgXusOFTIMCXoBkg9k2bzV4TD8cQ4IjlZhym3OdFLYfeGvH89AgmNUDUX
        QB2218jj/b30ft2vPv/2QDGtci5nNskV6QRxBRZeliHUkUrfpXqYQ6HLJc0IOMMy
        JPIHbKvu9wvuhqSzROMxIxvSbeszjlSLoh7f/BAop/hfEkSfttQNf6ioTO/5U2Qc
        OHBEBXAOWELhIy9zNHtZCRI0mYn0RQL/ghsBw+626w66NIv1WrPPCJC9J3J7uSC4
        I6JqOrAWb72qR5c38JYDiUHyRXajh2B7Wckc+dgPHxJpm+YJc96GaQEVADBRvBMQ
        ==
X-ME-Sender: <xms:N9_UYL0wipRRgsUzx516h_7sQQ-FtcorXIQmIRaiWut_oO816yMb-Q>
    <xme:N9_UYKGq0oJvsp0aHw7hYHKWrv1wxm_c6mGRbyxyCgVGaX_8XLDaoxmi7nvL7yPFc
    q3oxEOxaDtjltM>
X-ME-Received: <xmr:N9_UYL6ky9pAlAigF6tufUeQQ9DKtVRMBxWom_A1AtmtkToDahFaaQwJnw0w0mELiV4_KJuOnt9DY-lQSt34TiyL7lJ8ag>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeghedgudeflecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepgfevgfevueduueffieffheeifffgjeelvedtteeuteeuffekvefggfdtudfg
    keevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:N9_UYA1FwwYtpokO3VT8u8QdD2MK--_28U0JsyQvtjk8c7ROEiksbQ>
    <xmx:N9_UYOHYbXsOmNwpnx1_7N0FWja91y3X73TDmDpV_YyoxxKZIasIDg>
    <xmx:N9_UYB8a8swYHBg1FeDp083wZLrwBI7xP2t5dkgG_eaOUelSCIhNug>
    <xmx:ON_UYMY4xUJQ6CoJx9gAM_Ap2ydlzgQUfs3Yrw9o1ibH6dKP-TvYmg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Jun 2021 15:38:30 -0400 (EDT)
Date:   Thu, 24 Jun 2021 22:38:27 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, vladyslavt@nvidia.com, moshe@nvidia.com,
        vadimp@nvidia.com, mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/4] ethtool: Add ability to write to
 transceiver module EEPROMs
Message-ID: <YNTfMzKn2SN28Icq@shredder>
References: <20210623075925.2610908-1-idosch@idosch.org>
 <YNOBKRzk4S7ZTeJr@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNOBKRzk4S7ZTeJr@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 08:44:57PM +0200, Andrew Lunn wrote:
> On Wed, Jun 23, 2021 at 10:59:21AM +0300, Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > This patchset adds write support to transceiver module EEPROMs by
> > extending the ethtool netlink API.
> > 
> > Motivation
> > ==========
> > 
> > The kernel can currently dump the contents of module EEPROMs to user
> > space via the ethtool legacy ioctl API or the new netlink API. These
> > dumps can then be parsed by ethtool(8) according to the specification
> > that defines the memory map of the EEPROM. For example, SFF-8636 [1] for
> > QSFP and CMIS [2] for QSFP-DD.
> > 
> > In addition to read-only elements, these specifications also define
> > writeable elements that can be used to control the behavior of the
> > module. For example, controlling whether the module is put in low or
> > high power mode to limit its power consumption.
> 
> Hi Ido

Hi Andrew,

Thanks for the feedback.

> 
> So power control is part of the specification?

Yes. See "6.3.2.4 Module Power Mode" in CMIS.

> All CMIS devices should implement it the same.

The implementation inside the module will probably differ between
different vendors, but the interface towards the host (Linux) will be
the same as it is standardized by CMIS.

> 
> > The CMIS specification even defines a message exchange mechanism (CDB,
> > Command Data Block) on top of the module's memory map. This allows the
> > host to send various commands to the module. For example, to update its
> > firmware.
>  
> > This approach allows the kernel to remain ignorant of the various
> > standards and avoids the need to constantly update the kernel to support
> > new registers / commands. More importantly, it allows advanced
> > functionality such as firmware update to be implemented once in user
> > space and shared across all the drivers that support read and write
> > access to module EEPROMs.
> 
> I fear we are opening the door for user space binary blob drivers,

No need for multiple drivers. The whole point of these standards is that
a single implementation on the host will work across different modules
from different vendors. I expect that ethtool(8) will have an
implementation which other projects can then use as a reference. Similar
to how iproute2 is used as a reference by developers of various
interface managers / routing daemons.

> which do much more than just firmware upgrade.

CMIS indeed allows for much more than firmware update. But again, it is
all standardized to ensure a single implementation on the host will
suffice.

> You seems to say that power control is part of the CMIS standard. So
> we don't need userspace involved for that. We can implement a library
> which any MAC driver can share.

I fail to understand this logic. I would understand pushing
functionality into the kernel in order to create an abstraction for user
space over different hardware interfaces from different vendors. This is
not the case here. Nothing is vendor specific. Not to the host vendor
nor to the module vendor.

Pushing all this functionality into the kernel will basically mean
creating an abstraction over an abstraction. Practically, it means
bloating the kernel with several thousands LoC (maybe more) and a lot of
new user APIs which we will never be able to remove. TBH, I cannot
explain to myself what we stand to gain from that.

> 
> I also wonder if it is safe to perform firmware upgrade from user
> space?

I have yet to write the relevant code in ethtool(8), but it should be
safe. See more below.

> I've not looked at the code yet, but i assume you only allow
> write when the interface is down?

No. Taking it down will mean needless packet loss for the entire time of
the firmware download process. After the download process, you need to
activate the new image from one of the banks (A/B) via CDB "Run Image"
command, but even that can be hit less. See "HitlessRestart" bit which
can be queried using "Firmware Management Features" command:

"
0: CMD Run Image causes a reset. Traffic is affected.
1: CMD Run Image may reset, but module will do its best to maintain
traffic and management states. Data path functions are not reset.
"

Can be implemented in ethtool(8) using commands such as these:

# ethtool --module-fw-query DEVNAME
# ethtool --module-fw-dl DEVNAME FILENAME
# ethtool --module-fw-run DEVNAME

Just a quick example. Yet to design / implement this functionality.
Wanted to discuss the kernel interface before starting to pile user
space functionality on top.

> Otherwise isn't there a danger you can brick the SFP if the MAC
> accesses it at the same time as when an upgrade is happening?

No. You download the firmware image to a bank, verify it was downloaded
correctly and then activate the new image (without affecting traffic,
potentially).

> 
> Do you have other concrete use cases for write from user space?

The first priority on my list is related to SFF-8636 (QSFP).
Specifically, ability to monitor signal to noise ratio and laser
temperature. This is done via High Page 20h that can monitor up to 24
parameters. Since the number of parameters that can be monitored is much
larger than 24, you need to instruct the module which parameters to
monitor. This is done by writing to the "Param Configuration" table on
this page. See "6.7.2.5 Parameter Configuration Registers".

> 
> In general, we don't allow uncontrolled access to hardware from user
> space. We add specific, well documented API calls, and expect kernel
> drivers to implement them. I don't see why SFPs should be
> different. Standardised parts we can implement in common code. None
> standard parts we need device/vendor specific code. Which just means
> we need drivers following the usual linux conventions, some sort of
> bus driver which reads the vendor/device ID from the EEPROM and probes
> a driver for the specific SFP.

I think I touched on all these points above. The symmetric GET interface
was implemented following your good advice [1] from a year ago in order
to avoid two parsers, in user space and kernel. Creating a netlink API
for every little writeable element in these standards will not only mean
that the kernel will need to be intimately familiar with these memory
maps, but also that it will need to be constantly patched with new user
APIs which we will never be able to remove.

Given the above is entirely avoidable with a single portable
implementation in ethtool(8), I do not think we should go with a kernel
implementation.

[1] https://lore.kernel.org/netdev/20200630002159.GA597495@lunn.ch/

> 
>   Andrew
> 
> 
> 
