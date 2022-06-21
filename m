Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F391553EF0
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 01:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbiFUXbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 19:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiFUXbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 19:31:44 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6621C30F43
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 16:31:42 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id ACD19500084;
        Wed, 22 Jun 2022 02:30:08 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru ACD19500084
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1655854209; bh=QqElJcfcWwEYONyy6ZHAWlqqp9R73nsjjf2GMwgfEq8=;
        h=From:To:Cc:Subject:Date:From;
        b=l0Cii3jzm4ugM5CBTQ6dRtTVUvRh9oZ5gLaa9uYlFU/5jghqXxBhwMQA4GoRiyjra
         gtLyjexKyj00fIbkW02vS1GysAw1wqg6trSTLUbB2Em8lzjneZbvtACmAgfbLUE/tj
         re3W/7+YW6Z/GMfs5PXWJxtWpoGijJdJuQk4yNas=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Vadim Fedorenko <vadfed@fb.com>, netdev@vger.kernel.org
Subject: [PATCH net] MAINTAINERS: Add a maintainer for OCP Time Card
Date:   Wed, 22 Jun 2022 02:31:31 +0300
Message-Id: <20220621233131.21240-1-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vadfed@fb.com>

I've been contributing and reviewing patches for ptp_ocp driver for
some time and I'm taking care of it's github mirror. On Jakub's
suggestion, I would like to step forward and become a maintainer for
this driver. This patch adds a dedicated entry to MAINTAINERS.

Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 15a2341936ea..d922601f02ae 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14868,6 +14868,7 @@ F:	include/dt-bindings/
 
 OPENCOMPUTE PTP CLOCK DRIVER
 M:	Jonathan Lemon <jonathan.lemon@gmail.com>
+M:	Vadim Fedorenko <vadfed@fb.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/ptp/ptp_ocp.c
-- 
2.27.0

