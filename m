Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381C03C7083
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 14:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236203AbhGMMkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 08:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236137AbhGMMkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 08:40:11 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC70C0613DD;
        Tue, 13 Jul 2021 05:37:21 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1626179839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=m8rIX22IAGVfsJ3iDpBk4wsSFJiQUHqAci2MV1lrwys=;
        b=i/+tzeMzZdY4Ywz4r+O+7GR+rNL4PqoEkQl4XEDqxxeD1/ortCaI3dnPMn6rCzQh355hT8
        m/jcbO8xaUkbSQpRlPcPrq+Xb6GCIMyebdI4zMRv0iBfpadceUpjHCcQPs683lwG/1sjEc
        3JjcZQQdRhVL3D5Ebn7yXLt6FdobgCE=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, yajun.deng@linux.dev,
        johannes.berg@intel.com, ryazanov.s.a@gmail.com, avagin@gmail.com,
        vladimir.oltean@nxp.com, roopa@cumulusnetworks.com,
        zhudi21@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/2] net: Use nlmsg_{multicast, unicast} that contain if statement
Date:   Tue, 13 Jul 2021 20:36:52 +0800
Message-Id: <20210713123654.31174-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch1: use nlmsg_{multicast, unicast} instead of netlink_
{broadcast,unicast} in rtnetlink.
Patch2: The caller no need deal with the if statements and use
the rename function.

Yajun Deng (2):
  rtnetlink: use nlmsg_{multicast, unicast} instead of
    netlink_{broadcast,unicast}
  net/sched: Remove unnecessary judgment statements

 include/linux/rtnetlink.h |  2 +-
 net/core/rtnetlink.c      | 13 +++++++------
 net/sched/act_api.c       | 20 ++++++--------------
 net/sched/cls_api.c       | 28 +++++++++++-----------------
 net/sched/sch_api.c       | 18 ++++++------------
 5 files changed, 31 insertions(+), 50 deletions(-)

-- 
2.32.0

