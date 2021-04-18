Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9DD836344A
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 10:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhDRIE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 04:04:58 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:37479 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229605AbhDRIE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 04:04:57 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 457E95C011D;
        Sun, 18 Apr 2021 04:04:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 18 Apr 2021 04:04:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=qTeJWe
        P1iMniYFDsktUUrWalsdU7X2L/w5w1Udj6DKg=; b=NlxlVsZzqdTnnTtK+XJ3Mq
        REUR9f+gMcJKKRmwMqEB6qm3YSTvrhXGrAmPolj/VBrBe41aLV03A0ItOB6geRmX
        WTdBipMYhsDkTbj83E4wM7ONfvLhzA1mYq8F4A6980Se17L4lBRU+PjOWhH87R8e
        dC2917Awfbh+SsYQl80ZtCQf10sEhwyeTzHd6ouUa9NPMhyIxjW0kpkfkpFJsBIj
        XfwgintZFIkJ/1WafLET2UG4dWi6OppJGYZdDyiZHGu21eI0HVuOwaJnROZEjM9C
        Y2AcMJmVtx/M92G4LDfZ8412isZUgDzit5eOqPNOUvCnYZpgOd4USclP6NC5A9BA
        ==
X-ME-Sender: <xms:COh7YKgVEfNR1D_yvqHsbwfmLU8iYzRbSP8LpMXY5HZXU9Q6hgGerw>
    <xme:COh7YLBEkcaEKnCUu7w1ItYGQQGKy9H19dp_4GD6FY2Qd8VEm68LdSXz90z8x1uNN
    kM1ks5yKXxhDIo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelkedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtro
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepgfejvefhvdegiedukeetudevgeeuje
    efffeffeetkeekueeuheejudeltdejuedunecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:COh7YCG3MPkGv6w13sJJ2pG2E_k6wsKYpKFgid9EO-LSZNc3aGlGGA>
    <xmx:COh7YDQLlZMG17eOZAvGmJG-nOc9YsqdGrxidNDYXTZ-E_ZH7N4ptA>
    <xmx:COh7YHxBumZ0WSQiEP906LJ2bKIHICRtJWYkRlTChUM2iJY0fqIfhA>
    <xmx:Cuh7YJtMWGZErpQISSSzAGg4ut1pn7SJNgd3tAAV0rKz71HVIU6-wA>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id EB43224005A;
        Sun, 18 Apr 2021 04:04:23 -0400 (EDT)
Date:   Sun, 18 Apr 2021 11:04:16 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, idosch@nvidia.com, saeedm@nvidia.com,
        michael.chan@broadcom.com
Subject: Re: [PATCH net-next v2 6/9] ethtool: add interface to read RMON stats
Message-ID: <YHvoABffbJQxKmfI@shredder>
References: <20210416192745.2851044-1-kuba@kernel.org>
 <20210416192745.2851044-7-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416192745.2851044-7-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 12:27:42PM -0700, Jakub Kicinski wrote:
> +/**
> + * struct ethtool_rmon_hist_range - byte range for histogram statistics
> + * @low: low bound of the bucket (inclusive)
> + * @high: high bound of the bucket (inclusive)
> + */
> +struct ethtool_rmon_hist_range {
> +	u16 low;
> +	u16 high;

Given ETHTOOL_A_STATS_GRP_HIST_BKT_{LOW,HI} are u32, should this also be
u32?

> +};
