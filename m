Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 451D9912C2
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 21:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbfHQTsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 15:48:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55694 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfHQTsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 15:48:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 763CE14DB71DC;
        Sat, 17 Aug 2019 12:48:11 -0700 (PDT)
Date:   Sat, 17 Aug 2019 12:48:10 -0700 (PDT)
Message-Id: <20190817.124810.1171882980329111418.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org, ayal@mellanox.com, tariqt@mellanox.com,
        jiri@mellanox.com
Subject: Re: [net-next 11/16] net/mlx5e: Report and recover from rx timeout
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190815190911.12050-12-saeedm@mellanox.com>
References: <20190815190911.12050-1-saeedm@mellanox.com>
        <20190815190911.12050-12-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 17 Aug 2019 12:48:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu, 15 Aug 2019 19:10:07 +0000

> +static int mlx5e_rx_reporter_timeout_recover(void *ctx)
> +{
> +	struct mlx5e_rq *rq = ctx;
> +	struct mlx5e_icosq *icosq = &rq->channel->icosq;
> +	struct mlx5_eq_comp *eq = rq->cq.mcq.eq;
> +	int err;

In this and several further patches, this non-reverse-christmas tree
sequence appears.  Please fix it.

Put the variable assignments into the body of the function if you have
to in order to make this styled correctly.

Thanks.
