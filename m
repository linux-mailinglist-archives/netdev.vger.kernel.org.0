Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696ED41F089
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354974AbhJAPIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:08:50 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44647 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354744AbhJAPIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 11:08:40 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 5EB5F5C00F2;
        Fri,  1 Oct 2021 11:06:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 01 Oct 2021 11:06:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=JJIeBqEx0vh8sMu7xDyH85/7PXTPW1rsvs7aQcd3Gy8=; b=jlCtk4ok
        rfaLhb/v6jYW4d4axQfiXgAcV8zGGa2EDHJMFpsTmRRndhFxVzoolI00dybgnCzB
        vus4leTJk0rOXtAlfIuVM/urnL29DVW78HzDo77M3spdbzvIKH53/cD2scIgcYp1
        F2HGmLylQFvqql3GwmCphaIzXareLd+Yt8jCgHiKkleAzFoc2Qrhwl7xDwDCKj2T
        KwxJ1aMJPddzg1ENQ9DfhtqbPw8eln2gpoHNjpcWMQAVxEm5C0iO4Tkx5blViMN0
        86PaQLHUzAXTnR9v0EU9/qc3WqMUMvl+K5tqEj+VDV40FkRwFY72s1jWGXYzDOFz
        4EYHWG6/6VXIGw==
X-ME-Sender: <xms:ECRXYZkp3UECy96tkg0rj7W8bgdRnmagUfoyNKQOB4mFaz74d86esA>
    <xme:ECRXYU1IjA0XyPE5DRIxxdrsJEec-qP0kOGc_LgoM5CIQCu-ZxZmlA9u7nGTIgFLk
    tEYjyE4hHclnkM>
X-ME-Received: <xmr:ECRXYfpODDJvX6C1JNKD_PtrTEN40WOE2MjH8Ef59Bd1v9zds_UpMPg1WZWLlUqr-WVxZrjwynLwXXsahAQc-l__ANqER19DJg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudekiedgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ECRXYZmojT1YJhVy5g7iqUU3WrxCp7V8kdxe_Fnmlma3L1PGWnTGrg>
    <xmx:ECRXYX0DGtIU8kf0tGo1vIoDOgF-QCxtTZXesicK5LByOSjqUXg_qQ>
    <xmx:ECRXYYtmWPKCSi57OWVEJimXUoFQki1Piz7Qhu2wUbXGLI69_BmWTw>
    <xmx:ECRXYVAjYR4lJmg2WbpNCqoA9v02VCI1nLtGsYIb126MqnaNM3wGJg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 1 Oct 2021 11:06:54 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next v2 4/7] sff-8636: Remove incorrect comment
Date:   Fri,  1 Oct 2021 18:06:24 +0300
Message-Id: <20211001150627.1353209-5-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001150627.1353209-1-idosch@idosch.org>
References: <20211001150627.1353209-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The comment was copied from SFF-8472 (i.e., sfpdiag.c) where the
diagnostic page is at I2C address 0x51. SFF-8636 only uses I2C address
0x50.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 qsfp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/qsfp.c b/qsfp.c
index e84226bc1554..263cf188377d 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -64,7 +64,7 @@
 
 static struct sff8636_aw_flags {
 	const char *str;        /* Human-readable string, null at the end */
-	int offset;             /* A2-relative address offset */
+	int offset;
 	__u8 value;             /* Alarm is on if (offset & value) != 0. */
 } sff8636_aw_flags[] = {
 	{ "Laser bias current high alarm   (Chan 1)",
-- 
2.31.1

