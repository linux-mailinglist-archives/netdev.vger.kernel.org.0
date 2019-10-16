Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 276F5D84E3
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 02:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388229AbfJPAhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 20:37:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42368 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727579AbfJPAhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 20:37:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9186E12471F93;
        Tue, 15 Oct 2019 17:37:35 -0700 (PDT)
Date:   Tue, 15 Oct 2019 17:37:35 -0700 (PDT)
Message-Id: <20191015.173735.680126764547812788.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        george.mccollister@gmail.com, Tristram.Ha@microchip.com,
        woojung.huh@microchip.com
Subject: Re: [PATCH V2 2/2] net: dsa: microchip: Add shared regmap mutex
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191013193238.1638-2-marex@denx.de>
References: <20191013193238.1638-1-marex@denx.de>
        <20191013193238.1638-2-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 17:37:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Sun, 13 Oct 2019 21:32:38 +0200

> diff --git a/drivers/net/dsa/microchip/ksz8795_spi.c b/drivers/net/dsa/microchip/ksz8795_spi.c
> index d0f8153e86b7..614404c40cba 100644
> --- a/drivers/net/dsa/microchip/ksz8795_spi.c
> +++ b/drivers/net/dsa/microchip/ksz8795_spi.c
> @@ -26,6 +26,7 @@ KSZ_REGMAP_TABLE(ksz8795, 16, SPI_ADDR_SHIFT,
>  static int ksz8795_spi_probe(struct spi_device *spi)
>  {
>  	struct ksz_device *dev;
> +	struct regmap_config rc;
>  	int i, ret;

Please retain the reverse christmas tree ordering of local variables
here.

> @@ -18,6 +18,7 @@ static int ksz9477_i2c_probe(struct i2c_client *i2c,
>  			     const struct i2c_device_id *i2c_id)
>  {
>  	struct ksz_device *dev;
> +	struct regmap_config rc;
>  	int i, ret;

Likewise.

> @@ -25,6 +25,7 @@ KSZ_REGMAP_TABLE(ksz9477, 32, SPI_ADDR_SHIFT,
>  static int ksz9477_spi_probe(struct spi_device *spi)
>  {
>  	struct ksz_device *dev;
> +	struct regmap_config rc;
>  	int i, ret;

Likewise.
