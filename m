Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 161404EA6E1
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 07:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbiC2FKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 01:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbiC2FKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 01:10:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1C85FDB;
        Mon, 28 Mar 2022 22:08:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8B292CE1754;
        Tue, 29 Mar 2022 05:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E61C34111;
        Tue, 29 Mar 2022 05:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648530527;
        bh=NatzCXB0aPSVFPpNVuRVhJQSjaINFph+hqtkv+/sTDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLwpIdpa50Zo97saRCnTyZRlS6GqvXabaSulq513kbpStWecWbXfI6y60unjNldiX
         A8eF3Z+4p3fb1Y44z1CZf4vqIT7yJUcqCJ0YS0mXjb/mPdtWQ/16mepBe1Aw0BLLep
         NqUmZ4XU5RRBhVlfuQCBJzdeTutgOlah+x8WZ8LtbY+5X6hqCYjzUgs+pXiTcheY+J
         vLZ9NqmAO1tvVB29YuZlUyf2OtqQjqiB+robbu+R4MO6Foa3UnihzUV80ks7Sf1cYB
         0+2E8v6czHKrINZTdctIaclbiLmpTRJxdB3ml/hZs/1b9j+Z3DaL6YTBdZ/W7fr+Kr
         gd2JNrHVNE4SQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 05/14] docs: netdev: note that RFC postings are allowed any time
Date:   Mon, 28 Mar 2022 22:08:21 -0700
Message-Id: <20220329050830.2755213-6-kuba@kernel.org>
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

Document that RFCs are allowed during the merge window.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
v2: new patch
---
 Documentation/networking/netdev-FAQ.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index 041993258dda..f4c77efa75d4 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -74,6 +74,9 @@ sent to netdev, but knowing the above, you can predict that in advance.
   Do not send new ``net-next`` content to netdev during the
   period during which ``net-next`` tree is closed.
 
+RFC patches sent for review only are obviously welcome at any time
+(use ``--subject-prefix='RFC net-next'`` with ``git format-patch``).
+
 Shortly after the two weeks have passed (and vX.Y-rc1 is released), the
 tree for ``net-next`` reopens to collect content for the next (vX.Y+1)
 release.
-- 
2.34.1

