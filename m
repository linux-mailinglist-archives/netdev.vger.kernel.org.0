Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF0556C605
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 04:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiGICl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 22:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiGICl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 22:41:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED35768716;
        Fri,  8 Jul 2022 19:41:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0EB3B80CE9;
        Sat,  9 Jul 2022 02:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04075C341C0;
        Sat,  9 Jul 2022 02:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657334513;
        bh=umfFLEka3XrPxdqusW3BhDWioTLO6SMD/4V8fO3jGSc=;
        h=From:To:Cc:Subject:Date:From;
        b=q5egRZWRl7CgQ/8xhi30z8GzAg6plxGN8zO7ukerkfatFQDJ6GUlkND4cQWrp9A4h
         QSa7QZw9GC6Wry0D073IBjtJa7E+l7uLbrQux1guQJArE25/BWs48o4R0rhXvgF/5r
         723o9vbi/IYA32uAvdGnckivLIzWH7YNcTztErvdkXt9sFqCm7irF/7epdznurf57U
         twujhG2+5ShLCQDCs7M1nVtf2hesE09RwrEsV9PCsreElV60Z9VyCAVd3aHcFd2kRD
         oRDw8I36/eS2YjIPVd83No6EVUSvAi4uJa/LwD5CBH/YZQ5QBdaqCPoz9hp3NelNWL
         lmBTPKDkVsmHQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] selftest: net: add tun to .gitignore
Date:   Fri,  8 Jul 2022 19:41:41 -0700
Message-Id: <20220709024141.321683-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing .gitignore entry.

Fixes: 839b92fede7b ("selftest: tun: add test for NAPI dismantle")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index a29f79618934..ffc35a22e914 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -36,4 +36,5 @@ test_unix_oob
 gro
 ioam6_parser
 toeplitz
+tun
 cmsg_sender
-- 
2.36.1

