Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C00F4D5310
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 00:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbfJLWc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 18:32:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33208 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfJLWc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 18:32:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6EC87151226D0;
        Sat, 12 Oct 2019 15:32:27 -0700 (PDT)
Date:   Sat, 12 Oct 2019 15:32:24 -0700 (PDT)
Message-Id: <20191012.153224.2132803535359154086.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     netdev@vger.kernel.org, ruxandra.radulescu@nxp.com
Subject: Re: [PATCH net 2/2] dpaa2-eth: Fix TX FQID values
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1570724387-5370-3-git-send-email-ioana.ciornei@nxp.com>
References: <1570724387-5370-1-git-send-email-ioana.ciornei@nxp.com>
        <1570724387-5370-3-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 12 Oct 2019 15:32:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Thu, 10 Oct 2019 19:19:47 +0300

> @@ -2533,6 +2536,45 @@ static int set_pause(struct dpaa2_eth_priv *priv)
>  	return 0;
>  }
>  
> +static void update_tx_fqids(struct dpaa2_eth_priv *priv)
> +{
> +	struct dpaa2_eth_fq *fq;
> +	struct dpni_queue queue;
> +	struct dpni_queue_id qid = {0};
> +	int i, j, err;

Reverse christmas tree local variable ordering here please.
