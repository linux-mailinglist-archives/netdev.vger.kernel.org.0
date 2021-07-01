Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345533B8B1F
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 02:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237858AbhGAAU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 20:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236647AbhGAAUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 20:20:54 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CB7C061756
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 17:18:24 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id m41-20020a05600c3b29b02901dcd3733f24so5653641wms.1
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 17:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SBtwJKgc0T+2dOTNszlDoLaX2IUTZ6r/oUir5NyFDqs=;
        b=NgxfzqpIKr5S62MlJPBAm9TKS0yZIBo4rrsx+wx1JwXLgjUvXzDwQJgLckwL0wFEHN
         RYd95r9e2lar4a6VYXRka4PwGJibgINq2euNF3ShvXKDtAUD9SrUVjZY16sdnEwvF8kL
         tOlzHkGIHPBWhmHN5i28ZX1GQQmqasTws6Qtt0bj2lf3zcw1eQGG7BhE5Tck8HN9FRtP
         IAqh/3CQRCMpB8UuJoa1ZOwImbc7PMzRsvsL32TY7tYF9HjcxOcDAZkB0r/nyY9xzXsZ
         jjuHSCUFrNsmFehFVqXlAMXKi6TgieZtCSX9goC1AUJYvgeVx4f2lkwpeq/zEkUeu00v
         PcMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SBtwJKgc0T+2dOTNszlDoLaX2IUTZ6r/oUir5NyFDqs=;
        b=AEAARrZ/AjfUTk58eb0Pzo6OW8zL6xEPeIwPwU1TptvGLHvdw8m5FsVB/VxGKcpqLK
         4M4P0tEJGfVTuGOTtV+F/XMMR2qmeWTja8mMIkid1hEsQL3P+9W96AQGHI+rbEf6JSyb
         wJjsioXdYBFwkESC4B20XS3+2Cr86BZa5IR2dqjgLA1zdrX4E6awzZXNtSG30dKEAEke
         uNSjKPJVByqBOIex5oeZsk/kXZvEU6YKo3JM3eMVHO8tWxU7VBMepoetRQhxGmjdU74N
         WOwFd7wFHiW1vJOKo+9n0dvR+MYXYW2YHTigm/2sztuDSfU6RVov6rc7bbMiIMS37BNu
         JarQ==
X-Gm-Message-State: AOAM531YCjMY83dPxPPaGGLcbYGiZazX/ff9mpGSuHGleRs3N1+CEPAH
        EA4TGvDcEcTDXG9uVHPNCvTnz09x5sBfMA==
X-Google-Smtp-Source: ABdhPJzS3duIbKQHVT0j5Qh46XCZi3OqW8a1+2CS0IeAiYsSHgYjl4kd+D+JTMRCQMSQuhNuirr4wA==
X-Received: by 2002:a05:600c:3b8a:: with SMTP id n10mr40708656wms.123.1625098702688;
        Wed, 30 Jun 2021 17:18:22 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id l64sm7739822wmf.23.2021.06.30.17.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 17:18:22 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Jon Maloy <jmaloy@redhat.com>,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH net-next] Documentation: add more details in tipc.rst
Date:   Wed, 30 Jun 2021 20:18:20 -0400
Message-Id: <092c608f3bcf0e5db62cfe19379285c29cb37a43.1625098700.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernel-doc for TIPC is too simple, we need to add more information for it.

This patch is to extend the abstract, and add the Features and Links items.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
---
 Documentation/networking/tipc.rst | 121 +++++++++++++++++++++++++++++-
 1 file changed, 118 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/tipc.rst b/Documentation/networking/tipc.rst
index 76775f24cdc8..ab63d298cca2 100644
--- a/Documentation/networking/tipc.rst
+++ b/Documentation/networking/tipc.rst
@@ -4,10 +4,125 @@
 Linux Kernel TIPC
 =================
 
-TIPC (Transparent Inter Process Communication) is a protocol that is
-specially designed for intra-cluster communication.
+Introduction
+============
 
