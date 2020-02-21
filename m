Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B22EC16851D
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 18:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgBURgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 12:36:19 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:37524 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbgBURgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 12:36:19 -0500
Received: by mail-pj1-f65.google.com with SMTP id m13so1060279pjb.2;
        Fri, 21 Feb 2020 09:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xCuUVG8i9sUDnafZb9V7mQjHX9/dckJtwGg3rmaaHo4=;
        b=I7JCJhFZz8SRs2jNQKKGxgwzmYk7nx4qwqEm8xoUGhzbEX+jz77yNShT8//TUNew7o
         m9B2eLslNGYfGQ2F335wUDgqaUROFv6w8orB6SPR2bL80icZ6IVgKkbAHw/OZP9m0W42
         jJqOp8HalM194W7hG3xcHHTwJcZko+ncvfVT5MDko2o3akKrx3F2KNPPghDsPPu9NGvQ
         oj85orP2I77EIa0H3YQq71kOdC+jULP1NmHTZN/Fm2lgda/i7xjO+iwgfxDY5+Gu0gfP
         BZjn0BMzUEWVqzP3qGhtYJg/72AvYi60eYSO7NNZxmb+gqgGNoFeppczIl2n2chtkzzA
         UPag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xCuUVG8i9sUDnafZb9V7mQjHX9/dckJtwGg3rmaaHo4=;
        b=svwfsmAN6hxv2Xdch4/9S6q9YV1Iyr9m7IwKeMZIJhy64QVtGqb88jyHL7eC70pdfd
         ct6EQ9WKxCaDBTmGPVargjzLZjHdXprZPRHFpaJvdChrXh5AJ/4PgkkheF7nqJadu5In
         Zr+b3SK0sjyHd2WAN2bUeKQAek5i35lCTCY+oGwwmXN5KHih8kJ8jncii2pjGaOT++tw
         K4388clMRN2O2+UeHL8CpYy+Zhl7QU/ZtqBfu2Ona2PCidj8EGKnGwMMmO7j/F8ZMD6s
         0H+ZF/JvceTmHhGne0I3wr5gHCfaR1nuybcQ0eTNUz14PmsE5VT2P5cQPxZFAYxEnKyG
         tQ3A==
X-Gm-Message-State: APjAAAXQ9cBoE4ttnfqH/EF/XuFw6g05hxU3Z/kS9AwIAng/Uy8XLx3e
        Ypj4dEOtgOdZj7l4XB3WLA==
X-Google-Smtp-Source: APXvYqyViuIGu2NMjKXfV2oi5e71Y2nv4Ub8Ajrnm77/jV9pFx3oWcpx0XVU8lPi+Cpf68UC7E4Sjg==
X-Received: by 2002:a17:90a:c084:: with SMTP id o4mr4192690pjs.35.1582306578445;
        Fri, 21 Feb 2020 09:36:18 -0800 (PST)
Received: from madhuparna-HP-Notebook ([2402:3a80:1ee0:fe5e:d03d:769b:c838:c146])
        by smtp.gmail.com with ESMTPSA id l15sm3044096pgi.31.2020.02.21.09.35.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 21 Feb 2020 09:36:17 -0800 (PST)
From:   Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
X-Google-Original-From: Madhuparna Bhowmik <change_this_user_name@gmail.com>
Date:   Fri, 21 Feb 2020 23:05:34 +0530
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     madhuparnabhowmik10@gmail.com, jiri@mellanox.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org
Subject: Re: [PATCH] net: core: devlink.c: Use built-in RCU list checking
Message-ID: <20200221173533.GA13198@madhuparna-HP-Notebook>
References: <20200221165141.24630-1-madhuparnabhowmik10@gmail.com>
 <20200221172008.GA2181@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221172008.GA2181@nanopsycho>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 06:20:08PM +0100, Jiri Pirko wrote:
> Fri, Feb 21, 2020 at 05:51:41PM CET, madhuparnabhowmik10@gmail.com wrote:
> >From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> >
> >list_for_each_entry_rcu() has built-in RCU and lock checking.
> >
> >Pass cond argument to list_for_each_entry_rcu() to silence
> >false lockdep warning when CONFIG_PROVE_RCU_LIST is enabled
> >by default.
> >
> >Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> 
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> 
> Thanks.
> 
> However, there is a callpath where not devlink lock neither rcu read is
> taken:
> devlink_dpipe_table_register()->devlink_dpipe_table_find()
>
Hi,

Yes I had noticed this, but I was not sure if there is some other lock
which is being used.

If yes, then can you please tell me which lock is held in this case,
and I can add that condition as well to list_for_each_entry_rcu() usage.

And if no lock or rcu_read_lock is held then may be we should
use rcu_read_lock/unlock here.

Let me know what you think about this.

Thank you,
Madhuparna

> I guess that was not the trace you were seeing, right?
> 
> 
> >---
> > net/core/devlink.c | 3 ++-
> > 1 file changed, 2 insertions(+), 1 deletion(-)
> >
> >diff --git a/net/core/devlink.c b/net/core/devlink.c
> >index 4c63c9a4c09e..3e8c94155d93 100644
> >--- a/net/core/devlink.c
> >+++ b/net/core/devlink.c
> >@@ -2107,7 +2107,8 @@ devlink_dpipe_table_find(struct list_head *dpipe_tables,
> > {
> > 	struct devlink_dpipe_table *table;
> > 
> >-	list_for_each_entry_rcu(table, dpipe_tables, list) {
> >+	list_for_each_entry_rcu(table, dpipe_tables, list,
> >+				lockdep_is_held(&devlink->lock)) {
> > 		if (!strcmp(table->name, table_name))
> > 			return table;
> > 	}
> >-- 
> >2.17.1
> >
