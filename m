Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F550370D8C
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 17:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbhEBPFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 11:05:52 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:52231 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230110AbhEBPFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 11:05:51 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id E3D2F58073D;
        Sun,  2 May 2021 11:04:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 02 May 2021 11:04:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=MQUkWK
        w9RCDKfqU9d+QuZkH1t07x/WW5tw+ukNqYQ5A=; b=toVyAOSn7fm87WscwoiYas
        bKbnXw10S1R+2Ar8fKvdRsYuRrQv3vJu23MEiHEKJifJFIrTxwn1AZYB632d7LKw
        nihJhDpGxl/MQyzejdc5CjJyPzw8uHQQEESNw8ImtUXiU3GwA+2o48lHo91E8tPg
        eP0rb+SRGSPzkj0qAr1+SxxhyVBhXnGYwZyRUgBavi2YyjrAPubJLlmCYJi2VCtW
        hERMUnmArPMtoV0xA5dNuFqDc+xbUiyf5oKFcXX7jnb5FQqm2j+aOPe4tmKy0dH5
        sJoefOoNqjcuHJ7avqTzZBxoaYhXrBLKPT7xnZ8DSKs1h5eMDozvz28k/c7458eQ
        ==
X-ME-Sender: <xms:mb-OYGQh9A6F7nNVPbKzJzdWFYCxQqcDlLr92GNuRhXiGjYbRizSLg>
    <xme:mb-OYLwrGHwj3iPKu4FJkyFJJDDKSbvU2XC6W1F5cAAc0-E6Te0AtAHLwXr8o0nVz
    _KkJHyEMsB3Dyo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefuddgudefhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppeduleefrdegjedrudeihedrvdehudenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:mb-OYD3fRd7ZE59pApqUsg3_ZP9aPMDU3r4y49eWQJWN8wFdynvPzg>
    <xmx:mb-OYCBHcGE3EkNKtRnvGtBmJA8RYL8XpF2TySdZ9mwyMGVK3UYZAQ>
    <xmx:mb-OYPjMeOrWUN3lD5wOEyG-ddB6X1Frzw2L--_AUjpLeeufUQaLyw>
    <xmx:m7-OYONvpfXQWt-X4IV6I0IIixxUXEfEeGRFdWmTAE5BUdh_Y3k-pQ>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  2 May 2021 11:04:57 -0400 (EDT)
Date:   Sun, 2 May 2021 18:04:54 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        roopa@nvidia.com, nikolay@nvidia.com, jiri@resnulli.us,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [RFC net-next 4/9] net: bridge: switchdev: Forward offloading
Message-ID: <YI6/li9hwHo8GfCm@shredder>
References: <20210426170411.1789186-1-tobias@waldekranz.com>
 <20210426170411.1789186-5-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426170411.1789186-5-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 07:04:06PM +0200, Tobias Waldekranz wrote:
> +static void nbp_switchdev_fwd_offload_add(struct net_bridge_port *p)
> +{
> +	void *priv;
> +
> +	if (!(p->dev->features & NETIF_F_HW_L2FW_DOFFLOAD))
> +		return;
> +
> +	priv = p->dev->netdev_ops->ndo_dfwd_add_station(p->dev, p->br->dev);

Some changes to team/bond/8021q will be needed in order to get this
optimization to work when they are enslaved to the bridge instead of the
front panel port itself?

> +	if (!IS_ERR_OR_NULL(priv))
> +		p->accel_priv = priv;
> +}
> +
> +static void nbp_switchdev_fwd_offload_del(struct net_bridge_port *p)
> +{
> +	if (!p->accel_priv)
> +		return;
> +
> +	p->dev->netdev_ops->ndo_dfwd_del_station(p->dev, p->accel_priv);
> +	p->accel_priv = NULL;
> +}
