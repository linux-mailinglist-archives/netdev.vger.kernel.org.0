Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C35D3F801C
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 03:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237087AbhHZBzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 21:55:33 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:18674 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S236473AbhHZBzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 21:55:32 -0400
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AI0msBaF3WCYXjaV3pLqE1MeALOsnbusQ8zAX?=
 =?us-ascii?q?PiFKOHhom6mj+vxG88506faKslwssR0b+OxoW5PwJE80l6QFgrX5VI3KNGbbUQ?=
 =?us-ascii?q?CTXeNfBOXZowHIKmnX8+5x8eNaebFiNduYNzNHpPe/zA6mM9tI+rW6zJw=3D?=
X-IronPort-AV: E=Sophos;i="5.84,352,1620662400"; 
   d="scan'208";a="113479376"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 26 Aug 2021 09:54:44 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
        by cn.fujitsu.com (Postfix) with ESMTP id 9C2A54D0D9CD;
        Thu, 26 Aug 2021 09:54:42 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Thu, 26 Aug 2021 09:54:33 +0800
Received: from localhost.localdomain (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Thu, 26 Aug 2021 09:54:31 +0800
From:   Li Zhijian <lizhijian@cn.fujitsu.com>
To:     <shuah@kernel.org>, <linux-kselftest@vger.kernel.org>
CC:     <philip.li@intel.com>, <linux-kernel@vger.kernel.org>,
        Li Zhijian <lizhijian@cn.fujitsu.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        <wireguard@lists.zx2c4.com>, <netdev@vger.kernel.org>
Subject: [PATCH v2 3/3] selftests/wireguard: Rename DEBUG_PI_LIST to DEBUG_PLIST
Date:   Thu, 26 Aug 2021 09:58:47 +0800
Message-ID: <20210826015847.7416-4-lizhijian@cn.fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826015847.7416-1-lizhijian@cn.fujitsu.com>
References: <20210826015847.7416-1-lizhijian@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 9C2A54D0D9CD.A1A01
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lizhijian@fujitsu.com
X-Spam-Status: No
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DEBUG_PI_LIST was renamed to DEBUG_PLIST since 8e18faeac3 ("lib/plist: rename DEBUG_PI_LIST to DEBUG_PLIST")

CC: "Jason A. Donenfeld" <Jason@zx2c4.com>
CC: Nick Desaulniers <ndesaulniers@google.com>
CC: Masahiro Yamada <masahiroy@kernel.org>
CC: wireguard@lists.zx2c4.com
CC: netdev@vger.kernel.org

Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
---
 tools/testing/selftests/wireguard/qemu/debug.config | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/wireguard/qemu/debug.config b/tools/testing/selftests/wireguard/qemu/debug.config
index fe07d97df9fa..2b321b8a96cf 100644
--- a/tools/testing/selftests/wireguard/qemu/debug.config
+++ b/tools/testing/selftests/wireguard/qemu/debug.config
@@ -47,7 +47,7 @@ CONFIG_DEBUG_ATOMIC_SLEEP=y
 CONFIG_TRACE_IRQFLAGS=y
 CONFIG_DEBUG_BUGVERBOSE=y
 CONFIG_DEBUG_LIST=y
-CONFIG_DEBUG_PI_LIST=y
+CONFIG_DEBUG_PLIST=y
 CONFIG_PROVE_RCU=y
 CONFIG_SPARSE_RCU_POINTER=y
 CONFIG_RCU_CPU_STALL_TIMEOUT=21
-- 
2.31.1



