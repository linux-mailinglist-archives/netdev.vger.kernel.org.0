Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90554E4165
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 15:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237402AbiCVOdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 10:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237451AbiCVOdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 10:33:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2B53E7DE32
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 07:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647959540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=44jHngR8MVImHcNoiM4ygk+23Pe9WN7a5R9DoTr2u/Q=;
        b=Y7Qqxmp12JKBizbF8+HnxroQcnN6qWJcBpfs7RsK6NLOOLT3bIWXTKZZLY3W9BLS5gMgLF
        K4LftGXwjdaS7kM0p0uj+Ca6BZ+9nMxl0pW9qhhGDyC5kr36tL8OFcsGE9Uu0fiF7LVbS0
        YbUpFZE224XKyGm4m1+cw9+fSqRa0d8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-HApB1rwtO2qxuIx3vV3sGA-1; Tue, 22 Mar 2022 10:32:15 -0400
X-MC-Unique: HApB1rwtO2qxuIx3vV3sGA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3703B811E75;
        Tue, 22 Mar 2022 14:32:15 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.196.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 897AF4B8D42;
        Tue, 22 Mar 2022 14:32:14 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 1/3] man: devlink-region: fix typo in example
Date:   Tue, 22 Mar 2022 15:32:03 +0100
Message-Id: <1ae5a98139c632730c03dbe58d0f0271113937ee.1647955885.git.aclaudi@redhat.com>
In-Reply-To: <cover.1647955885.git.aclaudi@redhat.com>
References: <cover.1647955885.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
2.35.1

