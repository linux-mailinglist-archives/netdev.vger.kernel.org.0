Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B26D2D7D7B
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 18:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392763AbgLKRze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 12:55:34 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:62279 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392649AbgLKRyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 12:54:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607709291; x=1639245291;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=Jy3a9xryuHxWtnoO0PrKsoHstLAQUkeKOQZ9HySDrMs=;
  b=uFP9n2w75jgbSNGrPoPdW+Vffv0jMzMtA+zQRsYiKiMNmt0t97ik1bGM
   eyRFa0lnQ1dVFDl0ZGHbXUsfEIYa8RVCbaQPC0RSAJvDynqTD8WhPFyLd
   sEUfw6bGVjsoadsbcKgeddVpg4/FxOie+jrEL6/vnq1bFAUpFRqgEnBas
   U=;
X-IronPort-AV: E=Sophos;i="5.78,412,1599523200"; 
   d="scan'208";a="103547801"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-42f764a0.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 11 Dec 2020 17:54:04 +0000
Received: from EX13D31EUA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-42f764a0.us-east-1.amazon.com (Postfix) with ESMTPS id C5E50B1453;
        Fri, 11 Dec 2020 17:54:01 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.162.53) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 11 Dec 2020 17:53:41 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     SeongJae Park <sjpark@amazon.com>,
        David Miller <davem@davemloft.net>,
        SeongJae Park <sjpark@amazon.de>,
        Jakub Kicinski <kuba@kernel.org>,
        "Alexey Kuznetsov" <kuznet@ms2.inr.ac.ru>,
        Florian Westphal <fw@strlen.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        netdev <netdev@vger.kernel.org>, <rcu@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] net/ipv4/inet_fragment: Batch fqdir destroy works
Date:   Fri, 11 Dec 2020 18:53:26 +0100
Message-ID: <20201211175326.1705-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CANn89iKGU6_OusKfXeoT0hQN2kto2RF_RpL3GNBeB54iqvqvXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.53]
X-ClientProxiedBy: EX13D48UWA001.ant.amazon.com (10.43.163.52) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Dec 2020 15:36:53 +0100 Eric Dumazet <edumazet@google.com> wrote:

> On Fri, Dec 11, 2020 at 12:24 PM SeongJae Park <sjpark@amazon.com> wrote:
> >
> > From: SeongJae Park <sjpark@amazon.de>
> >
> > On a few of our systems, I found frequent 'unshare(CLONE_NEWNET)' calls
> > make the number of active slab objects including 'sock_inode_cache' type
> > rapidly and continuously increase.  As a result, memory pressure occurs.
> >
> 
> > Signed-off-by: SeongJae Park <sjpark@amazon.de>
> > ---
> >
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> 
> Jakub or David might change the patch title, no need to resend.
> 
> Thanks for this nice improvement.

My very best pleasure!  Thank you always for your nice advices and reviews!


Thanks,
SeongJae Park
