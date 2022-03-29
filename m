Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F36DE4EA6D6
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 07:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbiC2FKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 01:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbiC2FKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 01:10:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009165FDB;
        Mon, 28 Mar 2022 22:08:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5ABEB8129E;
        Tue, 29 Mar 2022 05:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173FDC34110;
        Tue, 29 Mar 2022 05:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648530526;
        bh=Y73qK9ruF5HFRSBlgXRAQY5JQ8nYLtLAB1qQ9NgYAOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=idextr0fg2Ru8CsMZ00ULm/MlaGnn27vJS3hZ/jN4EDCTWSW1E4B/HJKraIKmS+Gi
         Bsqkz3omB0zAHIRCKR/85bjCE6bHj3+lE1BaWIKP0gCq0kzcZTx086U8o0qQO3m+zw
         fwb7z54hekoavzIe0nd8NTsl4PocxPIM8eYQqEHySnoRNfOQIRza68njM/Ce2mTUJ8
         MykSZbhR2365tViBMuoU09jSLMOjzZzEU8mGcWR5b0+jKotfn8r6eh54absuDIYVAU
         1w7YQJV2v6L1xuoVjH7KdEFG10IgQppK8r9rvO10MiuZGFOcq2ndh/XVA69XItq4EM
         iMXcsEzhc4Vzw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 04/14] docs: netdev: turn the net-next closed into a Warning
Date:   Mon, 28 Mar 2022 22:08:20 -0700
Message-Id: <20220329050830.2755213-5-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220329050830.2755213-1-kuba@kernel.org>
References: <20220329050830.2755213-1-kuba@kernel.org>
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

Use the sphinx Warning box to make the net-next being closed
stand out more.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdev-FAQ.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index fd5f5a1a0846..041993258dda 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -70,8 +70,9 @@ relating to vX.Y
 An announcement indicating when ``net-next`` has been closed is usually
 sent to netdev, but knowing the above, you can predict that in advance.
 
-IMPORTANT: Do not send new ``net-next`` content to netdev during the
-period during which ``net-next`` tree is closed.
+.. warning::
+  Do not send new ``net-next`` content to netdev during the
+  period during which ``net-next`` tree is closed.
 
 Shortly after the two weeks have passed (and vX.Y-rc1 is released), the
 tree for ``net-next`` reopens to collect content for the next (vX.Y+1)
-- 
2.34.1

