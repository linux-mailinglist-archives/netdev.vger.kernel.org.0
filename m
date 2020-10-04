Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4036282B0C
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 15:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgJDNiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 09:38:07 -0400
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:59935 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725927AbgJDNiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 09:38:05 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id 0C75646D;
        Sun,  4 Oct 2020 09:38:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 04 Oct 2020 09:38:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=TkjPeK
        asb5N6JohTnx9KDQE5/E9yuGBJrhsKlkBNVeo=; b=ooTt8woDBcCoHur37dtX3z
        DFYE2hRn859ip2nadVAvsS7HdDRUM14tecBxA9kqo+zU6jxpTjpwZ5lzyQNL+ThI
        fSC37F2KLMGQ8K8BaJOjZwDFwbnmiDyicWsK1ofRodKwcwx0TP/tHGCdDaL2P6lS
        U/tb6y0K1ZevKtZfE3AMHOs4Q3jJOkhRJ2EMSaLgXAWSfHFEQk0OrDFvGMaUsHvJ
        u1JbYSacyn+kVhniDOwEUBA7i1fMEZicbJ8bI5zrixRwxvLMfYUSW9tb0PVwT6OU
        +WSobv/BhfEN8l9Z9H0rCwA0FFcq4GcUqqhEq16ed0lWufz9bfbSnTV5o3qhoTBg
        ==
X-ME-Sender: <xms:OdB5X9oZ_jUeP0r5WJACPnjciCfb0Nbf-3QcCr2zEfjw_WAU5-6j_A>
    <xme:OdB5X_r5WHF3ikD5Yduz636JDRvSvwEclUmk3W3kZB3I0kEwTscCHHRtW1xvEuws4
    uS3DDuCZpkVc-k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrgedtgdejtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrfeejrddugeeknecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:OdB5X6NjUWmOG-z_4MBsMXVRktu7p7eAT4vDaOJpEtjM3_sqAugANg>
    <xmx:OdB5X45KU3Ckct2GkeMWmHS9b4N55NPXZNjDDJiNlM2kHKWBWulYeA>
    <xmx:OdB5X84WnsOGfelAj_va5h2ESUmG-kDA-fLkcw3619A722yfcjUcAw>
    <xmx:O9B5X7b2PHGZJv63S7hX_q8977ESDVCU3k7ukM_7n4UgeW-ksN-_swIZB6k>
Received: from localhost (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id 08B263280059;
        Sun,  4 Oct 2020 09:38:00 -0400 (EDT)
Date:   Sun, 4 Oct 2020 16:37:57 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "ayal@nvidia.com" <ayal@nvidia.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next v2] ethtool: Improve compatibility between
 netlink and ioctl interfaces
Message-ID: <20201004133757.GA2189885@shredder>
References: <20201004101707.2177320-1-idosch@idosch.org>
 <07b469aea4494fdeb11f4915459540a4@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07b469aea4494fdeb11f4915459540a4@AcuMS.aculab.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 04, 2020 at 12:46:31PM +0000, David Laight wrote:
> From: Ido Schimmel
> > Sent: 04 October 2020 11:17
> > 
> > With the ioctl interface, when autoneg is enabled, but without
> > specifying speed, duplex or link modes, the advertised link modes are
> > set to the supported link modes by the ethtool user space utility.
> ...
> > Fix this incompatibility problem by introducing a new flag in the
> > ethtool netlink request header: 'ETHTOOL_FLAG_LEGACY'. The purpose of
> > the flag is to indicate to the kernel that it needs to be compatible
> > with the legacy ioctl interface. A patch to the ethtool user space
> > utility will make sure the flag is always set.
> 
> You need to do that the other way around.
> You can't assume the kernel and application are updated
> at the same time.

Thanks, David. In case ethtool is updated without updating the kernel we
will indeed get an error:

# ethtool -s eth0 autoneg on
netlink error: unrecognized request flags (offset 36)
netlink error: Operation not supported

Will wait for Michal's comments before doing another round.
