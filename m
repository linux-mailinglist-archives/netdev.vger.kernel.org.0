Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3901314944E
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 11:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgAYKSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 05:18:18 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:7721 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgAYKSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 05:18:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1579947498; x=1611483498;
  h=mime-version:content-transfer-encoding:subject:from:to:
   cc:date:in-reply-to:message-id;
  bh=s586s6VHd3EZHsg9RDm+ZBjEtElDaRSxLilltBK7yFs=;
  b=AN6gSaMfZWzOXgJrgZhue9hOWkQuhEedCXlCPfEEuE93x+M9Kj2Xi1xB
   pPeQkCkm74/f9rKmcnQvFGQR+rgPV8H4mJd9igmDjSNS2hLb8l6J4YUiB
   i5f7UdxU7w+0HqXpLfShRlWy954z3YkjDQXkfuMVJcCv9flp6au6pl8nN
   s=;
IronPort-SDR: faeywnosHeHLIf+h9FVtgojoXe3339KxhzJdH3FctvU4mIpJ87Aa9AbclNutLSKVlON53EiOYX
 UZ3DMjypMMIA==
X-IronPort-AV: E=Sophos;i="5.70,361,1574121600"; 
   d="scan'208";a="20968170"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 25 Jan 2020 10:18:17 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id DD80DA2F32;
        Sat, 25 Jan 2020 10:18:15 +0000 (UTC)
Received: from EX13D04ANB003.ant.amazon.com (10.43.156.155) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sat, 25 Jan 2020 10:18:15 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D04ANB003.ant.amazon.com (10.43.156.155) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sat, 25 Jan 2020 10:18:07 +0000
Received: from hnd-1800232320.ant.amazon.com (10.85.11.118) by
 mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP Server id
 15.0.1236.3 via Frontend Transport; Sat, 25 Jan 2020 10:18:04 +0000
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next] soreuseport: Cleanup duplicate initialization of
 more_reuse->max_socks.
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>
Date:   Sat, 25 Jan 2020 10:18:03 +0000
In-Reply-To: <20200125.102936.1710420903506965271.davem@davemloft.net>
Message-ID: <fac62808848f4cedab27756321fc8a96@EX13MTAUEA002.ant.amazon.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sat, 25 Jan 2020 10:29:36 +0100

> This patch is corrupted.  The context says that there are 7 lines beforehand
> and 6 afterwards.  But the hunk shows 6 lines beforehand and 5 afterward.

I am sorry, my mail client dropped the blank line. I will respin this 
patch.
