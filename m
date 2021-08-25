Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40AF83F73DA
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 12:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240209AbhHYK6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 06:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240182AbhHYK6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 06:58:17 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC83C06179A
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 03:57:30 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id mw10-20020a17090b4d0a00b0017b59213831so3914989pjb.0
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 03:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xDf10gq4U23Bi2OPexvVH69ZtkM5tb8AADS9VpuiTzk=;
        b=P6o7HaZptk3Mk77vxNpw6kBasIhYFaBgOzUp3KbjXtfIVZ2WEK5h8ChaLvaXWgheo4
         6/zbFxJRurqi7s+fr6LTQDMYKJ9ECk2gZVaL95h5G76LC2cOECSZY39kOyQ+5CZFhwR0
         dTd9BbhLVTWogMUvXYdo7dUaG5FGDiDimGCOgttCuFdCc+jK467TP7/85JZkAgzrj6BU
         PpiuwsyLCaUHbPwJQfAGc4wM2j8rV3fLhMf33a9/dQ7tEfqb1Vx6mjBgIduXZQmeUXyY
         H8VA4gTcmv2n2Fu2agz7cPh9gG+9jDnkzZAKf02EruOdhBl1IcdgYqxQp1/i4D2ZyemS
         n/gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xDf10gq4U23Bi2OPexvVH69ZtkM5tb8AADS9VpuiTzk=;
        b=FcZtQulXRf2SWQ4VOOz8wtengw68saE0Sn6EGvSySaIc9/CeVHWiUYRwCs23o+gYbB
         XDLY8K9r6dQ0iv4b1G6JidXgLKK0HbumVggVOzybwks3bic8Df6DGbiVqetDP0eUAi44
         mc5srsznHrrbHDG7qWpTyGf5uCEiXjQxlyYij8gIYnKZL+DRQbMOaTOFnN0vsKo8jjy+
         GMJ74sjRmdje+MpzTY9aqHwE7oAKKnUw30zub9+0oft6TK76jbIt4zJOwIzi74d4/YzG
         QuORL2XUhxtA4TkwvZVgyDnsdaPp3LVp9EmnD2YDa20FOxHQBHw4Ve188Sr7zlXEPlhQ
         eGEg==
X-Gm-Message-State: AOAM53332TSCkmVgDK6JQwVw7nZnvM0AHE70GJOs7bB/h3FT+wh13v5P
        xLkp8MOqxupN5rTD1l5k1sg=
X-Google-Smtp-Source: ABdhPJw1MEYt/1zA64LXqfJ/xIFzeJVC1t6ioj5MtXrFI/B5NtOWR55KyGn/q6TjiihpaxGxxHYLgA==
X-Received: by 2002:a17:902:8c81:b029:12c:ee37:3f58 with SMTP id t1-20020a1709028c81b029012cee373f58mr37452669plo.45.1629889050045;
        Wed, 25 Aug 2021 03:57:30 -0700 (PDT)
Received: from MASTER.. ([58.76.185.115])
        by smtp.gmail.com with ESMTPSA id 6sm5606191pjz.8.2021.08.25.03.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 03:57:29 -0700 (PDT)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     hawk@kernel.org, davem@davemloft.net, toke@toke.dk
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 3/3] pktgen: document the latest pktgen usage options
Date:   Wed, 25 Aug 2021 19:57:17 +0900
Message-Id: <20210825105717.43195-4-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210825105717.43195-1-claudiajkang@gmail.com>
References: <20210825105717.43195-1-claudiajkang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the pktgen.rst documentation doesn't cover the latest pktgen
sample usage options such as count and IPv6, and so on. Also, this
documentation includes the old sample scripts which are no longer use
because it was removed by the commit a4b6ade8359f ("samples/pktgen :
remove remaining old pktgen sample scripts")

Thus, this commit documents pktgen sample usage using the latest options
and removes old sample scripts, and fixes a minor typo.

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
---
 Documentation/networking/pktgen.rst | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/Documentation/networking/pktgen.rst b/Documentation/networking/pktgen.rst
index 7afa1c9f1183..1225f0f63ff0 100644
--- a/Documentation/networking/pktgen.rst
+++ b/Documentation/networking/pktgen.rst
@@ -248,26 +248,24 @@ Usage:::

   -i : ($DEV)       output interface/device (required)
   -s : ($PKT_SIZE)  packet size
-  -d : ($DEST_IP)   destination IP
+  -d : ($DEST_IP)   destination IP. CIDR (e.g. 198.18.0.0/15) is also allowed
   -m : ($DST_MAC)   destination MAC-addr
+  -p : ($DST_PORT)  destination PORT range (e.g. 433-444) is also allowed
   -t : ($THREADS)   threads to start
+  -f : ($F_THREAD)  index of first thread (zero indexed CPU number)
   -c : ($SKB_CLONE) SKB clones send before alloc new SKB
+  -n : ($COUNT)     num messages to send per thread, 0 means indefinitely
   -b : ($BURST)     HW level bursting of SKBs
   -v : ($VERBOSE)   verbose
   -x : ($DEBUG)     debug
+  -6 : ($IP6)       IPv6
+  -w : ($DELAY)     Tx Delay value (ns)
+  -a : ($APPEND)    Script will not reset generator's state, but will append its config

 The global variables being set are also listed.  E.g. the required
 interface/device parameter "-i" sets variable $DEV.  Copy the
 pktgen_sampleXX scripts and modify them to fit your own needs.

-The old scripts::
-
-    pktgen.conf-1-2                  # 1 CPU 2 dev
-    pktgen.conf-1-1-rdos             # 1 CPU 1 dev w. route DoS
-    pktgen.conf-1-1-ip6              # 1 CPU 1 dev ipv6
-    pktgen.conf-1-1-ip6-rdos         # 1 CPU 1 dev ipv6  w. route DoS
-    pktgen.conf-1-1-flows            # 1 CPU 1 dev multiple flows.
-

 Interrupt affinity
 ===================
@@ -398,7 +396,7 @@ Current commands and configuration options
 References:

 - ftp://robur.slu.se/pub/Linux/net-development/pktgen-testing/
-- tp://robur.slu.se/pub/Linux/net-development/pktgen-testing/examples/
+- ftp://robur.slu.se/pub/Linux/net-development/pktgen-testing/examples/

 Paper from Linux-Kongress in Erlangen 2004.
 - ftp://robur.slu.se/pub/Linux/net-development/pktgen-testing/pktgen_paper.pdf
--
2.30.2

