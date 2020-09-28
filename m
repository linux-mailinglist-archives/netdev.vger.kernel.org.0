Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A8727B53C
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 21:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgI1T0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 15:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgI1T0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 15:26:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F363AC061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 12:26:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9AC0F1440F9C3;
        Mon, 28 Sep 2020 12:09:14 -0700 (PDT)
Date:   Mon, 28 Sep 2020 12:25:58 -0700 (PDT)
Message-Id: <20200928.122558.900636172858820094.davem@davemloft.net>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org
Subject: Re: pull request (net): ipsec 2020-09-28
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200928082450.29414-1-steffen.klassert@secunet.com>
References: <20200928082450.29414-1-steffen.klassert@secunet.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 12:09:14 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Mon, 28 Sep 2020 10:24:42 +0200

> 1) Fix a build warning in ip_vti if CONFIG_IPV6 is not set.
>    From YueHaibing.
> 
> 2) Restore IPCB on espintcp before handing the packet to xfrm
>    as the information there is still needed.
>    From Sabrina Dubroca.
> 
> 3) Fix pmtu updating for xfrm interfaces.
>    From Sabrina Dubroca.
> 
> 4) Some xfrm state information was not cloned with xfrm_do_migrate.
>    Fixes to clone the full xfrm state, from Antony Antony.
> 
> 5) Use the correct address family in xfrm_state_find. The struct
>    flowi must always be interpreted along with the original
>    address family. This got lost over the years.
>    Fix from Herbert Xu.
> 
> Please pull or let me know if there are problems.

Pulled, thank you.
