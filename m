Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6ED05F4568
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 16:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiJDOZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 10:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiJDOZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 10:25:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384CB2DABB
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 07:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664893518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IQZ29yURLGWgq8SeMjpJR4evsvv78iAEKXzpFB0QESw=;
        b=N16fPVI95RrAeYww6Fvvlx4Wpjd6cBb57MYUr7OVYec2fsVm7z1ErJx87c2kaVHk5iz65L
        p1FHXcx9qpeTKx3cNFSUI2IWPnZv2jOyYN0SIx35+LZx0hqTNHECAA+he3T6YSzGyMpbqj
        aycopI7IqkVMm7lxedGpxpqPRdVaWqo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-4E2hB700MsCv2wR3kmZP-g-1; Tue, 04 Oct 2022 10:25:16 -0400
X-MC-Unique: 4E2hB700MsCv2wR3kmZP-g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 80318101A52A;
        Tue,  4 Oct 2022 14:25:16 +0000 (UTC)
Received: from tc2.redhat.com (unknown [10.39.192.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0BF740C206B;
        Tue,  4 Oct 2022 14:25:15 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH] man: ss.8: fix a typo
Date:   Tue,  4 Oct 2022 16:25:03 +0200
Message-Id: <7febff04089ef0a6ea47515178c74462f088a1f1.1664893492.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: f76ad635f21d ("man: break long lines in man page sources")
Reported-by: Prijesh Patel <prpatel@redhat.com>
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 man/man8/ss.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/ss.8 b/man/man8/ss.8
index 026530ed..12cb91b9 100644
--- a/man/man8/ss.8
+++ b/man/man8/ss.8
@@ -137,7 +137,7 @@ memory.
 The memory allocated for sending packet (which has not been sent to layer 3)
 .P
 .TP
-.B <ropt_mem>
+.B <opt_mem>
 The memory used for storing socket option, e.g., the key for TCP MD5 signature
 .P
 .TP
-- 
2.37.3

