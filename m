Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46852233AF3
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 23:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730752AbgG3Vk7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 30 Jul 2020 17:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728849AbgG3Vk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 17:40:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED820C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 14:40:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 252AB126ABD97;
        Thu, 30 Jul 2020 14:24:12 -0700 (PDT)
Date:   Thu, 30 Jul 2020 14:40:56 -0700 (PDT)
Message-Id: <20200730.144056.1854579189478441367.davem@davemloft.net>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org
Subject: Re: pull request (net-next): ipsec-next 2020-07-30
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200730054130.16923-1-steffen.klassert@secunet.com>
References: <20200730054130.16923-1-steffen.klassert@secunet.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Jul 2020 14:24:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Thu, 30 Jul 2020 07:41:11 +0200

> Please note that I did the first time now --no-ff merges
> of my testing branch into the master branch to include
> the [PATCH 0/n] message of a patchset. Please let me
> know if this is desirable, or if I should do it any
> different.

It looks really nice, thanks for doing this.

> 1) Introduce a oseq-may-wrap flag to disable anti-replay
>    protection for manually distributed ICVs as suggested
>    in RFC 4303. From Petr Vanìk.
> 
> 2) Patchset to fully support IPCOMP for vti4, vti6 and
>    xfrm interfaces. From Xin Long.
> 
> 3) Switch from a linear list to a hash list for xfrm interface
>    lookups. From Eyal Birger.
> 
> 4) Fixes to not register one xfrm(6)_tunnel object twice.
>    From Xin Long.
> 
> 5) Fix two compile errors that were introduced with the
>    IPCOMP support for vti and xfrm interfaces.
>    Also from Xin Long.
> 
> 6) Make the policy hold queue work with VTI. This was
>    forgotten when VTI was implemented.
> 
> Please pull or let me know if there are problems.
...
>   git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master

Pulled, thank you!
