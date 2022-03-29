Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDDA74EA6E8
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 07:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbiC2FKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 01:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbiC2FKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 01:10:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDB05F47;
        Mon, 28 Mar 2022 22:08:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5476CB8128D;
        Tue, 29 Mar 2022 05:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B1AC34114;
        Tue, 29 Mar 2022 05:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648530528;
        bh=1Zl5dHW90eZRIfCamQ/UYhcRQ7O3wbAmT3PaNN33wAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=auA9oHbufjsONF02Dw91kcW1tlGFaqxWafZttR49laGQLrEakDDjtP5gPsytzCK/G
         xo6uQCOM64LGcssP/WF3tMLaTkCATqSOxm/iI1A3raroY3kC9PIyiVSlmbhbvHEByj
         oDUBEwnBM3iXxXDs/wrWhDJrD1/n5BL1ifd7GA0s82yu0dG6/NbwXK7Kt0wLUEN5/+
         yr2lR6G6DnX0o14tOCkyJ8qVWCCLHVgG7Ri2EGQtzENoJWS5oNr2UXD2EG8UAHdsUn
         vKEb723goNRuBsh/SnT6FhWR3aqi1KHea+OaBTJIE+sbi+EOSwMh5PAfzkdCsbL+Dd
         2cu/FeWXivdVw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 07/14] docs: netdev: rephrase the 'Under review' question
Date:   Mon, 28 Mar 2022 22:08:23 -0700
Message-Id: <20220329050830.2755213-8-kuba@kernel.org>
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

The semantics of "Under review" have shifted. Reword the question
about it a bit and focus it on the response time.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdev-FAQ.rst | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index e10a8140d642..00ac300ebe6a 100644
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

