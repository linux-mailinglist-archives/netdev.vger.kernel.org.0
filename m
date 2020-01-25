Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3129A1493DF
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 08:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbgAYHPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 02:15:04 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48356 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgAYHPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 02:15:04 -0500
Received: from localhost (unknown [62.209.224.147])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1802715A16D6F;
        Fri, 24 Jan 2020 23:15:02 -0800 (PST)
Date:   Sat, 25 Jan 2020 08:15:01 +0100 (CET)
Message-Id: <20200125.081501.844064409437176102.davem@davemloft.net>
To:     mathew.j.martineau@linux.intel.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org, edumazet@google.com
Subject: Re: [PATCH net-next 2/2] mptcp: Fix code formatting
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200125000403.251894-3-mathew.j.martineau@linux.intel.com>
References: <20200125000403.251894-1-mathew.j.martineau@linux.intel.com>
        <20200125000403.251894-3-mathew.j.martineau@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jan 2020 23:15:03 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Date: Fri, 24 Jan 2020 16:04:03 -0800

> checkpatch.pl had a few complaints in the last set of MPTCP patches:
> 
> ERROR: code indent should use tabs where possible
> +^I         subflow, sk->sk_family, icsk->icsk_af_ops, target, mapped);$
> 
> CHECK: Comparison to NULL could be written "!new_ctx"
> +	if (new_ctx == NULL) {
> 
> ERROR: "foo * bar" should be "foo *bar"
> +static const struct proto_ops * tcp_proto_ops(struct sock *sk)
> 
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

Applied.
