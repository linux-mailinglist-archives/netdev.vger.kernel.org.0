Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 923C719247C
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 10:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbgCYJqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 05:46:44 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:43509 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727301AbgCYJqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 05:46:44 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5A5AB580316;
        Wed, 25 Mar 2020 05:46:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 25 Mar 2020 05:46:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=++m8+F
        zsKkAJMgJb4qVitUW0Blu7LYkzbgu33QCvqCY=; b=IMrJyulJK4pi+xatGDJCcD
        sU5H2YIuDZecd8jUna18CqdiPkxwSlxwHsoIKDY9jggVvMwJ3kaimnHF037ON49H
        CaiBaarP+zY7MYGrQ0xAE1bw47XKEV4QlV5BGarK+1eYnLDBCFBOVlOENIH4mxiu
        SCxiR22VHwNx1++iXIDLy1MqvXzAVZg+oeGp6FzuoebRQxwurDXwmEvt4+dpYCd8
        oPsyYYaK9Osfdkiioskntdk0pvB9LkTcTQzKtTL7y0jeJ84aJxbKQPwwyuXaTCvn
        XuqAMfOHy7s8aZYdPr3+NPTBffNmg+9XUxEUeCshQHqWmcsHm102jxXTEvRPkyeg
        ==
X-ME-Sender: <xms:gih7XjQy2hKqklmPW6MbWR-C5ZPvb3iHpF0z4b5u7DdKw8qakkcj3w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehfedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudektddrleegrddvvdehnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:gih7XitgK8afqVkdJi7IPR5Ldy3jAYVuMSOWP4JC7hqxrXp4frhzQg>
    <xmx:gih7XrLV80FeP2JacXeLiSUMoV2_gqoW-B2iAT7g-ps9FiLn-KPMdQ>
    <xmx:gih7XnlDq8vtu_mpukNBxCSt19fD_K1ZgWlD1fvrpINLqypIlX7O1w>
    <xmx:gyh7Xo-r1ky8gARyuQkUkz2fyELjskCyQg1sWk2C5Ja89jhYaU_ckA>
Received: from localhost (bzq-79-180-94-225.red.bezeqint.net [79.180.94.225])
        by mail.messagingengine.com (Postfix) with ESMTPA id BEF6D328005D;
        Wed, 25 Mar 2020 05:46:41 -0400 (EDT)
Date:   Wed, 25 Mar 2020 11:46:39 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 01/15] devlink: Add packet trap policers support
Message-ID: <20200325094639.GB1332836@splinter>
References: <20200324193250.1322038-1-idosch@idosch.org>
 <20200324193250.1322038-2-idosch@idosch.org>
 <20200324203723.1187ab10@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324203723.1187ab10@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 08:37:23PM -0700, Jakub Kicinski wrote:
> On Tue, 24 Mar 2020 21:32:36 +0200 Ido Schimmel wrote:
> >  static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
> 
> Hm. looks like devlink doesn't have .strict_start_type set, yet.
> Should we set it?

Good point. Will add.

> 
> >  	[DEVLINK_ATTR_BUS_NAME] = { .type = NLA_NUL_STRING },
> >  	[DEVLINK_ATTR_DEV_NAME] = { .type = NLA_NUL_STRING },
> > @@ -6064,6 +6309,9 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
> >  	[DEVLINK_ATTR_NETNS_PID] = { .type = NLA_U32 },
> >  	[DEVLINK_ATTR_NETNS_FD] = { .type = NLA_U32 },
> >  	[DEVLINK_ATTR_NETNS_ID] = { .type = NLA_U32 },
> > +	[DEVLINK_ATTR_TRAP_POLICER_ID] = { .type = NLA_U32 },
> > +	[DEVLINK_ATTR_TRAP_POLICER_RATE] = { .type = NLA_U64 },
> > +	[DEVLINK_ATTR_TRAP_POLICER_BURST] = { .type = NLA_U64 },
> >  };
