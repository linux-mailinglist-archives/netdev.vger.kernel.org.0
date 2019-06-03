Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6590E33AE5
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfFCWNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:13:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36144 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfFCWNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:13:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D358F136E16B0;
        Mon,  3 Jun 2019 15:13:29 -0700 (PDT)
Date:   Mon, 03 Jun 2019 15:13:29 -0700 (PDT)
Message-Id: <20190603.151329.1880364693299986138.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     ssantosh@kernel.org, richardcochran@gmail.com, robh+dt@kernel.org,
        nsekhar@ti.com, m-karicheri2@ti.com, w-kwok2@ti.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 04/10] net: ethernet: ti: cpts: add support
 for rftclk selection
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190601104534.25790-5-grygorii.strashko@ti.com>
References: <20190601104534.25790-1-grygorii.strashko@ti.com>
        <20190601104534.25790-5-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Jun 2019 15:13:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Sat, 1 Jun 2019 13:45:28 +0300

> +static int cpts_of_mux_clk_setup(struct cpts *cpts, struct device_node *node)
> +{
> +	unsigned int num_parents;
> +	const char **parent_names;
> +	struct device_node *refclk_np;
> +	struct clk_hw *clk_hw;
> +	u32 *mux_table;
> +	int ret = -EINVAL;

Reverse christmas tree please.

Thank you.
