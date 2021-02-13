Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96EF231AE45
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 23:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhBMWYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 17:24:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57974 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhBMWYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 17:24:24 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 841384D2ADD3C;
        Sat, 13 Feb 2021 14:23:43 -0800 (PST)
Date:   Sat, 13 Feb 2021 14:23:26 -0800 (PST)
Message-Id: <20210213.142326.2016470334339829024.davem@davemloft.net>
To:     mathew.j.martineau@linux.intel.com
Cc:     netdev@vger.kernel.org, fw@strlen.de, kuba@kernel.org,
        mptcp@lists.01.org, matthieu.baerts@tessares.net
Subject: Re: [PATCH net-next 0/8] mptcp: Add genl events for connection info
From:   David Miller <davem@davemloft.net>
In-Reply-To: <b89e4be5-cac-af1d-1c1-2ce92fa55e10@linux.intel.com>
References: <20210213000001.379332-1-mathew.j.martineau@linux.intel.com>
        <b89e4be5-cac-af1d-1c1-2ce92fa55e10@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Sat, 13 Feb 2021 14:23:43 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Date: Fri, 12 Feb 2021 20:46:30 -0800 (PST)

> On Fri, 12 Feb 2021, Mat Martineau wrote:
> 
>> This series from the MPTCP tree adds genl multicast events that are
>> important for implementing a userspace path manager. In MPTCP, a path
>> manager is responsible for adding or removing additional subflows on
>> each MPTCP connection. The in-kernel path manager (already part of the
>> kernel) is a better fit for many server use cases, but the additional
>> flexibility of userspace path managers is often useful for client
>> devices.
>>
>> Patches 1, 2, 4, 5, and 6 do some refactoring to streamline the
>> netlink
>> event implementation in the final patch.
>>
>> Patch 3 improves the timeliness of subflow destruction to ensure the
>> 'subflow closed' event will be sent soon enough.
>>
>> Patch 7 allows use of the GENL_UNS_ADMIN_PERM flag on genl mcast
>> groups
>> to mandate CAP_NET_ADMIN, which is important to protect token
>> information
>> in the MPTCP events. This is a genetlink change.
>>
> 
> David -
> 
> I noticed that this series got merged to net-next and shows as
> "Accepted" in patchwork:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=0a2f6b32cc45e3918321779fe90c28f1ed27d2af
> 
> 
> However, somehow patch 7 did not propagate through the netdev list and
> does not show up in patchwork or the merged series!

I did put patch 7 into the commit, so no worries...
