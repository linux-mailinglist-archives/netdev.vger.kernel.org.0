Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8F963E774
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 03:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiLACGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 21:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiLACGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 21:06:51 -0500
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB3B63D41;
        Wed, 30 Nov 2022 18:06:50 -0800 (PST)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxct.zte.com.cn (FangMail) with ESMTPS id 4NMzw93Tbtz4y0v0;
        Thu,  1 Dec 2022 10:06:49 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.40.50])
        by mse-fl2.zte.com.cn with SMTP id 2B126g6R046935;
        Thu, 1 Dec 2022 10:06:42 +0800 (+08)
        (envelope-from zhang.songyi@zte.com.cn)
Received: from mapi (xaxapp01[null])
        by mapi (Zmail) with MAPI id mid31;
        Thu, 1 Dec 2022 10:06:42 +0800 (CST)
Date:   Thu, 1 Dec 2022 10:06:42 +0800 (CST)
X-Zmail-TransId: 2af963880c32ffffffffd06acfa2
X-Mailer: Zmail v1.0
Message-ID: <202212011006426677429@zte.com.cn>
Mime-Version: 1.0
From:   <zhang.songyi@zte.com.cn>
To:     <lars.povlsen@microchip.com>
Cc:     <steen.hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <unglinuxdriver@microchip.com>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIG5ldC1uZXh0XSBuZXQ6IG1pY3JvY2hpcDogdmNhcDogUmVtb3ZlIHVubmVlZGVkIHNlbWljb2xvbnM=?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 2B126g6R046935
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.251.13.novalocal with ID 63880C39.000 by FangMail milter!
X-FangMail-Envelope: 1669860409/4NMzw93Tbtz4y0v0/63880C39.000/10.5.228.133/[10.5.228.133]/mse-fl2.zte.com.cn/<zhang.songyi@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 63880C39.000/4NMzw93Tbtz4y0v0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhang songyi <zhang.songyi@zte.com.cn>

Semicolons after "}" are not needed.

Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>
---
 drivers/net/ethernet/microchip/vcap/vcap_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 93efa8243b02..b8df3cf32f1f 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -1394,7 +1394,7 @@ static void vcap_copy_from_client_keyfield(struct vcap_rule *rule,
                vcap_copy_to_w32be(field->data.u128.value, data->u128.value, size);
                vcap_copy_to_w32be(field->data.u128.mask,  data->u128.mask, size);
                break;
-       };
+       }
 }

 /* Check if the keyfield is already in the rule */
@@ -1584,7 +1584,7 @@ static void vcap_copy_from_client_actionfield(struct vcap_rule *rule,
        case VCAP_FIELD_U128:
                vcap_copy_to_w32be(field->data.u128.value, data->u128.value, size);
                break;
-       };
+       }
 }

 /* Check if the actionfield is already in the rule */
--
2.25.1
