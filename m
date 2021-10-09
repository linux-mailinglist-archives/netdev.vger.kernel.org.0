Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E16427B51
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 17:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234463AbhJIPcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 11:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbhJIPcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 11:32:16 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D874C061570;
        Sat,  9 Oct 2021 08:30:19 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id g8so48105244edt.7;
        Sat, 09 Oct 2021 08:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1wLW8XYk7frOEDppst5zZlYPaWtciSg2QJyoOo6By1s=;
        b=NYx6to8rSPt8e8ErwjkWLGcDQg7nUigkDSnGWDm3rwd+hdnL0wjmPMIBzGjq4GPf8J
         HmvtYuwRZDWuvPy/awosU+pKsLUf7rYdoJ/1cv53rS3BjW7eUTEkOVCmtblP7f4GedJi
         4KczPH+iXThwv7AXdCzon1b3EoWt2qh6nBAHmIZDjXou1eWtqdsWvo/Y+cwP4EIq7I4e
         MRSL1XRaQc4ierdZcWgPy72TaacAnvjc1C/5bTCVjouKWEwHzaMesXvYPhEy55cQn9VB
         MfZpyJrXHviAxrp/2NL9q+vvfa3DyZTjT+YuWMQ1wrvNyM6qmfo9mmpDHcY72HyWSK85
         v26g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1wLW8XYk7frOEDppst5zZlYPaWtciSg2QJyoOo6By1s=;
        b=taTPFXCvIXT8ka6Q3HUQFJO5T2wI9DjJTFUGl60VtRfDFETMZ/ECQk9KCDBBW9zYiq
         b6YdyR/3Jo/eBOwN1QuoGvGEQpVUZCe4E0D8lgeRY8GVxmN57k33w8ZsUtLHtrtha10V
         JegE3OSA7v6OM3uL6685AwVVCSUXV95/K0hbju4YnyO+9KevsgW/tBbCcJv8+S2ceiq4
         hWQkiYnpd3edYSH0lmF6a8yLdBVtRT9eeVkv+p3MD3qBZfJbo6i/QhZ4yrGq0k/LAyoM
         1VFg90gqkgCnuWZVnqQHyBFH6qabB/2NtQylQ0x078eA1O9tNhTVCDwa4uitxWI+ZHv7
         ta+Q==
X-Gm-Message-State: AOAM531gumE/SeBHIMLbcSeF1MFTrwyoBwN09q5la7JBj0UOdqgJdWn8
        A++ojJfn2AmQz4RgRlQ7MWA=
X-Google-Smtp-Source: ABdhPJz00ChJLgAHDy1GjZQ0/aLmym1agZ5Gst19kOcSkrs2H0IoTvmo3ew+HMfHtr3x1j7ixlwlkA==
X-Received: by 2002:a17:906:fc11:: with SMTP id ov17mr12380200ejb.249.1633793417436;
        Sat, 09 Oct 2021 08:30:17 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id g8sm1406770edb.60.2021.10.09.08.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 08:30:17 -0700 (PDT)
Date:   Sat, 9 Oct 2021 17:30:14 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 06/15] dt-bindings: net: dsa: qca8k: document
 rgmii_1_8v bindings
Message-ID: <YWG1hj5zn/Pvqx0y@Ansuel-xps.localdomain>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
 <20211008002225.2426-7-ansuelsmth@gmail.com>
 <YWGy33inSic1PcC5@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWGy33inSic1PcC5@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 09, 2021 at 05:18:55PM +0200, Andrew Lunn wrote:
> On Fri, Oct 08, 2021 at 02:22:16AM +0200, Ansuel Smith wrote:
> > Document new qca,rgmii0_1_8v and qca,rgmii56_1_8v needed to setup
> > mac_pwr_sel register for qca8337 switch. Specific the use of this binding
> > that is used only in qca8337 and not in qca8327.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > index 8c73f67c43ca..9383d6bf2426 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > @@ -13,6 +13,14 @@ Required properties:
> >  Optional properties:
> >  
> >  - reset-gpios: GPIO to be used to reset the whole device
> > +- qca,rgmii0-1-8v: Set the internal regulator to supply 1.8v for MAC0 port.
> > +                   This is needed for qca8337 and toggles the supply voltage
> > +                   from 1.5v to 1.8v. For the specific regs it was observed
> > +                   that this is needed only for ipq8064 and ipq8065 target.
> > +- qca,rgmii56-1-8v: Set the internal regulator to supply 1.8v for MAC5/6 port.
> > +                    This is needed for qca8337 and toggles the supply voltage
> > +                    from 1.5v to 1.8v. For the specific regs it was observed
> > +                    that this is needed only for ipq8065 target.
> 
> Are ipq8065 & ipq8064 SoCs which the switch is embedded into? So you
> could look for the top level compatible and set these regulators based
> on that. No DT property needed.
> 
>    Andrew

The switch is still external for these 2 SoC. If we really want, yes we
can follow that route and sets only for the 2 SoC. (Considering ipq8065
is still not present, can I add it anyway in the qca8k code? Will for
sure propose the ipq8065 dtsi today)

-- 
	Ansuel
