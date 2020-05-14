Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997861D2456
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 02:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgENAzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 20:55:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59276 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbgENAzb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 20:55:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=d+prNKplLXd2K9h6jzjwwwsYEMWulaw2jkRS28BAZlg=; b=N9neC9QrZURYUQnJBGGMdzVmMU
        wq3wW4mXPiTBYbdmLaZi1X0jizCYfXL+gzqcddxmvdv4dfGfoDkvcQD2hPaUmyOKmmNISb1eNTWDF
        K4VsGmu4NGxBsyvc/nEJP+uhm+TuaEcm93jKglfb/eG4CgcQfWk4sxIJvn4QahtBGVJ4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jZ29p-002EH6-BH; Thu, 14 May 2020 02:55:29 +0200
Date:   Thu, 14 May 2020 02:55:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V5 08/19] net: ks8851: Use 16-bit writes to program MAC
 address
Message-ID: <20200514005529.GE527401@lunn.ch>
References: <20200514000747.159320-1-marex@denx.de>
 <20200514000747.159320-9-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514000747.159320-9-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 02:07:36AM +0200, Marek Vasut wrote:
> On the SPI variant of KS8851, the MAC address can be programmed with
> either 8/16/32-bit writes. To make it easier to support the 16-bit
> parallel option of KS8851 too, switch both the MAC address programming
> and readout to 16-bit operations.
> 
> Remove ks8851_wrreg8() as it is not used anywhere anymore.
> 
> There should be no functional change.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Petr Stetiar <ynezz@true.cz>
> Cc: YueHaibing <yuehaibing@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
