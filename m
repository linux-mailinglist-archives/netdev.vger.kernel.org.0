Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD260190339
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 02:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgCXBQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 21:16:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53174 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbgCXBQj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 21:16:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ernoI0tCnWDHgd+Rp/8w+IJa9tvWQT6j6b7xN2J9Pts=; b=QopavHY1Js7JDKT5Jrol0pHr7T
        v3WhLbd7nBHrsheOwXNjxl01LTCJA+vR7EZfIWll/veY6G/SEWGGoKlWOMuDmbb3aTd1auE+yvLW5
        3QkAiTM3r0yrqbnfqQy5S2sT3JJyTV7vr4R16g618qwKDbKEcb4Hh3Wf7E3w4CvQ6Hps=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jGYBI-0005Nx-KI; Tue, 24 Mar 2020 02:16:36 +0100
Date:   Tue, 24 Mar 2020 02:16:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH 02/14] net: ks8851: Replace dev_err() with netdev_err()
 in IRQ handler
Message-ID: <20200324011636.GJ3819@lunn.ch>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-3-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323234303.526748-3-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 12:42:51AM +0100, Marek Vasut wrote:
> Use netdev_err() instead of dev_err() to avoid accessing the spidev->dev
> in the interrupt handler. This is the only place which uses the spidev
> in this function, so replace it with netdev_err() to get rid of it. This
> is done in preparation for unifying the KS8851 SPI and parallel drivers.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Petr Stetiar <ynezz@true.cz>
> Cc: YueHaibing <yuehaibing@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
