Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E548355F2E
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbhDFXBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:01:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232398AbhDFXBW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 19:01:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85251613BE;
        Tue,  6 Apr 2021 23:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617750073;
        bh=MOxI+EZDMPVapGVH4Rll/KYW49AV3Fp1dCqdjUnzM1s=;
        h=From:To:Cc:Subject:Date:From;
        b=D4YZ7I1WRf8xWoNB78eRxi2euRlGyyuvcA0Pg247MCyGbrrAcB+7L+2KXYI9jEm8/
         JWJ6I+q+8yF53AdY8T0Eivvhr7CO7PBALM4XmwFHqKV2ExNvD3xSvCMY8lkkppulvk
         TmlHxcKjhAyvbn715wQqVQo0WMsZy2UN+JlroNKSbO5VYHu3rvdBNBI6nDl+0I6Fb8
         VXLugwZO63b6ipTFfzj0oVb1wjYUiAfwESAyxhEl6y1N7QFCXdE3CgNHwpILvUnvCp
         uSmGsbOeULlK3Wpca+TCkyr9A6aPlz6jtavQRkksN7Qu4RZ2AkWbJFm3V7fUsn0ZZa
         oMbSqkxuNyLQg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] ethtool: fix kdoc attr name
Date:   Tue,  6 Apr 2021 16:01:11 -0700
Message-Id: <20210406230111.1847402-1-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing 't' in attrtype.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ethtool/netlink.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 785f7ee45930..181fda8a590e 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -36,9 +36,9 @@ static inline int ethnl_strz_size(const char *s)
 
 /**
  * ethnl_put_strz() - put string attribute with fixed size string
- * @skb:     skb with the message
- * @attrype: attribute type
- * @s:       ETH_GSTRING_LEN sized string (may not be null terminated)
+ * @skb:      skb with the message
+ * @attrtype: attribute type
+ * @s:        ETH_GSTRING_LEN sized string (may not be null terminated)
  *
  * Puts an attribute with null terminated string from @s into the message.
  *
-- 
2.30.2

