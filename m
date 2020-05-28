Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E002B1E6F03
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437150AbgE1W3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:29:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55610 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437149AbgE1W3F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 18:29:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tzEfiDzj6ZhBacWZEbsUmJY5xz8YuXTA2nUo0DJrSO4=; b=PUj7vkB5N3TWl+DvCZabFeS/2i
        Rc5wYKmsDzYy9dgM7kMZyhS5rLUGWITkIaY7QvbEZ/T4Yhk3xPFILh0Fyp+v+zbCC2EI6cod2CzFY
        lwzZdD97sRV0a8txVSRlcqNaiXmu8TK2HckAPOHpEsNkBLFi/GgFMxUMuXQU48GqFGGM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jeR1L-003aVN-LR; Fri, 29 May 2020 00:29:03 +0200
Date:   Fri, 29 May 2020 00:29:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V7 09/19] net: ks8851: Use 16-bit read of RXFC register
Message-ID: <20200528222903.GE853774@lunn.ch>
References: <20200528222146.348805-1-marex@denx.de>
 <20200528222146.348805-10-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528222146.348805-10-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 12:21:36AM +0200, Marek Vasut wrote:
> The RXFC register is the only one being read using 8-bit accessors.
> To make it easier to support the 16-bit accesses used by the parallel
> bus variant of KS8851, use 16-bit accessor to read RXFC register as
> well as neighboring RXFCTR register.
> 
> Remove ks8851_rdreg8() as it is not used anywhere anymore.
> 
> There should be no functional change.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
