Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE7027B91E
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 02:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbgI2Axr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 20:53:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727117AbgI2Axm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 20:53:42 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA18B20773;
        Tue, 29 Sep 2020 00:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601340821;
        bh=3gxw13tMwww5Zoj4cA3F2PRtClm/f7JvfdUGN79ftM0=;
        h=From:To:Cc:Subject:Date:From;
        b=eGPxK6rySuxrQivIj0rUxhHBzRDiV6e2/XnhKjWArvzeDvNXQyHjmphtWhldHjHTm
         2WjHItCOEi78ka8QfmSRBrB3NJDiXpD+w93N6vJTJJMexXasm/6zT7leYNze8uVISw
         /94+TabgZpDXKSms9913HKLQQJUvvWXtI7xs77uo=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     johannes@sipsolutions.net, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] genetlink: add missing kdoc for validation flags
Date:   Mon, 28 Sep 2020 17:53:29 -0700
Message-Id: <20200929005329.3638695-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Validation flags are missing kdoc, add it.

Fixes: ef6243acb478 ("genetlink: optionally validate strictly/dumps")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/genetlink.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index b9eb92f3fe86..a3484fd736d6 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -130,6 +130,7 @@ genl_dumpit_info(struct netlink_callback *cb)
  * @cmd: command identifier
  * @internal_flags: flags used by the family
  * @flags: flags
+ * @validate: validation flags from enum genl_validate_flags
  * @doit: standard command callback
  * @start: start callback for dumps
  * @dumpit: callback for dumpers
-- 
2.26.2

