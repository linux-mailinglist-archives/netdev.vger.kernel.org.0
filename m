Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E72B1E911D
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 14:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbgE3MQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 08:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728769AbgE3MQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 08:16:45 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B576CC03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 05:16:45 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id dp10so2344625qvb.10
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 05:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zEW6cclPth/kke/4kgLWebf5VNk8029gdyqLv528sYg=;
        b=ZOUfpFBWS8mpNW0Qfc+RPmK41W9dihrx+dcPZQgbjDkWiV7KtEil94su1R0b3M/8Gg
         ZO547zC6bf57XHo/80riZ72RinUsPWHsM7cz6ksjB/H0q92/Hc1eo6s72bp3uln7au6P
         V+Mvp1z3Mo5ghFZNaiukw4kKQRt2g8U0tUxzc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zEW6cclPth/kke/4kgLWebf5VNk8029gdyqLv528sYg=;
        b=ckzJpZlhlcBtgNrqey6cwo5RQPBTBD8QZr56D6MM0GSgge4qr/Szm2UPFn6ap8RvYk
         clTFpQV+9MYmj4Oz0wfbEAVcFAWMQnPwJv45BWBrMo3Fh7WYqqw0NWGQuRpCCIAAhLR9
         OODO9myPudsiMRYqpLEozOUu/3O32WcPfpx/CgfzqoXZFDySfFV1GKAQ/cOEF9KzD+uN
         qL3gpgtHS/ljyWbOGSvlE3PtaSy+UV60ICdGi20ounyrKn9JhxThw7rkVYTsHckYe6hE
         RxP3qUHBg9xEf0U2SKkdschLnpqo3rrqyrEX7L7XnjNpKJe/v27z5Qtf2CTKjKC4d1jv
         FPTA==
X-Gm-Message-State: AOAM532E+9eGYHLdQO/25oTdV9t8N5dewxQA/3NfAyNrQAKCoh8/38Af
        omU7ZczxmDG5k480IW5EcKWEGKq+u5Q=
X-Google-Smtp-Source: ABdhPJxAfQ1St30VVHvPG8eFaXe4boNDhhiKiJ+Df81S5PXR394dUpQSNVsOVZoqlz/aob9r9N5Szw==
X-Received: by 2002:a05:6214:922:: with SMTP id dk2mr3422662qvb.87.1590841004428;
        Sat, 30 May 2020 05:16:44 -0700 (PDT)
Received: from eva.nc.rr.com (2606-a000-111d-823e-bcb5-9fa2-66e5-0dba.inf6.spectrum.com. [2606:a000:111d:823e:bcb5:9fa2:66e5:dba])
        by smtp.googlemail.com with ESMTPSA id k10sm3311895qkh.47.2020.05.30.05.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 05:16:43 -0700 (PDT)
From:   Donald Sharp <sharpd@cumulusnetworks.com>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        roopa@cumulusnetworks.com
Subject: [PATCH] nexthop: Fix Deletion display
Date:   Sat, 30 May 2020 08:16:37 -0400
Message-Id: <20200530121637.1233527-1-sharpd@cumulusnetworks.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Actually display that deletions are happening
when monitoring nexthops.

Signed-off-by: Donald Sharp <sharpd@cumulusnetworks.com>
---
 ip/ipnexthop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 99f89630..c33cef0c 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -224,7 +224,7 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
 
 	open_json_object(NULL);
 
-	if (n->nlmsg_type == RTM_DELROUTE)
+	if (n->nlmsg_type == RTM_DELNEXTHOP)
 		print_bool(PRINT_ANY, "deleted", "Deleted ", true);
 
 	if (tb[NHA_ID])
-- 
2.26.2

