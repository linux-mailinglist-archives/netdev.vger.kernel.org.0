Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65AC7481879
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbhL3CWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbhL3CWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 21:22:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F168C061574
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 18:22:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 604BBCE1AAD
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 02:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBD9C36AE1;
        Thu, 30 Dec 2021 02:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640830969;
        bh=K7zXGlj0HeueXYI2pKFbkA4//Qfs10qK/KdEgfE6Fc4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nGh1MmN1OwmiTKu9EGd3mdVTNbS4oSqABywv/4JMmBzSiz90n69rvmjk4lcB2bBL6
         6VuTEdPSn1Db82NuNzeVDAW2H6Ocb/jWQT/AmIYgwoWkwq+D4k449VjPU+4m6lDc4m
         NGZRko7cdeI6T+8HKGcQsll3iLZcEcicBReAJ6Lc+eYMzC6O1nc9P7qdPXvzz8AVSB
         lDZERxI1iZQsohDGZzrJlH03g6L+ORbwrzotXBWIGCaRiOMsK45RMU3IlwFc6jXRj1
         Uc40kvTg/dvzKcjdMTEdexLgJ2gXJjwIIXrsyfUMz0ox2NN+xsBdhQ2sjPHtJdAnu3
         CmiTkp6JpCGxg==
Date:   Wed, 29 Dec 2021 18:22:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arthur Kiyanovski <akiyano@amazon.com>
Cc:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>
Subject: Re: [PATCH V1 net 3/3] net: ena: Fix error handling when
 calculating max IO queues number
Message-ID: <20211229182247.7886a8f9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211229140021.8053-4-akiyano@amazon.com>
References: <20211229140021.8053-1-akiyano@amazon.com>
        <20211229140021.8053-4-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Dec 2021 14:00:21 +0000 Arthur Kiyanovski wrote:
> Fixes: 736ce3f414c ("net: ena: make ethtool -l show correct max number of queues")

Fixes tag: Fixes: 736ce3f414c ("net: ena: make ethtool -l show correct max number of queues")
Has these problem(s):
	- SHA1 should be at least 12 digits long
	  Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
	  or later) just making sure it is not set (or set to "auto").
