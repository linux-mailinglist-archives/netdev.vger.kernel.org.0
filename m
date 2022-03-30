Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 389F64EB995
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 06:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242590AbiC3E1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 00:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242526AbiC3E1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 00:27:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948D4DF77;
        Tue, 29 Mar 2022 21:25:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A49CB81B37;
        Wed, 30 Mar 2022 04:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3A8C34113;
        Wed, 30 Mar 2022 04:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648614315;
        bh=vdjnHae9b0yzMsExMtKNC+WLL55dm1Lg2N7VoIhWL24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mTZKm4E8m33oHKpcKq7YJWQyiuUk3Jg8Wh1nkdORLbAzaSYkoe3W9+ofBksvmsr1v
         Efo823GVm4kHVuXHNv8YPJuwges2bN/XsGmR9gLj0uQY8/eS7IEZFw1PHpkWxZL7Jy
         deqZnwwOtOTxIhntyVYE+RNzLpJvr2jMIu2oXJZgjyD/ZWz3Ed7DUa2LVorBMD7uuL
         5nZ3yNQLujZr6FV0et69NPdeiD4J3ZS3goiXAOUK66tEMFtSuzJ+bAKP58QrRZw/VV
         0YiY014VRDr3+PJwyZT4iM1L1WYyAmQEcLlJ4CAcMdjACa0iBCEbwufLrLN3NRCTx1
         4WQhPhw2g7j7Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v3 08/14] docs: netdev: rephrase the 'should I update patchwork' question
Date:   Tue, 29 Mar 2022 21:24:59 -0700
Message-Id: <20220330042505.2902770-9-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330042505.2902770-1-kuba@kernel.org>
References: <20220330042505.2902770-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the question shorter and adjust the start of the answer accordingly.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdev-FAQ.rst | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index 00ac300ebe6a..9c455d08510d 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -125,9 +125,11 @@ Asking the maintainer for status updates on your
 patch is a good way to ensure your patch is ignored or pushed to the
 bottom of the priority list.
 
-I submitted multiple versions of the patch series. Should I directly update patchwork for the previous versions of these patch series?
---------------------------------------------------------------------------------------------------------------------------------------
-No, please don't interfere with the patch status on patchwork, leave
+Should I directly update patchwork state of my own patches?
+-----------------------------------------------------------
+It may be tempting to help the maintainers and update the state of your
+own patches when you post a new version or spot a bug. Please do not do that.
+Interfering with the patch status on patchwork will only cause confusion. Leave
 it to the maintainer to figure out what is the most recent and current
 version that should be applied. If there is any doubt, the maintainer
 will reply and ask what should be done.
-- 
2.34.1

