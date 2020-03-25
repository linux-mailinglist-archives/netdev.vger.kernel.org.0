Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C20719221E
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 09:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgCYIHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 04:07:18 -0400
Received: from mail-qk1-f171.google.com ([209.85.222.171]:41104 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgCYIHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 04:07:17 -0400
Received: by mail-qk1-f171.google.com with SMTP id q188so1649568qke.8
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 01:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nn2ndWNh+t37Fcd5L4d6G6qNnefLjxC72tuGk4w6tes=;
        b=elp9agOFYLBvLkZC5cOqrD3HdpzibNKq2j7QaPuIYwxO9Z5zMmEQfgeYbnWtSev+dr
         bxc8EwqdhHHu3eTCC2cmOIOPuULMd8bD2ays5PLcr7GRwqL2J618zH73ZLXPavtw9knS
         Mlmh+eEhRV8dqrA/a4Qx0uHQvZDYfjZtViMyC1VpBH9JwA2XnmpPCk7ct7j7rmu5MwTc
         d5p0lDhX9b2WHCks+8FAaScpsDs1lD2srMJ3MOnlXefWDT/xfFE9zDtQFeD4iOcXOFGH
         mXmxlYb2sq7RZAw0MXvPN5oxbB+ZD9I4MuRio0ozmrR1wStBQPhAnLeiEV7yiIALkB0o
         GtFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nn2ndWNh+t37Fcd5L4d6G6qNnefLjxC72tuGk4w6tes=;
        b=IAxkCMEVlJ0bpJ8pddGF57+/4YYxzjnsdS70nHcKk9l2LJoTfhweThG3zVIUE7Symu
         WFZ/tiP8WrFlfZOo2cD34QAWjgmQMH6q44+/QAunFRfu084zMN1WooEEMvnNRTwKjKQ+
         qs8G3p+tGei16oPeC8k3XyBMptKGpjrLrbzNBvCPS7R1LVexF1H+BjV32KoJqfvrPJGK
         74kw0bw1SftMvyTX4wf+D64iIP55A/2CcuavcHYQ4xbPxGungNjx6f96EOaxDOIAhDeW
         uee3AWXCw7+aIU33kTeTHuj281xGCmlW/MinW92hZv2XxmxoHAYkThKa51QBSyYZXgXQ
         XZug==
X-Gm-Message-State: ANhLgQ0asPCNwsg+dyj/lBMN/5ZmiwWGNvnJa7JLP8ayADG5Ob+U0i9P
        fSdE9eRY+5/BaDOd8EuaLjQjopEFpJ0=
X-Google-Smtp-Source: ADFU+vtpbN+7KXdernr1gECAR/zNmPo2MhdZwKd1xdX4kEIPKkiPiSQsmhrk3GIQu1KUg9cZ1tt9aA==
X-Received: by 2002:a37:27cd:: with SMTP id n196mr1808964qkn.144.1585123636454;
        Wed, 25 Mar 2020 01:07:16 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 17sm14690355qkm.105.2020.03.25.01.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 01:07:16 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        David Miller <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] selftests/net: add missing tests to Makefile
Date:   Wed, 25 Mar 2020 16:07:01 +0800
Message-Id: <20200325080701.14940-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Find some tests are missed in Makefile by running:
for file in $(ls *.sh); do grep -q $file Makefile || echo $file; done

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 287ae916ec0b..4c1bd03ffa1c 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -11,7 +11,9 @@ TEST_PROGS += udpgso_bench.sh fib_rule_tests.sh msg_zerocopy.sh psock_snd.sh
 TEST_PROGS += udpgro_bench.sh udpgro.sh test_vxlan_under_vrf.sh reuseport_addr_any.sh
 TEST_PROGS += test_vxlan_fdb_changelink.sh so_txtime.sh ipv6_flowlabel.sh
 TEST_PROGS += tcp_fastopen_backup_key.sh fcnal-test.sh l2tp.sh traceroute.sh
-TEST_PROGS += fin_ack_lat.sh
+TEST_PROGS += fin_ack_lat.sh fib_nexthop_multiprefix.sh fib_nexthops.sh
+TEST_PROGS += altnames.sh icmp_redirect.sh ip6_gre_headroom.sh
+TEST_PROGS += route_localnet.sh
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
-- 
2.19.2

