Return-Path: <netdev+bounces-2547-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EFB787027A8
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 10:57:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B837E1C20ADA
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 08:56:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB9AB8829;
	Mon, 15 May 2023 08:56:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17813D6D
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 08:56:58 +0000 (UTC)
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274F3C9;
	Mon, 15 May 2023 01:56:49 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VifMYvK_1684141006;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VifMYvK_1684141006)
          by smtp.aliyun-inc.com;
          Mon, 15 May 2023 16:56:47 +0800
From: Yang Li <yang.lee@linux.alibaba.com>
To: davem@davemloft.net
Cc: kuba@kernel.org,
	edumazet@google.com,
	sgoutham@marvell.com,
	gakula@marvell.com,
	sbhatta@marvell.com,
	hkelam@marvell.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yang Li <yang.lee@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH net-next] octeontx2-pf: mcs: Remove unneeded semicolon
Date: Mon, 15 May 2023 16:56:45 +0800
Message-Id: <20230515085645.43309-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

./drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c:242:2-3: Unneeded semicolon
./drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c:476:2-3: Unneeded semicolon

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4947
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
index 8eaa50d0f668..b59532cf53ce 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -239,7 +239,7 @@ static int cn10k_mcs_write_rx_secy(struct otx2_nic *pfvf,
 		cipher = MCS_GCM_AES_128;
 		dev_warn(pfvf->dev, "Unsupported key length\n");
 		break;
-	};
+	}
 
 	policy |= FIELD_PREP(MCS_RX_SECY_PLCY_CIP, cipher);
 	policy |= FIELD_PREP(MCS_RX_SECY_PLCY_VAL, secy->validate_frames);
@@ -473,7 +473,7 @@ static int cn10k_mcs_write_tx_secy(struct otx2_nic *pfvf,
 		cipher = MCS_GCM_AES_128;
 		dev_warn(pfvf->dev, "Unsupported key length\n");
 		break;
-	};
+	}
 
 	policy |= FIELD_PREP(MCS_TX_SECY_PLCY_CIP, cipher);
 
-- 
2.20.1.7.g153144c


