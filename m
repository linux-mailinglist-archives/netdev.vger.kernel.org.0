Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0061618FC99
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 19:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbgCWSW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 14:22:57 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:35191 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgCWSW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 14:22:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1584987776; x=1616523776;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=nAIpt6DregPHZOfbgE7ffB/nutEY32Bh8o7oyxzRlSM=;
  b=eDSmCKnacFf4LbkPsDezqcPR96ZV3BI0hwZDaHhqCHb6P9lPq9QwNL3X
   ks7FHh/p34OEySFHMem/QmTMFpHRADhfPjPY1/G1wHW8rH4VOn+fvJafS
   LJ6dsv3NKfcemiOYJi6aTlk7wJxrFQ8Aj8lLmFWmeKMA6+RW3VwKGPhFO
   0=;
IronPort-SDR: wgYtHKNkTh4SCmXXG0gZt2PUoh0GYbsU3zCx8zszXCkE4ifTw5QwcsJeXUGbxp7ckFj7u3yU4P
 tBbDTmBgaQZA==
X-IronPort-AV: E=Sophos;i="5.72,297,1580774400"; 
   d="scan'208";a="23825892"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 23 Mar 2020 18:18:26 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com (Postfix) with ESMTPS id 460EBA2377;
        Mon, 23 Mar 2020 18:18:25 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 23 Mar 2020 18:18:24 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.101) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 23 Mar 2020 18:18:20 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Hideaki YOSHIFUJI" <yoshfuji@linux-ipv6.org>
CC:     <dccp@vger.kernel.org>, <netdev@vger.kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        <osa-contribution-log@amazon.com>
Subject: [PATCH net-next 0/2] tcp/dccp: Cleanup initialisation code of refcounted.
Date:   Tue, 24 Mar 2020 03:18:12 +0900
Message-ID: <20200323181814.87661-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.101]
X-ClientProxiedBy: EX13D03UWA003.ant.amazon.com (10.43.160.39) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches cleanup initialisation of the refcounted which is passed to
__inet_lookup_skb().

Kuniyuki Iwashima (2):
  tcp/dccp: Move initialisation of refcounted into if block.
  tcp/dccp: Remove unnecessary initialization of refcounted.

 include/net/inet6_hashtables.h | 11 +++++++----
 include/net/inet_hashtables.h  | 11 +++++++----
 net/dccp/ipv4.c                |  1 -
 net/dccp/ipv6.c                |  1 -
 net/ipv4/tcp_ipv4.c            |  1 -
 net/ipv6/tcp_ipv6.c            |  1 -
 6 files changed, 14 insertions(+), 12 deletions(-)

-- 
2.17.2 (Apple Git-113)

