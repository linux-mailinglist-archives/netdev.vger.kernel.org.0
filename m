Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9154EB983
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 06:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242534AbiC3E1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 00:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242510AbiC3E07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 00:26:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E524DF12;
        Tue, 29 Mar 2022 21:25:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF3D16154F;
        Wed, 30 Mar 2022 04:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C56C34112;
        Wed, 30 Mar 2022 04:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648614314;
        bh=Er8YOZixM4jKeeHVZrftGgBEi/e3ZfteGSGNqYpWtjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BA5VY8mSCChbxjABGX8WigW4bg+X2p9siIcFqRng7P01Ogzjw07jDmzVoZA9ihQ/b
         wthG40uHPZZx72x32dfeQcvIlPNwrLkTY++TDLP7b64gFiT413wfmoeB7zI+ji9vaK
         PTRLrxvI9rwMae822272+reMWnfvry7Da1pJ/9haSmrj2PjazT3icBwG3R8wb1GY4a
         wwJyYhp7RTl/yNeVvHjDnShYf1JCdsSRpBclWfbJ0vAhsqf+SfvMQLfqMwEGeeEM6H
         vFqWqI8OlLldZP0KH+9tq4rpDMD8xX4FVKWodzODQDBtcbGpJJmj7GccXJzMPR1d7/
         1gFQ+5WtKJ2Sw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v3 06/14] docs: netdev: shorten the name and mention msgid for patch status
Date:   Tue, 29 Mar 2022 21:24:57 -0700
Message-Id: <20220330042505.2902770-7-kuba@kernel.org>
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

Cut down the length of the question so it renders better in docs.
Mention that Message-ID can be used to search patchwork.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/networking/netdev-FAQ.rst | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index f4c77efa75d4..e10a8140d642 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -105,14 +105,16 @@ and note the top of the "tags" section.  If it is rc1, it is early in
 the dev cycle.  If it was tagged rc7 a week ago, then a release is
 probably imminent.
 
-I sent a patch and I'm wondering what happened to it - how can I tell whether it got merged?
---------------------------------------------------------------------------------------------
+How can I tell the status of a patch I've sent?
+-----------------------------------------------
 Start by looking at the main patchworks queue for netdev:
 
   https://patchwork.kernel.org/project/netdevbpf/list/
 
 The "State" field will tell you exactly where things are at with your
-patch.
+patch. Patches are indexed by the ``Message-ID`` header of the emails
+which carried them so if you have trouble finding your patch append
+the value of ``Message-ID`` to the URL above.
 
 The above only says "Under Review".  How can I find out more?
 -------------------------------------------------------------
-- 
2.34.1

