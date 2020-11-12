Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88C92B08C5
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728756AbgKLPqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:46:33 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:48661 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728732AbgKLPqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:46:31 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id D0292580402;
        Thu, 12 Nov 2020 10:46:30 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 12 Nov 2020 10:46:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ecba3g
        Rjc7G1F4YiLCFkhsZZYY4GbaNTefv9Zd/5+Bw=; b=j87mxMN55s9hlmJwHu5/4G
        Mp7Za3bVZZ/MSDBjG4qeHeIhUSdlZqt3X5VW9a7PZiyTNyiJOJ4sEBd4yKe9Dj6e
        AMUk53JZ/r4uymKPLUpdbpux8D8qqRZgqJgocoErV3MaU/XGY5Ve4euZf3LU5doL
        Bg9T1o48hdaM4/lA8Q4MEUOLRN2IH0qNnsFVq0duhMcBHI17Ea48ZtHyLLU/r9h2
        437xirG3tauSflUmT37mMoFhnc6Ne4ruL6IKJvPLse/iMhHq8+BBRy7o8Tnl/rJz
        crqawUt7AQ2vdpGvBE1AwuOTWCJsoHvPV4nC8LH2lQ/GMuOlEXqq1QESp1y6M+Dw
        ==
X-ME-Sender: <xms:1litX8njf1x8J4XcsDdVZydERgrKJekXX1G3jDlZTyLlENsgJwgqag>
    <xme:1litX72uXNxkV0BToLncl_QBZnW6RYzIn4xQLgLNz6xHUJO5cPZYh5cPF7fv7MMVS
    -Zz106lLZBG4Hw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvfedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheegrddugeejnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:1litX6qMEAywc8J7Govrhwqs93GtcVvQvTz_yZTQv1xsN0EpCHOPWQ>
    <xmx:1litX4kMCF-v_4CGMMO7C8hN_5wkgaY_lAMnuO0eyNYX0nBFXCAFfg>
    <xmx:1litX60wQEqGaIHqKL5oh8-cjSTd-iNtP8pClrWfi1Fdwgpsfl-qfA>
    <xmx:1litXzli86zu2hGigZBi7U61o0bWWx-Asv4VZfLasZw_XzI7kSP6zg>
Received: from localhost (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 412853067A2D;
        Thu, 12 Nov 2020 10:46:30 -0500 (EST)
Date:   Thu, 12 Nov 2020 17:46:27 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Moshe Shemesh <moshe@nvidia.com>,
        Itay Aveksis <itayav@nvidia.com>,
        Ran Rozenstein <ranro@nvidia.com>, tariqt@nvidia.com
Subject: Re: bug report: WARNING in bonding
Message-ID: <20201112154627.GA2138135@shredder>
References: <fb299ee2-4cf0-31d8-70f4-874da43e0021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb299ee2-4cf0-31d8-70f4-874da43e0021@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 05:38:44PM +0200, Tariq Toukan wrote:
> Hi all,
> 
> In the past ~2-3 weeks, we started seeing the following WARNING and traces
> in our regression testing systems, almost every day.
> 
> Reproduction is not stable, and not isolated to a specific test, so it's
> hard to bisect.
> 
> Any idea what could this be?
> Or what is the suspected offending patch?

Do you have commit f8e48a3dca06 ("lockdep: Fix preemption WARN for spurious
IRQ-enable")? I think it fixed the issue for me
