Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9962930490
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 00:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfE3WDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 18:03:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32870 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfE3WDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 18:03:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 090C814DB034D;
        Thu, 30 May 2019 14:26:26 -0700 (PDT)
Date:   Thu, 30 May 2019 14:26:26 -0700 (PDT)
Message-Id: <20190530.142626.1471109804622294121.davem@davemloft.net>
To:     tonylu@linux.alibaba.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        laoar.shao@gmail.com, songliubraving@fb.com
Subject: Re: [PATCH net-next 0/3] introduce two new tracepoints for udp
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190529130656.23979-1-tonylu@linux.alibaba.com>
References: <20190529130656.23979-1-tonylu@linux.alibaba.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 14:26:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Lu <tonylu@linux.alibaba.com>
Date: Wed, 29 May 2019 21:06:54 +0800

> This series introduces two new tracepoints trace_udp_send and
> trace_udp_queue_rcv, and removes redundant new line from
> tcp_event_sk_skb.

Why?

Is it faster than using kprobes?

Is it more reliable?

Are the events _so_ useful that they warrant a tracepoint and thus
creating a semi-stable interface for tracing and introspection via
ebpf and similar technologies?

Again, you have to say why in your log message(s).
