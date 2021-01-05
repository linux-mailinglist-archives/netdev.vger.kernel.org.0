Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 435312EAD88
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 15:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbhAEOlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 09:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727119AbhAEOlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 09:41:16 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FBEC061795;
        Tue,  5 Jan 2021 06:40:36 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id 4so16465351plk.5;
        Tue, 05 Jan 2021 06:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HbJW3NsKoqX4vBU/QIX81wQelNyQKvEabn44iqJjckA=;
        b=CG8lZ13Uk9aywsPfihuJ20nIDYsGGfGMvqKlG7y8QcpjkMwjMTtwPyQrknx2QQ21UU
         yUQ/nz9t1//fGezhqkSi3NKoOF1CByNVEGOMaMo2fnE00v4soTAQQZNsY1PJkUOiRehw
         NUHmA3VQdRXiTkwgrqZPy6+noaAwoVoraHX5gSJVwXhr0kbekL3IdNdm2u6T6QoAA83H
         YaSdeTePFS9yz3VURK450x/WXiKsaXxYDJ9958wP7Vlf8C/1nSJSxczIqLXcttbfEPuZ
         h4yok8EAFViY/Nw0NtVqM+ZOo/5o5Ns4kyK2IVZfPbcJ6zT2JXiI7gQl6HKJsV0kDqZb
         VmJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HbJW3NsKoqX4vBU/QIX81wQelNyQKvEabn44iqJjckA=;
        b=hyXpJDIFqOsBWX1fCnxw6jA16i1X8bHcP4/XQ2WifPpPJJVZBjr39Dri+9KRllmSy3
         4ZW3rRAczBrLxY7FtbSSpuEfYZRc6HylBmv/rPhq4oAIu+2JsncX6HuotUr1WNYUrMpI
         6qFyShopY5ZRZqExvhrDvoL1QzRJkwPFpD3upc+YuThvyxTnb8hvs0ZrgDpQbl50nDXX
         2Aud6Tt7yCIZRAr2uDBi9Q7B3NeYfW480eAsxUJwRlzbwngM2m6vHNBPggCjxoYIgsOR
         Syf8ofDxbkaf7nxcgePMlXz4/mfWKybrOlTabezKckGSqGGRfMZxC+pGrSDjEykG1f3U
         Evzw==
X-Gm-Message-State: AOAM532RWRI+lWE/WeVSA6oRUGuLODOExgRXUDNTD1+eEtNDty4m94kN
        eF+ekK0v87GBreDlMioINgU=
X-Google-Smtp-Source: ABdhPJyLd/QmTIDSYCxw1lc0fezaujusZC9WG5QcEJEOIr1M9QK7ZjzYYIUqhPQaduoFP/Jm3EK/UQ==
X-Received: by 2002:a17:902:8f8d:b029:dc:8ac6:98a7 with SMTP id z13-20020a1709028f8db02900dc8ac698a7mr27606plo.13.1609857635819;
        Tue, 05 Jan 2021 06:40:35 -0800 (PST)
Received: from masabert (oki-109-236-4-100.jptransit.net. [109.236.4.100])
        by smtp.gmail.com with ESMTPSA id bg20sm2986982pjb.6.2021.01.05.06.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 06:40:35 -0800 (PST)
Received: by masabert (Postfix, from userid 1000)
        id E057A236040C; Tue,  5 Jan 2021 23:40:31 +0900 (JST)
From:   Masanari Iida <standby24x7@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] net-next: docs: Fix typos in snmp_counter.rst
Date:   Tue,  5 Jan 2021 23:40:29 +0900
Message-Id: <20210105144029.219910-1-standby24x7@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes some spelling typos in snmp_counter.rst

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/networking/snmp_counter.rst | 28 +++++++++++------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/Documentation/networking/snmp_counter.rst b/Documentation/networking/snmp_counter.rst
index 4edd0d38779e..423d138b5ff3 100644
--- a/Documentation/networking/snmp_counter.rst
+++ b/Documentation/networking/snmp_counter.rst
@@ -314,7 +314,7 @@ https://lwn.net/Articles/576263/
 * TcpExtTCPOrigDataSent
 
 This counter is explained by `kernel commit f19c29e3e391`_, I pasted the
-explaination below::
+explanation below::
 
   TCPOrigDataSent: number of outgoing packets with original data (excluding
   retransmission but including data-in-SYN). This counter is different from
@@ -324,7 +324,7 @@ explaination below::
 * TCPSynRetrans
 
 This counter is explained by `kernel commit f19c29e3e391`_, I pasted the
-explaination below::
+explanation below::
 
   TCPSynRetrans: number of SYN and SYN/ACK retransmits to break down
   retransmissions into SYN, fast-retransmits, timeout retransmits, etc.
@@ -332,7 +332,7 @@ explaination below::
 * TCPFastOpenActiveFail
 
 This counter is explained by `kernel commit f19c29e3e391`_, I pasted the
-explaination below::
+explanation below::
 
   TCPFastOpenActiveFail: Fast Open attempts (SYN/data) failed because
   the remote does not accept it or the attempts timed out.
