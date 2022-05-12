Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE867524FD4
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 16:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355196AbiELOT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 10:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355213AbiELOT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 10:19:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 187B425C2B3
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 07:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652365165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PKu6AGIxohByBPEg2+BlGdRHs66UPalGQ4UvqFecae4=;
        b=JGoeHdlamPGttnz1DS/v+PR0MlyXCXdT4Osa3UxJz2htVkJAj8oUX1TI3epAQXYfolTbMT
        VMlpZk7Lv6syjhSmFTRKgnhdFzmx/cKh/IN9T4ufDasNxZck3lJTN41YzFK5XL1p91dGsZ
        Qqdi0HWctjVSnlcbnn+y4J4oLglPnS4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-LEw1XXHvMcuylphy5oBA0Q-1; Thu, 12 May 2022 10:19:09 -0400
X-MC-Unique: LEw1XXHvMcuylphy5oBA0Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1AF93C322E9;
        Thu, 12 May 2022 14:19:08 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.192.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CE5541617C;
        Thu, 12 May 2022 14:19:07 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH RESEND iproute2 1/3] man: devlink-region: fix typo in example
Date:   Thu, 12 May 2022 16:18:46 +0200
Message-Id: <0a2d3420afacf63d92b6ece9728d45b5394f7ed1.1652364969.git.aclaudi@redhat.com>
In-Reply-To: <cover.1652364969.git.aclaudi@redhat.com>
References: <cover.1652364969.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devlink-region does not accept the legth param, but the length one.

Fixes: 8b4fbf0bed8e ("devlink: Add support for devlink-region access")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 man/man8/devlink-region.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/devlink-region.8 b/man/man8/devlink-region.8
index c6756566..e6617c18 100644
--- a/man/man8/devlink-region.8
+++ b/man/man8/devlink-region.8
@@ -116,7 +116,7 @@ devlink region dump pci/0000:00:05.0/cr-space snapshot 1
 Dump the snapshot taken from cr-space address region with ID 1
 .RE
 .PP
-devlink region read pci/0000:00:05.0/cr-space snapshot 1 address 0x10 legth 16
+devlink region read pci/0000:00:05.0/cr-space snapshot 1 address 0x10 length 16
 .RS 4
 Read from address 0x10, 16 Bytes of snapshot ID 1 taken from cr-space address region
 .RE
-- 
2.35.3

