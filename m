Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B05259259
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 17:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgIAPKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 11:10:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51572 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726800AbgIAPJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 11:09:36 -0400
Received: from mail-pl1-f198.google.com ([209.85.214.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1kD7ug-00048e-80
        for netdev@vger.kernel.org; Tue, 01 Sep 2020 15:09:34 +0000
Received: by mail-pl1-f198.google.com with SMTP id bg5so757354plb.18
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 08:09:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JWz4w/tKyZ/PP+PlUCJ8+eDDTwAKqJWDoeBWELU6jAM=;
        b=CaGpmEn8cuDiP56WVt94pUb5IvhmVwslrBm9fhouda3BHkx40X3Jd/8ZwEnLxwpQuV
         sQJ6D+HDwdOWVWehhTreR15k2LrGGrmzHuGfa1ygoAZHWSC4RoqgK77T5qScKNmaGhJs
         VTaK7deuCM2LfRdO2TDpHkp6JipPsYo6eUdoBmaKrpkrziFDD6iUM5r9CIus+ueqvIh2
         iX92oeYkF6hf5zN7LmrZw45LG57TMr8+FbeW4TYQ1CSxWDd0MFh1dTnKQzzgBnl3EkRV
         9Q9A47QYNkKGdbNvQCv1/TjnUXN2qm9w01ZcBp3qlH2JUiwsNSVM4rXlK0i7/SK5Ss8r
         wQXQ==
X-Gm-Message-State: AOAM53077r3BTZ3RT+qsL46HjF7t9kUxMUdE1iGVHE5CiJ8msaEZ2mZ2
        srfc5rUADiu04EBJP4HX37Qntg7gk/U3dHQ1vZSsq4SBfNzqkpmWSY3XTkWHGZ//0yr2XASVyEb
        xsVcHmnswtp8HqpRWip1d2qDZ1kkjwsyS
X-Received: by 2002:a05:6a00:15d0:: with SMTP id o16mr1610236pfu.231.1598972972772;
        Tue, 01 Sep 2020 08:09:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNSfUNALPQS+9nTX7oFc7jV43D9g7tlXj9ZJWwL0ajWGT5buiowf8haAL9Usk5V2m8MfmNqA==
X-Received: by 2002:a05:6a00:15d0:: with SMTP id o16mr1610207pfu.231.1598972972424;
        Tue, 01 Sep 2020 08:09:32 -0700 (PDT)
Received: from localhost.localdomain (114-136-253-112.emome-ip.hinet.net. [114.136.253.112])
        by smtp.gmail.com with ESMTPSA id y4sm2391098pfr.46.2020.09.01.08.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 08:09:31 -0700 (PDT)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     po-hsu.lin@canonical.com, davem@davemloft.net, kuba@kernel.org,
        skhan@linuxfoundation.org
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/net: improve descriptions for XFAIL cases in psock_snd.sh
Date:   Tue,  1 Sep 2020 23:09:23 +0800
Message-Id: <20200901150923.36083-1-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before changing this it's a bit confusing to read test output:
  raw csum_off with bad offset (fails)
  ./psock_snd: write: Invalid argument

Change "fails" in the test case description to "expected to fail", so
that the test output can be more understandable.

Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 tools/testing/selftests/net/psock_snd.sh | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/psock_snd.sh b/tools/testing/selftests/net/psock_snd.sh
index 6331d91..170be65 100755
--- a/tools/testing/selftests/net/psock_snd.sh
+++ b/tools/testing/selftests/net/psock_snd.sh
@@ -45,7 +45,7 @@ echo "raw vnet hdr"
 echo "raw csum_off"
 ./in_netns.sh ./psock_snd -v -c
 
-echo "raw csum_off with bad offset (fails)"
+echo "raw csum_off with bad offset (expected to fail)"
 (! ./in_netns.sh ./psock_snd -v -c -C)
 
 
@@ -57,7 +57,7 @@ echo "raw min size"
 echo "raw mtu size"
 ./in_netns.sh ./psock_snd -l "${mss}"
 
-echo "raw mtu size + 1 (fails)"
+echo "raw mtu size + 1 (expected to fail)"
 (! ./in_netns.sh ./psock_snd -l "${mss_exceeds}")
 
 # fails due to ARPHRD_ETHER check in packet_extra_vlan_len_allowed
@@ -65,19 +65,19 @@ echo "raw mtu size + 1 (fails)"
 # echo "raw vlan mtu size"
 # ./in_netns.sh ./psock_snd -V -l "${mss}"
 
-echo "raw vlan mtu size + 1 (fails)"
+echo "raw vlan mtu size + 1 (expected to fail)"
 (! ./in_netns.sh ./psock_snd -V -l "${mss_exceeds}")
 
 echo "dgram mtu size"
 ./in_netns.sh ./psock_snd -d -l "${mss}"
 
-echo "dgram mtu size + 1 (fails)"
+echo "dgram mtu size + 1 (expected to fail)"
 (! ./in_netns.sh ./psock_snd -d -l "${mss_exceeds}")
 
-echo "raw truncate hlen (fails: does not arrive)"
+echo "raw truncate hlen (expected to fail: does not arrive)"
 (! ./in_netns.sh ./psock_snd -t "$((${vnet_hlen} + ${eth_hlen}))")
 
-echo "raw truncate hlen - 1 (fails: EINVAL)"
+echo "raw truncate hlen - 1 (expected to fail: EINVAL)"
 (! ./in_netns.sh ./psock_snd -t "$((${vnet_hlen} + ${eth_hlen} - 1))")
 
 
@@ -86,13 +86,13 @@ echo "raw truncate hlen - 1 (fails: EINVAL)"
 echo "raw gso min size"
 ./in_netns.sh ./psock_snd -v -c -g -l "${mss_exceeds}"
 
-echo "raw gso min size - 1 (fails)"
+echo "raw gso min size - 1 (expected to fail)"
 (! ./in_netns.sh ./psock_snd -v -c -g -l "${mss}")
 
 echo "raw gso max size"
 ./in_netns.sh ./psock_snd -v -c -g -l "${max_mss}"
 
-echo "raw gso max size + 1 (fails)"
+echo "raw gso max size + 1 (expected to fail)"
 (! ./in_netns.sh ./psock_snd -v -c -g -l "${max_mss_exceeds}")
 
 echo "OK. All tests passed"
-- 
2.7.4

