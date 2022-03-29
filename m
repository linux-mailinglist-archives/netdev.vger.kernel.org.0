Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1C054EA6FC
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 07:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbiC2FKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 01:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbiC2FKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 01:10:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C3B65D0;
        Mon, 28 Mar 2022 22:08:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D486B816AA;
        Tue, 29 Mar 2022 05:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23C6C34110;
        Tue, 29 Mar 2022 05:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648530529;
        bh=597EzgyqUo5HMoPJfzujtM5GBcYMh6YxaHst/EREyU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PY3pXkMJXHfJO7z2MObhIyGS47wUKwUHgySADVIVqDbvfK7VX1HinweHctAWXbbBI
         3b5t5e+lxaZ8U2fVu3avspf+HUNFI33BVVF6zfgGZ8ZmQNqZyZPLO+wBX2LR9eQ7bu
         zaQO2RTeqyeM9EkYAlth3rYdMabfnSnm6DGQsLsvCGxUdxmN1AmWA79n5SlTBUQGq2
         1oTy4Eh7KJSKfp1VW67nvuXqF+gQCGvUjc16pb8GIZjihCPTWuFM7gbnnxCb9Y8/i7
         lS7CMFO/TCAuhLCN/c1ylL+6fOfuOV2GUIGfGgMPmcrW89Ed/mwEJ6Zo/zGT/+JWmG
         m4r5od9pq2Nyw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 09/14] docs: netdev: add a question about re-posting frequency
Date:   Mon, 28 Mar 2022 22:08:25 -0700
Message-Id: <20220329050830.2755213-10-kuba@kernel.org>
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

We have to tell people to stop reposting to often lately,
or not to repost while the discussion is ongoing.
Document this.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdev-FAQ.rst | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index 9c455d08510d..f8b89dc81cab 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -140,6 +140,17 @@ No, please resend the entire patch series and make sure you do number your
 patches such that it is clear this is the latest and greatest set of patches
 that can be applied.
 
+I have received review feedback, when should I post a revised version of the patches?
+-------------------------------------------------------------------------------------
+Allow at least 24 hours to pass between postings. This will ensure reviewers
+from all geographical locations have a chance to chime in. Do not wait
+too long (weeks) between postings either as it will make it harder for reviewers
+to recall all the context.
+
+Make sure you address all the feedback in your new posting. Do not post a new
+version of the code if the discussion about the previous version is still
+ongoing, unless directly instructed by a reviewer.
+
 I submitted multiple versions of a patch series and it looks like a version other than the last one has been accepted, what should I do?
 ----------------------------------------------------------------------------------------------------------------------------------------
 There is no revert possible, once it is pushed out, it stays like that.
-- 
2.34.1

