Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3792625C9
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 05:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbgIIDRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 23:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728197AbgIIDRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 23:17:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8616AC061755;
        Tue,  8 Sep 2020 20:17:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0DA3611E3E4C3;
        Tue,  8 Sep 2020 20:00:43 -0700 (PDT)
Date:   Tue, 08 Sep 2020 20:17:29 -0700 (PDT)
Message-Id: <20200908.201729.542237023404934204.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     hkallweit1@gmail.com, kuba@kernel.org, mhabets@solarflare.com,
        tony.felice@timesys.com, mst@redhat.com, gustavo@embeddedor.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: tc35815: switch from 'pci_' to 'dma_' API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200908202747.330007-1-christophe.jaillet@wanadoo.fr>
References: <20200908202747.330007-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 08 Sep 2020 20:00:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Tue,  8 Sep 2020 22:27:47 +0200

> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.
> 
> When memory is allocated in 'tc35815_init_queues()' GFP_ATOMIC must be used
> because it can be called from 'tc35815_restart()' where some spinlock are
> taken.
> The call chain is:
>   tc35815_restart
>     --> tc35815_clear_queues
>       --> tc35815_init_queues
> 
 ...
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied.