@@ -382,7 +382,7 @@ Defined in `RFC1213 tcpAttemptFails`_.
 
 Defined in `RFC1213 tcpOutRsts`_. The RFC says this counter indicates
 the 'segments sent containing the RST flag', but in linux kernel, this
-couner indicates the segments kerenl tried to send. The sending
+counter indicates the segments kernel tried to send. The sending
 process might be failed due to some errors (e.g. memory alloc failed).
 
 .. _RFC1213 tcpOutRsts: https://tools.ietf.org/html/rfc1213#page-52
@@ -700,7 +700,7 @@ SACK option could have up to 4 blocks, they are checked
 individually. E.g., if 3 blocks of a SACk is invalid, the
 corresponding counter would be updated 3 times. The comment of the
 `Add counters for discarded SACK blocks`_ patch has additional
-explaination:
+explanation:
 
 .. _Add counters for discarded SACK blocks: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=18f02545a9a16c9a89778b91a162ad16d510bb32
 
@@ -829,7 +829,7 @@ PAWS check fails or the received sequence number is out of window.
 
 * TcpExtTCPACKSkippedTimeWait
 
-Tha ACK is skipped in Time-Wait status, the reason would be either
+The ACK is skipped in Time-Wait status, the reason would be either
 PAWS check failed or the received sequence number is out of window.
 
 * TcpExtTCPACKSkippedChallenge
@@ -984,7 +984,7 @@ TcpExtSyncookiesRecv counter wont be updated.
 
 Challenge ACK
 =============
-For details of challenge ACK, please refer the explaination of
+For details of challenge ACK, please refer the explanation of
 TcpExtTCPACKSkippedChallenge.
 
 * TcpExtTCPChallengeACK
@@ -1002,7 +1002,7 @@ prune
 =====
 When a socket is under memory pressure, the TCP stack will try to
 reclaim memory from the receiving queue and out of order queue. One of
-the reclaiming method is 'collapse', which means allocate a big sbk,
+the reclaiming method is 'collapse', which means allocate a big skb,
 copy the contiguous skbs to the single big skb, and free these
 contiguous skbs.
 
@@ -1163,7 +1163,7 @@ The server side nstat output::
   IpExtOutOctets                  52                 0.0
   IpExtInNoECTPkts                1                  0.0
 
-Input a string in nc client side again ('world' in our exmaple)::
+Input a string in nc client side again ('world' in our example)::
 
   nstatuser@nstat-a:~$ nc -v nstat-b 9000
   Connection to nstat-b 9000 port [tcp/*] succeeded!
@@ -1211,7 +1211,7 @@ replied an ACK. But kernel handled them in different ways. When the
 TCP window scale option is not used, kernel will try to enable fast
 path immediately when the connection comes into the established state,
 but if the TCP window scale option is used, kernel will disable the
-fast path at first, and try to enable it after kerenl receives
+fast path at first, and try to enable it after kernel receives
 packets. We could use the 'ss' command to verify whether the window
 scale option is used. e.g. run below command on either server or
 client::
@@ -1343,7 +1343,7 @@ Check TcpExtTCPAbortOnMemory on client::
   nstatuser@nstat-a:~$ nstat | grep -i abort
   TcpExtTCPAbortOnMemory          54                 0.0
 
-Check orphane socket count on client::
+Check orphaned socket count on client::
 
   nstatuser@nstat-a:~$ ss -s
   Total: 131 (kernel 0)
@@ -1685,7 +1685,7 @@ Send 3 SYN repeatly to nstat-b::
 
   nstatuser@nstat-a:~$ for i in {1..3}; do sudo tcpreplay -i ens3 /tmp/syn_fixcsum.pcap; done
 
-Check snmp cunter on nstat-b::
+Check snmp counter on nstat-b::
 
   nstatuser@nstat-b:~$ nstat | grep -i skip
   TcpExtTCPACKSkippedSynRecv      1                  0.0
@@ -1770,7 +1770,7 @@ string 'foo' in our example::
   Connection from nstat-a 42132 received!
   foo
 
-On nstat-a, the tcpdump should have caputred the ACK. We should check
+On nstat-a, the tcpdump should have captured the ACK. We should check
 the source port numbers of the two nc clients::
 
   nstatuser@nstat-a:~$ ss -ta '( dport = :9000 || dport = :9001 )' | tee
@@ -1778,7 +1778,7 @@ the source port numbers of the two nc clients::
   ESTAB  0        0            192.168.122.250:50208       192.168.122.251:9000
   ESTAB  0        0            192.168.122.250:42132       192.168.122.251:9001
 
-Run tcprewrite, change port 9001 to port 9000, chagne port 42132 to
+Run tcprewrite, change port 9001 to port 9000, change port 42132 to
 port 50208::
 
   nstatuser@nstat-a:~$ tcprewrite --infile /tmp/seq_pre.pcap --outfile /tmp/seq.pcap -r 9001:9000 -r 42132:50208 --fixcsum
-- 
2.25.0

