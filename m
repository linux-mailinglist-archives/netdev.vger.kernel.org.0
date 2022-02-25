Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99044C4249
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 11:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239490AbiBYK2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 05:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239492AbiBYK2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 05:28:36 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11CB673F7;
        Fri, 25 Feb 2022 02:27:43 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id 26B9E1F45BB1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1645784862;
        bh=wzxS9IYpPZYXwEBTYdvdnNqibFpihz4xflY5zMogAxw=;
        h=From:To:Cc:Subject:Date:From;
        b=VKWuyAqhuFnGiCvci1gV4hdzLXUNYnEG29UDYAHHmMJUGf/VplyVlC6hio64RgXVh
         c2vi5rRzT/sNiMmNbJ034SbUkSMbPuEOnTGfQjiOIrZ6bEMjWFPHyeVb68a8KAgqY1
         6sTseP/esTX73pONhiZ598BQM+oOpeBQhQUBslcCnDapx5P0ZCxzanByG3F4yKZ3No
         o+aGuGXtQGthl8O9IbGliDLuIvtmuUgFs4sY04n45g853JvuqO6U5I3unNGVN9HaJA
         zy9xWkWx3Js2KymGJvDXPGwGqUGio+a2jPy4qdhqmZGGeACNiS90wdd7Z5H4hu/gn+
         77OEgtfUlcILQ==
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
To:     Shuah Khan <shuah@kernel.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        kernel@collabora.com, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] kselftest: add generated objects to .gitignore
Date:   Fri, 25 Feb 2022 15:27:25 +0500
Message-Id: <20220225102726.3231228-1-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add kselftests_install directory and some other files to the
.gitignore.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 tools/testing/selftests/.gitignore      | 1 +
 tools/testing/selftests/exec/.gitignore | 2 ++
 tools/testing/selftests/kvm/.gitignore  | 1 +
 tools/testing/selftests/net/.gitignore  | 1 +
 4 files changed, 5 insertions(+)

diff --git a/tools/testing/selftests/.gitignore b/tools/testing/selftests/.gitignore
index 055a5019b13c..cb24124ac5b9 100644
--- a/tools/testing/selftests/.gitignore
+++ b/tools/testing/selftests/.gitignore
@@ -3,6 +3,7 @@ gpiogpio-event-mon
 gpiogpio-hammer
 gpioinclude/
 gpiolsgpio
+kselftest_install/
 tpm2/SpaceTest.log
 
 # Python bytecode and cache
diff --git a/tools/testing/selftests/exec/.gitignore b/tools/testing/selftests/exec/.gitignore
index 9e2f00343f15..2f715782b076 100644
--- a/tools/testing/selftests/exec/.gitignore
+++ b/tools/testing/selftests/exec/.gitignore
@@ -12,3 +12,5 @@ execveat.denatured
 xxxxxxxx*
 pipe
 S_I*.test
+non-regular
+null-argv
diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 7903580a48ac..4d11adeac214 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -21,6 +21,7 @@
 /x86_64/hyperv_clock
 /x86_64/hyperv_cpuid
 /x86_64/hyperv_features
+/x86_64/hyperv_svm_test
 /x86_64/mmio_warning_test
 /x86_64/mmu_role_test
 /x86_64/platform_info_test
diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 21a411b04890..c3a6dc45eff4 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -36,3 +36,4 @@ gro
 ioam6_parser
 toeplitz
 cmsg_sender
+cmsg_so_mark
-- 
2.30.2

