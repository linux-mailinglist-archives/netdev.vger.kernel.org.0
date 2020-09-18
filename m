Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB6626EA38
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 03:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgIRBAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 21:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgIRBAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 21:00:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710ACC06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:00:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1D71B13682862;
        Thu, 17 Sep 2020 17:43:58 -0700 (PDT)
Date:   Thu, 17 Sep 2020 18:00:44 -0700 (PDT)
Message-Id: <20200917.180044.1080137100500079082.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] ionic: add DIMLIB to Kconfig
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200917203335.23924-1-snelson@pensando.io>
References: <20200917203335.23924-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 17 Sep 2020 17:43:58 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Thu, 17 Sep 2020 13:33:35 -0700

>>> ld.lld: error: undefined symbol: net_dim_get_rx_moderation
>    >>> referenced by ionic_lif.c:52 (drivers/net/ethernet/pensando/ionic/ionic_lif.c:52)
>    >>> net/ethernet/pensando/ionic/ionic_lif.o:(ionic_dim_work) in archive drivers/built-in.a
> 
>>> ld.lld: error: undefined symbol: net_dim
>    >>> referenced by ionic_txrx.c:456 (drivers/net/ethernet/pensando/ionic/ionic_txrx.c:456)
>    >>> net/ethernet/pensando/ionic/ionic_txrx.o:(ionic_dim_update) in archive drivers/built-in.a
> 
> v2: removed sketchy dashes in commit message
> 
> Fixes: 04a834592bf5 ("ionic: dynamic interrupt moderation")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Applied, thank you.
