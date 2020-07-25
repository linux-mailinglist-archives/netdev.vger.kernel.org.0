Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A1222D6EA
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 12:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgGYKy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 06:54:57 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:28351 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgGYKy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 06:54:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1595674496; x=1627210496;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=6M08r14XIT6Lt8oZF0/v6yc4h5PvDPR6FVM+6X7dKP4=;
  b=D6CIrlzWKNfN5EtHp5wCdW0lQJdAoUrOcUbDK7QTcKMTxFAq92IecZfc
   4nnlEVVrtzgUlSKrZ0p6OC4KSkDuR2ohwdnJXgp/tot/bbYGykmuBYyd7
   F8ExspaFDdFp7olY6cVSzd2kWMS3bgU9svZA2HBD1xqfS8+/+58IXmB0/
   c=;
IronPort-SDR: kkbzulHtinpvqUPY/2lgjvsdPvYxYvxoC/6JVA1x4FzxBdlZcw0x/mOO7VS4ZlrzbsEfE7gyY9
 H0vTYegJDDTw==
X-IronPort-AV: E=Sophos;i="5.75,394,1589241600"; 
   d="scan'208";a="45341434"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 25 Jul 2020 10:54:56 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id B7CFFA2307;
        Sat, 25 Jul 2020 10:54:53 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 25 Jul 2020 10:54:52 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.146) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 25 Jul 2020 10:54:48 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <davem@davemloft.net>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <jakub@cloudflare.com>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <netdev@vger.kernel.org>, <willemb@google.com>,
        <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH net] udp: Remove an unnecessary variable in udp[46]_lib_lookup2().
Date:   Sat, 25 Jul 2020 19:54:44 +0900
Message-ID: <20200725105444.17260-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20200724.164847.1111562996497649259.davem@davemloft.net>
References: <20200724.164847.1111562996497649259.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.146]
X-ClientProxiedBy: EX13D29UWA003.ant.amazon.com (10.43.160.253) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   David Miller <davem@davemloft.net>
Date:   Fri, 24 Jul 2020 16:48:47 -0700 (PDT)
> From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Date: Fri, 24 Jul 2020 15:13:04 +0900
> 
> > Yes. I think this kind of patch should be submitted to net-next, but
> > this is for the net tree. Please let me add more description.
> 
> This does not fix a bug, therefore 'net' is not appropriate.

Exactly, I am sorry for the confusion.


> The merge conflicts should be handled by the appropriate maintainer
> when the merges happen.

I will keep this in mind, thank you.

Best Regards,
Kuniyuki
