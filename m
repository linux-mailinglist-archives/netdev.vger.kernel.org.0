Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB5191A7B
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 02:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfHSAiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 20:38:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40316 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbfHSAiG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Aug 2019 20:38:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BrMXY7EIAyVUBAzvqXeIobS9TRD0sVX9w0IwUrcpffM=; b=PE3/GP8p/ed33a+Wk6aGB3xX+E
        c+IsGouiSzIwdwhHyMf3Beb+NbiyrdVlH4YtE6zTbwMdBj6lf29TplWtFf39rMMfYOevXfCBxJNnz
        3iiFlEWu+C0ar56VsqIe0nprfyahzC1IE6Yb+KppQu3O0g33HGQjlt2ssdW7v775+9+Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hzVgL-0002VI-CB; Mon, 19 Aug 2019 02:37:57 +0200
Date:   Mon, 19 Aug 2019 02:37:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Matthias Kaehlcke <mka@chromium.org>, jacek.anaszewski@gmail.com,
        linux-leds@vger.kernel.org, dmurphy@ti.com,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v6 4/4] net: phy: realtek: Add LED configuration support
 for RTL8211E
Message-ID: <20190819003757.GB8981@lunn.ch>
References: <20190813191147.19936-1-mka@chromium.org>
 <20190813191147.19936-5-mka@chromium.org>
 <20190816201342.GB1646@bug>
 <20190816212728.GW250418@google.com>
 <20190817140502.GA5878@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190817140502.GA5878@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yes, I believe the integration is neccessary. Using same binding is
> neccessary for that, but not sufficient. For example, we need
> compatible trigger names, too.

Hi Pavel

Please could you explain what you mean by compatible trigger names?

> So... I'd really like to see proper integration is possible before we
> merge this.

Please let me turn that around. What do you see as being impossible at
the moment? What do we need to convince you about?

    Thanks
	Andrew
