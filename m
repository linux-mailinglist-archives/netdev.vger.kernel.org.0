Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFB342A599
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236767AbhJLN1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:27:55 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51283 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236626AbhJLN1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 09:27:54 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id AF9EE5C0176;
        Tue, 12 Oct 2021 09:25:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 12 Oct 2021 09:25:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Auc3LZ98p3kqT/ly0kMdqYJd0QUoNR9OPLaUEumg1EE=; b=DdKqxxcm
        d9V2GhUr6xNwcOyTl5sis5xA3EpNoEccS70p7ibHfdn8vlsU1Iqh+qeuWGhRpBO6
        FrE+kCDgp8rBtl4edksTdz3n2RHROpFSF09E2gJ9dMRq7wtRX250Wn5pKkr48fqq
        cdJBnuAWGRgSSD3TNVzV6xPxh6ziaNKeUDgfIvlv1YAV4WTjOXB17bis2EXvx2Lb
        GZFDLJeymQEKy7HhJ2Pp5nnHjwhxCGHp89M2or13uAbOn04RJGV+URXohYo1Adl0
        JkJudTApV252ny+ilWCuneGR7zZyrDpvn8eMCrmUUbLr6vNoxRhqxAdTnq/DXQLX
        nOZ8GmKNdvm63Q==
X-ME-Sender: <xms:4IxlYSdtJcCMc-Zc1guC_DOMFIVdvpP3YgyVzswlYHeT15m2c4H4cA>
    <xme:4IxlYcOf6ilWdZqgTIMwk45pN2FZvCiIOaFa0iTmr9m6vI1hBUtIUZFDFqgoDn-vC
    U7j2lFXDpUlqV0>
X-ME-Received: <xmr:4IxlYTiQk_04c2sctiBBvn_s9VkRB2mq0qSODO7mqK-ddZhkPfRI6zx2XPNUR4Yo3inCI09U8wbIfZJYCI-AEIUjfGCVS1Voniaaq9CTxzZGxA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtkedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:4IxlYf8j6lOQB_WztKp0TDvmUpQYA9dMVH3ZwoepjOiyxgs8JDaSdw>
    <xmx:4IxlYesxYKRm-CJlU2L1RdO2LhUR_zPH6NHrNRn9V0J5dfLgLmyWSw>
    <xmx:4IxlYWH_WLnARAuq_nKfznFGpdtJsw22XH2z7ya_dv0283HsuTyxzw>
    <xmx:4IxlYQKKrhKhZL6cMRH5rm231j7TsXYI5tUSYF8AWcIelqipeVIgpw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 Oct 2021 09:25:50 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 01/14] cmis: Rename CMIS parsing functions
Date:   Tue, 12 Oct 2021 16:25:12 +0300
Message-Id: <20211012132525.457323-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012132525.457323-1-idosch@idosch.org>
References: <20211012132525.457323-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Currently, there are two CMIS parsing functions. qsfp_dd_show_all() and
cmis_show_all(). The former is called from the IOCTL path with a buffer
containing EEPROM contents and the latter is called from the netlink
path with pointer to individual EEPROM pages.

Rename them with '_ioctl' and '_nl' suffixes to make the distinction
clear.

In subsequent patches, these two functions will only differ in the way
they initialize the CMIS memory map for parsing, while the parsing code
itself will be shared between the two.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 cmis.c                  | 6 +++---
 cmis.h                  | 6 +++---
 netlink/module-eeprom.c | 2 +-
 qsfp.c                  | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/cmis.c b/cmis.c
index 591cc72953b7..68c5b2d3277b 100644
--- a/cmis.c
+++ b/cmis.c
@@ -326,7 +326,7 @@ static void cmis_show_vendor_info(const __u8 *id)
 			       "CLEI code");
 }
 
-void qsfp_dd_show_all(const __u8 *id)
+void cmis_show_all_ioctl(const __u8 *id)
 {
 	cmis_show_identifier(id);
 	cmis_show_power_info(id);
@@ -340,8 +340,8 @@ void qsfp_dd_show_all(const __u8 *id)
 	cmis_show_rev_compliance(id);
 }
 
-void cmis_show_all(const struct ethtool_module_eeprom *page_zero,
-		   const struct ethtool_module_eeprom *page_one)
+void cmis_show_all_nl(const struct ethtool_module_eeprom *page_zero,
+		      const struct ethtool_module_eeprom *page_one)
 {
 	const __u8 *page_zero_data = page_zero->data;
 
diff --git a/cmis.h b/cmis.h
index e3012ccfdd79..734b90f4ddb4 100644
--- a/cmis.h
+++ b/cmis.h
@@ -120,9 +120,9 @@
 #define YESNO(x) (((x) != 0) ? "Yes" : "No")
 #define ONOFF(x) (((x) != 0) ? "On" : "Off")
 
-void qsfp_dd_show_all(const __u8 *id);
+void cmis_show_all_ioctl(const __u8 *id);
 
-void cmis_show_all(const struct ethtool_module_eeprom *page_zero,
-		   const struct ethtool_module_eeprom *page_one);
+void cmis_show_all_nl(const struct ethtool_module_eeprom *page_zero,
+		      const struct ethtool_module_eeprom *page_one);
 
 #endif /* CMIS_H__ */
diff --git a/netlink/module-eeprom.c b/netlink/module-eeprom.c
index 48cd2cc55bee..fc4ef1a53aff 100644
--- a/netlink/module-eeprom.c
+++ b/netlink/module-eeprom.c
@@ -332,7 +332,7 @@ static void decoder_print(void)
 		break;
 	case SFF8024_ID_QSFP_DD:
 	case SFF8024_ID_DSFP:
-		cmis_show_all(page_zero, page_one);
+		cmis_show_all_nl(page_zero, page_one);
 		break;
 	default:
 		dump_hex(stdout, page_zero->data, page_zero->length, page_zero->offset);
diff --git a/qsfp.c b/qsfp.c
index 3f37f1036e96..27fdd3bd1771 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -856,7 +856,7 @@ static void sff8636_show_page_zero(const __u8 *id)
 void sff8636_show_all(const __u8 *id, __u32 eeprom_len)
 {
 	if (id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP_DD) {
-		qsfp_dd_show_all(id);
+		cmis_show_all_ioctl(id);
 		return;
 	}
 
-- 
2.31.1

