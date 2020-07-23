Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B75722A3A4
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 02:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732755AbgGWAbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 20:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbgGWAbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 20:31:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F7CC0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 17:31:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9E81E11FFCC2A;
        Wed, 22 Jul 2020 17:14:49 -0700 (PDT)
Date:   Wed, 22 Jul 2020 17:31:34 -0700 (PDT)
Message-Id: <20200722.173134.594466541827728596.davem@davemloft.net>
To:     vincent.ldev@duvert.net
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] appletalk: Improve handling of broadcast packets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200722113752.1218-2-vincent.ldev@duvert.net>
References: <20200722113752.1218-1-vincent.ldev@duvert.net>
        <20200722113752.1218-2-vincent.ldev@duvert.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jul 2020 17:14:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Duvert <vincent.ldev@duvert.net>
Date: Wed, 22 Jul 2020 13:37:52 +0200

> @@ -89,6 +89,7 @@ static struct sock *atalk_search_socket(struct sockaddr_at *to,
>  					struct atalk_iface *atif)
>  {
>  	struct sock *s;
> +	struct sock *def_socket = NULL;
>  
>  	read_lock_bh(&atalk_sockets_lock);
>  	sk_for_each(s, &atalk_sockets) {

Please use reverse christmas tree ordering for local variables.

Also, please post the next revision of this patch series with
a proper "[PATCH net 0/N]" header posting, explaining what the
patch series is doing, how it is doing it, and why it is
doing it this way.

Your Subject lines should all also indicate the proper target GIT tree
your changes are for.  This is indicated in the "[]" bracket area,
as either 'net' or 'net-next', f.e. "[PATCH net 1/2] ..."

Thank you.
