Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A893A1C1980
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 17:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbgEAP1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 11:27:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36408 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728812AbgEAP1h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 11:27:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JzQbjs2YBlSTis4wrxqDm78Cgcs84Uh0alAUpsN/J0w=; b=6Z/FRrhe/1z41Dn7fUM+CbVrge
        WsFBp3pK4D8K6Vuk7S6P1A1AZif6EeqEXxARNNzEPJF5aQvjJ63wz22SwkMQROuJwXJf/H3+Zpc9W
        v3PraefvHSuDVtCbk/IAlS6e/TmdvBId9hX+itfHz1BfVFqQOx5R2hl2SEfpCugCTTyE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jUXZY-000YBo-M2; Fri, 01 May 2020 17:27:28 +0200
Date:   Fri, 1 May 2020 17:27:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     robh+dt@kernel.org, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC v2 02/11] dt-bindings: net: dwmac-meson: Document the
 "timing-adjustment" clock
Message-ID: <20200501152728.GB128733@lunn.ch>
References: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
 <20200429201644.1144546-3-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429201644.1144546-3-martin.blumenstingl@googlemail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 10:16:35PM +0200, Martin Blumenstingl wrote:
> The PRG_ETHERNET registers can add an RX delay in RGMII mode. This
> requires an internal re-timing circuit whose input clock is called
> "timing adjustment clock". Document this clock input so the clock can be
> enabled as needed.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
