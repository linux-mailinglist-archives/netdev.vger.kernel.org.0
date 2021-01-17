Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275A12F914D
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 09:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbhAQIFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 03:05:08 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:53577 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726214AbhAQIDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 03:03:49 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 9230A1843;
        Sun, 17 Jan 2021 03:02:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 17 Jan 2021 03:03:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=utWo+iYDFTkyb1xJ78mQ+9MHyhDrxFQEhneLhVbMhn8=; b=O1WAX9py
        or7ShiU3AXSyIvKu8pBNZYaO+CeuE9hVG8JAfZt+tDBhmTjOOnN8VNRzN2f5LDus
        MpOL3ONSI+fbjJMgXooZndV4XJbq7HjKzwpbHGs2Kd1avfEg77FDHkMEtMdTTWkO
        KqUy/4xg9re+7HsGwrxlU76hTO5ACHdPTV0Bd4R80695HNFU5WaKSaKRYmfHGsYI
        Y4Tklu0ttcNUwjplL+G/qY2rv28fb7dUuw7b5tNGtPQLRtf1iSHYM6YV7fNHRtCO
        EvRspcBDYjW9R8kwL721k0WWJCnHpLYwekuSN+0/4l43UPRq5N/eUlyNMlCXR0I2
        MibNRE7BkUBQNw==
X-ME-Sender: <xms:M-8DYL6mQLHgJ0KmaIIoCgm4hc_HZl61iZQcHtBwgtNMmABSuFy7IQ>
    <xme:M-8DYA7Pc1E36ucE7IiCgO6JNVOJeM3vdcAM_zI6dC0hyuRQJVFETHkKABJQhPm-k
    PhJImaufi7S87w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdehgdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:M-8DYCcVnrbTo7Bi18XRXikQ-M7Z2VVJSUMQ4wJltXo4IPxDVWdkMA>
    <xmx:M-8DYMJ3J18hs6TLjoHJ2MX38sp9KNgppnvNHajb80gggCweyjV26g>
    <xmx:M-8DYPINgth5dalmoaBB2EyK-aCg1vbCcSXdZec1de-Mu3joEz7iFQ>
    <xmx:M-8DYMEr_GUnCoAnIM19ih3eQQtkO3rUEN-jkHNN_sppdl28969DZA>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0F8C224005B;
        Sun, 17 Jan 2021 03:02:56 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/5] selftests: mlxsw: sch_red_core: Drop two unused variables
Date:   Sun, 17 Jan 2021 10:02:22 +0200
Message-Id: <20210117080223.2107288-5-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210117080223.2107288-1-idosch@idosch.org>
References: <20210117080223.2107288-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

These variables are cut'n'pasted from other functions in the file and not
actually used.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
index b0cb1aaffdda..d439ee0eaa8a 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
@@ -551,10 +551,8 @@ do_drop_test()
 	local trigger=$1; shift
 	local subtest=$1; shift
 	local fetch_counter=$1; shift
-	local backlog
 	local base
 	local now
-	local pct
 
 	RET=0
 
-- 
2.29.2

