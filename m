Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94D70824CD
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 20:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730207AbfHESUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 14:20:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60342 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728831AbfHESUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 14:20:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A5B2C1540E332;
        Mon,  5 Aug 2019 11:20:07 -0700 (PDT)
Date:   Mon, 05 Aug 2019 11:20:07 -0700 (PDT)
Message-Id: <20190805.112007.2076762521602269526.davem@davemloft.net>
To:     mpelland@starry.com
Cc:     netdev@vger.kernel.org, maxime.chevallier@bootlin.com,
        antoine.tenart@bootlin.com
Subject: Re: [PATCH 1/2] net: mvpp2: implement RXAUI support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190801204523.26454-2-mpelland@starry.com>
References: <20190801204523.26454-1-mpelland@starry.com>
        <20190801204523.26454-2-mpelland@starry.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 Aug 2019 11:20:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matt Pelland <mpelland@starry.com>
Date: Thu,  1 Aug 2019 16:45:22 -0400

> +static void mvpp22_gop_init_rxaui(struct mvpp2_port *port)
> +{
> +	struct mvpp2 *priv = port->priv;
> +	void __iomem *xpcs = priv->iface_base + MVPP22_XPCS_BASE(port->gop_id);
> +	u32 val;

Reverse christmas tree please.

