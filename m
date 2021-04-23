Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85DA368AD5
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240210AbhDWB6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 21:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240153AbhDWB6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 21:58:13 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5847BC061574;
        Thu, 22 Apr 2021 18:57:37 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id j12so30696227edy.3;
        Thu, 22 Apr 2021 18:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Pw1mhVccXQSelU4p5Lj7XgUTfoAZ43zN4KCnRYn/EYk=;
        b=XHKSYh37QP1rBGQmKQYjAmPEtfFS2yyGsqAEHe7iyaLnCv3ZCXjAQLdLa+lyrJ7KTK
         Dd4rqHJGSjhKZHC9dPMjfzFhmPbZzF1cdnb7DnHVL4lILOdJECby0opUeA+B5+foQWeN
         O5gkQLtCwJxfScHwDxxo9ijJUZ6REqrNHg+aca9tf7+qjwDhQ0OSu4NYixdZjXZF/3l5
         uq9B/r8X34hsZSTXx16htBtxDwX6ZcHX9iAOEqjkiXohTTYrSaiwa8EFZHhiZ0GZ+bbY
         iX+N20f+9IB6qurJultywYFN7wGI+aQg7jv4Uh0zrZ4jxyst712REutqNKTgVtxvJSZf
         1N8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Pw1mhVccXQSelU4p5Lj7XgUTfoAZ43zN4KCnRYn/EYk=;
        b=nH8YSiM5cFuEIMimumY+KVFmGPq7bdJQ86iABlXdK3PUyW2zYaGYBPgpwviFRRcbMA
         +I5J+DiPPa3nmFQerPxW7EhNjTsE6p5GDE8TRv1y1PrBudbd3tAYJ6ujd9Hm1Um4uogQ
         NVWUsexNM+NYw/QOM67lc2ktuRksiCXvaicPlOCgbzQo1wwkXPSztTcE3pjwQEaejc74
         0P8pK8M31iDwGnXkkms9z+wHWNJlwLXtq82tDXg268mMgpgyD84hLIoS8lacjYjHJSdu
         U4RtX+89G68/g62pVvcP013BHLomFxWIREjB5T/hgtf7CjoVAx/TGA0tBWGENV9VW+QH
         r9fA==
X-Gm-Message-State: AOAM531+hRYhj+PxQAJcAVQTqKvu0mRALTSVGiGfuhDX1LVu6CReYA3k
        lCbBrRP0oUM0MaOL2GAM2Mc=
X-Google-Smtp-Source: ABdhPJw/Reuwwz4qr7zbUtf1dXpgTFdEhbhL3iKdM++pXiBz+zYqcXmt+6wmGT2xRy0ZuCSe/cfBGw==
X-Received: by 2002:a50:e848:: with SMTP id k8mr1555196edn.179.1619143056014;
        Thu, 22 Apr 2021 18:57:36 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.gmail.com with ESMTPSA id u24sm3411764edt.85.2021.04.22.18.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 18:57:35 -0700 (PDT)
Date:   Fri, 23 Apr 2021 03:57:32 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/14] drivers: net: dsa: qca8k: tweak internal delay to
 oem spec
Message-ID: <YIIpjBH8hZH/MaS7@Ansuel-xps.localdomain>
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
 <20210423014741.11858-3-ansuelsmth@gmail.com>
 <fdddeb1a-33c7-3087-86a1-f3b735a90eb1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdddeb1a-33c7-3087-86a1-f3b735a90eb1@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 06:53:45PM -0700, Florian Fainelli wrote:
> 
> 
> On 4/22/2021 6:47 PM, Ansuel Smith wrote:
> > The original code had the internal dalay set to 1 for tx and 2 for rx.
> > Apply the oem internal dalay to fix some switch communication error.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  drivers/net/dsa/qca8k.c | 6 ++++--
> >  drivers/net/dsa/qca8k.h | 9 ++++-----
> >  2 files changed, 8 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index a6d35b825c0e..b8bfc7acf6f4 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -849,8 +849,10 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
> >  		 */
> >  		qca8k_write(priv, reg,
> >  			    QCA8K_PORT_PAD_RGMII_EN |
> > -			    QCA8K_PORT_PAD_RGMII_TX_DELAY(QCA8K_MAX_DELAY) |
> > -			    QCA8K_PORT_PAD_RGMII_RX_DELAY(QCA8K_MAX_DELAY));
> > +			    QCA8K_PORT_PAD_RGMII_TX_DELAY(1) |
> > +			    QCA8K_PORT_PAD_RGMII_RX_DELAY(2) |
> > +			    QCA8K_PORT_PAD_RGMII_TX_DELAY_EN |
> > +			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
> 
> There are standard properties in order to configure a specific RX and TX
> delay:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/devicetree/bindings/net/ethernet-controller.yaml#n125
> 
> can you use that mechanism and parse that property, or if nothing else,
> allow an user to override delays via device tree using these standard
> properties?

Since this is mac config, what would be the best way to parse these
data? Parse them in the qca8k_setup and put them in the
qca8k_priv?

> -- 
> Florian
