Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A51DD59A609
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 21:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350288AbiHSTGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 15:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350291AbiHSTGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 15:06:08 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B5A109756
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 12:06:06 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-33352499223so90312557b3.8
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 12:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=5JSsb+WOL2PRRRtzCmHCqxve5DtUEXcq/IOMBu4qce0=;
        b=SRGFz0UxO9qHFdoqQw32kNSRjkhmTjtfPheQkpWP605nkFzoYps1LZGNARmWXWb9MY
         G74w1rODJWrscyDa9rUk1mw8kYD5jw6ckmmgwCJuMuEapsu83BphhpcQ0M7mMp0h7KJj
         tQvJn64oDzHkh5ZGKK96zNBffP0UibPQiEw4Bj7Jo1HikizPf8mgF3kZNLzMWyBqcJTu
         RD6t9gPjUEvww/MCbtYDwqlp0fybRBzDus+1Vq+LIt1Ho0vJ+t6BoM1XX5atqgFnAfCj
         HCGKXdJJxK+C8iIO8XPBoYs0ap2fX1hJ8Th0ia5X5IRC8/Oss88K3pZlacOoJy/uAlxX
         cfTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=5JSsb+WOL2PRRRtzCmHCqxve5DtUEXcq/IOMBu4qce0=;
        b=ng59zD24sZce94yyDOUTylE/eWLyK0clwcKExq110ywsClrMWlj9VK11rCc3mcaufE
         Xh/Ds0RYOG3RKU+BgMy0mufeIe92RXQx4GKV2QL21bNjFCUvWq9R/NIqYg48tsXDwYh5
         qvy+EKEu0Mn/plJWuUYqrcvtFSWY1g5KYfABs1tmjxlAP7b+VqKD1reDLkAjntIYl4Lc
         7sfJocavjHuUWUaieEMyPp6FJ4KvHBP1vjLJyY6WUfekq98Dl3XxmPcTj8kvsz2j2m41
         ddX4XbD3Zd1reOLdCTKC9Ho642I6MPvG/RnggUMA2o+dk2p3T+ayuItXXujcmN5pOZ9w
         2vVg==
X-Gm-Message-State: ACgBeo0pkxdTaYYv4bW9zFND5rR0/AJUUPRp7J0AkuibopDZOzuePqB4
        duBkistrZI6WG4yTKI4CP9/+pEan5860c7bnhUVH
X-Google-Smtp-Source: AA6agR7COISpW6YfKqsutuWvWAN6P5p0kgRn+s9JAiTVa5fT1l1f3q6RNbxgEh2pJIBNHpn9F5/leOvSW9+DPABnP87+
X-Received: from ajr0.svl.corp.google.com ([2620:15c:2d4:203:676:8328:93fe:a318])
 (user=axelrasmussen job=sendgmr) by 2002:a05:6902:124f:b0:66e:e3da:487e with
 SMTP id t15-20020a056902124f00b0066ee3da487emr9778025ybu.310.1660935965922;
 Fri, 19 Aug 2022 12:06:05 -0700 (PDT)
Date:   Fri, 19 Aug 2022 12:05:58 -0700
Message-Id: <20220819190558.477166-1-axelrasmussen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH] selftests: fix a couple missing .gitignore entries
From:   Axel Rasmussen <axelrasmussen@google.com>
To:     Andrei Vagin <avagin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Kees Cook <keescook@chromium.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some recent commits added new test binaries, but forgot to add those to
.gitignore. Now, after one does "make -C tools/testing/selftests", one
ends up with some untracked files in the kernel tree.

Add the test binaries to .gitignore, to avoid this minor annoyance.

Fixes: d8b6171bd58a ("selftests/io_uring: test zerocopy send")
Fixes: 6342140db660 ("selftests/timens: add a test for vfork+exit")
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
---
 tools/testing/selftests/net/.gitignore    | 3 ++-
 tools/testing/selftests/timens/.gitignore | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 0e5751af6247..02abf8fdfd3a 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -39,4 +39,5 @@ toeplitz
 tun
 cmsg_sender
 unix_connect
-tap
\ No newline at end of file
+tap
+io_uring_zerocopy_tx
diff --git a/tools/testing/selftests/timens/.gitignore b/tools/testing/selftests/timens/.gitignore
index fe1eb8271b35..cae8dca0fbff 100644
--- a/tools/testing/selftests/timens/.gitignore
+++ b/tools/testing/selftests/timens/.gitignore
@@ -8,3 +8,4 @@ procfs
 timens
 timer
 timerfd
+vfork_exec
-- 
2.37.1.595.g718a3a8f04-goog

