Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40BD66E4B82
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 16:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbjDQOcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 10:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbjDQOc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 10:32:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E79AD38
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 07:32:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A95F1625CB
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 14:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D9FC4339B;
        Mon, 17 Apr 2023 14:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681741941;
        bh=ncxpGOSaL56uTiJe56OB54FSN1HoiRc4uRzhwedAZws=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LiJL6mAjRHZinf6vsps7QIxrRg/Ctwj30PlaAL6DIutmKc+4+afW6LarubsQ6qWm1
         fpiGXziJ1amSiWsJHwy//o65z0FBihe4Mdaykf17/8Bq3G9IVde6oifjyklpJYvSlx
         R6swEpi/9rpCwR9ymVBzhaDhB61zUyDbZZEmBU9eCaCW0x9aJIqQmEXbd3mLCyBVSL
         itBUV0op9cpMXOMajCcgWZF/k34i6z+9BGND3zizu3rorlEPwqEgMsk6NUqY4STJZ4
         HxrHXcV8pk2a9O7QAbS4jmu/Jt+i3chyNxRfr1OFaxgzu6ZFTjf+rHWf4RNLuanmsW
         PG9ZxDiG0ReBA==
Subject: [PATCH v10 1/4] .gitignore: Do not ignore .kunitconfig files
From:   Chuck Lever <cel@kernel.org>
To:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Cc:     netdev@vger.kernel.org, kernel-tls-handshake@lists.linux.dev
Date:   Mon, 17 Apr 2023 10:32:19 -0400
Message-ID: <168174193954.9520.14714553158588211840.stgit@91.116.238.104.host.secureserver.net>
In-Reply-To: <168174169259.9520.1911007910797225963.stgit@91.116.238.104.host.secureserver.net>
References: <168174169259.9520.1911007910797225963.stgit@91.116.238.104.host.secureserver.net>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

Circumvent the .gitignore wildcard to avoid warnings about ignored
.kunitconfig files. As far as I can tell, the warnings are harmless
and these files are not actually ignored.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202304142337.jc4oUrov-lkp@intel.com/
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 .gitignore |    1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 70ec6037fa7a..51117ba29c88 100644
--- a/.gitignore
+++ b/.gitignore
@@ -105,6 +105,7 @@ modules.order
 !.gitignore
 !.mailmap
 !.rustfmt.toml
+!.kunitconfig
 
 #
 # Generated include files


