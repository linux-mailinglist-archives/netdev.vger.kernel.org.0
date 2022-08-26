Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A33F5A2BA1
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 17:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344649AbiHZPsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 11:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344662AbiHZPs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 11:48:29 -0400
Received: from mx1.riseup.net (mx1.riseup.net [198.252.153.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331B4A1D75
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 08:48:10 -0700 (PDT)
Received: from mx0.riseup.net (mx0-pn.riseup.net [10.0.1.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mx0.riseup.net", Issuer "R3" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4MDkkd4Cq9zDrv0
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 15:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1661528889; bh=PZXlHdewHKlsFlSQ+8A/nhwSkmBkkONKqBVVu3TIVkk=;
        h=From:To:Cc:Subject:Date:From;
        b=SO3SRsgYzqH6jOL7eSXuz+YexUN6PkKbpnm8oC5nx2CXRAn5knWBhivyNwya1Ccj+
         swQ6VA5kjl+oRnRH9QtdlvBcoLuzEksyQKWV6H4DUUb5xhsE6fr9DsoIutASOs1BAK
         /g86XGMxWzgKp/D5hP2lNK7S8fIfZLNKR2PKPkRk=
Received: from fews1.riseup.net (fews1-pn.riseup.net [10.0.1.83])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx0.riseup.net (Postfix) with ESMTPS id 4MDkkc62BVz9sQf
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 15:48:08 +0000 (UTC)
X-Riseup-User-ID: B25F4928A307BF5292420C8DC8A69D29E443167737D88AC36D0F1E83F7C88972
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews1.riseup.net (Postfix) with ESMTPSA id 4MDkkb6yTWz5vcD;
        Fri, 26 Aug 2022 15:48:07 +0000 (UTC)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netdev@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH net-next] Documentation: bonding: clarify supported modes for tlb_dynamic_lb
Date:   Fri, 26 Aug 2022 17:47:38 +0200
Message-Id: <20220826154738.4039-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tlb_dynamic_lb bonding option is compatible with balance-tlb and balance-alb
modes. In order to be consistent with other option documentation, it should
mention both modes not only balance-tlb.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 Documentation/networking/bonding.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
index 7823a069a903..96cd7a26f3d9 100644
--- a/Documentation/networking/bonding.rst
+++ b/Documentation/networking/bonding.rst
@@ -846,7 +846,7 @@ primary_reselect
 tlb_dynamic_lb
 
 	Specifies if dynamic shuffling of flows is enabled in tlb
-	mode. The value has no effect on any other modes.
+	or alb mode. The value has no effect on any other modes.
 
 	The default behavior of tlb mode is to shuffle active flows across
 	slaves based on the load in that interval. This gives nice lb
-- 
2.30.2

