Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 293346C5A14
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 00:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjCVXMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 19:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjCVXMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 19:12:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AEE1F976;
        Wed, 22 Mar 2023 16:12:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38D24622AE;
        Wed, 22 Mar 2023 23:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43950C433EF;
        Wed, 22 Mar 2023 23:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679526725;
        bh=WT0iGPe8aO02K38pg9YUokWwFwEi1y3oeJ6wfh7kpm0=;
        h=From:To:Cc:Subject:Date:From;
        b=b8vXLUPTNpElNI1iOoI8cUcdF9gcQGweFoXj57fnHvldEiHzFckHerVOjvZ6l3kph
         IuxlnvErEYwPzazf/7ep3o5JU7INyPsT8wQfG7NofWXgCOp/F140JyKZIbGBycyF9L
         Sbr9OtjnIJ0HrYwdBIDr7BkJjqcVHIJiJCn598OB4ykO41xDPCuqdNpH3zm46lV6WT
         nV12hZ4/tNt7Ia+43+iWuSejKzOPFPdA8wRNnQpUy7/YN+SxKFNKp4fycoAOv59bfm
         ykDl4gpKSzPmneZGMyh1BUgv7B6ejRj1x6Lk36Hce4aNV7fgaW8PRfP+4qgopDmRUe
         /omSnbDsGk2Ew==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, sean.anderson@seco.com,
        corbet@lwn.net, linux-doc@vger.kernel.org
Subject: [PATCH net-next] docs: netdev: add note about Changes Requested and revising commit messages
Date:   Wed, 22 Mar 2023 16:12:02 -0700
Message-Id: <20230322231202.265835-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One of the most commonly asked questions is "I answered all questions
and don't need to make any code changes, why was the patch not applied".
Document our time honored tradition of asking people to repost with
improved commit messages, to record the answers to reviewer questions.

Take this opportunity to also recommend a change log format.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
I couldn't come up with a real example of the commit message.
LMK if the fake one is too silly :)

CC: sean.anderson@seco.com
CC: corbet@lwn.net
CC: linux-doc@vger.kernel.org
---
 Documentation/process/maintainer-netdev.rst | 29 +++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/Documentation/process/maintainer-netdev.rst b/Documentation/process/maintainer-netdev.rst
index 4a75686d35ab..4d109d92f40d 100644
--- a/Documentation/process/maintainer-netdev.rst
+++ b/Documentation/process/maintainer-netdev.rst
@@ -109,6 +109,8 @@ Finally, the vX.Y gets released, and the whole cycle starts over.
 netdev patch review
 -------------------
 
+.. _patch_status:
+
 Patch status
 ~~~~~~~~~~~~
 
@@ -143,6 +145,33 @@ Asking the maintainer for status updates on your
 patch is a good way to ensure your patch is ignored or pushed to the
 bottom of the priority list.
 
+Changes requested
+~~~~~~~~~~~~~~~~~
+
+Patches :ref:`marked<patch_status>` as ``Changes Requested`` need
+to be revised. The new version should come with a change log,
+preferably including links to previous postings, for example::
+
+  [PATCH net-next v3] net: make cows go moo
+
+  Even users who don't drink milk appreciate hearing the cows go "moo".
+
+  The amount of mooing will depend on packet rate so should match
+  the diurnal cycle quite well.
+
+  Signed-of-by: Joe Defarmer <joe@barn.org>
+  ---
+  v3:
+    - add a note about time-of-day mooing fluctuation to the commit message
+  v2: https://lore.kernel.org/netdev/123themessageid@barn.org/
+    - fix missing argument in kernel doc for netif_is_bovine()
+    - fix memory leak in netdev_register_cow()
+  v1: https://lore.kernel.org/netdev/456getstheclicks@barn.org/
+
+Commit message should be revised to answer any questions reviewers
+had to ask in previous discussions. Occasionally the update of
+the commit message will be the only change in the new version.
+
 Partial resends
 ~~~~~~~~~~~~~~~
 
-- 
2.39.2

