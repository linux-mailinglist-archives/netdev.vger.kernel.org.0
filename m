Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B84EF5D66C
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 20:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfGBSyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 14:54:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40036 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfGBSyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 14:54:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CFFBC134166F7;
        Tue,  2 Jul 2019 11:54:09 -0700 (PDT)
Date:   Tue, 02 Jul 2019 11:54:07 -0700 (PDT)
Message-Id: <20190702.115407.589130187506465260.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        martin@linuxlounge.net, bridge@lists.linux-foundation.org,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net 0/4] net: bridge: fix possible stale skb pointers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190702120021.13096-1-nikolay@cumulusnetworks.com>
References: <20190702120021.13096-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jul 2019 11:54:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Tue,  2 Jul 2019 15:00:17 +0300

> In the bridge driver we have a couple of places which call pskb_may_pull
> but we've cached skb pointers before that and use them after which can
> lead to out-of-bounds/stale pointer use. I've had these in my "to fix"
> list for some time and now we got a report (patch 01) so here they are.
> Patches 02-04 are fixes based on code inspection. Also patch 01 was
> tested by Martin Weinelt, Martin if you don't mind please add your
> tested-by tag to it by replying with Tested-by: name <email>.
> I've also briefly tested the set by trying to exercise those code paths.

Series applied, thanks.
