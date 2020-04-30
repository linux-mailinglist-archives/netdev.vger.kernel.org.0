Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913061C095D
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 23:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgD3VdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 17:33:13 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:48395 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbgD3VdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 17:33:12 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MuDLZ-1jBNLy1S1d-00uY02; Thu, 30 Apr 2020 23:31:55 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bing Zhao <bzhao@marvell.com>,
        Marc Yang <yangyang@marvell.com>,
        Ramesh Radhakrishnan <rramesh@marvell.com>,
        Kiran Divekar <dkiran@marvell.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Yogesh Ashok Powar <yogeshp@marvell.com>,
        Frank Huang <frankh@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Cathy Luo <xiaohua.luo@nxp.com>, James Cao <zheng.cao@nxp.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 03/15] mwifiex: avoid -Wstringop-overflow warning
Date:   Thu, 30 Apr 2020 23:30:45 +0200
Message-Id: <20200430213101.135134-4-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200430213101.135134-1-arnd@arndb.de>
References: <20200430213101.135134-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:gMEl41YFbv5VNowjvujQX1bH3XU15sf/EJ9rXogJvBQnt/sHj7H
 O2p++mED5GY1IUjnTdzdot3eCWrYutWmEBT6VRsXYMSwBS1bLyz+ZqBzfcUkyYV6iWVaKHN
 HQmyPesu8JEWYaVUg8tyLxSGDw0wD6s4ynsVQCXKFRZFafVz836k1aQocTn3vvLcihzCsjU
 SGGI7RkzszWYg5Eg8IuxA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Iefr0Y7FrDk=:3xVJsBu2lbVSWDdgd21qFQ
 pTfq+BIvkox+0xWPzM2TwfzqFKWqYhK9fvTojKD3U/6L2YQ/f+Sikwg4jXatAAWcye9lmRHnN
 FeVCZmiN1DbMh36QRHN4hi8jRE1amPmzr1AdNuZsesEm0LHaLZbe8K8Rte+SNPEIRFTr4vY1+
 CKBI9X0VZhtYkBVU/eeSSSnp2S3cQs2g0Tav76BbohvAN6r4gbd58fKyDq5PokBNlzLy3RmXX
 RvjWvGefF94Zkb11Y5x2ODRYH2tfOhNRyVRwMWazUkwbXceJpKE81UzNLrXQRRDPWwDjOtjwR
 hpqh02Zb82qfUM9nvvFa9+SQGQLU/6NzUQhq+1y9c42a/zpQSVEVOeLbHkxiR4xoS/o6On2ep
 3z3XQltx4vFbreny69BTpAZj72dwCCF4RI0LJikyl81VFlDIITjyjiMueRE6oDRdvypOw7zPG
 Ef9ooJgoNQ3S5dB+FWSKngRDgZs+KzHqxg4AHiLVly4hEVr7vLHUIEYVWm8IoO/p3UdAnmLxM
 n9uNxgELQx1Dy9CuMJrWYsyvXacGodE9+NoHFJHpizaiHGli/qfXRUNoloWhgga3pWGsx2YN0
 fNpn//idri55nJKGbO+oYCa0VyQeEdKM8lV3UnrWRaDO55e6FXf/1MWW1raWro6piMqcOrgY+
 sUymLvbiQaeMjMcdvKHv+eLH5d87rx+tKSo7Fy94VFb25ez9ejXHbCkCb4Zcw4QYNN8P4EMML
 6JBedCIp0OpjaFdx93P+LMdHzwYQs5LDkVb32jWSx/MN/qW4BDHqINuqCUbuHjNSg870Nlwyv
 T3sDpnz3h+hvNfHI5FbroNjYE8pkjtxb8A9sZfaw6srZtxVjpI=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gcc-10 reports a warning for mwifiex_cmd_802_11_key_material_v1:

