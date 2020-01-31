Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D51014EF30
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 16:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729249AbgAaPJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 10:09:36 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:59720 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729004AbgAaPJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 10:09:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1580483376; x=1612019376;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=TWhifcpHB+dd048pcnCF4nKnIf/oG0lsDe/ax/0lEmw=;
  b=JX/viUVYXWGUpQFjNc3f7m+0Ro8fR7SecP47z/QswizKyiFN5wEdMFI8
   KCDFei+yqMoU4MA9UwdSgQ/XSNodLvL1zjHRfWhPt4W5oip8W0hK/YpPJ
   z3EC2q8Wn4EGXR6SzzlH+/SMrbZWHiStttYoeb5amSNRnl/KglPUZmgvX
   o=;
IronPort-SDR: H6IgLyGs83Nn0RsWC4S5JdFqMKDINuBsVCNl3MoHrAyAVHYqYqtWbtvCpZXhKvSbSPEvXFTiez
 z3fLBQw8nkNw==
X-IronPort-AV: E=Sophos;i="5.70,386,1574121600"; 
   d="scan'208";a="23625855"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-2225282c.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 31 Jan 2020 15:09:24 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-2225282c.us-west-2.amazon.com (Postfix) with ESMTPS id 4DD4EA25AC;
        Fri, 31 Jan 2020 15:09:24 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Fri, 31 Jan 2020 15:09:24 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.161.117) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 31 Jan 2020 15:09:19 +0000
From:   <sjpark@amazon.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     <sjpark@amazon.com>, David Miller <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>, netdev <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <sj38.park@gmail.com>,
        <aams@amazon.com>, SeongJae Park <sjpark@amazon.de>
Subject: Re: Re: [PATCH 1/3] net/ipv4/inet_timewait_sock: Fix inconsistent comments
Date:   Fri, 31 Jan 2020 16:09:05 +0100
Message-ID: <20200131150905.27132-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CANn89iK3usa_bAfnD37VKvS45Qf6FH+H4fo-9zNrGGanc=7uAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.117]
X-ClientProxiedBy: EX13D29UWA001.ant.amazon.com (10.43.160.187) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On   Fri, 31 Jan 2020 06:54:53 -0800   Eric Dumazet <edumazet@google.com> wrote:

> On Fri, Jan 31, 2020 at 4:24 AM <sjpark@amazon.com> wrote:
> >
> > From: SeongJae Park <sjpark@amazon.de>
> >
> > Commit ec94c2696f0b ("tcp/dccp: avoid one atomic operation for timewait
> > hashdance") mistakenly erased a comment for the second step of
> > `inet_twsk_hashdance()`.  This commit restores it for better
> > readability.
> >
> > Signed-off-by: SeongJae Park <sjpark@amazon.de>
> > ---
> >  net/ipv4/inet_timewait_sock.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
> > index c411c87ae865..fbfcd63cc170 100644
> > --- a/net/ipv4/inet_timewait_sock.c
> > +++ b/net/ipv4/inet_timewait_sock.c
> > @@ -120,6 +120,7 @@ void inet_twsk_hashdance(struct inet_timewait_sock *tw, struct sock *sk,
> >
> >         spin_lock(lock);
> >
> > +       /* Step 2: Hash TW into tcp ehash chain. */
> 
> This comment adds no value, please do not bring it back.
> 
> net-next is closed, now is not the time for cosmetic changes.
> 
> Also take a look at Documentation/networking/netdev-FAQ.rst

Thank you for this kind reference.  Will drop this in next spin.


Thanks,
SeongJae Park

> 
