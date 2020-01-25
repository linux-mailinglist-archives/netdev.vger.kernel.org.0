Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 366BD14941E
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 10:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgAYJ3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 04:29:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48772 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgAYJ3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 04:29:39 -0500
Received: from localhost (unknown [147.229.117.36])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 61BA315A1BC2D;
        Sat, 25 Jan 2020 01:29:38 -0800 (PST)
Date:   Sat, 25 Jan 2020 10:29:36 +0100 (CET)
Message-Id: <20200125.102936.1710420903506965271.davem@davemloft.net>
To:     kuniyu@amazon.co.jp
Cc:     netdev@vger.kernel.org, kuni1840@gmail.com
Subject: Re: [PATCH net-next] soreuseport: Cleanup duplicate initialization
 of more_reuse->max_socks.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <658d70e554ee4206b753cc2014407d95@EX13MTAUWA001.ant.amazon.com>
References: <658d70e554ee4206b753cc2014407d95@EX13MTAUWA001.ant.amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Jan 2020 01:29:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Date: Thu, 23 Jan 2020 15:52:23 +0000

> diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> index f19f179538b9..91e9f2223c39 100644
> --- a/net/core/sock_reuseport.c
> +++ b/net/core/sock_reuseport.c
> @@ -107,7 +107,6 @@ static struct sock_reuseport *reuseport_grow(struct sock_reuseport *reuse)
> 	if (!more_reuse)
> 		return NULL;
> -	more_reuse->max_socks = more_socks_size;
> 	more_reuse->num_socks = reuse->num_socks;
> 	more_reuse->prog = reuse->prog;
> 	more_reuse->reuseport_id = reuse->reuseport_id;
> --
> 2.17.2

This patch is corrupted.  The context says that there are 7 lines beforehand
and 6 afterwards.  But the hunk shows 6 lines beforehand and 5 afterward.
