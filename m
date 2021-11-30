Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C170C463F1E
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 21:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240127AbhK3UVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 15:21:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60132 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235480AbhK3UVX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 15:21:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ZBWT1PySTivEVx80gU1KZHlW/Od7AtZt9Y0vGbN4x0k=; b=upx8L+mvY8Iqye6iaJnMXpf1dZ
        aKRVmvG/Z/l1FPPCiuZEqu1GkZTDRuuewYWe7xNx8MHF+k9kDvdmbFIOpR5uhGvLxLAkl+5D3UZn8
        3PVsADr3HNV9UPZFuCH8sr3J1gHJYve66q3RIqRmC19y53YBNW2fEtM4qsUXh6xfGzdI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ms9Zd-00F8eN-5m; Tue, 30 Nov 2021 21:17:57 +0100
Date:   Tue, 30 Nov 2021 21:17:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wells Lu <wellslutw@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de,
        wells.lu@sunplus.com, vincent.shih@sunplus.com
Subject: Re: [PATCH net-next v3 0/2] This is a patch series for pinctrl
 driver for Sunplus SP7021 SoC.
Message-ID: <YaaG9V2c/DL11GJC@lunn.ch>
References: <1638266572-5831-1-git-send-email-wellslutw@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1638266572-5831-1-git-send-email-wellslutw@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 06:02:50PM +0800, Wells Lu wrote:
> Sunplus SP7021 is an ARM Cortex A7 (4 cores) based SoC. It integrates
> many peripherals (ex: UART, I2C, SPI, SDIO, eMMC, USB, SD card and
> etc.) into a single chip. It is designed for industrial control
> applications.

The subject line is wrong again. This has nothing to do with a pin
controller.

	Andrew
