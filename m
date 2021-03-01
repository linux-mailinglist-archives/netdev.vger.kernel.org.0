Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA03327932
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 09:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232979AbhCAI22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 03:28:28 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:43207 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232965AbhCAI20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 03:28:26 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C428D5C00EB;
        Mon,  1 Mar 2021 03:27:16 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 01 Mar 2021 03:27:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=3VNe/Z
        IQjG0QqQLJGcIdV8/TBAtjFq/Dmnk92GJqRy4=; b=HrE7ekOFAtZromWAf3v0rU
        GXlkcV9Ji/97I4U6/br8rNmDzq2DuQh40oq2+GkNGAaOF5hA5/R+KmdqvQSwpLjJ
        u0WjKtpx2yT/aKtMIDiGIYagoePEtm/ntWWuXap+lUhgzqcMTGtYX39qEa0Yh+QK
        wipOwJBEcg/w9CyDOXmqFWJNqOkYvS0cWqbfCBUIX+dez3nfy10csmymZfSIexeo
        AOyF3rovJCSsF1hUlwsChW2+IGAadHqpLokFfuNOGdadMmDkKHoZS179SKuIwM0T
        WCRatdUaiTQNr5AA0zC8vyOyjm8++PrNBg8Bq2NyRcOS4o6dG3n+rPF9UI9MagJg
        ==
X-ME-Sender: <xms:ZKU8YIWXgavrrd9wTzwdhI3D9zUKHYSoG-f0Z-o-SzCqkuubz7uRxg>
    <xme:ZKU8YMkd4cAU0Ih9bwZ8i9U0S7hOsQWgVM12tV9JDHkVkHyFpMfOiBZAw8CuL8_GG
    awOh0nDiOCRlpI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleejgdduvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:ZKU8YMacSBt-BGN7ZnJ49tQsSKBWdHvjrglRxCTIaDq4vgPjldthGQ>
    <xmx:ZKU8YHUQMFoDp1VZe60B94YTntUxTA5UWUuXfPMXOOJNOSCsZRgP6w>
    <xmx:ZKU8YCnkX3OPhJf4ln0UAObrJX1ckd4-OGoKg3-udRKdvzE8A9kEuA>
    <xmx:ZKU8YDBRmavXgDJ05F_5V-72uBGhX5bMrVnB7pRWQ4_PtebYxye09g>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1AFCD1080057;
        Mon,  1 Mar 2021 03:27:15 -0500 (EST)
Date:   Mon, 1 Mar 2021 10:27:12 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        roopa@nvidia.com, sharpd@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net 1/2] nexthop: Do not flush blackhole nexthops
 when loopback goes down
Message-ID: <YDylYHA/FsQS4Oa3@shredder.lan>
References: <20210228142613.1642938-1-idosch@idosch.org>
 <20210228142613.1642938-2-idosch@idosch.org>
 <1db96a26-9500-aa3d-16ce-2774e6dcc5f2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1db96a26-9500-aa3d-16ce-2774e6dcc5f2@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 28, 2021 at 04:40:13PM -0700, David Ahern wrote:
> LGTM. I suggest submitting without the RFC.
> 
> Reviewed-by: David Ahern <dsahern@gmail.com>

Thanks, David. Will let it go through regression and submit later this
week.
