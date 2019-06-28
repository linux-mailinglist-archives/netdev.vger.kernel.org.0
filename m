Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9617958F0C
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 02:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfF1AiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 20:38:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39008 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbfF1AiX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 20:38:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gVkSxAiMlXSfh9RL33TH3pj01z8yvZ/fbj8jxkc41wI=; b=lT/yFmZknIIoN57MqD+ikWWD5T
        FTt1CZb9in+/54QDcUbLcZAxLPfENU+wjthystamFWFKGXl70QiHfbc8DvjX1ZHYKxaOeyceoTri9
        +NGYCTdXebEf8tGTcYktLXsbssbICn+Q3O+2y8dyqJrU46PJE/FY+fTpLW7A87dtXBMw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hgeuD-0004mQ-Bj; Fri, 28 Jun 2019 02:38:21 +0200
Date:   Fri, 28 Jun 2019 02:38:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
Subject: Re: [PATCH 1/5] net: dsa: microchip: Replace ad-hoc polling with
 regmap
Message-ID: <20190628003821.GA17615@lunn.ch>
References: <20190627215556.23768-1-marex@denx.de>
 <20190627215556.23768-2-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627215556.23768-2-marex@denx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 11:55:52PM +0200, Marek Vasut wrote:
> Regmap provides polling function to poll for bits in a register,
> use in instead of reimplementing it.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
