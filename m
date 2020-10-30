Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD3A2A051C
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 13:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgJ3MOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 08:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgJ3MOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 08:14:36 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6998C0613D2;
        Fri, 30 Oct 2020 05:14:35 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id g12so6187839wrp.10;
        Fri, 30 Oct 2020 05:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YM6lVvP1rsbQaoeXf51BiJbGQods3VmOPaRIQze1Y/4=;
        b=HYS7Z4uAi2/xNN9o74spG3l4kzUyP8VyV1TecIsI0doBZ3KR403fmibbpqsKbbgf1I
         3YWsELKS/7CS8edlysu8nDc8RcDcXMmEGa4o1BQqQLKZe87LrkxJ58Kz1Epu/BxhLZa2
         SyShNcHGq1zDPLgM10ram2PFohrsa3jhJOWizJV8PO0Wz++hR+C10AzNUhRMFNrMTcIE
         5kE+QciPzpMLTBsx/B+SjWbEm0JFjOfIgDoRl/aOyHJ8AoSyZW0z4fea/VU5b2rg3GYi
         NWz9y4KXE6Z4SsKitRMANq9qNhAnIRcQFnigs4kXnYaJqXClKX7njkNtK1BI53TwQ2OW
         /taQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YM6lVvP1rsbQaoeXf51BiJbGQods3VmOPaRIQze1Y/4=;
        b=Laf0vRhRHfsWG9Jx2wY85vLWMuOA/4gVZikG/k+uhsS9l4g9Y3TTAiXFW/804wa/XE
         PcXHfwGXTMXYFtRlVjFeoxST487kzHqT2sTilELvbV8HhZP/vi4ZMCUvsrr9s0t99RlZ
         qAMCOdYXF8BKZvDXbG2NFrNgMjrikJYVNjzZOhI/xuFn0HLC8VJ2TRAMCyIp1H0ndYnY
         IAJ2FcU3SInSFGTa9RnMjRLg27p0fTMs3PP+Al97gGlvGefpHB2JSneVwTqO8iEC/gEj
         rV+y2moXGPNKVBO9hFpPK3++3UVNwWutlLcWLYvVY5NrevxGTeD9G3g7igqU6zo8BJ92
         E2xA==
X-Gm-Message-State: AOAM532iCEHJYwLgcARj5jhhfm+UZUqApWoG76/B2/hRzqug1zSrDiT3
        vf50GVIeIG7VN6Ut8gmLGaxSyB3kLZ3Xo0dJ/iE=
X-Google-Smtp-Source: ABdhPJwickHJXtZNeeSxMgk7CR4/SX9TpUvLmsnUgAWwQfcePxqc+JJdQMVbyqrvcOZmy3D37IpNYw==
X-Received: by 2002:a05:6000:12c2:: with SMTP id l2mr2949137wrx.249.1604060073865;
        Fri, 30 Oct 2020 05:14:33 -0700 (PDT)
Received: from kernel-dev.chello.ie ([80.111.136.190])
        by smtp.gmail.com with ESMTPSA id 90sm10020925wrh.35.2020.10.30.05.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 05:14:33 -0700 (PDT)
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
X-Google-Original-From: Weqaar Janjua <weqaar.a.janjua@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, magnus.karlsson@gmail.com, bjorn.topel@intel.com
Cc:     Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        anders.roxell@linaro.org, jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 0/5] selftests/xsk: xsk selftests
Date:   Fri, 30 Oct 2020 12:13:42 +0000
Message-Id: <20201030121347.26984-1-weqaar.a.janjua@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds AF_XDP selftests based on veth to selftests/xsk/.

# Topology:
# ---------
#                 -----------
#               _ | Process | _
#              /  -----------  \
#             /        |        \
#            /         |         \
#      -----------     |     -----------
#      | Thread1 |     |     | Thread2 |
#      -----------     |     -----------
#           |          |          |
#      -----------     |     -----------
#      |  xskX   |     |     |  xskY   |
#      -----------     |     -----------
#           |          |          |
#      -----------     |     ----------
#      |  vethX  | --------- |  vethY |
#      -----------   peer    ----------
#           |          |          |
#      namespaceX      |     namespaceY

These selftests test AF_XDP SKB and Native/DRV modes using veth Virtual
Ethernet interfaces.

The test program contains two threads, each thread is single socket with
a unique UMEM. It validates in-order packet delivery and packet content
by sending packets to each other.

Prerequisites setup by script TEST_PREREQUISITES.sh:

   Set up veth interfaces as per the topology shown ^^:
   * setup two veth interfaces and one namespace
   ** veth<xxxx> in root namespace
   ** veth<yyyy> in af_xdp<xxxx> namespace
   ** namespace af_xdp<xxxx>
   * create a spec file veth.spec that includes this run-time configuration
     that is read by test scripts - filenames prefixed with TEST_XSK
   *** xxxx and yyyy are randomly generated 4 digit numbers used to avoid
       conflict with any existing interface.

The following tests are provided:

1. AF_XDP SKB mode
   Generic mode XDP is driver independent, used when the driver does
   not have support for XDP. Works on any netdevice using sockets and
   generic XDP path. XDP hook from netif_receive_skb().
   a. nopoll - soft-irq processing
   b. poll - using poll() syscall
   c. Socket Teardown
      Create a Tx and a Rx socket, Tx from one socket, Rx on another.
      Destroy both sockets, then repeat multiple times. Only nopoll mode
	  is used
   d. Bi-directional Sockets
      Configure sockets as bi-directional tx/rx sockets, sets up fill
	  and completion rings on each socket, tx/rx in both directions.
	  Only nopoll mode is used

