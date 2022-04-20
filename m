Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158DB508051
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 06:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350180AbiDTE6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 00:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238693AbiDTE6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 00:58:01 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FBC167EC
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 21:55:17 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id x12so255203qtp.9
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 21:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=1ylqEqxzb9r+YeMoJNAalBpdnk8Al8y9yQpbE6jYWN8=;
        b=Z/EMKqBjndW27c8d00KoK5XYXz0QVINpLblAgbn4V8X+934rHn4ZTLmYgD/dlk0O8V
         z76C21QhCIif3+3WtiENDgNQIPhYPZZD6lBl0vVLU5UNNcXxYJVhcpo9HUhjkWQYFnsQ
         fdMDDC4Suv56Q5GvwQAuE4O0o+s9hqEmJMKtO7zBAz0eb69Mf3ltEGqvzBf7OyGq0rf5
         BzM4Jp58YpHz+fshG999vOFzU31XM5TfUFrs5ntJiVux8Xt2124cNOzxiw8h80gn3aCN
         M3/JvFThPDeqDtxCXV4yurBDBmEkbxhKgqi5CmKbIGnhAdGonlVuXAOYbyK7tt6lKUr3
         BtMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=1ylqEqxzb9r+YeMoJNAalBpdnk8Al8y9yQpbE6jYWN8=;
        b=S9QQ3LsdH6e3/Fxqnu9w+MNPy7k6Y7blFTUCQV40HLzet6J0pMApCS9ORww/TX5U4R
         AMG6+o69HduYbv5w/V5B2+IEb7wCCTzpgTpWWbq/UCyZeFG4869awb8+9A1x34A7rSPE
         hmQyNZeb9HvMi8UiiwKVlJTMndeXL3zeXMizt3SSdcKO8Le2K8ns2igBCCC3cofjvqyj
         GfRKm3W/pmvw69seiaPzHWy7lR7Hq/7tXSQSeiwXeDKLuWcosWyuu2DUvPnAYZi69drf
         6ZtwAtfNukIF75HqSWwHQAGhbhPlyKi+gLXM3Sl3/MGtYb4mKjqGIotq6c+GGXdLDZHS
         NQOg==
X-Gm-Message-State: AOAM530jswShQmLY6rg36CHOSFRB7VZwuyeQrTl+x1d6epe+/brBH62Z
        54iRTe6vvTvUKWie2JmDTaA=
X-Google-Smtp-Source: ABdhPJwEWkBriThwlBbwY51TmenNIKzBixQ9gSvamRxmY+0KSaphW0h2fJjpCQtDjaAJOYOr+zL+nA==
X-Received: by 2002:a05:622a:13c6:b0:2e2:2778:2ea5 with SMTP id p6-20020a05622a13c600b002e227782ea5mr12636029qtk.512.1650430516173;
        Tue, 19 Apr 2022 21:55:16 -0700 (PDT)
Received: from jaehee-ThinkPad-X1-Extreme ([2607:fb90:50e7:2813:787e:11ec:44cf:aee6])
        by smtp.gmail.com with ESMTPSA id n81-20020a37a454000000b0069e66f8a905sm1014475qke.17.2022.04.19.21.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 21:55:15 -0700 (PDT)
Date:   Wed, 20 Apr 2022 00:55:12 -0400
From:   Jaehee Park <jhpark1013@gmail.com>
To:     outreachy@lists.linux.dev, Julia Denham <jdenham@redhat.com>,
        Roopa Prabhu <roopa.prabhu@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org,
        jhpark1013@gmail.com
Subject: [PATCH net-next] selftests: net: vrf_strict_mode_test: add support
 to select a test to run
Message-ID: <20220420045512.GA1289782@jaehee-ThinkPad-X1-Extreme>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a boilerplate test loop to run all tests in
vrf_strict_mode_test.sh.

Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
---
 .../testing/selftests/net/vrf_strict_mode_test.sh  | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/vrf_strict_mode_test.sh b/tools/testing/selftests/net/vrf_strict_mode_test.sh
index 865d53c1781c..116ca43381b5 100755
--- a/tools/testing/selftests/net/vrf_strict_mode_test.sh
+++ b/tools/testing/selftests/net/vrf_strict_mode_test.sh
@@ -14,6 +14,8 @@ INIT_NETNS_NAME="init"
 
 PAUSE_ON_FAIL=${PAUSE_ON_FAIL:=no}
 
+TESTS="vrf_strict_mode_tests_init vrf_strict_mode_tests_testns vrf_strict_mode_tests_mix"
+
 log_test()
 {
 	local rc=$1
@@ -391,7 +393,17 @@ fi
 cleanup &> /dev/null
 
 setup
-vrf_strict_mode_tests
+for t in $TESTS
+do
+	case $t in
+	vrf_strict_mode_tests_init|vrf_strict_mode_init) vrf_strict_mode_tests_init;;
+	vrf_strict_mode_tests_testns|vrf_strict_mode_testns) vrf_strict_mode_tests_testns;;
+	vrf_strict_mode_tests_mix|vrf_strict_mode_mix) vrf_strict_mode_tests_mix;;
+
+	help) echo "Test names: $TESTS"; exit 0;;
+
+	esac
+done
 cleanup
 
 print_log_test_results
-- 
2.25.1

