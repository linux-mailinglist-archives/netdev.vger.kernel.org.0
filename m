Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3688C1E8C24
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 01:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbgE2XjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 19:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgE2XjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 19:39:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2495FC03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 16:39:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 516FF12867EB2;
        Fri, 29 May 2020 16:38:59 -0700 (PDT)
Date:   Fri, 29 May 2020 16:38:58 -0700 (PDT)
Message-Id: <20200529.163858.366561938125003879.davem@davemloft.net>
To:     vinay.yadav@chelsio.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, kuba@kernel.org,
        borisp@mellanox.com, jakub@cloudflare.com, secdev@chelsio.com
Subject: Re: [PATCH net-next,v2] crypto/chtls: IPv6 support for inline TLS
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527055352.7103-1-vinay.yadav@chelsio.com>
References: <20200527055352.7103-1-vinay.yadav@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 May 2020 16:38:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Date: Wed, 27 May 2020 11:23:52 +0530

> @@ -2110,6 +2110,7 @@ struct proto tcpv6_prot = {
>  #endif
>  	.diag_destroy		= tcp_abort,
>  };
> +EXPORT_SYMBOL(tcpv6_prot);

If you are going to do something which is so invasive and exposes
internals so deeply, you _MUST_ use EXPORT_SYMBOL_GPL().
