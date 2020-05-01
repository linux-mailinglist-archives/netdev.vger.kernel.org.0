Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386E91C1999
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 17:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729195AbgEAPde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 11:33:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36476 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728865AbgEAPde (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 11:33:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=A9TtI7VDQObXMoinioifEuMMByRyNVr20UDZ67M6hYc=; b=yZUzlud6epMH0rEU0IRXDZbHVO
        psLnZuQBQZRYMOUsS2KbfcdVWoGrWugIYjaFYEjLsjbpODuV9QdTvNEOkNIzb4lv2trCr3kMRXolH
        Ay2Ilm9Ul1qrT1hcurbLJ0B0jQLMiuBK/PUGdz/DTnP0Z4AZO9vgQ+ulxcNu7OGhGDls=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jUXfL-000YGS-MU; Fri, 01 May 2020 17:33:27 +0200
Date:   Fri, 1 May 2020 17:33:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     robh+dt@kernel.org, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC v2 05/11] net: stmmac: dwmac-meson8b: Add the
 PRG_ETH0_ADJ_* bits
Message-ID: <20200501153327.GE128733@lunn.ch>
References: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
 <20200429201644.1144546-6-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429201644.1144546-6-martin.blumenstingl@googlemail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 10:16:38PM +0200, Martin Blumenstingl wrote:
> The PRG_ETH0_ADJ_* are used for applying the RGMII RX delay. The public
> datasheets only have very limited description for these registers, but
> Jianxin Pan provided more detailed documentation from an (unnamed)
> Amlogic engineer. Add the PRG_ETH0_ADJ_* bits along with the improved
> description.
> 
> Suggested-by: Jianxin Pan <jianxin.pan@amlogic.com>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
