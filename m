Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 492B2610BF2
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 10:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiJ1IMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 04:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJ1IME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 04:12:04 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B9401863D9
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 01:12:03 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MzFcz3CdszHvJ8;
        Fri, 28 Oct 2022 16:11:47 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 28 Oct 2022 16:12:01 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 28 Oct
 2022 16:12:01 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <Steen.Hegelund@microchip.com>, <davem@davemloft.net>
Subject: [PATCH net-next] net: microchip: sparx5: kunit test: change test_callbacks and test_vctrl to static
Date:   Fri, 28 Oct 2022 16:11:06 +0800
Message-ID: <20221028081106.3595875-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

test_callbacks and test_vctrl are only used in vcap_api_kunit.c now,
change them to static.

Fixes: 67d637516fa9 ("net: microchip: sparx5: Adding KUNIT test for the VCAP API")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
index b01a6e5039b0..d142ed660338 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
@@ -204,7 +204,7 @@ static int vcap_test_port_info(struct net_device *ndev, enum vcap_type vtype,
 	return 0;
 }
 
-struct vcap_operations test_callbacks = {
+static struct vcap_operations test_callbacks = {
 	.validate_keyset = test_val_keyset,
 	.add_default_fields = test_add_def_fields,
 	.cache_erase = test_cache_erase,
@@ -216,7 +216,7 @@ struct vcap_operations test_callbacks = {
 	.port_info = vcap_test_port_info,
 };
 
-struct vcap_control test_vctrl = {
+static struct vcap_control test_vctrl = {
 	.vcaps = kunit_test_vcaps,
 	.stats = &kunit_test_vcap_stats,
 	.ops = &test_callbacks,
-- 
2.25.1

