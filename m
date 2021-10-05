Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52888422738
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 14:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234946AbhJEM6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 08:58:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49752 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233977AbhJEM6I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 08:58:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dpuqj2Jeeee/gupFFc81hYqxPAQItHzGH75X2bBgRSQ=; b=xVS9UVzfcdoHAaaQmFjsL6A1M+
        deiCx3x/cWg7jwnpc0kPMrPKMUdaWDdRPDodgw2MMv8LO68Km6HKHs2K/G8zLTMNGMVg7284DOe1i
        NfVbxozCaRw3H4lA99FP0rZn3/TqkNYKuGqXFf40+WSEk2gzwGfrqfoMwI4wkMxb9zwI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mXjzS-009h1l-30; Tue, 05 Oct 2021 14:56:14 +0200
Date:   Tue, 5 Oct 2021 14:56:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcel Ziswiler <marcel@ziswiler.com>
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Gregory Clement <gregory.clement@bootlin.com>,
        Russell King <linux@armlinux.org.uk>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v1 3/4] ARM: mvebu_v7_defconfig: rebuild default
 configuration
Message-ID: <YVxLbhCml+ba1AIx@lunn.ch>
References: <20211005060334.203818-1-marcel@ziswiler.com>
 <20211005060334.203818-4-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005060334.203818-4-marcel@ziswiler.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 08:03:33AM +0200, Marcel Ziswiler wrote:
> Run "make mvebu_v7_defconfig; make savedefconfig" to rebuild
> mvebu_v7_defconfig
> 
> This re-ordered the following configuration options:
> 
> CONFIG_MODULES=y
> CONFIG_MODULE_UNLOAD=y
> CONFIG_PCI=y
> CONFIG_PCI_MVEBU=y
> CONFIG_CRYPTO_DEV_MARVELL_CESA=y
> 
> And dropped the following nowadays obsolete configuration options:
> 
> CONFIG_ZBOOT_ROM_TEXT=0x0 (default now anyway since commit 39c3e304567a
>  ("ARM: 8984/1: Kconfig: set default ZBOOT_ROM_TEXT/BSS value to 0x0"))
> CONFIG_ZBOOT_ROM_BSS=0x0 (ditto)
> CONFIG_MTD_M25P80=y (got integrated into MTD_SPI_NOR)
> 
> Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
