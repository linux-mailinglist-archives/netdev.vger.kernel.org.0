Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8050420BA15
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 22:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgFZUPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 16:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgFZUPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 16:15:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D616EC03E97B
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 13:15:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7F54F127320AB;
        Fri, 26 Jun 2020 13:15:17 -0700 (PDT)
Date:   Fri, 26 Jun 2020 13:15:16 -0700 (PDT)
Message-Id: <20200626.131516.1400996071899307828.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     linux-net-drivers@solarflare.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 05/15] sfc: refactor EF10 stats handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e6c9678d-832b-20eb-7d03-8182b3267063@solarflare.com>
References: <1a1716f9-f909-4093-8107-3c2435d834c5@solarflare.com>
        <e6c9678d-832b-20eb-7d03-8182b3267063@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Jun 2020 13:15:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Fri, 26 Jun 2020 12:29:02 +0100

> diff --git a/drivers/net/ethernet/sfc/nic.c b/drivers/net/ethernet/sfc/nic.c
> index b0baa70fbba7..9f5d6932ed71 100644
> --- a/drivers/net/ethernet/sfc/nic.c
> +++ b/drivers/net/ethernet/sfc/nic.c
 ...
> +int efx_nic_copy_stats(struct efx_nic *efx, __le64 *dest)
> +{
> +	int retry;
> +	__le64 generation_start, generation_end;
> +	__le64 *dma_stats = efx->stats_buffer.addr;
> +	int rc = 0;

Reverse christmas tree please.
