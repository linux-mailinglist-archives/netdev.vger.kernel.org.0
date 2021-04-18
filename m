Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C818B363452
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 10:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhDRIYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 04:24:51 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55091 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229585AbhDRIYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 04:24:49 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id BD2435C0043;
        Sun, 18 Apr 2021 04:24:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 18 Apr 2021 04:24:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=vKuIlh
        l4afq2JB9nbx5/nVWHiC81ACtaB3YuuSwX3zo=; b=lOtP+CzkW25gZBktGfrDAl
        X/qfK6Bc/gqhrdcj9TC6A2HvB6IQvbKAFy4S1p8GVODM76qYszNy4y2eIqakKiLb
        QcF868nqI6TNRQ2C31jxJtg0B6moPNMp6yiRwRzuLgWsQ6XI+AciSe3VQlr8iPG0
        8xMHaxTo7IJGhVECsCnvAozxqrat65fPgAQEIgo0Z97uCrFbZz8aetXQtFkrtMUg
        U1RgAzS7th1bL6vaHin6NQ/xwuTR+DPyLwa4MWcPJaFf65uRDNbxbC4bYhZ1GYuJ
        EHWgH2Uc9DamBGwVZOore1DxXOWYvC5VytJsTKIoEiIUsVMW0e5EomiS4C/pO7nA
        ==
X-ME-Sender: <xms:tOx7YJORFhxjA5CwWNU9fOYSmzsMp7kW1kl652SgqiFV13L12j5OUg>
    <xme:tOx7YL8p4DFqOnKovVQUox4HWQ2iyCeAAF_2dK1QLRXtcluBpXkMkZJkimnJYX1Sf
    iL2PBTUANUx1WY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelkedgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepveejtdegteevlefgtdfgueekveegje
    duieetvdduvdetveffgfelgeegfeetgfeunecuffhomhgrihhnpehgihhthhhusgdrtgho
    mhdpshhhohifmhgrgidrtghomhenucfkphepudelfedrgeejrdduieehrddvhedunecuve
    hluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:tOx7YIS4Z7ct_FPF8Iqk4j4_1G4-1nS2L6pqrcYzf1rwbcHu-_ynhw>
    <xmx:tOx7YFuUgx2VAPW_z158n5ssa-6AhXuKm2Bpk9ai4_e3O0h5Cw5arw>
    <xmx:tOx7YBexd7J1cct8cIT85QL5GrN1Iv4GfiyX6C4rCVvRMMhEkJCAJQ>
    <xmx:tex7YI4AqHXIFwlIdqUede7NmJN1HeOcgM2PFcWt2fzYTG_0Day8AA>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E3C041080067;
        Sun, 18 Apr 2021 04:24:19 -0400 (EDT)
Date:   Sun, 18 Apr 2021 11:24:17 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, idosch@nvidia.com, saeedm@nvidia.com,
        michael.chan@broadcom.com
Subject: Re: [PATCH net-next 0/9] ethtool: add uAPI for reading standard stats
Message-ID: <YHvssTvheST9nE6d@shredder>
References: <20210416022752.2814621-1-kuba@kernel.org>
 <YHmw2tmhFGWFTzPo@shredder.lan>
 <20210416090816.3f805b96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416090816.3f805b96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 09:08:16AM -0700, Jakub Kicinski wrote:
> On Fri, 16 Apr 2021 18:44:26 +0300 Ido Schimmel wrote:
> > Given that you have now standardized these stats, do you plan to feed
> > them into some monitoring system? 
> 
> Yes and no, I'm only intending to replace the internal FB ethtool
> scraping script with these stats..

Cool

> 
> > For example, Prometheus has an ethtool
> > exporter [1] and now I see that support is also being added to
> > node_exporter [2] where it really belongs. They obviously mentioned [3]
> > the problem with lack of standardization: "There is also almost no
> > standardization, so if you use multiple network card vendors, you have
> > to examine the data closely to find out what is useful to you and set up
> > your alerts and dashboards accordingly."
> > 
> > [1] https://github.com/Showmax/prometheus-ethtool-exporter
> > [2] https://github.com/prometheus/node_exporter/pull/1832
> > [3] https://tech.showmax.com/2018/11/scraping-ethtool-data-into-prometheus/
>  
> Wow, are you working with those projects? We should probably let them
> know about the patches.

I'm mostly a user, not a contributor (wrote some exporters of my own).
I'll drop a comment there once your patches are in net-next.
