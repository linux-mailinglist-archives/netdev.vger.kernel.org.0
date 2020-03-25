Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C35A8192631
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 11:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgCYKv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 06:51:27 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:45807 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726103AbgCYKv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 06:51:26 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 813C1580092;
        Wed, 25 Mar 2020 06:51:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 25 Mar 2020 06:51:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=BcCB9O
        XpHgn65zXIZoqRcgnWnQhSPer2YSAb0AkPeQU=; b=YRiJH0p/j83COSeVngY2Ch
        gMef0VXMy3/V0K98PKlVUihtao6KqdMv1ToRMFszDMg8Sezyt3xJa3t72bMaYy4M
        p1UMPpm+9qEx5BdZT8iByG3yFS9n4JG+T/g1r9P4JNI704g2oDg16s69xUBgSD1T
        SMrBv4P/hm0a2nxlJ5Mpodeq5a6Y/zEUqgZM7Ls3cCmK5JO6YUdw0js0gbYKVfiN
        y8nt6EEo7m0luIB4I1YRaae/std+ToRw4165rXJ5GO7vYzt+SMR4U1MqBfegPzQa
        FJTcLcW1CSOrLO3gcvYU/vKbpAijfMp0v+lTkvb9+BNvdbfwMyMUk3pHL17r6cHg
        ==
X-ME-Sender: <xms:qzd7XogoZ5dy85BHdDvlzN-vf2dpvaAUJN3ZLnHchCgFxoO1OZqmmg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehfedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudektddrleegrddvvdehnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:rDd7XlRn2xOvILgzVlQHBtvx8mnzbb1DH7otUqhssjKgXabOSB3Now>
    <xmx:rDd7XrFjW25hh5-hbJ7hoCZdP8Fgf4GY3pQojrC-RhNDPGbexeLecQ>
    <xmx:rDd7XtmBpYySAAK-h9lVJnb4KDqhzlp0cy8m6w3TFqbATb7YwnA1mQ>
    <xmx:rTd7XvqpFv89UVLMKIvuXKOB2J7Z5mneU1yvLb9eMqLvvqAWo3CkOQ>
Received: from localhost (bzq-79-180-94-225.red.bezeqint.net [79.180.94.225])
        by mail.messagingengine.com (Postfix) with ESMTPA id 974F73280065;
        Wed, 25 Mar 2020 06:51:23 -0400 (EDT)
Date:   Wed, 25 Mar 2020 12:51:21 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 11/15] mlxsw: spectrum_trap: Add devlink-trap
 policer support
Message-ID: <20200325105121.GD1332836@splinter>
References: <20200324193250.1322038-1-idosch@idosch.org>
 <20200324193250.1322038-12-idosch@idosch.org>
 <20200324203349.6a76e581@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324203349.6a76e581@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 08:33:49PM -0700, Jakub Kicinski wrote:
> On Tue, 24 Mar 2020 21:32:46 +0200 Ido Schimmel wrote:
> > +static int mlxsw_sp_trap_policer_params_check(u64 rate, u64 burst,
> > +					      u8 *p_burst_size,
> > +					      struct netlink_ext_ack *extack)
> > +{
> > +	int bs = fls64(burst);
> > +
> > +	if (rate < MLXSW_REG_QPCR_LOWEST_CIR) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Policer rate lower than limit");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (rate > MLXSW_REG_QPCR_HIGHEST_CIR) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Policer rate higher than limit");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (!bs) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Policer burst size lower than limit");
> > +		return -EINVAL;
> > +	}
> > +
> > +	--bs;
> > +
> > +	if (burst != (1 << bs)) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Policer burst size is not power of two");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (bs < MLXSW_REG_QPCR_LOWEST_CBS) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Policer burst size lower than limit");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (bs > MLXSW_REG_QPCR_HIGHEST_CBS) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Policer burst size higher than limit");
> > +		return -EINVAL;
> > +	}
> 
> Any chance we could make the min/max values part of the policer itself?
> Are they dynamic? Seems like most drivers will have to repeat this
> checking against constants while maybe core could have done it?

Yea, it's a good idea. We can also expose these values to user space,
but I think it's not really necessary and I prefer not to extend uAPI
unless we really have to.

> 
> > +
> > +	*p_burst_size = bs;
> > +
> > +	return 0;
> > +}
