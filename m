Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069821E4D03
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 20:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391960AbgE0SXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 14:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387699AbgE0SW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 14:22:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6B5C08C5C1;
        Wed, 27 May 2020 11:22:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 23A12128B1F1F;
        Wed, 27 May 2020 11:22:56 -0700 (PDT)
Date:   Wed, 27 May 2020 11:22:55 -0700 (PDT)
Message-Id: <20200527.112255.785601694284982795.davem@davemloft.net>
To:     natechancellor@gmail.com
Cc:     dsahern@kernel.org, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, roopa@cumulusnetworks.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH net-next] nexthop: Fix type of event_type in
 call_nexthop_notifiers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527080019.3489332-1-natechancellor@gmail.com>
References: <20200527080019.3489332-1-natechancellor@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 May 2020 11:22:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>
Date: Wed, 27 May 2020 01:00:20 -0700

> Clang warns:
> 
> net/ipv4/nexthop.c:841:30: warning: implicit conversion from enumeration
> type 'enum nexthop_event_type' to different enumeration type 'enum
> fib_event_type' [-Wenum-conversion]
>         call_nexthop_notifiers(net, NEXTHOP_EVENT_DEL, nh);
>         ~~~~~~~~~~~~~~~~~~~~~~      ^~~~~~~~~~~~~~~~~
> 1 warning generated.
> 
> Use the right type for event_type so that clang does not warn.
> 
> Fixes: 8590ceedb701 ("nexthop: add support for notifiers")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1038
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Applied, thanks.
