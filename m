Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA3435D091
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 20:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236576AbhDLSr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 14:47:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhDLSr2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 14:47:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49F4661206;
        Mon, 12 Apr 2021 18:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618253230;
        bh=Mvw/l6XmzsrhcS+ZaKfHC3aRtjgQpmNwCiIOG2jHSlA=;
        h=From:To:Cc:Subject:Date:From;
        b=YSvONtNX2NZAIS+Fj6sFZRP23gVJU1EvIReuEQZhNZFXlvVKu3gFJGo01F/cJAZQM
         J/QI8yh8mojUqgjdYHHTL7nMUCJUURvWxMoaTTzgo+uo7hlpvvCBeo57PBnnnMX4xF
         Jion8OyGYqjDWVYcVpyFtTzUDoTvL3g/YXqQXwke6IBk/fUQmViDD63DbzZwph3Blj
         29iNHEuhpFkiVXkQ0vBF+eIaJvdl7KZPL7hMKjTVATt+dFQUwRcA86Yij8C/8nhrX5
         imeAm7GByIJOkUdsvWIXABsh0msINcHcfxQ2F0+9xRA/MMGopLELqOG/PpBCnuMF4M
         Du32k+yJHTr6A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz, andrew@lunn.ch,
        johannes.berg@intel.com, danieller@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net resend] ethtool: fix kdoc attr name
Date:   Mon, 12 Apr 2021 11:47:07 -0700
Message-Id: <20210412184707.825656-1-kuba@kernel.org>
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
index 6eabd58d81bf..cde9f3169ae5 100644
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

