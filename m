Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2E724FEB8
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 15:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgHXNU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 09:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgHXNUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 09:20:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC49C061573;
        Mon, 24 Aug 2020 06:20:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 00B6712824063;
        Mon, 24 Aug 2020 06:04:07 -0700 (PDT)
Date:   Mon, 24 Aug 2020 06:20:52 -0700 (PDT)
Message-Id: <20200824.062052.523630350034926727.davem@davemloft.net>
To:     sylphrenadin@gmail.com
Cc:     Julia.Lawall@lip6.fr, andrew@lunn.ch, sean.wang@mediatek.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] net: dsa: Add of_node_put() before break and return
 statements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200823193054.29336-1-sylphrenadin@gmail.com>
References: <20200823193054.29336-1-sylphrenadin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 06:04:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sumera Priyadarsini <sylphrenadin@gmail.com>
Date: Mon, 24 Aug 2020 01:00:54 +0530

> ---
> 
> Signed-off-by: Sumera Priyadarsini <sylphrenadin@gmail.com>
> 
> Signed-off-by: Sumera Priyadarsini <sylphrenadin@gmail.com>

You only need one Signed-off-by:

You must not put the signoff after the "---" otherwise GIT will remove
it from the commit log message when I try to apply your patch.

Combine this with the fact that your change didn't even compile
properly up until even V2, I wish you would put more effort and
care into your patch submission.  It feels to reviewers like
you are just throwing this patch onto the mailing list without
much care or testing at all.

Thank you.
