Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD7E9D76E5
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 14:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfJOMyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 08:54:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45578 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726004AbfJOMyG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 08:54:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mSm5WrnMjVEX7H9gawcWAyy7zSXN5kf0ISdm/U6OHfU=; b=MGSIhRKC4Jdh5LmqSfqDt1n1JI
        yaWDaYDy1m0gmiCd1H1KCGaPTLqhKh5fcJ4fHvU4uCdAMsYXm9LfGt7R8nQw9LYRoA4hK3d+B8XKF
        Mwt4lNYURQcVWzUBYr1t6alAM2GE2DAVS8Qe7bI9xBhpUdo43vjYKKlqbcyMnCzmsAlY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iKMKw-00014w-He; Tue, 15 Oct 2019 14:54:02 +0200
Date:   Tue, 15 Oct 2019 14:54:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2 2/3] net: phy: fixed_phy: fix use-after-free when
 checking link GPIO
Message-ID: <20191015125402.GB3486@lunn.ch>
References: <20191014174022.94605-1-dmitry.torokhov@gmail.com>
 <20191014174022.94605-3-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014174022.94605-3-dmitry.torokhov@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 14, 2019 at 10:40:21AM -0700, Dmitry Torokhov wrote:
> If we fail to locate GPIO for any reason other than deferral or
> not-found-GPIO, we try to print device tree node info, however if might
> be freed already as we called of_node_put() on it.
> 
> Acked-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
