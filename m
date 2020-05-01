Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4572A1C198F
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 17:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729733AbgEAP3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 11:29:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36448 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728812AbgEAP3z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 11:29:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0oFnvmjDPVBMOQrnKCtF1VSBYWpdcWGbY1ugeUjkCs0=; b=ZqncxFdWqbRuDkB4HOmtEjSR6D
        rRHaLpAOMIlNMmOYMWOBWBYlrQCFBgpdRwiZahZZkQ2XwCg6kizZiDRLGxISbUo/bRKYa2fLsL4+t
        7K5mZ/UMaLO+hEA08YH+8MnZGOK1cSfcLbm4/bRchTxDV1rHijO2JKDFc8PAiTEherfU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jUXbo-000YEH-9Z; Fri, 01 May 2020 17:29:48 +0200
Date:   Fri, 1 May 2020 17:29:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     robh+dt@kernel.org, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC v2 04/11] net: stmmac: dwmac-meson8b: Move the
 documentation for the TX delay
Message-ID: <20200501152948.GD128733@lunn.ch>
References: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
 <20200429201644.1144546-5-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429201644.1144546-5-martin.blumenstingl@googlemail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 10:16:37PM +0200, Martin Blumenstingl wrote:
> Move the documentation for the TX delay above the PRG_ETH0_TXDLY_MASK
> definition. Future commits will add more registers also with
> documentation above their register bit definitions. Move the existing
> comment so it will be consistent with the upcoming changes.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
