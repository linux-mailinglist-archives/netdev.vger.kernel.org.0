Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA1A679C96
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235080AbjAXOww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:52:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbjAXOwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:52:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CA94ABF7
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 06:51:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674571895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zItE6ZaXDxNGCcmbJiQNR0G3jwGnmRx9/O3O4PSlyO4=;
        b=XuD7yGCOS7h7TLO/83Y4TEGhj/PpV7pr1zS5IzdlEfnv0WK4GM++qzAavs2Q+kgOfZ6hoJ
        ySZs74D9Qfd6JQ6kxOx9QDo9jx+g3HdmsgEBHi4vS6crSEMMuWRpUMcj+Z4P1YaZVjVh2s
        NgkMK971hhFM/qopdloCxPXiIKC0/kY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-439-MOn-FsRJNjCy3jQKWUazfw-1; Tue, 24 Jan 2023 09:51:32 -0500
X-MC-Unique: MOn-FsRJNjCy3jQKWUazfw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC3AF1C0040C;
        Tue, 24 Jan 2023 14:51:31 +0000 (UTC)
Received: from p1.luc.com (ovpn-194-196.brq.redhat.com [10.40.194.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E907FC15BA0;
        Tue, 24 Jan 2023 14:51:29 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION)
Subject: [PATCH net-next] docs: networking: Fix bridge documentation URL
Date:   Tue, 24 Jan 2023 15:51:26 +0100
Message-Id: <20230124145127.189221-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current documentation URL [1] is no longer valid.

[1] https://www.linuxfoundation.org/collaborate/workgroups/networking/bridge

Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 Documentation/networking/bridge.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/bridge.rst b/Documentation/networking/bridge.rst
index 4aef9cddde2f..c859f3c1636e 100644
--- a/Documentation/networking/bridge.rst
+++ b/Documentation/networking/bridge.rst
@@ -8,7 +8,7 @@ In order to use the Ethernet bridging functionality, you'll need the
 userspace tools.
 
 Documentation for Linux bridging is on:
-   http://www.linuxfoundation.org/collaborate/workgroups/networking/bridge
+   https://wiki.linuxfoundation.org/networking/bridge
 
 The bridge-utilities are maintained at:
    git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/bridge-utils.git
-- 
2.38.2

