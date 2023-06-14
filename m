Return-Path: <netdev+bounces-10729-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37E5F730015
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 15:30:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF8272813BB
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CBCDAD4E;
	Wed, 14 Jun 2023 13:30:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B01613F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 13:30:20 +0000 (UTC)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCCE91FF9;
	Wed, 14 Jun 2023 06:30:18 -0700 (PDT)
Received: from evilbit.green-communications.fr ([92.154.77.116]) by
 mrelayeu.kundenserver.de (mreue109 [213.165.67.119]) with ESMTPSA (Nemesis)
 id 1MDQqe-1qJuy03YJS-00ARru; Wed, 14 Jun 2023 15:29:58 +0200
From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
To: Johannes Berg <johannes@sipsolutions.net>,
	Ilan Peer <ilan.peer@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH] wifi: mac80211: Remove "Missing iftype sband data/EHT cap" spam
Date: Wed, 14 Jun 2023 15:26:48 +0200
Message-Id: <20230614132648.28995-1-nicolas.cavallari@green-communications.fr>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:p5lfg+3UXicIZGYb0JHBflhBj7jnvcIRt9qFuBHqNbyMdrCOc2e
 AY5V5fkpw+FrSQwtCzbsyHwZw6KZe+FwpLyj0M9Si4vhJkS+OK+cxqg4msBOVR1UQmAbh08
 67myYFo30cXM0zBRZQI/NeoydyJAUiGzEiIEPhQG1rxq+f6n3/uSLYAastEy7utVuY/S8ew
 Pc2DM4R5u7mQetJkpcSFQ==
UI-OutboundReport: notjunk:1;M01:P0:3IuVxyuHRuI=;tkE++l+Jmdeqi4kp51P6qk9MIRK
 WzSJcETRA8pw79iwFGrvBdV1LlyK/i17+3e2ryao3Kwv4akqfc+Q4/AELW7E0C8Do/CyG3TTX
 C+rY3ztWJrEhpg5iS1cf3z5/JP4r2foy9qAzypp6w5p+tnY/XSzuDKZa4FxM5jIbF3fA5WV+E
 smpUfP5EYd7r4pKs0800NaQobSDWjzs6L0KNJF/RkOAo4MaiDHFKDQA9u7/heBY9Cx8MFjRq1
 EqnC+wOSjeEbsA51bw9/DsN8klHJab7xPOmR0rZA0rf0y+dvrKQkYWDXLwtB2LU9RnkbWkLT7
 Vz7g5DpWOXA9jM14F8PGsIJY4/5Y48iDqZWo4B6baLXNAQVUkjz0qudOOSsy/g4ZUY7GJw+kD
 +a68zkLk04MtMNuQCXtR5KYdC+A+UfEyQhmwKIq2nxsv7yTNiRJxhplZ3Ppsq2VbW2Js6yZoS
 uzCbBqaSvApwmLMag0mpusr4KodSHutAc+XcUhKRXwV0MclEAxv6dVWMpDbAx4mf/8PntwNhb
 KKfUw1q/XnKz3dAZ9pezO5ZnNbcvQtf2fKJpHuKnJJYhijUm7wx4DCvv91Zo16gYq/FbSrFa3
 AdRT9aygAr36WMNbmHBklq+otL1wXDrbxvmgjyPbPwz+FUMQfL92PtkBAtVcpo1bG9jbip9dy
 sFTkOgmMqTbsV8GHRvWJYVhd+M+sUtJUoXKHdOJ6Vg==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In mesh mode, ieee80211_chandef_he_6ghz_oper() is called by
mesh_matches_local() for every received mesh beacon.

On a 6 GHz mesh of a HE-only phy, this spams that the hardware does not
have EHT capabilities, even if the received mesh beacon does not have an
EHT element.

Unlike HE, not supporting EHT in the 6 GHz band is not an error so do
not print anything in this case.

Fixes: 5dca295dd767 ("mac80211: Add initial support for EHT and 320 MHz channels")

Signed-off-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
---
 net/mac80211/util.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 3bd07a0a782f..325a1e107240 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3801,10 +3801,8 @@ bool ieee80211_chandef_he_6ghz_oper(struct ieee80211_sub_if_data *sdata,
 	}
 
 	eht_cap = ieee80211_get_eht_iftype_cap(sband, iftype);
-	if (!eht_cap) {
-		sdata_info(sdata, "Missing iftype sband data/EHT cap");
+	if (!eht_cap)
 		eht_oper = NULL;
-	}
 
 	he_6ghz_oper = ieee80211_he_6ghz_oper(he_oper);
 
-- 
2.40.1


