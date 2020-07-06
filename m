Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7559F215FCD
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 22:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgGFUBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 16:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGFUBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 16:01:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADA7C061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 13:01:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 45401120ED49A;
        Mon,  6 Jul 2020 13:01:34 -0700 (PDT)
Date:   Mon, 06 Jul 2020 13:01:33 -0700 (PDT)
Message-Id: <20200706.130133.435191921384022769.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] dpaa2-eth: fix draining of S/G cache
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200706145554.29439-1-ioana.ciornei@nxp.com>
References: <20200706145554.29439-1-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Jul 2020 13:01:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Mon,  6 Jul 2020 17:55:54 +0300

> On link down, the draining of the S/G cache should be done on all
> _possible_ CPUs not just the ones that are online in that moment.
> Fix this by changing the iterator.
> 
> Fixes: d70446ee1f40 ("dpaa2-eth: send a scatter-gather FD instead of realloc-ing")
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Applied to net-next.

Please explicitly specify the target tree in your Subject lines, "net-next"
in this case.

Otherwise I have to guess and do some trial and error to figure out where
your patch applied.  That wastes my time.

Thank you.
