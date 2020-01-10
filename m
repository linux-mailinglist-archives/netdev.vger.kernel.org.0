Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 615A5136581
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 03:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730889AbgAJCnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 21:43:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60874 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730764AbgAJCnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 21:43:42 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E455A1573FEF3;
        Thu,  9 Jan 2020 18:43:40 -0800 (PST)
Date:   Thu, 09 Jan 2020 18:43:40 -0800 (PST)
Message-Id: <20200109.184340.89665512479537332.davem@davemloft.net>
To:     fw@strlen.de
Cc:     mathew.j.martineau@linux.intel.com, netdev@vger.kernel.org,
        mptcp@lists.01.org, ast@kernel.org, daniel@iogearbox.net,
        bpf@vger.kernel.org
Subject: Re: [MPTCP] Re: [PATCH net-next v7 02/11] sock: Make sk_protocol a
 16-bit value
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200109212528.GF795@breakpoint.cc>
References: <20200109155924.30122-3-mathew.j.martineau@linux.intel.com>
        <20200109.110514.747612850299504416.davem@davemloft.net>
        <20200109212528.GF795@breakpoint.cc>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Jan 2020 18:43:41 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Thu, 9 Jan 2020 22:25:28 +0100

> If you think such a size increase is ok I could give that solution a shot
> and see what other problems with 8bit sk_protocol might remain.
> 
> Mat reported /sys/kernel/debug/tracing/trace lists mptcp sockets as
> IPPROTO_TCP in the '8 bit sk_protocol' case, but if thats the only issue
> this might have a smaller/acceptable "avoidance fix".

Ok I'll apply the current series as-is with the 16-bit sk_protocol.  Let's
see how this goes in practice.

Thanks for explaining.
