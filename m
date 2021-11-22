Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687ED458C22
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 11:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239136AbhKVKUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 05:20:10 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:55832 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234129AbhKVKUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 05:20:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1637576221; x=1669112221;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8ApudiASmBoeo+XCVvgpoBoUuEej9N2qPGh5qrGWeEI=;
  b=fsK4psUyJNG+ZfoOukhCCZlx9Esmzj7S1Z+LW4vu2P3raq7EC0fDbuKy
   7PVpIgv2xwmEQuVMnM9kYoxUWH2HNgxWf+eCs97cUgBp0o9OkK4yyNG//
   sXd4m02so+9Rh2LAHWK3sFLm7rPGNO6jE4kGB5JThm1jvCy9jtP29lbfB
   A=;
X-IronPort-AV: E=Sophos;i="5.87,254,1631577600"; 
   d="scan'208";a="153780533"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-39fdda15.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 22 Nov 2021 10:16:59 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-39fdda15.us-west-2.amazon.com (Postfix) with ESMTPS id 358E841DF9;
        Mon, 22 Nov 2021 10:16:59 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 22 Nov 2021 10:16:58 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.66) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 22 Nov 2021 10:16:53 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Yafang Shao <laoar.shao@gmail.com>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <dccp@vger.kernel.org>
Subject: [PATCH net-next 0/2] dccp/tcp: Minor fixes for inet_csk_listen_start().
Date:   Mon, 22 Nov 2021 19:16:20 +0900
Message-ID: <20211122101622.50572-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.66]
X-ClientProxiedBy: EX13D05UWB004.ant.amazon.com (10.43.161.208) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch removes an unused argument, and the second removes a stale
comment.


Kuniyuki Iwashima (2):
  dccp/tcp: Remove an unused argument in inet_csk_listen_start().
  dccp: Inline dccp_listen_start().

 include/net/inet_connection_sock.h            |  2 +-
 net/dccp/proto.c                              | 27 ++++++++-----------
 net/ipv4/af_inet.c                            |  2 +-
 net/ipv4/inet_connection_sock.c               |  2 +-
 .../bpf/progs/test_sk_storage_tracing.c       |  2 +-
 5 files changed, 15 insertions(+), 20 deletions(-)

-- 
2.30.2

