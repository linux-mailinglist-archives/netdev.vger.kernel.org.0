Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F3A21CBC7
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 00:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgGLWSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 18:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbgGLWSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 18:18:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB365C061794
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 15:18:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 932AD1284AF42;
        Sun, 12 Jul 2020 15:18:44 -0700 (PDT)
Date:   Sun, 12 Jul 2020 15:18:41 -0700 (PDT)
Message-Id: <20200712.151841.665763672459551082.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next] net: bridge: notify on vlan tunnel changes
 done via the old api
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200711150504.885831-1-nikolay@cumulusnetworks.com>
References: <20200711150504.885831-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 12 Jul 2020 15:18:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Sat, 11 Jul 2020 18:05:04 +0300

> If someone uses the old vlan API to configure tunnel mappings we'll only
> generate the old-style full port notification. That would be a problem
> if we are monitoring the new vlan notifications for changes. The patch
> resolves the issue by adding vlan notifications to the old tunnel netlink
> code. As usual we try to compress the notifications for as many vlans
> in a range as possible, thus a vlan tunnel change is considered able
> to enter the "current" vlan notification range if:
>  1. vlan exists
>  2. it has actually changed (curr_change == true)
>  3. it passes all standard vlan notification range checks done by
>     br_vlan_can_enter_range() such as option equality, id continuity etc
> 
> Note that vlan tunnel changes (add/del) are considered a part of vlan
> options so only RTM_NEWVLAN notification is generated with the relevant
> information inside.
> 
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

Applied, thank you.
