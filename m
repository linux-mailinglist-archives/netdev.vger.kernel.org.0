Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1936B442539
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 02:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhKBBkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 21:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhKBBkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 21:40:02 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4314C061714;
        Mon,  1 Nov 2021 18:37:28 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id t21so13492473plr.6;
        Mon, 01 Nov 2021 18:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2wJSCm4mTIxO9BKENLHwFcyBgURfxQfwV9J5UNHWgiQ=;
        b=ACSg5eZuRvHZSNPFtBHnuPrTp04GGzDJj0iLrtszSTC8tawgrscFFIcGtk1cIPRBTg
         3FDOpziZSFqmVh5ILERvg0M3stOS+QuRDBp+mWuB27EBZ2uxKW+ifLJW87p43gHy6Pji
         nVDp7tl3i3uFiVjB+kNt2QHfiVa+a9F9wBI7JowCE/ds21gvqAvC/mKv/IztBsTkfe3F
         MKvJZlwqDxv/Uss4xiZgYs7erBm/qFpor/hYJxKiotPePSLm+lz8nx84frVv0aBdfKcE
         pr6lLf2SeMQAFjVTxABA6ZVopgVcywcH6bPRRNrX796jenkzm/suSohoU5x6Jx0twgdq
         5RPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2wJSCm4mTIxO9BKENLHwFcyBgURfxQfwV9J5UNHWgiQ=;
        b=o1lbMv2nPs6znxJqyUoCgR93mFU3ANPMFOi7CNt+PakB9P97pnpnBG+mHMGxbdqyJx
         r0/wrxgUyha5ZbatsbFFRcFcX4V5BJBR2Kh3kjMeF6cuPyAiYNWko2s/6Tqg7G812CrW
         0jMYEelHA/sXlQgVwPDHnqYSNRiqvi9Y3iWKFPFVSMxd51mmFlftT+zyxGcIRb0t+t0v
         u+6+2EBVLPw0+QQxVsQrdZQWdrjtm/GPQP0HwBWH89qEZiHTehbaCbLLMz4dNO1B/d5w
         a1fFkI4CMxkrKorob4nsxvjKus0Bvhl2Bbnf9/Sm+FmchcTPfdsbVPKePw/ZfeXV+FBh
         Wdgw==
X-Gm-Message-State: AOAM530oQNAl0k3Sk1tBOyfMkdVUXVDahywImtARUl0NmH0E5hio0CYf
        1z/I/mAhfpg++uVl8MMKkhChJqSKzqA=
X-Google-Smtp-Source: ABdhPJyCi5AgvjVgLGH31497o821fgb3cwKF73E1yatdBsm7P6dXdPGXwf5jgMmu9rMy9AtsuiBR9w==
X-Received: by 2002:a17:90b:110d:: with SMTP id gi13mr3004208pjb.1.1635817048222;
        Mon, 01 Nov 2021 18:37:28 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b16sm16867209pfm.58.2021.11.01.18.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 18:37:27 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Coco Li <lixiaoyan@google.com>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net 5/5] kselftests/net: add missed toeplitz.sh/toeplitz_client.sh to Makefile
Date:   Tue,  2 Nov 2021 09:36:36 +0800
Message-Id: <20211102013636.177411-6-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211102013636.177411-1-liuhangbin@gmail.com>
References: <20211102013636.177411-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When generating the selftests to another folder, the toeplitz.sh
and toeplitz_client.sh are missing as they are not in Makefile, e.g.

  make -C tools/testing/selftests/ install \
      TARGETS="net" INSTALL_PATH=/tmp/kselftests

Making them under TEST_PROGS_EXTENDED as they test NIC hardware features
and are not intended to be run from kselftests.

Fixes: 5ebfb4cc3048 ("selftests/net: toeplitz test")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v2: move the tests under TEST_PROGS_EXTENDED as Willem suggested.
---
 tools/testing/selftests/net/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 7328bede35f0..6a953ec793ce 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -33,6 +33,7 @@ TEST_PROGS += srv6_end_dt4_l3vpn_test.sh
 TEST_PROGS += srv6_end_dt6_l3vpn_test.sh
 TEST_PROGS += vrf_strict_mode_test.sh
 TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
+TEST_PROGS_EXTENDED += toeplitz_client.sh toeplitz.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
 TEST_GEN_FILES += tcp_mmap tcp_inq psock_snd txring_overwrite
-- 
2.31.1

