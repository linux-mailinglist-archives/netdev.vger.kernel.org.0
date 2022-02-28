Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B0E4C60B4
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 02:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbiB1BzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 20:55:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiB1BzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 20:55:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFD033A0C
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 17:54:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3231E60A0F
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 01:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5FEC340E9;
        Mon, 28 Feb 2022 01:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646013280;
        bh=3ZNr8TaM0G7V0Z5MYNQiRyQn8nqFWzCMDexcjyDBXC8=;
        h=From:To:Cc:Subject:Date:From;
        b=adRt/MxcYXTjtkUJSLU21dZ7wuT76iDDewDedaHAOvS6zeJfaT521UOvDBbDSE2W3
         5vtyLl9ntRAbNTBHCGymlQtI2AYr/P/r7MLkAimKhZzTUQhLKbucUc+ntK46HzeNne
         QJ5ySPosvpvgSM+ZMmMDLJsvYj1Fk9ThZ6pVre8cOzT1+gJ2xA1lTTXgqwOPAPHVhC
         iKVQsY6J3E+i6o4wHsVt1ZoJSgQxllY5JHC6MECNNGPcHXwuAfow3BO4hyqkgfpU32
         mohMU3IdR9vjtBnjINACQ04CzQc1OQ+YrCfueN0KmrZkakyn1SCqIYMabO4JnvK56f
         SVOZ0y5qpfHkQ==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2-next] configure: Allow command line override of toolchain
Date:   Sun, 27 Feb 2022 18:54:35 -0700
Message-Id: <20220228015435.1328-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Easy way to build for both gcc and clang.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 configure | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/configure b/configure
index 8ddff43c6a7d..13f2d1739b99 100755
--- a/configure
+++ b/configure
@@ -19,10 +19,10 @@ check_toolchain()
     : ${AR=ar}
     : ${CC=gcc}
     : ${YACC=bison}
-    echo "PKG_CONFIG:=${PKG_CONFIG}" >>$CONFIG
-    echo "AR:=${AR}" >>$CONFIG
-    echo "CC:=${CC}" >>$CONFIG
-    echo "YACC:=${YACC}" >>$CONFIG
+    echo "PKG_CONFIG?=${PKG_CONFIG}" >>$CONFIG
+    echo "AR?=${AR}" >>$CONFIG
+    echo "CC?=${CC}" >>$CONFIG
+    echo "YACC?=${YACC}" >>$CONFIG
 }
 
 check_atm()
-- 
2.24.3 (Apple Git-128)

