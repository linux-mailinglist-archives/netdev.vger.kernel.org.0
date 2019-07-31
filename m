Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88BA47B9CA
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 08:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387414AbfGaGjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 02:39:22 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54173 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727645AbfGaGjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 02:39:22 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8A96822221;
        Wed, 31 Jul 2019 02:39:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 31 Jul 2019 02:39:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=MyyuOpM+MAMbX7tA0
        tPPOJvZs6IuGHk3LNzG1sJukE0=; b=SEkjiOBD91PKrN3mnv4qRBpgv9DRjrS/6
        Hf0+U35KW8etRFlOJZKNRpL3hzlg6iC4a6E5OF6DSzhh43uWx2jadXtvhQHKDqAO
        HNEgPqiAgqcnuOmUjRVIxFpvhC95Z7YP2UTPpH56Ex+WtBl1gp3/oX1bLuCeRfpI
        uccko5JC7sbE9JDkgssjAn50OQPmZcqfSul8cF/zX/agXCBRDCF+TBX0588+5edY
        JwbdwZRC9MuvvN2/n1bbks2rjPlI1WOGwWHoSS+A/9dcCjft1WW2AFKFrGTryowO
        K4Dt5uLoetM8tMeBQC6ujy3I3NLL8CNH0mAkY5WW18I9yR9iGdtTA==
X-ME-Sender: <xms:mTdBXXPDIaJc4q5ysiuaZLgTk4XbRW0NAEwi1Q7Qdy9OzMCC5re6Cg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrleeggddutdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuffhomhgrihhnpehfvgguohhrrghhohhsthgvugdrohhrghenucfkph
    epudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiugho
    shgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:mTdBXeR2qAfnLIhTuIVjBeZA0FgBO_oAZq7xFzrkeLOFl2amk5uN-Q>
    <xmx:mTdBXZCAuv6Wi318-EKMYlt6LzB6xhnf9qk44gPxtQAv8dbH5dVJ2w>
    <xmx:mTdBXdi8PUIsjUhRVedxWrb-_fNdQYXNo8m_GTXSrDOGEegHRjCsiQ>
    <xmx:mTdBXR8hK_Gz3wCCxv1orYOwtq3vnjklxJpDVwSxbrY0cF_W6LwMug>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id AEDAB380087;
        Wed, 31 Jul 2019 02:39:19 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net] drop_monitor: Add missing uAPI file to MAINTAINERS file
Date:   Wed, 31 Jul 2019 09:38:19 +0300
Message-Id: <20190731063819.10001-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Fixes: 6e43650cee64 ("add maintainer for network drop monitor kernel service")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9f5b8bd4faf9..b540794cbd91 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11137,6 +11137,7 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 W:	https://fedorahosted.org/dropwatch/
 F:	net/core/drop_monitor.c
+F:	include/uapi/linux/net_dropmon.h
 
 NETWORKING DRIVERS
 M:	"David S. Miller" <davem@davemloft.net>
-- 
2.21.0

