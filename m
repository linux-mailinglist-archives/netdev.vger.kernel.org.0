Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 088B827F2B0
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 21:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbgI3ToN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 15:44:13 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47477 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725799AbgI3ToM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 15:44:12 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A30105C012E;
        Wed, 30 Sep 2020 15:44:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 30 Sep 2020 15:44:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=8XGKV3
        q5Xzwx82FPNclj487x0cnmgo9nn/1IQcFKS8E=; b=VK1E2yA14dtA+vcOeHHBnQ
        WX9dXjwEBkVnQxdsIBPMYTt64fWamhB2/g5MVdNVxbPczYMNcKRHmPkpfMFuijeB
        7cdPoVF/E/7safW7ObN45l+LVT3UlfWwwU4O/93fdgGjeyGLCpDPjFqnyhepcSCx
        sfWQ7wNCMOK6NpECNKBek4JMcSsNu79ugOMa3eDUE0kz8s5xJrtGaXNLpJbcctZx
        RnEft1InZb5r/lZTOZp37zcLzZHvZ2Lw+H3V9ObfihB01xjfPA0mcqrP6zuiRmR2
        G90yOpDEm6lPbL8A6WrG5kr26y3rxnkKpsxQAx99+7LJJNKnqjf5NbGnBSh73LpQ
        ==
X-ME-Sender: <xms:C-B0X5mgN6K-EqNFWG4z1cJX5fdigxv8EzgNvG1gmY1CTaOUo183uQ>
    <xme:C-B0X03z-g6UB6ONIfQpTattzIFIDB0P2fKLcJpuqLQ4d5pGsTkRRr2N1dBX4oowb
    C__2EyvTyIiPRA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrfedvgddufeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdefjedrudegkeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:C-B0X_odzd9iWB00tVnnthn8MVguntHh__p0E5BHdxoJNZHp4S_v0Q>
    <xmx:C-B0X5nLn0ZG4pEXYL0_D99P1-wO22-9wPADc9FMF2q7d1fopb9Smw>
    <xmx:C-B0X33qRD6XlLYAZrH9n0UTExxyN2ioYXB51s7Kv6vARRr241mHpw>
    <xmx:C-B0X1DqYRi85tmmZ_IYDNvw2VRdct3Ni0wa-rdAWaENq-3wkETCNA>
Received: from localhost (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id 88E6D306467D;
        Wed, 30 Sep 2020 15:44:10 -0400 (EDT)
Date:   Wed, 30 Sep 2020 22:44:07 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        jiri@nvidia.com, idosch@nvidia.com
Subject: Re: [PATCH net-next v2 4/4] dpaa2-eth: add support for devlink
 parser error drop traps
Message-ID: <20200930194407.GA1850258@shredder>
References: <20200930191645.9520-1-ioana.ciornei@nxp.com>
 <20200930191645.9520-5-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930191645.9520-5-ioana.ciornei@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 10:16:45PM +0300, Ioana Ciornei wrote:
> +static int dpaa2_eth_dl_trap_action_set(struct devlink *devlink,
> +					const struct devlink_trap *trap,
> +					enum devlink_trap_action action,
> +					struct netlink_ext_ack *extack)
> +{
> +	/* No support for changing the action of an independent packet trap,
> +	 * only per trap group - parser error drops
> +	 */
> +	return -EOPNOTSUPP;

Please also add an error message via extack

> +}
