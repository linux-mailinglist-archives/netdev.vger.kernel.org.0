Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7F32146C0
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 17:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgGDPFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 11:05:32 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:17276 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgGDPFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 11:05:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1593875132; x=1625411132;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=ZXx9JmTl7wcYNtYvGId7da35QCBcGlf7mvlovLk/+yY=;
  b=LR/M8GsvCd6z/l4w23SzzuFGkwslImnJr3ylsV/7k7Nc1AHISVXzB0zG
   tsdWeCS3gNII8BK7yH6aA5+nDJQJb+P5zl+hQmr6U/lXGnhOHV3STTdx+
   YSyKMgWi6Xb2ndPwxnurrZQAt0VNVQqjb8wQeX3NMwEhhNdbM1XTVwvSU
   g=;
IronPort-SDR: x7AUWQtBlFc8ez4Q3t0BeKUTJchXx4T/Od/8s0W1KVXkfzZ1bnB8XVbsvtmCvRp7hGhW8sXVtp
 peDb8uHBebwg==
X-IronPort-AV: E=Sophos;i="5.75,312,1589241600"; 
   d="scan'208";a="41403442"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 04 Jul 2020 15:05:31 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id E01BAC07AC;
        Sat,  4 Jul 2020 15:05:28 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 4 Jul 2020 15:05:27 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.73) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 4 Jul 2020 15:05:18 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kuniyu@amazon.co.jp>
CC:     <benh@amazon.com>, <davem@davemloft.net>, <ja@ssi.bg>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuznet@ms2.inr.ac.ru>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>,
        <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net-next] inet: Remove an unnecessary arguments of syn_ack_recalc().
Date:   Sun, 5 Jul 2020 00:05:10 +0900
Message-ID: <20200704150510.8771-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20200704081158.83489-1-kuniyu@amazon.co.jp>
References: <20200704081158.83489-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.73]
X-ClientProxiedBy: EX13D40UWC002.ant.amazon.com (10.43.162.191) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm sorry, I would fix typo in title and respin it.

Regards,
Kuniyuki Iwashima
