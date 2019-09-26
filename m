Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85390BF28E
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 14:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfIZMJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 08:09:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38892 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbfIZMJ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 08:09:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FR/mHngE5HbT/uqxBpiJEJEzHfI2HKsFHQ7kEhbaacM=; b=kFx6jlD/Le6t10WNuUy2btsrhO
        QSt14kXkqJJxuw54aksMcTrXiv3EZpC1gRnB1/T8WWVnpw5Ud8FTh+ZPtfF70xZleMDh5GMqE9d7G
        ZVbi2lEbMUKc7J0hR7N390WRn2tgKiwLe8JTV58okEU9X+48gzZ/rV3YExFCLl9xoZto=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iDSaI-0001oU-SL; Thu, 26 Sep 2019 14:09:22 +0200
Date:   Thu, 26 Sep 2019 14:09:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hans Andersson <haan@cellavision.se>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        antoine.tenart@bootlin.com,
        Hans Andersson <hans.andersson@cellavision.se>
Subject: Re: [PATCH] net: phy: micrel: add Asym Pause workaround for KSZ9021
Message-ID: <20190926120922.GD1864@lunn.ch>
References: <20190926075437.18088-1-haan@cellavision.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926075437.18088-1-haan@cellavision.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 09:54:37AM +0200, Hans Andersson wrote:
> From: Hans Andersson <hans.andersson@cellavision.se>
> 
> The Micrel KSZ9031 PHY may fail to establish a link when the Asymmetric
> Pause capability is set. This issue is described in a Silicon Errata
> (DS80000691D or DS80000692D), which advises to always disable the
> capability.
> 
> Micrel KSZ9021 has no errata, but has the same issue with Asymmetric Pause.
> This patch apply the same workaround as the one for KSZ9031.
> 
> Signed-off-by: Hans Andersson <hans.andersson@cellavision.se>

Fixes: 3aed3e2a143c ("net: phy: micrel: add Asym Pause workaround")

This is not the best fixes: tag, since it was not that change which
broke it. But going further back will be hard.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
