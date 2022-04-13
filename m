Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB7704FF847
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 16:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiDMOCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 10:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235882AbiDMOCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 10:02:37 -0400
Received: from smtpservice.6wind.com (unknown [185.13.181.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 911D63B3CE
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 07:00:13 -0700 (PDT)
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id 4B8B060010;
        Wed, 13 Apr 2022 16:00:12 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1nedXY-00069d-7O; Wed, 13 Apr 2022 16:00:12 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Xin Long <lucien.xin@gmail.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net] doc/ip-sysctl: add bc_forwarding
Date:   Wed, 13 Apr 2022 16:00:00 +0200
Message-Id: <20220413140000.23648-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's describe this sysctl.

Fixes: 5cbf777cfdf6 ("route: add support for directed broadcast forwarding")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 Documentation/networking/ip-sysctl.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index b0024aa7b051..66828293d9cb 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -267,6 +267,13 @@ ipfrag_max_dist - INTEGER
 	from different IP datagrams, which could result in data corruption.
 	Default: 64
 
+bc_forwarding - INTEGER
+	bc_forwarding enables the feature described in rfc1812#section-5.3.5.2
+	and rfc2644. It allows the router to forward directed broadcast.
+	To enable this feature, the 'all' entry and the input interface entry
+	should be set to 1.
+	Default: 0
+
 INET peer storage
 =================
 
-- 
2.33.0

