Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7F727EB05
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 16:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730588AbgI3Ofe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 10:35:34 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:34939 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728496AbgI3Ofd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 10:35:33 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id D37BD5803A5;
        Wed, 30 Sep 2020 10:35:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 30 Sep 2020 10:35:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=epeZdv
        7/aFa/KIm5g07zoe24B4eWVcEw3jq5pRYXsbA=; b=gJYm105PEXFYIHe6YEimOg
        l/d6AM6NMAsc8J05VfVprqgN5wyM6/LDepzlWuu1XjFf4O9qFcBFnjZJbKDYjpgg
        oP9VoX/3SqvuWHSoCp294DbEWotk9/u9lcTksbIjQxUuezxc7xYex9rPlwnVus5j
        ecFPUWJArlX5sD421qQ6rhECX0c/zNoN7jmfhgITlf0uByD3tPs/VN7GZllBtYos
        HVEnu2xUFrBNtOY2pyHH0PRnigdiWRXLmuXiajdDi8iLryQiab93uYaCjxHbsUIj
        6qyraakrRS2AuPMSc8efWfhH/FbiRXKsAgKFlkQosO0GDJJLFFvYPuNEDf0SFehA
        ==
X-ME-Sender: <xms:s5d0Xwvf5bqKhrI3j8xk9Usk3ip3WWolg55SpBMTdeENWZdOdFTNgA>
    <xme:s5d0X9f1XYoTo8yPBb0bts9-9JYBva5kER4NymLWUt3deDWe42u9YWVt1lS9W6mTX
    gph4UI7pW9efsg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrfedvgdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepfeegtddtkefhgeehteelgedvheeghedvkeeggefgveekteelffevfefhvdelheeg
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpghhithhhuhgsrdgtohhmnecukfhppe
    ekgedrvddvledrfeejrddugeeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:s5d0X7wudWDmLJdrx1RjuGj-0lPW0oehSOPch2Wd63ADHFx_V6dcNw>
    <xmx:s5d0XzM6FbzCtTmax7S6v3t3KiIF3cmbBRZ6xAC81ygdiCa9IOnAfQ>
    <xmx:s5d0Xw9em0SqsKM5k33kPyML5XJm_0G--vhsinVnCo_C66ioAcwodg>
    <xmx:tJd0X9OjnNVUnJPdZmvoWD4fM6LmrWKl_-V4VmUTmyoU1kfDPDYOFg>
Received: from localhost (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id B8C8E328005A;
        Wed, 30 Sep 2020 10:35:30 -0400 (EDT)
Date:   Wed, 30 Sep 2020 17:35:27 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        ayal@nvidia.com, danieller@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net] ethtool: Fix incompatibility between netlink and
 ioctl interfaces
Message-ID: <20200930143527.GA1824481@shredder>
References: <20200929160247.1665922-1-idosch@idosch.org>
 <20200929164455.pzymi4chmvl3yua5@lion.mk-sys.cz>
 <20200930072529.GA1788067@shredder>
 <20200930085917.xr2orisrg3oxw6cw@lion.mk-sys.cz>
 <20200930141909.GJ3996795@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930141909.GJ3996795@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 04:19:09PM +0200, Andrew Lunn wrote:
> > > I don't think so. Doing:
> > > 
> > > # ethtool -s eth0 autoneg
> > > 
> > > Is a pretty established behavior to enable all the supported advertise
> > > bits.
> 
> I would disagree. phylib will return -EINVAL for this.

This has nothing to do with the kernel / phylib. With the ioctl
interface when you do:

# ethtool -s eth0 autoneg on

The ethtool user space utility will enable all the supported link modes:

https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/tree/ethtool.c#n3170

For the netlink interface this is done by the kernel:

https://github.com/torvalds/linux/blob/master/net/ethtool/linkmodes.c#L2

But only if speed or duplex were specified:

https://github.com/torvalds/linux/blob/master/net/ethtool/linkmodes.c#L383

Which is a problem.

> 
> int phy_ethtool_ksettings_set(struct phy_device *phydev,
>                               const struct ethtool_link_ksettings *cmd)
> {
>         __ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
>         u8 autoneg = cmd->base.autoneg;
>         u8 duplex = cmd->base.duplex;
>         u32 speed = cmd->base.speed;
> 
> ...
>         linkmode_copy(advertising, cmd->link_modes.advertising);
> 
> ...
> 
>         if (autoneg == AUTONEG_ENABLE && linkmode_empty(advertising))
>                 return -EINVAL;
> 
> You have to pass a list of modes you want it to advertise. If you are
> using phylink and not a copper PHY, and autoneg, that means you are
> using in-band signalling. The same is imposed:
> 
>         /* If autonegotiation is enabled, we must have an advertisement */
>         if (config.an_enabled && phylink_is_empty_linkmode(config.advertising))
>                 return -EINVAL;
> 
> We have consistent behaviour whenever Linux is controlling the PHY
> because the core is imposing that behaviour. It would be nice if
> drivers ignoring the PHY core where consistent with this.

You will get an error from mlxsw as well (see example in the change
log).

> 
> 	Andrew
