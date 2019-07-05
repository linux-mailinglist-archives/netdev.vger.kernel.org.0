Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE99360D67
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 23:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfGEV6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 17:58:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43164 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfGEV6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 17:58:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6912015040B58;
        Fri,  5 Jul 2019 14:58:41 -0700 (PDT)
Date:   Fri, 05 Jul 2019 14:58:38 -0700 (PDT)
Message-Id: <20190705.145838.1520777700292544385.davem@davemloft.net>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org
Subject: Re: pull request (net): ipsec 2019-07-05
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190705082700.31107-1-steffen.klassert@secunet.com>
References: <20190705082700.31107-1-steffen.klassert@secunet.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Jul 2019 14:58:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Fri, 5 Jul 2019 10:26:53 +0200

> 1)  Fix xfrm selector prefix length validation for
>     inter address family tunneling.
>     From Anirudh Gupta.
> 
> 2) Fix a memleak in pfkey.
>    From Jeremy Sowden.
> 
> 3) Fix SA selector validation to allow empty selectors again.
>    From Nicolas Dichtel.
> 
> 4) Select crypto ciphers for xfrm_algo, this fixes some
>    randconfig builds. From Arnd Bergmann.
> 
> 5) Remove a duplicated assignment in xfrm_bydst_resize.
>    From Cong Wang.
> 
> 6) Fix a hlist corruption on hash rebuild.
>    From Florian Westphal.
> 
> 7) Fix a memory leak when creating xfrm interfaces.
>    From Nicolas Dichtel.
> 
> Please pull or let me know if there are problems.

Pulled, thanks Steffen.
