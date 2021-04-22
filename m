Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5CF367E0E
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 11:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235818AbhDVJpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 05:45:09 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:49999 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235809AbhDVJpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 05:45:04 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 7C9B610AC;
        Thu, 22 Apr 2021 05:44:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 22 Apr 2021 05:44:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=EAVKBY
        RCUAxx+DP9lvwCNC3TR2gLoQFsbf+1d0aMdVU=; b=uiFlVsX4DID8iQBUYF9f5U
        bSGiHTwcaMQXm6wG+Sueh09iJxKcE92qafU865L3BgQUHkqONE8l/dzE8xc2sU46
        P4HeAVD+U1IoxGAlVvolNDt+JrI30sC2Y3eX/iJZLifaot9YDEJzu84wh3qbRt+B
        Lp6A127qQWG6TCPAj8Mv8jcc2QoNFvq5RsiI0ox+40ZRQBAMXCJxOOfj0zI8OUbr
        /ROOY+qCCnljvk0c/Lm7B+NJi2rDvO5CJcthkpjHgB+S6DxB5uDEo5KpaHn8BDuE
        U0tr0qQ3uYmrGzKt+WSkXIteFoHg9gmKxnP2ZFE1dWgsEKlVoUnNTrtZh5RslSuQ
        ==
X-ME-Sender: <xms:e0WBYAa9E9e2GcMjjsdcXawNGjEHML2JuBzK7jbRW1ZKBEI_9WP9ag>
    <xme:e0WBYLb7uAxCOkNWmKaaiPzyrDqMujLOqQCyCqPkINku2hpwLDmWi7hfxwVbwPpJ2
    O92B8mUB5T5U1w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddutddgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtro
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepgfejvefhvdegiedukeetudevgeeuje
    efffeffeetkeekueeuheejudeltdejuedunecukfhppeekgedrvddvledrudehfedrudek
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:e0WBYK8IEXSpJsGEn0mNsFMgKNfeOWH6WIMfHVBHuIxo1unDjALUaw>
    <xmx:e0WBYKpYRcEW9-HAQ9gY_P-nEI7_ukeycMAuBHqWbv_gtyd1jOxUKw>
    <xmx:e0WBYLpAK_2wIhJEKtZ-_8_AR9d0YkMw1eWtO2MJpWzp-7fV0v0x6g>
    <xmx:fEWBYKTsLqWJYaSXnXwgX8Q5qch9Q4-UJ2cmoNAwvma0JuW2dUTvwg>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA id 555A6108005F;
        Thu, 22 Apr 2021 05:44:27 -0400 (EDT)
Date:   Thu, 22 Apr 2021 12:44:24 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH ethtool-next 7/7] netlink: stats: add on --all-groups
 option
Message-ID: <YIFFeDibFAmusGhM@shredder.lan>
References: <20210420003112.3175038-1-kuba@kernel.org>
 <20210420003112.3175038-8-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420003112.3175038-8-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 05:31:12PM -0700, Jakub Kicinski wrote:
> Add a switch for querying all statistic groups available
> in the kernel.
> 
> To reject --groups and --all-groups being specified
> for one request add a concept of "parameter equivalency"
> in the parser. Alternative of having a special group
> type like "--groups all" seems less clean.
> 
> Suggested-by: Ido Schimmel <idosch@nvidia.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Tested-by: Ido Schimmel <idosch@nvidia.com>

Thanks!
