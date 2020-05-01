Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E441C19A4
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 17:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbgEAPfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 11:35:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36496 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729269AbgEAPfl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 11:35:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UU/fQcc5IkUFR5zmnSvwjof6KoRn9CYog61HdJuoYss=; b=WizIfuGt1yWHrpGGRBhCnQq4Iv
        QnVagAczUBU2RqynEYkci5GBxY727Zn8xhgzc0IXL+VgbTy2fLz36JT63XvxUGO3ubF0Vu3Be/CaX
        sw34vdPl56aD6hFakAJWUQd7NPXMGfLdHJz611RhO41DWsnrjZch6I4nRXj/jXJs/brI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jUXhO-000YIB-Mf; Fri, 01 May 2020 17:35:34 +0200
Date:   Fri, 1 May 2020 17:35:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     robh+dt@kernel.org, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC v2 06/11] net: stmmac: dwmac-meson8b: Fetch the
 "timing-adjustment" clock
Message-ID: <20200501153534.GF128733@lunn.ch>
References: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
 <20200429201644.1144546-7-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429201644.1144546-7-martin.blumenstingl@googlemail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 10:16:39PM +0200, Martin Blumenstingl wrote:
> The PRG_ETHERNET registers have a built-in timing adjustment circuit
> which can provide the RX delay in RGMII mode. This is driven by an
> external (to this IP, but internal to the SoC) clock input. Fetch this
> clock as optional (even though it's there on all supported SoCs) since
> we just learned about it and existing .dtbs don't specify it.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
