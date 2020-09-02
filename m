Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96CDA25B4EC
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 21:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgIBT6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 15:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgIBT6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 15:58:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8EF8C061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 12:58:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ADD0315634E26;
        Wed,  2 Sep 2020 12:42:00 -0700 (PDT)
Date:   Wed, 02 Sep 2020 12:58:46 -0700 (PDT)
Message-Id: <20200902.125846.1328960907241014780.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next v2 00/15] net: bridge: mcast: initial IGMPv3
 support (part 1)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200902112529.1570040-1-nikolay@cumulusnetworks.com>
References: <20200902112529.1570040-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 02 Sep 2020 12:42:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Wed,  2 Sep 2020 14:25:14 +0300

> Here're the sets that will come next (in order):
>  - Fast path patch-set which adds support for (S, G) mdb entries needed
>    for IGMPv3 forwarding, entry add source (kernel, user-space etc)
>    needed for IGMPv3 entry management, entry block mode needed for
>    IGMPv3 exclude mode. This set will also add iproute2 support for
>    manipulating and showing all the new state.
>  - Selftests patch-set which will verify all IGMPv3 state transitions
>    and forwarding
>  - Explicit host tracking patch-set, needed for proper fast leave and
>    with it fast leave will be enabled for IGMPv3
> 
> Not implemented yet:
>  - Host IGMPv3 support (currently we handle only join/leave as before)
>  - Proper other querier source timer and value updates
>  - IGMPv3/v2 compat (I have a few rough patches for this one)

What about ipv6 support?  The first thing I notice when reading these
patches is the source filter code only supports ipv4.
