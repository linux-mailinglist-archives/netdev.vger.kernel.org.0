Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4801433A4DD
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 13:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235450AbhCNMr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 08:47:27 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:46873 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235207AbhCNMrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 08:47:11 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id EC7015808B4;
        Sun, 14 Mar 2021 08:47:09 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 14 Mar 2021 08:47:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=t0m7jd
        tPqXIaqEcRWEY/GD8RkZot8D/MuiQxA9B2pYs=; b=ejydQnkGcNXaiKCSscCZ++
        ewRtl7FTPOSZEJpo+rhevzO+TdX9/RZbSTFylQDnLNthrj/z+MSQD3MtuV7YEeTm
        9xn6wJfFJGvKUuCXxCdUGGz+fkQSfi3vuqN0Y430SqabqN+bI43UYJXiUwtz9oqM
        eM75e9CDGD8uQPnu+rANJ9bHWLwTw6uk+g4zlNiY8ATUZIrhYsC+FIF9PJAkHT6Z
        Ab8ZLYbqPhM+7uonUNc/MrYllQGqyWaUTgmCA0YC/chYhuYek96CfPWeIn9z7NMw
        CHlP2NRYFCQW+83HIwrjf64Qx0sIx4J3A90cAeZ5waz9jj6sVwYxGhWPi7VUW6Tg
        ==
X-ME-Sender: <xms:zQVOYImOxbRrOC62a0FhBDpqlEu44XEzzKQrCY_XmxMzZCTZ1uHtLQ>
    <xme:zQVOYH3ibvLkOF6iRSU-5njEOIkTgT1YhGRIIJu7KUSJGFvjhvQi3dazqGw97DIBH
    5pL4R4EGKhAEe8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvjedgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:zQVOYGoVTwFsNTdYqTsgiXm2ZaTWguNYiNtUuEfXt-TjCi1IxkYuGQ>
    <xmx:zQVOYEnGhIpes_-hHQ8eu7moHxYLrXFynzfAsZ948I-Y6ieFTQUbmQ>
    <xmx:zQVOYG3HPZpL3x8zjKM-LDZa9YEu7mbf_oXk2dN1Aln_BiKMAk79lw>
    <xmx:zQVOYPkF-t5NpoGbdjtKa5Lz4w47aUD434ksm68pKkIyI_QdSZ4uYg>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id D1F03240057;
        Sun, 14 Mar 2021 08:47:08 -0400 (EDT)
Date:   Sun, 14 Mar 2021 14:47:06 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     rui.zhang@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, lukasz.luba@arm.com,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Amit Kucheria <amitk@kernel.org>,
        "open list:MELLANOX ETHERNET SWITCH DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 1/5] thermal/drivers/core: Use a char pointer for the
 cooling device name
Message-ID: <YE4FyiFgwM8cf5xe@shredder.lan>
References: <20210314111333.16551-1-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210314111333.16551-1-daniel.lezcano@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 14, 2021 at 12:13:29PM +0100, Daniel Lezcano wrote:
> We want to have any kind of name for the cooling devices as we do no
> longer want to rely on auto-numbering. Let's replace the cooling
> device's fixed array by a char pointer to be allocated dynamically
> when registering the cooling device, so we don't limit the length of
> the name.
> 
> Rework the error path at the same time as we have to rollback the
> allocations in case of error.
> 
> Tested with a dummy device having the name:
>  "Llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogoch"
> 
> A village on the island of Anglesey (Wales), known to have the longest
> name in Europe.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>

Tested-by: Ido Schimmel <idosch@nvidia.com>