-For more information about TIPC, see http://tipc.sourceforge.net.
+TIPC (Transparent Inter Process Communication) is a protocol that is specially
+designed for intra-cluster communication. It can be configured to transmit
+messages either on UDP or directly across Ethernet. Message delivery is
+sequence guaranteed, loss free and flow controlled. Latency times are shorter
+than with any other known protocol, while maximal throughput is comparable to
+that of TCP.
+
+TIPC Features
+-------------
+
+- Cluster wide IPC service
+
+  Have you ever wished you had the convenience of Unix Domain Sockets even when
+  transmitting data between cluster nodes? Where you yourself determine the
+  addresses you want to bind to and use? Where you don't have to perform DNS
+  lookups and worry about IP addresses? Where you don't have to start timers
+  to monitor the continuous existence of peer sockets? And yet without the
+  downsides of that socket type, such as the risk of lingering inodes?
+
+  Welcome to the Transparent Inter Process Communication service, TIPC in short,
+  which gives you all of this, and a lot more.
+
+- Service Addressing
+
+  A fundamental concept in TIPC is that of Service Addressing which makes it
+  possible for a programmer to chose his own address, bind it to a server
+  socket and let client programs use only that address for sending messages.
+
+- Service Tracking
+
+  A client wanting to wait for the availability of a server, uses the Service
+  Tracking mechanism to subscribe for binding and unbinding/close events for
+  sockets with the associated service address.
+
+  The service tracking mechanism can also be used for Cluster Topology Tracking,
+  i.e., subscribing for availability/non-availability of cluster nodes.
+
+  Likewise, the service tracking mechanism can be used for Cluster Connectivity
+  Tracking, i.e., subscribing for up/down events for individual links between
+  cluster nodes.
+
+- Transmission Modes
+
+  Using a service address, a client can send datagram messages to a server socket.
+
+  Using the same address type, it can establish a connection towards an accepting
+  server socket.
+
+  It can also use a service address to create and join a Communication Group,
+  which is the TIPC manifestation of a brokerless message bus.
+
+  Multicast with very good performance and scalability is available both in
+  datagram mode and in communication group mode.
+
+- Inter Node Links
+
+  Communication between any two nodes in a cluster is maintained by one or two
+  Inter Node Links, which both guarantee data traffic integrity and monitor
+  the peer node's availability.
+
+- Cluster Scalability
+
+  By applying the Overlapping Ring Monitoring algorithm on the inter node links
+  it is possible to scale TIPC clusters up to 1000 nodes with a maintained
+  neighbor failure discovery time of 1-2 seconds. For smaller clusters this
+  time can be made much shorter.
+
+- Neighbor Discovery
+
+  Neighbor Node Discovery in the cluster is done by Ethernet broadcast or UDP
+  multicast, when any of those services are available. If not, configured peer
+  IP addresses can be used.
+
+- Configuration
+
+  When running TIPC in single node mode no configuration whatsoever is needed.
+  When running in cluster mode TIPC must as a minimum be given a node address
+  (before Linux 4.17) and told which interface to attach to. The "tipc"
+  configuration tool makes is possible to add and maintain many more
+  configuration parameters.
+
+- Performance
+
+  TIPC message transfer latency times are better than in any other known protocol.
+  Maximal byte throughput for inter-node connections is still somewhat lower than
+  for TCP, while they are superior for intra-node and inter-container throughput
+  on the same host.
+
+- Language Support
+
+  The TIPC user API has support for C, Python, Perl, Ruby, D and Go.
+
+More Information
+----------------
+
+- How to set up TIPC:
+
+  http://tipc.io/getting_started.html
+
+- How to program with TIPC:
+
+  http://tipc.io/programming.html
+
+- How to contribute to TIPC:
+
+- http://tipc.io/contacts.html
+
+- More details about TIPC specification:
+
+  http://tipc.io/protocol.html
+
+
+Implementation
+==============
+
+TIPC is implemented as a kernel module in net/tipc/ directory.
 
 TIPC Base Types
 ---------------
-- 
2.27.0

