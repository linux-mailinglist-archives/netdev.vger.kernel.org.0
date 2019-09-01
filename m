Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5E6A4A40
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 17:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbfIAPwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 11:52:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43750 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728644AbfIAPwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 11:52:09 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1i4S98-0004Og-3I; Sun, 01 Sep 2019 15:52:06 +0000
From:   Colin King <colin.king@canonical.com>
To:     Paul Moore <paul@paul-moore.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] netlabel: remove redundant assignment to pointer iter
Date:   Sun,  1 Sep 2019 16:52:05 +0100
Message-Id: <20190901155205.16877-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Pointer iter is being initialized with a value that is never read and
is being re-assigned a little later on. The assignment is redundant
and hence can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/netlabel/netlabel_kapi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
index 2b0ef55cf89e..409a3ae47ce2 100644
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -607,7 +607,7 @@ static struct netlbl_lsm_catmap *_netlbl_catmap_getnode(
  */
 int netlbl_catmap_walk(struct netlbl_lsm_catmap *catmap, u32 offset)
 {
-	struct netlbl_lsm_catmap *iter = catmap;
+	struct netlbl_lsm_catmap *iter;
 	u32 idx;
 	u32 bit;
 	NETLBL_CATMAP_MAPTYPE bitmap;
-- 
2.20.1

