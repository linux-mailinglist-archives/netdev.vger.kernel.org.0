Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94780F33E5
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 16:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729955AbfKGP4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 10:56:05 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54546 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbfKGP4F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 10:56:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Z9n0Z9XDmBEkEbdW4TBEHkqC9phlox06d85Xa+B+O7A=; b=udOSizcBSBi1zPX2oYk1I/Ouy7
        biO2Ycn0hruG9pIFv5rw/cDvz1bjIE1jlkSGyyxNvJa0GHjaBSRnTa44D9tBlLvKPfLCQ1rg/WfwY
        FZOR+pQIDjAVSOsgauqUvTczQRPtl6F2rG0PBodzxHQF1Gw3dCESeh2VyobfTUxjwt0c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iSk8h-0006sD-1H; Thu, 07 Nov 2019 16:56:03 +0100
Date:   Thu, 7 Nov 2019 16:56:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     netdev@vger.kernel.org, Tristram.Ha@microchip.com,
        UNGLinuxDriver@microchip.com, kernel@pengutronix.de
Subject: Re: [PATCH v1 3/4] ksz: Add Microchip KSZ8863 SMI-DSA driver
Message-ID: <20191107155603.GH7344@lunn.ch>
References: <20191107110030.25199-1-m.grzeschik@pengutronix.de>
 <20191107110030.25199-4-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107110030.25199-4-m.grzeschik@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static const u8 stp_multicast_addr[] = {
> +	0x01, 0x80, 0xC2, 0x00, 0x00, 0x00
> +};

This probably exists already. Please go looking in include/linux and
include/net.

> +static int ksz8863_mdio_read(void *ctx, const void *reg_buf, size_t reg_len,
> +			     void *val_buf, size_t val_len)
> +{
> +	struct ksz_device *dev = (struct ksz_device *)ctx;

ctx is a void *, so you don't need the cast.

> +	struct mdio_device *mdev = (struct mdio_device *)dev->priv;

and priv is also probably a void *.

And please fix the reverse christmas tree.

Thanks
	Andrew
