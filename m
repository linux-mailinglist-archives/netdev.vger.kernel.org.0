Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9D83F1BAA
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 16:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240539AbhHSOfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 10:35:30 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:60083 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238547AbhHSOf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 10:35:29 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id B717E580A1C;
        Thu, 19 Aug 2021 10:34:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 19 Aug 2021 10:34:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=bjqTlZ
        Os1a7kp3IJhmetlzhS6Ki+E9AJU18kgYXkNi4=; b=AJIOuDpe1ja60M1BaYq6QP
        EZPdNW3viMveSojk+1FM22Qj72ZTrGXS3gMjpDI8qqLDhG1ykFJigAaQKPA/nNCR
        4tfD/+aC8VRvsZ6aIoP3OcrLtMjHXGsUyE1kOKiC2pBUlOXUu0EZ43C4q4vxVGk6
        ON5mLcqq+xowfRCFVMi7/4BWD/qlGBYdyydBryjOtRGbqxK3yuJo2llsYi8f1Xl8
        ovUCBiI2R9pC3841vU2rf7TWZPPtNF0xLJTjIzG3ScWZWo3zJKDhN2hLSE2JPkVf
        CBlGDBaR0iwTwOxXF3xjcdO4wdzS2dv+XN2mVTKQOiewW7L9Hu4BSjhW8J9l8xKg
        ==
X-ME-Sender: <xms:CmweYYBvrkmZrIty_Tt8hY8bQZzQzKqdf5NlGyjjiPfdT66uUOOfsQ>
    <xme:CmweYaiVaClQ8u9gHoUpHpocIegP6mxb3L48jd9iqsNnqh1d2cWJWobKY7_XVfM4z
    jpIQA3ye81ZD14>
X-ME-Received: <xmr:CmweYbkAPTa9XQbQdM3JJKF8WD2G1CUWnnRI5HCRiGNt7WM840vobhxWFTf1Z8wLgJn0KDVuZAqFNdr63DQ7BnRfGzt4hw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrleejgdejiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepjeehudefleekfeevkeeiieeifeefteejieegudevieekvdetieelkefghffgledv
    necuffhomhgrihhnpehmvghllhgrnhhogidrtghomhenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:CmweYezwDkS8CAxei3-0U5P_PP5LEQLqnL849er_EZDTM_1WkqnEkA>
    <xmx:CmweYdRgpGTaZuneFt8TqslnUpx8pdESMWDLrggYduLQra-r515MaA>
    <xmx:CmweYZZOUiVkeO479cgpnrjTzD_dQjnshjKeOwQxjZTLzqSkkImfnA>
    <xmx:DGweYYGJASth1xwc9YBNHUayFjHWRALq4vwCIU0DdKVgkitUaCJn9w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Aug 2021 10:34:50 -0400 (EDT)
Date:   Thu, 19 Aug 2021 17:34:46 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, mkubecek@suse.cz, pali@kernel.org,
        jacob.e.keller@intel.com, jiri@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next v2 1/6] ethtool: Add ability to control
 transceiver modules' power mode
Message-ID: <YR5sBqnf7RZqVKl4@shredder>
References: <20210818155202.1278177-1-idosch@idosch.org>
 <20210818155202.1278177-2-idosch@idosch.org>
 <20210818153241.7438e611@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YR2P7+1ZGiEBDtAq@lunn.ch>
 <YR4NTylFy2ejODV6@shredder>
 <YR5Y5hCavFaWZCFH@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YR5Y5hCavFaWZCFH@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 03:13:10PM +0200, Andrew Lunn wrote:
> > > Should we also document what the default is? Seems like
> > > ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH_ON_UP is the generic network
> > > interface default, so maybe it should also be the default for SFPs?
> > 
> > I will add a note in Documentation/networking/ethtool-netlink.rst that
> > the default power mode policy is driver-dependent (can be queried) and
> > that it can either be 'high' or 'auto'.
> 
> Hi Ido

Hi Andrew,

> 
> That is kind of my question. Do you want the default driver defined,
> and varying between implementations, or do we want a clearly defined
> default?
> 
> The stack has a mixture of both. An interface is admin down by
> default, but it is anybody guess how pause will be configured?
> 
> By making it driver undefined, you cannot assume anything, and you
> require user space to always configure it.
> 
> I don't have too strong an opinion, i'm more interested in what others
> say, those who have to live with this.

I evaluated the link up times using a QSFP module [1] connected to my
system. There is a 36% increase in link up times when using the 'auto'
policy compared to the 'high' policy (default on all Mellanox systems).
Very noticeable and very measurable.

Couple the above with the fact that despite shipping millions of ports
over the years, we are only now getting requests to control the power
mode of transceivers and from a small number of users.

In addition, any user space that is interested in changing the behavior,
has the ability to query the default policy and override it in a
vendor-agnostic way.

Therefore, I'm strictly against changing the existing behavior.

[1] https://www.mellanox.com/related-docs/prod_cables/PB_MFS1S00-VxxxE_200GbE_QSFP56_AOC.pdf

> 
> 	Andrew
