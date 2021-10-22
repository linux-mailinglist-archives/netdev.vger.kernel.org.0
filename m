Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38419437ED2
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 21:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233955AbhJVTuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 15:50:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53546 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233848AbhJVTuZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 15:50:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Tytk5FMvC1g6mogGFBCJGyppm64lxflaNaQqb/7b8i0=; b=VSeuzSs+uKkSmfWnWtex5E5FdP
        2YgYlzCN8nGdxv4xgPtLa4JLsEBoRsp9cQHfV8+Gu4WfYSf6cGOdgdBgPUuk2UsbEN+jduEbbzD5z
        WM0W0QcilmWnIbzyq5pkbAqPAn5Su76BdVfSwUY9lEVPfC4eWPzRlC6VjLlLFR5jCAxk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1me0WM-00BQOR-5G; Fri, 22 Oct 2021 21:48:06 +0200
Date:   Fri, 22 Oct 2021 21:48:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yuiko Oshino <yuiko.oshino@microchip.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        nisar.sayed@microchip.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next] net: phy: microchip_t1: add cable test support
 for lan87xx phy
Message-ID: <YXMVdkXIenVuD3gV@lunn.ch>
References: <20211022183632.8415-1-yuiko.oshino@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022183632.8415-1-yuiko.oshino@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* MISC Control 1 Register */
> +#define LAN87XX_CTRL_1                          (0x11)
> +#define LAN87XX_MASK_RGMII_TXC_DLY_EN           (0x4000)
> +#define LAN87XX_MASK_RGMII_RXC_DLY_EN           (0x2000)

Interesting to know, but not used in this patch.

Please can you write a patch to actually make use of these bits, and
do the right thing when phydev->interface is one of the four
PHY_INTERFACE_MODE_RGMII values.

	 Andrew
