Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAF79270C2
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730063AbfEVUUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 16:20:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33622 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729679AbfEVUUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 16:20:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 57BD415006225;
        Wed, 22 May 2019 13:20:30 -0700 (PDT)
Date:   Wed, 22 May 2019 13:20:27 -0700 (PDT)
Message-Id: <20190522.132027.1907723568435949257.davem@davemloft.net>
To:     alexei.starovoitov@gmail.com
Cc:     kris.van.hees@oracle.com, peterz@infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190522195526.mayamzc7gstqzcpr@ast-mbp.dhcp.thefacebook.com>
References: <20190522142531.GE16275@worktop.programming.kicks-ass.net>
        <20190522182215.GO2422@oracle.com>
        <20190522195526.mayamzc7gstqzcpr@ast-mbp.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 13:20:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 22 May 2019 12:55:27 -0700

> I suggest to proceed with user space dtrace conversion to bpf
> without introducing kernel changes.

Yes, please...

+1
