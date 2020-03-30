Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF711982DD
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729573AbgC3R7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:59:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40366 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgC3R7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 13:59:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1928015C44B41;
        Mon, 30 Mar 2020 10:59:40 -0700 (PDT)
Date:   Mon, 30 Mar 2020 10:59:39 -0700 (PDT)
Message-Id: <20200330.105939.815343006259131072.davem@davemloft.net>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org
Subject: Re: pull request (net-next): ipsec-next 2020-03-28
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200328112924.676-1-steffen.klassert@secunet.com>
References: <20200328112924.676-1-steffen.klassert@secunet.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 10:59:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Sat, 28 Mar 2020 12:29:19 +0100

> 1) Use kmem_cache_zalloc() instead of kmem_cache_alloc()
>    in xfrm_state_alloc(). From Huang Zijiang.
> 
> 2) esp_output_fill_trailer() is the same in IPv4 and IPv6,
>    so share this function to avoide code duplcation.
>    From Raed Salem.
> 
> 3) Add offload support for esp beet mode.
>    From Xin Long.
> 
> Please pull or let me know if there are problems.

Pulled, thanks Steffen.
