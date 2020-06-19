Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD556201BF5
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 22:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391592AbgFSUE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 16:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389021AbgFSUE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 16:04:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E56C06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 13:04:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E31881286291B;
        Fri, 19 Jun 2020 13:04:26 -0700 (PDT)
Date:   Fri, 19 Jun 2020 13:04:26 -0700 (PDT)
Message-Id: <20200619.130426.2081069133350332173.davem@davemloft.net>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org
Subject: Re: pull request (net): ipsec 2020-06-19
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200619074342.14095-1-steffen.klassert@secunet.com>
References: <20200619074342.14095-1-steffen.klassert@secunet.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Jun 2020 13:04:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Fri, 19 Jun 2020 09:43:37 +0200

> 1) Fix double ESP trailer insertion in IPsec crypto offload if
>    netif_xmit_frozen_or_stopped is true. From Huy Nguyen.
> 
> 2) Merge fixup for "remove output_finish indirection from
>    xfrm_state_afinfo". From Stephen Rothwell.
> 
> 3) Select CRYPTO_SEQIV for ESP as this is needed for GCM and several
>    other encryption algorithms. Also modernize the crypto algorithm
>    selections for ESP and AH, remove those that are maked as "MUST NOT"
>    and add those that are marked as "MUST" be implemented in RFC 8221.
>    From Eric Biggers.
> 
> Please note the merge conflict between commit:
> 
> a7f7f6248d97 ("treewide: replace '---help---' in Kconfig files with 'help'")
> 
> from Linus' tree and commits:
> 
> 7d4e39195925 ("esp, ah: consolidate the crypto algorithm selections")
> be01369859b8 ("esp, ah: modernize the crypto algorithm selections")
> 
> from the ipsec tree.
> 
> Please pull or let me know if there are problems.

Pulled, thanks a lot.
