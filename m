Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC2B228F27
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 06:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgGVE2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 00:28:16 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:47534 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgGVE2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 00:28:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1595392095; x=1626928095;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Uj5oimQJYnVJCt755XlF+PSpnC4d8chAEs13hBLchr0=;
  b=HvjrfzvYfZ9Yc33wxevGO0gci0UfXMBU15YtFEGUlWwgzxkqrn/j9w9G
   V5GWVXhrciaRyy+Gq0F2XZUBqJB0nkcCsR12h+Hux2lPc/RmpvYRm4nAW
   QrjSiYoe5Jm6yQ3eKLZ1Qkl8bGHPD1nNcyQDQ520QzAu0WTc9Bymys6mA
   o=;
IronPort-SDR: KYpcyCQoD8CsnX+uARRQ4VVaOjsHJA9Tr1Y62JIq4NeXILCnxH/Cj9LX6HAofWtZvOxKpqTZFb
 tieDb2uqdrIQ==
X-IronPort-AV: E=Sophos;i="5.75,381,1589241600"; 
   d="scan'208";a="61791087"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 22 Jul 2020 04:28:14 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id BAF1CA1E0B;
        Wed, 22 Jul 2020 04:28:11 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Jul 2020 04:28:10 +0000
Received: from 38f9d3582de7.ant.amazon.com.com (10.43.162.73) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Jul 2020 04:28:06 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <davem@davemloft.net>
CC:     <benh@amazon.com>, <edumazet@google.com>, <kraig@google.com>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <kuznet@ms2.inr.ac.ru>, <netdev@vger.kernel.org>,
        <osa-contribution-log@amazon.com>, <pabeni@redhat.com>,
        <willemb@google.com>, <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net 0/2] udp: Fix reuseport selection with connected sockets.
Date:   Wed, 22 Jul 2020 13:28:02 +0900
Message-ID: <20200722042802.8724-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20200721.153239.840568562226163775.davem@davemloft.net>
References: <20200721.153239.840568562226163775.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.73]
X-ClientProxiedBy: EX13D15UWB002.ant.amazon.com (10.43.161.9) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   David Miller <davem@davemloft.net>
Date:   Tue, 21 Jul 2020 15:32:39 -0700 (PDT)
> From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Date: Tue, 21 Jul 2020 15:15:29 +0900
> 
> > From: kuniyu <kuniyu@amazon.co.jp>
> 
> Please fix your configuration to show your full name in this
> "From: " field, I had to edit it out and use the one from your
> email headers.
> 
> > This patch set addresses two issues which happen when both connected and
> > unconnected sockets are in the same UDP reuseport group.
> 
> Series applied and queued up for -stable, th anks.

I am sorry for bothering you... and grateful for your kind advice.
I have fixed my configuration for net repository as with net-next.

Thank you.

