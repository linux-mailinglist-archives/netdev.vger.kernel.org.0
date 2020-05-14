Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA101D2418
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 02:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730671AbgENAvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 20:51:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59206 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728313AbgENAvA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 20:51:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=n+9uV3hhysi/ZEcjmHPsx+Z82QSxRMqbZkZjL5nHYbI=; b=Zc9PUo57AFCOGyOOk1+/ymvVnJ
        AK5Y9iv/oc556hfgsyjMUSstYs2GJ+u+GigouMfb98AO/4J1o+OuTnXbaH6iBZwvVBZqjnVu+ekyQ
        UZjn52rvxCcGc3VhQPGtK0p+6zF4bLY4V39ZsrsEGeAQgwsNLzoBzpMSfldLd9nOqU8k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jZ25S-002EA2-LE; Thu, 14 May 2020 02:50:58 +0200
Date:   Thu, 14 May 2020 02:50:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V5 02/19] net: ks8851: Rename ndev to netdev in probe
Message-ID: <20200514005058.GB527401@lunn.ch>
References: <20200514000747.159320-1-marex@denx.de>
 <20200514000747.159320-3-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514000747.159320-3-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 02:07:30AM +0200, Marek Vasut wrote:
> Rename ndev variable to netdev for the sake of consistency.
> 
> No functional change.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Petr Stetiar <ynezz@true.cz>
> Cc: YueHaibing <yuehaibing@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
