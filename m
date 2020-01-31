Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4B7914EF41
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 16:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbgAaPNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 10:13:34 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:33739 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728846AbgAaPNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 10:13:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1580483613; x=1612019613;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=/LNOzaMe/3JZolWTvP9IVpSTbmeTWa8BUCvny72YYxY=;
  b=vSU/a8TdIL3WfKPkFbhL0fV1fVGlaiNxAujzM5V31a9GE9jSf0wHney4
   bNonC+kIGzmNoLOgE1sN0jQiuH2MXqr97U+rbHKLtVuhTHWVqykJbe/3k
   xrWjEJigQ8jsnSuv381aTR59HDxcFiT9USEa10i/jzjI3tmvMhhJnEDMp
   U=;
IronPort-SDR: KVYn3WWRFZcf3tBkHpyDu7mmLFvMRWRoxr8gDHFHRpJ7/4LVKKqIClS8gp9SN7t9eoYm0+9Rda
 Ar54+gtUYhcA==
X-IronPort-AV: E=Sophos;i="5.70,386,1574121600"; 
   d="scan'208";a="13861159"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 31 Jan 2020 15:13:22 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com (Postfix) with ESMTPS id BB7CCA230C;
        Fri, 31 Jan 2020 15:13:21 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Fri, 31 Jan 2020 15:13:21 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.162.249) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 31 Jan 2020 15:13:16 +0000
From:   <sjpark@amazon.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     <sjpark@amazon.com>, David Miller <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>, netdev <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <sj38.park@gmail.com>,
        <aams@amazon.com>, SeongJae Park <sjpark@amazon.de>
Subject: Re: Re: [PATCH 3/3] selftests: net: Add FIN_ACK processing order related latency spike test
Date:   Fri, 31 Jan 2020 16:13:02 +0100
Message-ID: <20200131151302.28040-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CANn89iJrwVuEUHFqH1iCJd3nwTWAuXCdEJozwz6gzDV5Snm3Ug@mail.gmail.com> (raw)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.249]
X-ClientProxiedBy: EX13D17UWB001.ant.amazon.com (10.43.161.252) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jan 2020 06:56:13 -0800 Eric Dumazet <edumazet@google.com> wrote:

> On Fri, Jan 31, 2020 at 4:25 AM <sjpark@amazon.com> wrote:
> >
> > From: SeongJae Park <sjpark@amazon.de>
> >
> > This commit adds a test for FIN_ACK process races related reconnection
> > latency spike issues.  The issue has described and solved by the
> > previous commit ("tcp: Reduce SYN resend delay if a suspicous ACK is
> > received").
> >
> 
> I do not know for other tests, but using a hard coded port (4242) is
> going to be flakky, since the port might be already used.
> 
> Please make sure to run tests on a separate namespace.

Agreed, will do so in next spin.


Thanks,
SeongJae Park
