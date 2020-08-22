Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B38124E971
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 21:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728661AbgHVTmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 15:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728639AbgHVTmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 15:42:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E51C061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 12:42:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C476C15CFB426;
        Sat, 22 Aug 2020 12:25:24 -0700 (PDT)
Date:   Sat, 22 Aug 2020 12:42:09 -0700 (PDT)
Message-Id: <20200822.124209.2224829060342809395.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        syzbot+a61aa19b0c14c8770bd9@syzkaller.appspotmail.com
Subject: Re: [PATCH net v2] net: nexthop: don't allow empty NHA_GROUP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200822120636.194237-1-nikolay@cumulusnetworks.com>
References: <20200822103340.184978-1-nikolay@cumulusnetworks.com>
        <20200822120636.194237-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Aug 2020 12:25:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Sat, 22 Aug 2020 15:06:36 +0300

> Currently the nexthop code will use an empty NHA_GROUP attribute, but it
> requires at least 1 entry in order to function properly. Otherwise we
> end up derefencing null or random pointers all over the place due to not
> having any nh_grp_entry members allocated, nexthop code relies on having at
> least the first member present. Empty NHA_GROUP doesn't make any sense so
> just disallow it.
> Also add a WARN_ON for any future users of nexthop_create_group().
 ...
> CC: David Ahern <dsahern@gmail.com>
> Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
> Reported-by: syzbot+a61aa19b0c14c8770bd9@syzkaller.appspotmail.com
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

Applied and queued up for -stable, thanks.