2. AF_XDP DRV/Native mode
   Works on any netdevice with XDP_REDIRECT support, driver dependent.
   Processes packets before SKB allocation. Provides better performance
   than SKB. Driver hook available just after DMA of buffer descriptor.
   a. nopoll
   b. poll
   c. Socket Teardown
   d. Bi-directional Sockets
   * Only copy mode is supported because veth does not currently support
     zero-copy mode

Total tests: 8.

Flow:
* Single process spawns two threads: Tx and Rx
* Each of these two threads attach to a veth interface within their
  assigned namespaces
* Each thread creates one AF_XDP socket connected to a unique umem
  for each veth interface
* Tx thread transmits 10k packets from veth<xxxx> to veth<yyyy>
* Rx thread verifies if all 10k packets were received and delivered
  in-order, and have the right content

Structure of the patch set:

Patch 1: This patch adds XSK Selftests framework under
         tools/testing/selftests/xsk, and README
Patch 2: Adds tests: SKB poll and nopoll mode, mac-ip-udp debug,
         and README updates
Patch 3: Adds tests: DRV poll and nopoll mode, and README updates
Patch 4: Adds tests: SKB and DRV Socket Teardown, and README updates
Patch 5: Adds tests: SKB and DRV Bi-directional Sockets, and README
         updates

Thanks: Weqaar

Weqaar Janjua (5):
  selftests/xsk: xsk selftests framework
  selftests/xsk: xsk selftests - SKB POLL, NOPOLL
  selftests/xsk: xsk selftests - DRV POLL, NOPOLL
  selftests/xsk: xsk selftests - Socket Teardown - SKB, DRV
  selftests/xsk: xsk selftests - Bi-directional Sockets - SKB, DRV

 MAINTAINERS                                   |    1 +
 tools/testing/selftests/Makefile              |    1 +
 tools/testing/selftests/xsk/Makefile          |   34 +
 tools/testing/selftests/xsk/README            |  125 +++
 .../selftests/xsk/TEST_PREREQUISITES.sh       |   53 +
 tools/testing/selftests/xsk/TEST_XSK.sh       |   15 +
 .../xsk/TEST_XSK_DRV_BIDIRECTIONAL.sh         |   22 +
 .../selftests/xsk/TEST_XSK_DRV_NOPOLL.sh      |   18 +
 .../selftests/xsk/TEST_XSK_DRV_POLL.sh        |   18 +
 .../selftests/xsk/TEST_XSK_DRV_TEARDOWN.sh    |   18 +
 .../xsk/TEST_XSK_SKB_BIDIRECTIONAL.sh         |   19 +
 .../selftests/xsk/TEST_XSK_SKB_NOPOLL.sh      |   18 +
 .../selftests/xsk/TEST_XSK_SKB_POLL.sh        |   18 +
 .../selftests/xsk/TEST_XSK_SKB_TEARDOWN.sh    |   18 +
 tools/testing/selftests/xsk/config            |   12 +
 tools/testing/selftests/xsk/prereqs.sh        |  119 ++
 tools/testing/selftests/xsk/xdpprogs/Makefile |   64 ++
 .../selftests/xsk/xdpprogs/Makefile.target    |   68 ++
 .../selftests/xsk/xdpprogs/xdpxceiver.c       | 1000 +++++++++++++++++
 .../selftests/xsk/xdpprogs/xdpxceiver.h       |  159 +++
 tools/testing/selftests/xsk/xskenv.sh         |   33 +
 21 files changed, 1833 insertions(+)
 create mode 100644 tools/testing/selftests/xsk/Makefile
 create mode 100644 tools/testing/selftests/xsk/README
 create mode 100755 tools/testing/selftests/xsk/TEST_PREREQUISITES.sh
 create mode 100755 tools/testing/selftests/xsk/TEST_XSK.sh
 create mode 100755 tools/testing/selftests/xsk/TEST_XSK_DRV_BIDIRECTIONAL.sh
 create mode 100755 tools/testing/selftests/xsk/TEST_XSK_DRV_NOPOLL.sh
 create mode 100755 tools/testing/selftests/xsk/TEST_XSK_DRV_POLL.sh
 create mode 100755 tools/testing/selftests/xsk/TEST_XSK_DRV_TEARDOWN.sh
 create mode 100755 tools/testing/selftests/xsk/TEST_XSK_SKB_BIDIRECTIONAL.sh
 create mode 100755 tools/testing/selftests/xsk/TEST_XSK_SKB_NOPOLL.sh
 create mode 100755 tools/testing/selftests/xsk/TEST_XSK_SKB_POLL.sh
 create mode 100755 tools/testing/selftests/xsk/TEST_XSK_SKB_TEARDOWN.sh
 create mode 100644 tools/testing/selftests/xsk/config
 create mode 100755 tools/testing/selftests/xsk/prereqs.sh
 create mode 100644 tools/testing/selftests/xsk/xdpprogs/Makefile
 create mode 100644 tools/testing/selftests/xsk/xdpprogs/Makefile.target
 create mode 100644 tools/testing/selftests/xsk/xdpprogs/xdpxceiver.c
 create mode 100644 tools/testing/selftests/xsk/xdpprogs/xdpxceiver.h
 create mode 100755 tools/testing/selftests/xsk/xskenv.sh

-- 
2.20.1

