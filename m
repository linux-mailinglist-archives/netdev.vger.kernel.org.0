Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3AE255BBE
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 15:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgH1N4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 09:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbgH1N4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 09:56:19 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA019C061264;
        Fri, 28 Aug 2020 06:56:18 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id o4so1410808wrn.0;
        Fri, 28 Aug 2020 06:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tNnC4MJvn0YjQrnjipXsey8gWX0l8zpkvsFTkYPZMtw=;
        b=DFvfG+CV/NabXSoKc7HsspXMZviwC0JAjzPglV9m/Z7tQZwz2Mm32FnFtmXnTecyQ7
         y4DbbKRszeuKs6Olk3lbgPsOrFYiBX70UBisAn41m4r5NXiKpxbKyBJ2IGqyBltVMDcy
         SQDebQmU0xzznWVNqklhsKDg177XCldRwVQbj/Yc7MVrAgJEeCUHXafE1um6q13Esu7q
         Dv01Cst5L424ZexQCWPzONb9ZehitJJ5WvMjG+1uJcbKoFC1+ph42iBwiDqO3E4qTyRK
         Ava4Tl+KdmwmSJ9QJFMDHhNiqTSo35zKZFwmp+fNU3iE2RkkiV1wC3HBWWLsAl4Ah8qh
         jhgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tNnC4MJvn0YjQrnjipXsey8gWX0l8zpkvsFTkYPZMtw=;
        b=bHwyH/6IDkW4/u3Uo+UGh68kAv6JJED7p7r9gyig3VUVAunWiPhhyjVLTXBVYkonl1
         JgKI0zeXTzrbASElbooWk7rGDy5s3RBiKATTA9+rKjnRBlB/9LwS/yAPFE5JQbPxYiRh
         r9JsxZVfCm6Iry6TqVckHhVqbCzbdCOr2dkL1xc6E0TrTK2YDkLKlATykXeQRTA5D3jZ
         +r7xvv3X9cEJR9SGTykDFpAFlBPd6Kmahtubev7Z28Sa7741Kw1muwANCM6AgDUn4agH
         2dpkc3C8HHLyekjjXiWXA153dOmFrSGandA7+OqYSdMV0l9asGlXcfU5EIX7u5BCd+QK
         JD7g==
X-Gm-Message-State: AOAM5328p6aRqprxH0UeoN7+6yrvQXRa1Z4sIvc1Dww4JNVibucv7bip
        p1KLViFEOq4LSL8Bc2NesTU=
X-Google-Smtp-Source: ABdhPJzOs7Ukf3vzvCE+JHO212o3YOfnaw8XSZwGBL6HLr2/Z+gFDcduI5jRVM3FYHa4X3MXC5gSUw==
X-Received: by 2002:adf:fec6:: with SMTP id q6mr1651248wrs.59.1598622977484;
        Fri, 28 Aug 2020 06:56:17 -0700 (PDT)
Received: from lenovo-laptop.home ([2a00:23c4:4b87:b300:cc3a:c411:9a4b:dba6])
        by smtp.gmail.com with ESMTPSA id v11sm2046865wrr.10.2020.08.28.06.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 06:56:16 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Paul Moore <paul@paul-moore.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] netlabel: remove unused param from audit_log_format()
Date:   Fri, 28 Aug 2020 14:55:23 +0100
Message-Id: <20200828135523.12867-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <CAHC9VhRtTykJVze_93ed+n+v14Ai9J5Mbre9nGEc2rkqbqKc_g@mail.gmail.com>
References: <CAHC9VhRtTykJVze_93ed+n+v14Ai9J5Mbre9nGEc2rkqbqKc_g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit d3b990b7f327 ("netlabel: fix problems with mapping removal")
added a check to return an error if ret_val != 0, before ret_val is
later used in a log message. Now it will unconditionally print "...
res=1". So just drop the check.

Addresses-Coverity: ("Dead code")
Fixes: d3b990b7f327 ("netlabel: fix problems with mapping removal")
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
v2: Still print the res field, because it's useful (Paul)

 net/netlabel/netlabel_domainhash.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/netlabel/netlabel_domainhash.c b/net/netlabel/netlabel_domainhash.c
index f73a8382c275e..dc8c39f51f7d3 100644
--- a/net/netlabel/netlabel_domainhash.c
+++ b/net/netlabel/netlabel_domainhash.c
@@ -612,9 +612,8 @@ int netlbl_domhsh_remove_entry(struct netlbl_dom_map *entry,
 	audit_buf = netlbl_audit_start_common(AUDIT_MAC_MAP_DEL, audit_info);
 	if (audit_buf != NULL) {
 		audit_log_format(audit_buf,
-				 " nlbl_domain=%s res=%u",
-				 entry->domain ? entry->domain : "(default)",
-				 ret_val == 0 ? 1 : 0);
+				 " nlbl_domain=%s res=1",
+				 entry->domain ? entry->domain : "(default)");
 		audit_log_end(audit_buf);
 	}
 
-- 
2.28.0

