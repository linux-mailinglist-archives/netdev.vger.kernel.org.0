Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E75471BDF
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 18:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbhLLRWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 12:22:16 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51484 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229787AbhLLRWP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Dec 2021 12:22:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PvBu6pM6ivfWqicogYSc+w//A4DBGGri5+6KhU4I7Zk=; b=ExPv4Eh3niwRPdMsTwJAepKWq6
        QXMjZ4X5HW1obUb0pLGZKp53gzkIeshpxDPvwBARLP1UWOp2fAMvyjNha/qErY4jawow/kt44r0AF
        z9awVwBhvXCML96lqukY5NwrX/PSkClrv3rhahRB3bn6bqgbLpr/BhmZowXuHz5b/EVE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mwSY6-00GKkN-J0; Sun, 12 Dec 2021 18:22:10 +0100
Date:   Sun, 12 Dec 2021 18:22:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joseph CHANG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4, 2/2] net: Add dm9051 driver
Message-ID: <YbYvwqhu41UNIqsD@lunn.ch>
References: <20211212104604.20334-1-josright123@gmail.com>
 <20211212104604.20334-3-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211212104604.20334-3-josright123@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 12, 2021 at 06:46:04PM +0800, Joseph CHANG wrote:
> Add davicom dm9051 spi ethernet driver. The driver work for the
> device platform with spi master
> 
> Signed-off-by: Joseph CHANG <josright123@gmail.com>
> ---
>  drivers/net/ethernet/davicom/Kconfig  |  30 +
>  drivers/net/ethernet/davicom/Makefile |   1 +
>  drivers/net/ethernet/davicom/dm9051.c | 865 ++++++++++++++++++++++++++
>  drivers/net/ethernet/davicom/dm9051.h | 225 +++++++
>  4 files changed, 1121 insertions(+)
>  create mode 100644 drivers/net/ethernet/davicom/dm9051.c
>  create mode 100644 drivers/net/ethernet/davicom/dm9051.h
> 
> diff --git a/drivers/net/ethernet/davicom/Kconfig b/drivers/net/ethernet/davicom/Kconfig
> index 7af86b6d4150..9c00328f6e05 100644
> --- a/drivers/net/ethernet/davicom/Kconfig
> +++ b/drivers/net/ethernet/davicom/Kconfig
> @@ -3,6 +3,20 @@
>  # Davicom device configuration
>  #
>  
> +config NET_VENDOR_DAVICOM
> +	bool "Davicom devices"
> +	depends on ARM || MIPS || COLDFIRE || NIOS2 || COMPILE_TEST || SPI

Why don't DAVICOM produces work on x86? Or RISCV?

    Andrew
