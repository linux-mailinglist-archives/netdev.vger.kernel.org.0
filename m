Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADBE022D1B3
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 00:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgGXWRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 18:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgGXWRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 18:17:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C5AC0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 15:17:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3FC7B1274BDEE;
        Fri, 24 Jul 2020 15:00:54 -0700 (PDT)
Date:   Fri, 24 Jul 2020 15:17:34 -0700 (PDT)
Message-Id: <20200724.151734.311823341957534173.davem@davemloft.net>
To:     herbert@gondor.apana.org.au
Cc:     wenxu@ucloud.cn, jakub.kicinski@netronome.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] flow_offload: Move rhashtable inclusion to the source
 file
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200724005022.GA29161@gondor.apana.org.au>
References: <20200724005022.GA29161@gondor.apana.org.au>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jul 2020 15:00:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 24 Jul 2020 10:50:22 +1000

> I noticed that touching linux/rhashtable.h causes lib/vsprintf.c to
> be rebuilt.  This dependency came through a bogus inclusion in the
> file net/flow_offload.h.  This patch moves it to the right place.
> 
> This patch also removes a lingering rhashtable inclusion in cls_api
> created by the same commit.
> 
> Fixes: 4e481908c51b ("flow_offload: move tc indirect block to...")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied, thanks.
