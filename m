Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46FC3A3726
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 00:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhFJWdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 18:33:14 -0400
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:45656 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhFJWdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 18:33:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1623364275; x=1654900275;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4L1uhlRXfuioW8/my8xTSASqKD8SZtwMJGn66ovgUUw=;
  b=SjIItNbD0kFb2t0aBo7jgpXKHv9aj3/NKFTv/UB/gKrKzdg8iYboZjFb
   PGjKPmO8U3QEdYKIEJPoDJPI8ZhG7at5yuEV+0abx8RmokhkInJU01WDM
   BtpSX5XkwpdpQxfXwgVAxb1ds9VVSK3KnL7gXN2rTHTmJZ33nuiL8A7oh
   E=;
X-IronPort-AV: E=Sophos;i="5.83,264,1616457600"; 
   d="scan'208";a="6050384"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 10 Jun 2021 22:31:15 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com (Postfix) with ESMTPS id 2A066A1DE8;
        Thu, 10 Jun 2021 22:31:14 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 10 Jun 2021 22:31:13 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.41) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 10 Jun 2021 22:31:08 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <eric.dumazet@gmail.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kafai@fb.com>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v7 bpf-next 01/11] net: Introduce net.ipv4.tcp_migrate_req.
Date:   Fri, 11 Jun 2021 07:31:05 +0900
Message-ID: <20210610223105.97080-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <3a9ecbe4-fe7e-1acf-36b7-1f999f8f01d6@gmail.com>
References: <3a9ecbe4-fe7e-1acf-36b7-1f999f8f01d6@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.41]
X-ClientProxiedBy: EX13D41UWC003.ant.amazon.com (10.43.162.30) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <eric.dumazet@gmail.com>
Date:   Thu, 10 Jun 2021 19:24:14 +0200
> On 5/21/21 8:20 PM, Kuniyuki Iwashima wrote:
> > This commit adds a new sysctl option: net.ipv4.tcp_migrate_req. If this
> > option is enabled or eBPF program is attached, we will be able to migrate
> > child sockets from a listener to another in the same reuseport group after
> > close() or shutdown() syscalls.
> > 
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> > Acked-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  Documentation/networking/ip-sysctl.rst | 25 +++++++++++++++++++++++++
> >  include/net/netns/ipv4.h               |  1 +
> >  net/ipv4/sysctl_net_ipv4.c             |  9 +++++++++
> >  3 files changed, 35 insertions(+)
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Thank you!
