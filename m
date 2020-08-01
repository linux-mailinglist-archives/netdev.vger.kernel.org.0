Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF27234ED6
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 02:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgHAAL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 20:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbgHAAL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 20:11:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69907C06174A
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 17:11:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3070B11E58FA7;
        Fri, 31 Jul 2020 16:54:43 -0700 (PDT)
Date:   Fri, 31 Jul 2020 17:11:27 -0700 (PDT)
Message-Id: <20200731.171127.1407635367747909671.davem@davemloft.net>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org
Subject: Re: pull request (net): ipsec 2020-07-31
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200731071804.29557-1-steffen.klassert@secunet.com>
References: <20200731071804.29557-1-steffen.klassert@secunet.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 Jul 2020 16:54:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Fri, 31 Jul 2020 09:17:54 +0200

> 1) Fix policy matching with mark and mask on userspace interfaces.
>    From Xin Long.
> 
> 2) Several fixes for the new ESP in TCP encapsulation.
>    From Sabrina Dubroca.
> 
> 3) Fix crash when the hold queue is used. The assumption that
>    xdst->path and dst->child are not a NULL pointer only if dst->xfrm
>    is not a NULL pointer is true with the exception of using the
>    hold queue. Fix this by checking for hold queue usage before
>    dereferencing xdst->path or dst->child.
> 
> 4) Validate pfkey_dump parameter before sending them.
>    From Mark Salyzyn.
> 
> 5) Fix the location of the transport header with ESP in UDPv6
>    encapsulation. From Sabrina Dubroca.
> 
> Please pull or let me know if there are problems.

Pulled, thanks a lot Steffen.
