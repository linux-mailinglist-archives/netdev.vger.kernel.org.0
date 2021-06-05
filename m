Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C1A39C743
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 12:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbhFEKMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 06:12:19 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:4319 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhFEKMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 06:12:19 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FxwHq01Vwz1BJ6X;
        Sat,  5 Jun 2021 18:05:43 +0800 (CST)
Received: from dggema762-chm.china.huawei.com (10.1.198.204) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 18:10:29 +0800
Received: from huawei.com (10.175.127.227) by dggema762-chm.china.huawei.com
 (10.1.198.204) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sat, 5 Jun
 2021 18:10:29 +0800
From:   Yu Kuai <yukuai3@huawei.com>
To:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yukuai3@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH 00/13] fix dox warning in net/sched/sch_htb.c
Date:   Sat, 5 Jun 2021 18:18:32 +0800
Message-ID: <20210605101845.1264706-1-yukuai3@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema762-chm.china.huawei.com (10.1.198.204)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yu Kuai (13):
  sch_htb: fix doc warning in htb_add_to_wait_tree()
  sch_htb: fix doc warning in htb_next_rb_node()
  sch_htb: fix doc warning in htb_add_class_to_row()
  sch_htb: fix doc warning in htb_remove_class_from_row()
  sch_htb: fix doc warning in htb_activate_prios()
  sch_htb: fix doc warning in htb_deactivate_prios()
  sch_htb: fix doc warning in htb_class_mode()
  sch_htb: fix doc warning in htb_change_class_mode()
  sch_htb: fix doc warning in htb_activate()
  sch_htb: fix doc warning in htb_deactivate()
  sch_htb: fix doc warning in htb_charge_class()
  sch_htb: fix doc warning in htb_do_events()
  sch_htb: fix doc warning in htb_lookup_leaf()

 net/sched/sch_htb.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

-- 
2.31.1

