Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B3D42A5A0
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236834AbhJLN2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:28:05 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48621 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236830AbhJLN2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 09:28:04 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id EF56B5C0150;
        Tue, 12 Oct 2021 09:26:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 12 Oct 2021 09:26:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=ZQw9IvCceAxotoo/fzpjzTsbxsP1q501I3GP85Du6YU=; b=cjn5CWD8
        NGL6c1TZWX4BBgS5bfVTNP6xlGz4WxrRSIn77k01nmcNpTgVTf29rr8R+NYYyzMQ
        CG1CL61VRFNOqEoNF2GX4oRw/+nQAAmHSkCDFUP0lENWnRqabZQ0MAkhOLCtv/Zk
        BetZ/S8D2k9wg9+0CxZlON2Tdqna/vb92owhKVbZigjjlL9sZQDZxfbzz7GuOhGU
        gl/Vm7wpRjFNzeqUhdmHWYaebOuMPxWLT1iUwYLm6F4t3OFFyJISAStzkWiQjEfD
        0MMSfSfWmLLGC5c+gVLGqO2+O6g3P85la2vqn/P6avRO85397ZVV2zgvoiywL44z
        zuW0wpvOgP0ldQ==
X-ME-Sender: <xms:6oxlYbENA0nHpr8R3cqUTEP6A9sPrwXBTkNC_dYgGa12PhDBcQ7iMw>
    <xme:6oxlYYX2uzlNsiMv1THVBgCPgGQ50YjMxqzow8_9DNMHqNsAL_CxE0TVBhjGUvxOM
    yeSTfcT9v_e3PU>
X-ME-Received: <xmr:6oxlYdLMfwTc29Zb61nFbEwqYUeUC5QhBO3JE2fuXGy0LN0FZf_C8pU1buq-VEilCoQSih11vBLCkXayQ0XaBKvNLUILyDOUpYiTCakxICJerA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtkedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepvdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:6oxlYZFN6u4U-vHbpo6atiV2YYWQFWjlfEZO1gusoJdSpYqE4G_FRA>
    <xmx:6oxlYRURY7eYv3Ir15rvARsCzrDsrCvy0ul5t4QExSrH3lGfy_hh2A>
    <xmx:6oxlYUPAyYy-gF3ilnHfh4vqAZlWNwL4N3BFbwTd6ggNTVxvEkovag>
    <xmx:6oxlYXxD00iX1BvQIVAnJ77paUJywFY_sg7q7CNr0y3y7leJchdiyQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 Oct 2021 09:26:00 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 05/14] sff-8636: Rename SFF-8636 parsing functions
Date:   Tue, 12 Oct 2021 16:25:16 +0300
Message-Id: <20211012132525.457323-6-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012132525.457323-1-idosch@idosch.org>
References: <20211012132525.457323-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Currently, there are two SFF-8636 parsing functions. sff8636_show_all()
and sff8636_show_all_paged(). The former is called from the IOCTL path
with a buffer containing EEPROM contents and the latter is called from
the netlink path with pointer to individual EEPROM pages.

Rename them with '_ioctl' and '_nl' suffixes to make the distinction
clear.

In subsequent patches, these two functions will only differ in the way
they initialize the SFF-8636 memory map for parsing, while the parsing
code itself will be shared between the two.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 ethtool.c               | 4 ++--
 internal.h              | 6 +++---
 netlink/module-eeprom.c | 2 +-
 qsfp.c                  | 6 +++---
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 46887c7263e1..e3347db78fc3 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -4908,8 +4908,8 @@ static int do_getmodule(struct cmd_context *ctx)
 				break;
 			case ETH_MODULE_SFF_8436:
 			case ETH_MODULE_SFF_8636:
-				sff8636_show_all(eeprom->data,
-						 modinfo.eeprom_len);
+				sff8636_show_all_ioctl(eeprom->data,
+						       modinfo.eeprom_len);
 				break;
 #endif
 			default:
diff --git a/internal.h b/internal.h
index 33e619b3ac53..7ca6066d4e12 100644
--- a/internal.h
+++ b/internal.h
@@ -390,9 +390,9 @@ void sff8079_show_all(const __u8 *id);
 void sff8472_show_all(const __u8 *id);
 
 /* QSFP Optics diagnostics */
-void sff8636_show_all(const __u8 *id, __u32 eeprom_len);
-void sff8636_show_all_paged(const struct ethtool_module_eeprom *page_zero,
-			    const struct ethtool_module_eeprom *page_three);
+void sff8636_show_all_ioctl(const __u8 *id, __u32 eeprom_len);
+void sff8636_show_all_nl(const struct ethtool_module_eeprom *page_zero,
+			 const struct ethtool_module_eeprom *page_three);
 
 /* FUJITSU Extended Socket network device */
 int fjes_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
diff --git a/netlink/module-eeprom.c b/netlink/module-eeprom.c
index fc4ef1a53aff..18b1abbe1252 100644
--- a/netlink/module-eeprom.c
+++ b/netlink/module-eeprom.c
@@ -328,7 +328,7 @@ static void decoder_print(void)
 	case SFF8024_ID_QSFP:
 	case SFF8024_ID_QSFP28:
 	case SFF8024_ID_QSFP_PLUS:
-		sff8636_show_all_paged(page_zero, page_three);
+		sff8636_show_all_nl(page_zero, page_three);
 		break;
 	case SFF8024_ID_QSFP_DD:
 	case SFF8024_ID_DSFP:
diff --git a/qsfp.c b/qsfp.c
index 27fdd3bd1771..dc6407d3ef6f 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -853,7 +853,7 @@ static void sff8636_show_page_zero(const __u8 *id)
 
 }
 
-void sff8636_show_all(const __u8 *id, __u32 eeprom_len)
+void sff8636_show_all_ioctl(const __u8 *id, __u32 eeprom_len)
 {
 	if (id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP_DD) {
 		cmis_show_all_ioctl(id);
@@ -871,8 +871,8 @@ void sff8636_show_all(const __u8 *id, __u32 eeprom_len)
 	}
 }
 
-void sff8636_show_all_paged(const struct ethtool_module_eeprom *page_zero,
-			    const struct ethtool_module_eeprom *page_three)
+void sff8636_show_all_nl(const struct ethtool_module_eeprom *page_zero,
+			 const struct ethtool_module_eeprom *page_three)
 {
 	sff8636_show_identifier(page_zero->data);
 	sff8636_show_page_zero(page_zero->data);
-- 
2.31.1

