Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F9A637017
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 02:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiKXB43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 20:56:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiKXB42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 20:56:28 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76BCE63172;
        Wed, 23 Nov 2022 17:56:27 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NHgxc6YMkzJnpy;
        Thu, 24 Nov 2022 09:53:08 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 09:56:25 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
CC:     <naveenm@marvell.com>, <rsaladi2@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 0/2] octeontx2: Fix several bugs in exception paths
Date:   Thu, 24 Nov 2022 09:56:22 +0800
Message-ID: <cover.1669253985.git.william.xuanziyang@huawei.com>
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

Ziyang Xuan (2):
  octeontx2-pf: Fix possible memory leak in otx2_probe()
  octeontx2-vf: Fix possible memory leak in otx2vf_probe()

 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c |  5 ++++-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c | 12 +++++++++---
 2 files changed, 13 insertions(+), 4 deletions(-)

-- 
2.25.1

