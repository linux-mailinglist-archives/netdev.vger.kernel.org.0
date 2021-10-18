Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED62431024
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 08:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhJRGHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 02:07:31 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57759 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229533AbhJRGHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 02:07:31 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 432EA5C018A;
        Mon, 18 Oct 2021 02:05:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 18 Oct 2021 02:05:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=BiWPny
        J/W+lzFpsP4kXiVnmaGa3SLmP1Bl/bcwhD1UY=; b=jTIEOoHVnEUayQTRbpBaan
        KefSyLPT/gZ0EiuNiOapntqTTPkqYio3JmgOloaCx3e4sU+hd0V/y5FxRXP9HIPu
        A54sU4ZrXPcjQ1hRxafJh9qP024Q2616V6N/WC2s9X2ZmNB+hFax0BcN8wB4w3ek
        o9qnoNi3XbYuJncE0xtMxTLysb2VOW27OnI/o08tXSZejhIJn1rkj0YkdSoZ22V7
        6WEr+RCt0zDkAd/9FqJ4iQHSl4gWWGkyJLcRoquuMm/LMkCZpHsHmT8Jv93A0PHi
        tEvXapuHF6jwcfykmEX84b1Un7L4LK6eK3TgL1mYtEILp7kjX/CaliKmcsUpc2iw
        ==
X-ME-Sender: <xms:nw5tYQuMs9U2jAGVK_xSHsTk4MnS5gjxAIRdK8GIS6c-v-w0goNXrQ>
    <xme:nw5tYdeeXjlsXEmHBnU_UvfwJ99-aWbImKXmwRNSLeuaofGqqmq9w_FRE9STFO5Pe
    yjiNGvRGTkdJAI>
X-ME-Received: <xmr:nw5tYbwjk0cuXPmMGi-P7y-BAXC5IYyD157vQ_TcDFG_RZalCKPAV7i1wgKqMsIEu8mg7LRvqY3s3j5xMoEJtFAZf-Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdduledgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:nw5tYTOL9OmZ3PmAMXice8QF5qxTlVKZ3hNoYa7QdOkSDSUL6jeUVw>
    <xmx:nw5tYQ_bdhsiXEhrm2RcsiX3UpYQoylGnI77afAQ7NZxqH3mFXu94Q>
    <xmx:nw5tYbVbJe_c0he6UmVNlhr_1mv5yuUL-apqehzF-dy2hY0pVdYjww>
    <xmx:oA5tYQwKGOqfRk3kOFQge4C_N9Ejxk1nQBZ6SnT6AknJ0_w8_GeG1Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Oct 2021 02:05:19 -0400 (EDT)
Date:   Mon, 18 Oct 2021 09:05:14 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Amit Cohen <amcohen@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <YW0OmrRN0uFc6oiz@shredder>
References: <20211018105151.16ff248d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018105151.16ff248d@canb.auug.org.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 10:51:51AM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net-next tree got a conflict in:
> 
>   tools/testing/selftests/net/forwarding/forwarding.config.sample
> 
> between commit:
> 
>   0857d6f8c759 ("ipv6: When forwarding count rx stats on the orig netdev")
> 
> from the net tree and commit:
> 
>   45d45e5323a9 ("testing: selftests: forwarding.config.sample: Add tc flag")
> 
> from the net-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

Looks good to me. Thanks!
