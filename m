Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3EF5229DA0
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 18:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgGVQ7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 12:59:16 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:10243 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgGVQ7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 12:59:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1595437155; x=1626973155;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Ii8cjk4IQHFJom5jUg5CvG8Dn7N/tuaozH9/Wd8E8Ms=;
  b=WunqPlLw04jpQc1pggInB6PWBxgBlynUDIdUK1z91SFMAZA33t879LrR
   3/K+BZLO/7zJQKC6bwjnOirOc3S3dZSQtvxkSyQqliXLxg0RhBDH5foY3
   2gX28xETsOSBDJneC3nDKPLr6hWClRjV/CGFmn/214+RDctcappF6DvjJ
   k=;
IronPort-SDR: 2UuOvxPhSwqD4fmJIs9O7v8NMnr1Vmn/JUdkghZZ5O8vgJiqAk27gribZwPEps5Owllie1cIOY
 ltYCHY+JH5qw==
X-IronPort-AV: E=Sophos;i="5.75,383,1589241600"; 
   d="scan'208";a="43524652"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-f273de60.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 22 Jul 2020 16:59:14 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-f273de60.us-east-1.amazon.com (Postfix) with ESMTPS id 6D803A2336;
        Wed, 22 Jul 2020 16:59:11 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Jul 2020 16:59:10 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.214) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Jul 2020 16:59:06 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <jakub@cloudflare.com>
CC:     <ast@kernel.org>, <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <kernel-team@cloudflare.com>,
        <kuba@kernel.org>, <kuniyu@amazon.co.jp>, <netdev@vger.kernel.org>,
        <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH bpf-next 0/2] Fix BPF socket lookup with reuseport groups with connections
Date:   Thu, 23 Jul 2020 01:59:02 +0900
Message-ID: <20200722165902.51857-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20200722161720.940831-1-jakub@cloudflare.com>
References: <20200722161720.940831-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.214]
X-ClientProxiedBy: EX13D13UWB002.ant.amazon.com (10.43.161.21) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Jakub Sitnicki <jakub@cloudflare.com>
Date:   Wed, 22 Jul 2020 18:17:18 +0200
> This mini series contains a fix for a bug noticed when analyzing a reported
> merge conflict between bpf-next and net tree [0].
> 
> Apart from fixing a corner-case that affects use of BPF sk_lookup in tandem
> with UDP reuseport groups with connected sockets, it should make the
> conflict resolution with net tree easier.
> 
> These changes don't replicate the improved UDP socket lookup behavior from
> net tree, where commit efc6b6f6c311 ("udp: Improve load balancing for
> SO_REUSEPORT.") is present.
> 
> Happy to do it as a follow up. For the moment I didn't want to make things
> more confusing when it comes to what got fixed where and why.
> 
> Thanks,
> -jkbs

Acked-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

Thank you.
