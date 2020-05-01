Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C301C1984
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 17:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgEAP3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 11:29:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36426 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728812AbgEAP3D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 11:29:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=g87l+dQPat6RISHmb/M+c0r+YR6nZMVGy4jXDg/BT5Y=; b=P6PpYSUIF0qaq/BE82nIHPuExZ
        oz4MO4IxBlfZiIOqksQmOxpu61b4C1+2I9DCYthnN+6zEx14OUppsEropI5s74zCRnfYEqUsP5XbV
        oZuRUQWXYdXom6Ft2YPceKMwcxm4Rf5SFFjmPuumyDsRCaBf5YHANqEk24vp4hUy/Aak=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jUXay-000YD8-Cv; Fri, 01 May 2020 17:28:56 +0200
Date:   Fri, 1 May 2020 17:28:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     robh+dt@kernel.org, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC v2 03/11] net: stmmac: dwmac-meson8b: use FIELD_PREP
 instead of open-coding it
Message-ID: <20200501152856.GC128733@lunn.ch>
References: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
 <20200429201644.1144546-4-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429201644.1144546-4-martin.blumenstingl@googlemail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 10:16:36PM +0200, Martin Blumenstingl wrote:
> Use FIELD_PREP() to shift a value to the correct offset based on a
> bitmask instead of open-coding the logic.
> No functional changes.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
