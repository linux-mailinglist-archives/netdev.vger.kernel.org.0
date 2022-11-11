Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D543625441
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 08:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbiKKHIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 02:08:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233127AbiKKHIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 02:08:07 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B57779D0D;
        Thu, 10 Nov 2022 23:08:06 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N7qXV4X2VzHvmN;
        Fri, 11 Nov 2022 15:07:38 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 15:08:04 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <vburru@marvell.com>, <aayarekar@marvell.com>,
        <sburla@marvell.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 0/4] octeon_ep: fix several bugs in exception paths
Date:   Fri, 11 Nov 2022 15:08:01 +0800
Message-ID: <cover.1668150074.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Find several obvious bugs during code review in exception paths. Provide
this patchset to fix them. Not tested, just compiled.

Ziyang Xuan (4):
  octeon_ep: delete unnecessary napi rollback under set_queues_err in
    octep_open()
  octeon_ep: ensure octep_get_link_status() successfully before
    octep_link_up()
  octeon_ep: fix potential memory leak in octep_device_setup()
  octeon_ep: ensure get mac address successfully before
    eth_hw_addr_set()

 .../net/ethernet/marvell/octeon_ep/octep_main.c  | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

-- 
2.25.1

