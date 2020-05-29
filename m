Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D7D1E8866
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 22:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbgE2UDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 16:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbgE2UDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 16:03:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 589B4C03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 13:03:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 146281283BB0E;
        Fri, 29 May 2020 13:03:18 -0700 (PDT)
Date:   Fri, 29 May 2020 13:03:17 -0700 (PDT)
Message-Id: <20200529.130317.773571363899064525.davem@davemloft.net>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org
Subject: Re: pull request (net-next): ipsec-next 2020-05-29
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200529103011.30127-1-steffen.klassert@secunet.com>
References: <20200529103011.30127-1-steffen.klassert@secunet.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 May 2020 13:03:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Fri, 29 May 2020 12:30:00 +0200

> 1) Add IPv6 encapsulation support for ESP over UDP and TCP.
>    From Sabrina Dubroca.
> 
> 2) Remove unneeded reference when initializing xfrm interfaces.
>    From Nicolas Dichtel.
> 
> 3) Remove some indirect calls from the state_afinfo.
>    From Florian Westphal.
> 
> Please note that this pull request has two merge conflicts
 ...
> Both conflicts can be resolved as done in linux-next.
> 
> Please pull or let me know if there are problems.

Pulled, thanks Steffen.
