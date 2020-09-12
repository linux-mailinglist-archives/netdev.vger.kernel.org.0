Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6B42676CA
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 02:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbgILA1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 20:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbgILA12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 20:27:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4ACC061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 17:27:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1EE3E1216DC44;
        Fri, 11 Sep 2020 17:10:41 -0700 (PDT)
Date:   Fri, 11 Sep 2020 17:27:27 -0700 (PDT)
Message-Id: <20200911.172727.2300332911533778993.davem@davemloft.net>
To:     rohitm@chelsio.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, secdev@chelsio.com
Subject: Re: [net-next] crypto/chcr: move nic TLS functionality to
 drivers/net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200910142147.21851-1-rohitm@chelsio.com>
References: <20200910142147.21851-1-rohitm@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 11 Sep 2020 17:10:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rohit Maheshwari <rohitm@chelsio.com>
Date: Thu, 10 Sep 2020 19:51:47 +0530

> This patch moves complete nic tls offload (kTLS) code from crypto
> directory to drivers/net/ethernet/chelsio/inline_crypto/ch_ktls
> directory. nic TLS is made a separate ULD of cxgb4.
> 
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>

Applied, but...

> diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/Makefile b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/Makefile
> new file mode 100644
> index 000000000000..aee3ee884799
> --- /dev/null
> +++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/Makefile
> @@ -0,0 +1,7 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +ccflags-y := -I $(srctree)/drivers/net/ethernet/chelsio/cxgb4
> +
> +obj-$(CONFIG_CHELSIO_TLS_DEVICE) += ch_ktls.o
> +ch_ktls-objs := chcr_ktls.o
> +
> +

Please avoid empty trailing lines in files.
