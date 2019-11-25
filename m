Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D79F1093B8
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 19:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbfKYSuX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 25 Nov 2019 13:50:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52820 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfKYSuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 13:50:23 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1FA8315008C8B;
        Mon, 25 Nov 2019 10:50:23 -0800 (PST)
Date:   Mon, 25 Nov 2019 10:50:22 -0800 (PST)
Message-Id: <20191125.105022.2027962925589066709.davem@davemloft.net>
To:     zenczykowski@gmail.com
Cc:     maze@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net-sctp: replace some sock_net(sk) with just 'net'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191124104727.8273-1-zenczykowski@gmail.com>
References: <20191124104727.8273-1-zenczykowski@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 Nov 2019 10:50:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej ¯enczykowski <zenczykowski@gmail.com>
Date: Sun, 24 Nov 2019 02:47:27 -0800

> @@ -8264,6 +8264,7 @@ static struct sctp_bind_bucket *sctp_bucket_create(
>  
>  static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
>  {
> +	struct net *net = sock_net(sk);
>  	struct sctp_sock *sp = sctp_sk(sk);
>  	bool reuse = (sk->sk_reuse || sp->reuse);
>  	struct sctp_bind_hashbucket *head; /* hash list */

Please don't make the reverse christmas tree situation here worse,
thank you.
