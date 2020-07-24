Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511F122BDF0
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 08:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgGXGNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 02:13:15 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:44113 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgGXGNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 02:13:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1595571194; x=1627107194;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=wAf+4j22j4tA6PH+JPqoCK4dCJvptQHGHT4gjPajInU=;
  b=IgvifmERXIjyybGhik2dSL8fnx29Ad2Gy9ow7e0QQxl9Bktttod8OoSO
   MLRDXszSoKnyXFksPH0wrQAuQVApHtFZ0gBNlvfC7YC9CIo4tO6zEcEUo
   U2/zQt1YktxEz/OYfFE9qzLZDkllhBiSXic5Q3m/LAh3CQQecRdr4zKvT
   o=;
IronPort-SDR: K6nd/+N2tYbBfBstNi0MVGDTSSDCervCrRAoRkSZrV9qx9XFGO+X1+zSJK36stTK5LTJPVBwoZ
 rsdRpLnFslPA==
X-IronPort-AV: E=Sophos;i="5.75,389,1589241600"; 
   d="scan'208";a="54273050"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-22cc717f.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 24 Jul 2020 06:13:13 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-22cc717f.us-west-2.amazon.com (Postfix) with ESMTPS id 49FB1A0521;
        Fri, 24 Jul 2020 06:13:13 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 24 Jul 2020 06:13:12 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.48) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 24 Jul 2020 06:13:08 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <davem@davemloft.net>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <jakub@cloudflare.com>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <netdev@vger.kernel.org>, <willemb@google.com>,
        <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH net] udp: Remove an unnecessary variable in udp[46]_lib_lookup2().
Date:   Fri, 24 Jul 2020 15:13:04 +0900
Message-ID: <20200724061304.14997-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20200723.151051.16194602184853977.davem@davemloft.net>
References: <20200723.151051.16194602184853977.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.48]
X-ClientProxiedBy: EX13D38UWB003.ant.amazon.com (10.43.161.178) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   David Miller <davem@davemloft.net>
Date:   Thu, 23 Jul 2020 15:10:51 -0700 (PDT)
> From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Date: Thu, 23 Jul 2020 01:52:27 +0900
> 
> > This patch removes an unnecessary variable in udp[46]_lib_lookup2() and
> > makes it easier to resolve a merge conflict with bpf-next reported in
> > the link below.
> > 
> > Link: https://lore.kernel.org/linux-next/20200722132143.700a5ccc@canb.auug.org.au/
> > Fixes: efc6b6f6c311 ("udp: Improve load balancing for SO_REUSEPORT.")
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> 
> This doesn't apply to net-next.

Yes. I think this kind of patch should be submitted to net-next, but this
is for the net tree. Please let me add more description.

Currently, the net and net-next trees conflict in udp[46]_lib_lookup2()
between

   efc6b6f6c311 ("udp: Improve load balancing for SO_REUSEPORT.")

and

   7629c73a1466 ("udp: Extract helper for selecting socket from reuseport group")
   2a08748cd384 ("udp6: Extract helper for selecting socket from reuseport group")
.

The conflict is reported in the link[0] and Jakub suggested how to resolve
it[1]. To ease the merge conflict, Jakub and I have to send follow up patches to
the bpf-next and net trees.

Now, his patchset (7629c73a1466 and 2a08748cd384) to bpf-next is merged
into net-next, and his follow up patch is applied in bpf-next[2].

I fixed a bug in efc6b6f6c311, but it introduced an unnecessary variable
and made the conflict worse. So I sent this follow up patch to net tree.

However, I do not know the best way to resolve the conflict, so any comments
are welcome.

[0] https://lore.kernel.org/linux-next/20200722132143.700a5ccc@canb.auug.org.au/
[1] https://lore.kernel.org/linux-next/87wo2vwxq6.fsf@cloudflare.com/
[2] https://lore.kernel.org/netdev/20200722165902.51857-1-kuniyu@amazon.co.jp/T/#t


Best Regards,
Kuniyuki
