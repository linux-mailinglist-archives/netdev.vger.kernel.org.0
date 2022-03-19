Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B85B4DE53E
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 03:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241801AbiCSC5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 22:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233889AbiCSC5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 22:57:18 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE1C29B105;
        Fri, 18 Mar 2022 19:55:58 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KL59P2Dq6zcb0s;
        Sat, 19 Mar 2022 10:55:53 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 19 Mar 2022 10:55:55 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <borisp@nvidia.com>, <john.fastabend@gmail.com>,
        <daniel@iogearbox.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <pabeni@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v2 0/2] net/tls: some optimizations for tls
Date:   Sat, 19 Mar 2022 11:13:34 +0800
Message-ID: <cover.1647658604.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do some small optimizations for tls, including jump instructions
optimization, and judgement processes optimization.

---
v1-v2:
  - Delete a new line before "return rc;" in patch 2.

Ziyang Xuan (2):
  net/tls: remove unnecessary jump instructions in
    do_tls_setsockopt_conf()
  net/tls: optimize judgement processes in tls_set_device_offload()

 net/tls/tls_device.c | 62 ++++++++++++++++++++++----------------------
 net/tls/tls_main.c   | 15 ++++-------
 2 files changed, 36 insertions(+), 41 deletions(-)

-- 
2.25.1

