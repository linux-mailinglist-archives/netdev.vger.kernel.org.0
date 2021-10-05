Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4F9E421F30
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 08:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbhJEG7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 02:59:17 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:46861 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230526AbhJEG7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 02:59:15 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 82D7E580C63;
        Tue,  5 Oct 2021 02:57:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 05 Oct 2021 02:57:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=oHwjks
        x2QdW/gxVNtktS5EH2VOoHgbf6sgKtHST5fSw=; b=jNcHDU+AQEILuTd4xh6KNf
        Uo13D13AbwpFP8gLMTvRQ3Dn0ladpj9cRsAuVZVKhI0ZnYI7JlR53F749RzN8zUS
        UUvzB9ezrezYLSSoSl3zGfxKyScXeaxu9NuBhveH93+5KZqHfAYU7rUb000WR9Tl
        FMbPt1MrkM01cuJCmhpMet7Q9EfheHUBFeuKNK/nsKBGagnmAAyVrtpS/DGE5hdz
        +FSGsLwzEnKXWu84WP6oqQ4VBibKtJdUYsAT6+BBbVwSMZkUOKDMDv6qTDgc/cqa
        3N0HlIJJ2sA/h/vFbTyIkTfPhEJxugfcFX8JQKCA720QYlfSnik0ow0yvAhW2lcA
        ==
X-ME-Sender: <xms:VPdbYZhlesFVLjqKH0RhhNzAaSyQwjdqFpp6Ty7j0DQi83nNm1j6_A>
    <xme:VPdbYeDteRimyq4PmyKxF7wuSxirZs1cbnCDL7NMf78l8A2j3fcb8gcHWOq5TkvCV
    shP_3pccBt7kLY>
X-ME-Received: <xmr:VPdbYZHggXkfpNzOK1NGq1I2aERKdwteIV35TwWckGbEQfzzxXC-TysmTjkOUqHADHI_lJorOUo1Y3KhPbNrX75-boZlzQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudelfedguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpefgvefgveeuudeuffeiffehieffgf
    ejleevtdetueetueffkeevgffgtddugfekveenucffohhmrghinhepkhgvrhhnvghlrdho
    rhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:VPdbYeRPnnRwFgW6i3QyJLHv15zxuSf_ua4lev5zGfyjKHpg7dt_Bw>
    <xmx:VPdbYWygon1CjyFsMZHbpZj-UKuzp1nvXhaH_QVzgL_-DRVqNLdlFg>
    <xmx:VPdbYU7y1abocumkNk6n0ucANupDleMWB9pYMQqfd_LhVAo4W47yag>
    <xmx:VfdbYVkPHjfN1PSzbtrh5uyiL_1RWTM1yEgXSRMjNpNFz2PQmgE4WA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 5 Oct 2021 02:57:24 -0400 (EDT)
Date:   Tue, 5 Oct 2021 09:57:20 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/6] ethtool: Add ability to control transceiver
 modules' power mode
Message-ID: <YVv3UARMHU8HZTfz@shredder>
References: <20211003073219.1631064-1-idosch@idosch.org>
 <20211003073219.1631064-2-idosch@idosch.org>
 <20211004180135.55759be4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004180135.55759be4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 06:01:35PM -0700, Jakub Kicinski wrote:
> On Sun,  3 Oct 2021 10:32:14 +0300 Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > Add a pair of new ethtool messages, 'ETHTOOL_MSG_MODULE_SET' and
> > 'ETHTOOL_MSG_MODULE_GET', that can be used to control transceiver
> > modules parameters and retrieve their status.
> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Thanks!

> 
> Couple of take it or leave it comments again, if you prefer to leave as
> is that's fine.

I'll make whatever changes we conclude are necessary. See below.

> 
> > +enum ethtool_module_power_mode_policy {
> > +	ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH,
> > +	ETHTOOL_MODULE_POWER_MODE_POLICY_AUTO,
> > +};
> 
> I see you left this starting from 0, and we still need a valid bit,
> granted just internal to the core.

I was under the impression that we were only talking about the power
mode itself (which can be invalid if a module is unplugged), but not the
policy [1]. I did change that like we discussed.

[1] https://lore.kernel.org/netdev/YSYmFEDWJIu6eDvR@shredder/

> 
> Would we not need a driver-facing valid bit later on when we extend 
> the module API to control more params?

To keep the driver-facing API simple I want to have different ethtool
operations for different parameters (like rtnetlink and ndos). So, if a
driver does not support a parameter, the operation will not be
implemented and the attributes will not be dumped.

> Can't there be drivers which implement power but don't support the
> mode policy?

I don't really see how. The policy is a host attribute (not module)
determining how the host configures the power mode of the module. It
always exists, but can be fixed.

Do you still think we should make the change below?

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 1b126e8b5269..a2223b685451 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -721,7 +721,7 @@ enum ethtool_stringset {
  *     administratively down.
  */
 enum ethtool_module_power_mode_policy {
-       ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH,
+       ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH = 1,
        ETHTOOL_MODULE_POWER_MODE_POLICY_AUTO,
 };

> 
> > +static int module_set_power_mode(struct net_device *dev, struct nlattr **tb,
> > +				 bool *p_mod, struct netlink_ext_ack *extack)
> > +{
> > +	struct ethtool_module_power_mode_params power = {};
> > +	struct ethtool_module_power_mode_params power_new;
> > +	const struct ethtool_ops *ops = dev->ethtool_ops;
> > +	int ret;
> > +
> > +	if (!tb[ETHTOOL_A_MODULE_POWER_MODE_POLICY])
> > +		return 0;
> 
> Feels a little old school to allow set with no attrs, now that we 
> do strict validation on attrs across netlink.  What's the reason?

The power mode policy is the first parameter that can be set via
MODULE_SET, but in the future there can be more and it is valid for user
space to only want to change a subset. In which case, we will skip over
attributes that were not specified.

> 
> > +	if (!ops->get_module_power_mode || !ops->set_module_power_mode) {
> > +		NL_SET_ERR_MSG_ATTR(extack,
> > +				    tb[ETHTOOL_A_MODULE_POWER_MODE_POLICY],
> > +				    "Setting power mode policy is not supported by this device");
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	power_new.policy = nla_get_u8(tb[ETHTOOL_A_MODULE_POWER_MODE_POLICY]);
> > +	ret = ops->get_module_power_mode(dev, &power, extack);
> > +	if (ret < 0)
> > +		return ret;
> > +	*p_mod = power_new.policy != power.policy;
> > +
> > +	return ops->set_module_power_mode(dev, &power_new, extack);
> 
> Why still call set if *p_mod == false?

Good question...

Thinking about this again, this seems better:

diff --git a/net/ethtool/module.c b/net/ethtool/module.c
index 254ac84f9728..a6eefae906eb 100644
--- a/net/ethtool/module.c
+++ b/net/ethtool/module.c
@@ -141,7 +141,10 @@ static int module_set_power_mode(struct net_device *dev, struct nlattr **tb,
        ret = ops->get_module_power_mode(dev, &power, extack);
        if (ret < 0)
                return ret;
-       *p_mod = power_new.policy != power.policy;
+
+       if (power_new.policy == power.policy)
+               return 0;
+       *p_mod = true;
 
        return ops->set_module_power_mode(dev, &power_new, extack);
 }

That way we avoid setting 'mod' to 'false' if it was already 'true'
because of other parameters that were changed in ethnl_set_module(). We
don't have any other parameters right now, but this can change.

Thanks for looking into this
