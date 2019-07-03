Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57B1C5ED2F
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 22:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfGCUHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 16:07:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52146 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbfGCUHw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 16:07:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=z7jk6x5FmWmv60BLPQd58n5oT9q9Kq0RFvPsjKqmiOk=; b=InPLH5l4f68ZtWZU/0SiSQfH30
        7UMlutMNJunhbk7FjlM1CLUrTyea6VUQG92J0+C4oHJt99iMjFRvrYDB9SQB50yhc9VCVEICv0Hon
        6Wb+cW+2lTPpbXkXBxAb05Vu243aqvOL7nQq2dEuuxjLO96XPFB0TvxfbGi2+cgZ4Pvc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hilXb-0007TL-JZ; Wed, 03 Jul 2019 22:07:43 +0200
Date:   Wed, 3 Jul 2019 22:07:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2 6/7] dt-bindings: net: realtek: Add property to
 configure LED mode
Message-ID: <20190703200743.GF18473@lunn.ch>
References: <20190703193724.246854-1-mka@chromium.org>
 <20190703193724.246854-6-mka@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703193724.246854-6-mka@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 12:37:23PM -0700, Matthias Kaehlcke wrote:

Hi Matthias

Maybe add a #define for 0, so we know what it does.

> +#define RTL8211E_LINK_10		1
> +#define RTL8211E_LINK_100		2
> +#define RTL8211E_LINK_1000		4