drivers/net/wireless/marvell/mwifiex/sta_cmd.c: In function 'mwifiex_cmd_802_11_key_material_v1':
cc1: warning: writing 16 bytes into a region of size 0 [-Wstringop-overflow=]
In file included from drivers/net/wireless/marvell/mwifiex/sta_cmd.c:23:
drivers/net/wireless/marvell/mwifiex/fw.h:993:9: note: at offset 0 to object 'action' with size 2 declared here
  993 |  __le16 action;
      |         ^~~~~~

As the warning makes no sense, I reported it as a bug for gcc. In the
meantime using a temporary pointer for the key data makes the code easier
to read and stops the warning.

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=94881
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 .../net/wireless/marvell/mwifiex/sta_cmd.c    | 39 ++++++++-----------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index 0bd93f26bd7f..8bd355d7974e 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -853,43 +853,36 @@ mwifiex_cmd_802_11_key_material_v1(struct mwifiex_private *priv,
 		memset(&key_material->key_param_set, 0,
 		       sizeof(struct mwifiex_ie_type_key_param_set));
 	if (enc_key->is_wapi_key) {
+		struct mwifiex_ie_type_key_param_set *set;
+
 		mwifiex_dbg(priv->adapter, INFO, "info: Set WAPI Key\n");
-		key_material->key_param_set.key_type_id =
-						cpu_to_le16(KEY_TYPE_ID_WAPI);
+		set = &key_material->key_param_set;
+		set->key_type_id = cpu_to_le16(KEY_TYPE_ID_WAPI);
 		if (cmd_oid == KEY_INFO_ENABLED)
-			key_material->key_param_set.key_info =
-						cpu_to_le16(KEY_ENABLED);
+			set->key_info = cpu_to_le16(KEY_ENABLED);
 		else
-			key_material->key_param_set.key_info =
-						cpu_to_le16(!KEY_ENABLED);
+			set->key_info = cpu_to_le16(!KEY_ENABLED);
 
-		key_material->key_param_set.key[0] = enc_key->key_index;
+		set->key[0] = enc_key->key_index;
 		if (!priv->sec_info.wapi_key_on)
-			key_material->key_param_set.key[1] = 1;
+			set->key[1] = 1;
 		else
 			/* set 0 when re-key */
-			key_material->key_param_set.key[1] = 0;
+			set->key[1] = 0;
 
 		if (!is_broadcast_ether_addr(enc_key->mac_addr)) {
 			/* WAPI pairwise key: unicast */
-			key_material->key_param_set.key_info |=
-				cpu_to_le16(KEY_UNICAST);
+			set->key_info |= cpu_to_le16(KEY_UNICAST);
 		} else {	/* WAPI group key: multicast */
-			key_material->key_param_set.key_info |=
-				cpu_to_le16(KEY_MCAST);
+			set->key_info |= cpu_to_le16(KEY_MCAST);
 			priv->sec_info.wapi_key_on = true;
 		}
 
-		key_material->key_param_set.type =
-					cpu_to_le16(TLV_TYPE_KEY_MATERIAL);
-		key_material->key_param_set.key_len =
-						cpu_to_le16(WAPI_KEY_LEN);
-		memcpy(&key_material->key_param_set.key[2],
-		       enc_key->key_material, enc_key->key_len);
-		memcpy(&key_material->key_param_set.key[2 + enc_key->key_len],
-		       enc_key->pn, PN_LEN);
-		key_material->key_param_set.length =
-			cpu_to_le16(WAPI_KEY_LEN + KEYPARAMSET_FIXED_LEN);
+		set->type = cpu_to_le16(TLV_TYPE_KEY_MATERIAL);
+		set->key_len = cpu_to_le16(WAPI_KEY_LEN);
+		memcpy(&set->key[2], enc_key->key_material, enc_key->key_len);
+		memcpy(&set->key[2 + enc_key->key_len], enc_key->pn, PN_LEN);
+		set->length = cpu_to_le16(WAPI_KEY_LEN + KEYPARAMSET_FIXED_LEN);
 
 		key_param_len = (WAPI_KEY_LEN + KEYPARAMSET_FIXED_LEN) +
 				 sizeof(struct mwifiex_ie_types_header);
-- 
2.26.0

