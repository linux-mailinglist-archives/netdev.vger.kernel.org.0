Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF77912B8
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 21:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfHQThM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 15:37:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55522 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfHQThL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 15:37:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 525C114DB6DFE;
        Sat, 17 Aug 2019 12:37:11 -0700 (PDT)
Date:   Sat, 17 Aug 2019 12:37:10 -0700 (PDT)
Message-Id: <20190817.123710.1132912615652102377.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next v3 0/4] net: bridge: mdb: allow dump/add/del
 of host-joined entries
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190817112213.27097-1-nikolay@cumulusnetworks.com>
References: <20190816.130417.1610388599335442981.davem@davemloft.net>
        <20190817112213.27097-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 17 Aug 2019 12:37:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Sat, 17 Aug 2019 14:22:09 +0300

> This set makes the bridge dump host-joined mdb entries, they should be
> treated as normal entries since they take a slot and are aging out.
> We already have notifications for them but we couldn't dump them until
> now so they remained hidden. We dump them similar to how they're
> notified, in order to keep user-space compatibility with the dumped
> objects (e.g. iproute2 dumps mdbs in a format which can be fed into
> add/del commands) we allow host-joined groups also to be added/deleted via
> mdb commands. That can later be used for L2 mcast MAC manipulation as
> was recently discussed. Note that iproute2 changes are not necessary,
> this set will work with the current user-space mdb code.
> 
> Patch 01 - a trivial comment move
> Patch 02 - factors out the mdb filling code so it can be
>            re-used for the host-joined entries
> Patch 03 - dumps host-joined entries
> Patch 04 - allows manipulation of host-joined entries via standard mdb
>            calls
> 
> v3: fix compiler warning in patch 04 (DaveM)
> v2: change patch 04 to avoid double notification and improve host group
>     manual removal if no ports are present in the group

Series applied.
