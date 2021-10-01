Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD20E41F08E
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355078AbhJAPI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:08:58 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44647 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354938AbhJAPIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 11:08:45 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id AAC3B5C0117;
        Fri,  1 Oct 2021 11:07:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 01 Oct 2021 11:07:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=wMgHWGEFDtQMgyF9iJhX0MHEQhexcToVkFgOADVIAoA=; b=iUndApsK
        23XBJ7WC3MmY5VG7VEnGyrinjmb2n4bxQv/3WiJVFmnVPD35l80QIg4g/Y2h13Yc
        1ppJbFy544Om/rdqcewFZmBnxrI6lpb9bd6Tviy85UEnLlLs9ft7nwiv43EKF7DJ
        oc0Skpt3ix2CXcCQeeJQbnxT18M0THZfCOjHF0TmgSqwvLMEDXgC5H4kJVTC+4ya
        bdQO0uakkro3FVy/z7Deld4TCUHu+RzZ1LJGRjaoVektwJRCFZpUF8YMrVQumDab
        QZg31Et3Nx4opjZ8PyrYVSokp8evf3mud+lFSbulqEaOGRMMbJfCJFSFxqpY/eYu
        nFIf70e2oVqFJg==
X-ME-Sender: <xms:FCRXYU9Q53Q8t2w6bUtVXQi2tQlDfxWBf0WYyvDttcTBiDPJjQs2rQ>
    <xme:FCRXYctHbmsN3Be2i1LXEB-v2uVKXyK73wCeM2cvZnaRdnWeaYWcS0gQyO8K_QETF
    96z-Q2yfR_54Mk>
X-ME-Received: <xmr:FCRXYaBL-QKiy6abHRYzt-FP-3eZjImjtq1MNryj46ls4rPNUJUKLyOV2Qw8Ts0o68_UJGOz_oVkbCXEUC37mtjOT_o4cUCqQQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudekiedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepvdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:FCRXYUdfevrAPicZY4H6_ci7en7san3voQIcoE8jzhnkas4VzUxZgA>
    <xmx:FCRXYZMfbDuvauxYB3leVuhKBBnSho6KaUE1CqFTsUz4ye9zeXuRIg>
    <xmx:FCRXYekf0oc-X-zCRVVb1ZSqdqMqs6_ZFv3O6SohsA2UZ6ivxEFkHg>
    <xmx:FCRXYSZslmpgIjIpIWh25miihDL07Go05N0sTC7UC4aceVGAaozGVw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 1 Oct 2021 11:06:59 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next v2 7/7] sff-8636: Remove extra blank lines
Date:   Fri,  1 Oct 2021 18:06:27 +0300
Message-Id: <20211001150627.1353209-8-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001150627.1353209-1-idosch@idosch.org>
References: <20211001150627.1353209-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Not needed, so remove them.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 qsfp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/qsfp.c b/qsfp.c
index d1464cb50fdc..3f37f1036e96 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -738,7 +738,6 @@ static void sff8636_dom_parse(const __u8 *id, const __u8 *page_three, struct sff
 		sd->scd[i].rx_power = OFFSET_TO_U16(rx_power_offset);
 		sd->scd[i].tx_power = OFFSET_TO_U16(tx_power_offset);
 	}
-
 }
 
 static void sff8636_show_dom(const __u8 *id, const __u8 *page_three, __u32 eeprom_len)
@@ -819,7 +818,6 @@ static void sff8636_show_dom(const __u8 *id, const __u8 *page_three, __u32 eepro
 	}
 }
 
-
 static void sff8636_show_page_zero(const __u8 *id)
 {
 	sff8636_show_ext_identifier(id);
-- 
2.31.1

