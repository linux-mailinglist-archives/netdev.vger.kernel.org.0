Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1116D7515
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 09:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236999AbjDEHQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 03:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236899AbjDEHQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 03:16:03 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D34A26BA
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 00:15:59 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5458201ab8cso352419697b3.23
        for <netdev@vger.kernel.org>; Wed, 05 Apr 2023 00:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680678958;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=amtanVGX2KHy1Ul9xt/uUN0pT9lmrAuWpQQIKQiY23g=;
        b=dSMQCfa9MREifNlA2b8Nbi7ysInV2bVG2N6YXOUyZkNGHUzEIFRhwGy8XFHeesapkw
         CWZ7GAX6kCuPPTgEAXCTx+hgzcoFLIxZit1p13E1Z2sMpRIYUGfLnDxhNz6fgx1UmlOr
         HW22JflRE0BKizRGPIFW8+gJl1Qd99SdhSmt0MtW36VKv0CyUFxJtNRD0nDFc+Rmr7a5
         wi090rqn4TJdpYE0NxHEu34P/GDZeCYT4VLNwzGXhtcVfe97g/CRwEEL709bVk2kIp40
         /XzqnAZxG4+sjIslAHJVCngqiympL5ydf3925AmMJGsCKFapIm4oGQkFEBiN3zAU68tc
         7c5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680678958;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=amtanVGX2KHy1Ul9xt/uUN0pT9lmrAuWpQQIKQiY23g=;
        b=oHnc3HnhW9/mY7cpcrJH2txKsrLNnzMDKbaYPDzcLqkS9hSmjGkrRcj7M41gHTeb8l
         QE4/7yWXbvZK/76ucJD/NcyryYBzlrka6NH264KmX734pFlNLjfOSZ7F+MC/a/lYjAHs
         3qKt7YtJHKUBUzE24fMWb+WZvQEjs9jagWxqBz6bLAy2+xZ3KKFABZ7kRdo9mwUkM9BN
         9bJSw9osVTfAfHW/5D61IhQFNHuxhJkfComiACFz4XDob4QZkrE6ZxNLpyM9KzSrWQ2m
         4ABC2C3twdctAuRcBlkJ262WtTqdX5VUkkj3FPeou3tPToxoa6yBjgfhZy86nTQ6hUTo
         P/SQ==
X-Gm-Message-State: AAQBX9f8oH8IAnQno+owQBX/F4pGf9MFgQBzaq0hiFl1KuUAdCBOZ7Ng
        4GEBaz42KGQyRuSDXPjLbhRjno08pq0fww==
X-Google-Smtp-Source: AKy350a4xIDSKcYCJ9BtkS+Y76SsrUpLhswejiHETFdlBaHAI/tZdg7e/smTdTcJdd7E6MfvdT4yqYn6wFJ+Vg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:d6c9:0:b0:b78:4b00:775f with SMTP id
 n192-20020a25d6c9000000b00b784b00775fmr2991392ybg.4.1680678958533; Wed, 05
 Apr 2023 00:15:58 -0700 (PDT)
Date:   Wed,  5 Apr 2023 07:15:56 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405071556.1019623-1-edumazet@google.com>
Subject: [PATCH net-next] selftests/net: fix typo in tcp_mmap
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        kernel test robot <lkp@intel.com>,
        Xiaoyan Li <lixiaoyan@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernel test robot reported the following warning:

All warnings (new ones prefixed by >>):

   tcp_mmap.c: In function 'child_thread':
>> tcp_mmap.c:211:61: warning: 'lu' may be used uninitialized in this function [-Wmaybe-uninitialized]
     211 |                         zc.length = min(chunk_size, FILE_SZ - lu);

We want to read FILE_SZ bytes, so the correct expression
should be (FILE_SZ - total)

Fixes: 5c5945dc695c ("selftests/net: Add SHA256 computation over data sent in tcp_mmap")
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202304042104.UFIuevBp-lkp@intel.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Xiaoyan Li <lixiaoyan@google.com>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 tools/testing/selftests/net/tcp_mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/tcp_mmap.c b/tools/testing/selftests/net/tcp_mmap.c
index 607cc9ad8d1b72cdcb96ca0d6fdb70900c9b9bc0..6e59b1461dcceaa658185071a758e1006b48299a 100644
--- a/tools/testing/selftests/net/tcp_mmap.c
+++ b/tools/testing/selftests/net/tcp_mmap.c
@@ -208,7 +208,7 @@ void *child_thread(void *arg)
 
 			memset(&zc, 0, sizeof(zc));
 			zc.address = (__u64)((unsigned long)addr);
-			zc.length = min(chunk_size, FILE_SZ - lu);
+			zc.length = min(chunk_size, FILE_SZ - total);
 
 			res = getsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE,
 					 &zc, &zc_len);
-- 
2.40.0.348.gf938b09366-goog

