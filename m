Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 013E14E8524
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 04:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbiC0C4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 22:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233026AbiC0Czw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 22:55:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5128D5A;
        Sat, 26 Mar 2022 19:54:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88976B80C73;
        Sun, 27 Mar 2022 02:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11BEC34112;
        Sun, 27 Mar 2022 02:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648349651;
        bh=TZJIrvLHdjUy8d6E2YHam4eLC7lZC+BM83i2BOP+9r4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CiFatBjxf8uvXibFJsxStO3qgx0Q+U/NFO7Z47tHvS6KRcBsdUtlvmfZlAr2sWYxv
         Vn4AyCubLKvgqzm3q0uMP06EZku431oM5bldX9wkg5CljxrqtnL3pJQimi5FK0aWvh
         HCHdrbkyg7F9DEvIeHJJUITQzfgv/8YV0VdvUYApXxMu8RFJ1XfqeUNc1Ll/hJvLVn
         0NeYWD+9m01uI6jURLkGIouKstwbhNs8IL6QkcoLusidmqvVIC1wDk/hvm6nXxqGvs
         PcXjIGhO9TB1tvauvfBkeZBG68IIjaJPAW7hfDqAzumSL62d8F0/GRIeaKc1T23qA0
         omJ9sG5R5Lksw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 06/13] docs: netdev: rephrase the 'Under review' question
Date:   Sat, 26 Mar 2022 19:53:53 -0700
Message-Id: <20220327025400.2481365-7-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220327025400.2481365-1-kuba@kernel.org>
References: <20220327025400.2481365-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The semantics of "Under review" have shifted. Reword the question
about it a bit and focus it on the response time.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdev-FAQ.rst | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index f0d452846d84..5f7b1e6fb249 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -116,10 +116,12 @@ patch. Patches are indexed by the ``Message-ID`` header of the emails
 which carried them so if you have trouble finding your patch append
 the value of ``Message-ID`` to the URL above.
 
-The above only says "Under Review".  How can I find out more?
--------------------------------------------------------------
+How long before my patch is accepted?
+-------------------------------------
 Generally speaking, the patches get triaged quickly (in less than
-48h).  So be patient.  Asking the maintainer for status updates on your
+48h). But be patient, if your patch is active in patchwork (i.e. it's
+listed on the project's patch list) the chances it was missed are close to zero.
+Asking the maintainer for status updates on your
 patch is a good way to ensure your patch is ignored or pushed to the
 bottom of the priority list.
 
-- 
2.34.1

