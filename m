Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1FB32316AC
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbgG2ASq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 20:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728236AbgG2ASq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 20:18:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BD5C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 17:18:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E2C4F128D3078;
        Tue, 28 Jul 2020 17:01:59 -0700 (PDT)
Date:   Tue, 28 Jul 2020 17:18:44 -0700 (PDT)
Message-Id: <20200728.171844.437436118773403885.davem@davemloft.net>
To:     herbert@gondor.apana.org.au
Cc:     ayush.sawal@chelsio.com, netdev@vger.kernel.org,
        secdev@chelsio.com, lkp@intel.com, steffen.klassert@secunet.com
Subject: Re: [PATCH net V2] Crypto/chcr: Registering cxgb4 to xfrmdev_ops
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200725062034.GA19493@gondor.apana.org.au>
References: <20200724084124.21651-1-ayush.sawal@chelsio.com>
        <20200724.170108.362782113011946610.davem@davemloft.net>
        <20200725062034.GA19493@gondor.apana.org.au>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 17:02:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Sat, 25 Jul 2020 16:20:34 +1000

> I think this patch belongs to the networking tree.  The reason is
> that it's related to xfrm offload which has nothing to do with the
> Crypto API.
> 
> Do xfrm offload drivers usually go through the networking tree or
> would it be better directed through the xfrm tree?
> 
> There's really nobody on the crypto mailing list who could give
> this the proper review that it deserves.
> 
> Of course I'm happy to continue taking anything that touches
> chcr_algo.c as that resides wholly within the Crypto API.

Meanwhile it looks like the restructuring effort is underway so
hopefully this is less painful in the future.
