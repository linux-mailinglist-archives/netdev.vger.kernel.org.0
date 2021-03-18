Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B49341111
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 00:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbhCRXcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 19:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbhCRXcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 19:32:03 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48DBC06174A;
        Thu, 18 Mar 2021 16:32:03 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id m7so5450356qtq.11;
        Thu, 18 Mar 2021 16:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qNNmgS5jO9ghaN1h12J0G5/UTr/xxIWCcWjW1ZZJjYA=;
        b=eU9BpRzUo4uuZ5aCMwqNW2HYolvLwcNEPTnFnD09YEoO5KC0oJYniROwtVjWY7qA1w
         KIw4WSCLEsCgNuHuUSmjLSYb97d/NI73y6Eh0IfGQD9bfR1/v1dFkUxGGGVpZ+SnC4EH
         nMbcujanCe6GWbPTbZwFDi0qZRr6CsW1c7ll2aCydBIAwBpd3pgtdSioZ+yRALzfEqYz
         ktyv1/LN8i6nSHSa3B92u1uQ5Dpsz436nd3URzfEG/9qg90pylwMefJ4JESOBZlKHvaE
         yRIoFyBbYrXFmerA+8lSoZO1lbr/zTrL1HDsZEOsz2QBoXQwR+nWAgOd32nIZ6Kr+LM1
         C/lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qNNmgS5jO9ghaN1h12J0G5/UTr/xxIWCcWjW1ZZJjYA=;
        b=hFzFPCcUJaqrv57qYmG5RY7LzXTfky18qK7w8jTeMObnQLK3o9NQyJLGSPCVAp2cd1
         9455Q70L6gZNRGoG34m3RAegMOo8dhd3xaJl5vlq7NOunQ1uwhqlIYNSzMXl8HQ+pTvG
         6tLudehRNoqdh8KGcpoiIJdZxehMMZjN8sULmlv47fVXD/e5wR4zOTNj1OUpu/uQF4Ib
         xnRi5mMYOXp3UfpNUdkscBOnWDL0OHqYusRtwCUNuPD4aI2nSHXyDCSJC/mYciier1A8
         3Q0UM6HLL/THbNK9VxVHdWpm++GLab7/kxmKKX9hxlz3+MbcbMAloQRbEK8UhFKwQBeQ
         AXaw==
X-Gm-Message-State: AOAM533NGgduF6uoPQrPI3oTQPklG1yuNGO/PHNLn4LyG/PYFs0XVGAs
        EPdZa4PodKdcurvdvTCc06R40P0gAFXMMrJk
X-Google-Smtp-Source: ABdhPJzP+CdSsZd0n5w4v4ZYyzgVdaAjb8/9yWUsrKXkKJMKv7R2G9/qTpRqxF9fmlM49qEpGGoQiQ==
X-Received: by 2002:ac8:5510:: with SMTP id j16mr5986398qtq.339.1616110322904;
        Thu, 18 Mar 2021 16:32:02 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.63])
        by smtp.gmail.com with ESMTPSA id t188sm3024152qke.91.2021.03.18.16.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 16:32:02 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        unixbhaskar@gmail.com, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org
Subject: [PATCH] selftests: net: forwarding: Fix a typo
Date:   Fri, 19 Mar 2021 04:59:45 +0530
Message-Id: <20210318232945.17834-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/verfied/verified/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 tools/testing/selftests/net/forwarding/fib_offload_lib.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/fib_offload_lib.sh b/tools/testing/selftests/net/forwarding/fib_offload_lib.sh
index 66496659bea7..e134a5f529c9 100644
--- a/tools/testing/selftests/net/forwarding/fib_offload_lib.sh
+++ b/tools/testing/selftests/net/forwarding/fib_offload_lib.sh
@@ -224,7 +224,7 @@ fib_ipv4_plen_test()
 	ip -n $ns link set dev dummy1 up

 	# Add two routes with the same key and different prefix length and
-	# make sure both are in hardware. It can be verfied that both are
+	# make sure both are in hardware. It can be verified that both are
 	# sharing the same leaf by checking the /proc/net/fib_trie
 	ip -n $ns route add 192.0.2.0/24 dev dummy1
 	ip -n $ns route add 192.0.2.0/25 dev dummy1
--
2.26.2

