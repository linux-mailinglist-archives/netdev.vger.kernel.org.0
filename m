Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684DB427E05
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 01:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhJIXSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 19:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbhJIXSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 19:18:11 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2D8C061570;
        Sat,  9 Oct 2021 16:16:13 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id i20so34765510edj.10;
        Sat, 09 Oct 2021 16:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hOSRe/Yki+d7ofiMIHxMQp0x1aWjsfq22qP+igPVVo4=;
        b=KRob+oPfn99rJQUaa23vS6tW9Wf6YlkrHW4Phl8Uy+UPqlxCKb+dgtDFy+4rHpwFxT
         0GzShpFMAw7vamGlW/jej+YfmFdH6UJnSpJDRckMm67h2KSJd9HMRS/F6ORu8Z6Ni5M3
         XadWYQtXdzbqPXjLKQ22evhkigjL6IVzM+ledy2j1hhUkWuq6+49HSE38GifQDMqJoTN
         l7acBijb5i9Fn9qYzRvdU6JvCC85Eq6266VxJeo1pUzF+eQrEOg5OA3rilZG+F7rvcx0
         UR5i+uMnU2faua+WTkCkaPsfq+JIXAD4ia3HCXEQiZrYUpsMGQa7gXeffirTVu42iXZe
         Oxsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hOSRe/Yki+d7ofiMIHxMQp0x1aWjsfq22qP+igPVVo4=;
        b=X54LRLb74HI9cfNEkH7lBJfssEgYOFzU8cYfLbuHP5YE/NCcuYQaDa8/525TK6CXjO
         qbDOsgh6sdFQYhmWTxHq/lcjpcpEIVxi5AFYiZAHTnkzOc/sdw3EuNRlgBZFN3dJDcTT
         LhpIh3i/IeupzJgjpPYN34g2Hv5mjmNwduY/wJGHNpT0lu9SqO3IjB83CySCCw+y/agt
         1SZTt6qa0O+L+WIIeywwm4yunHGHZYiZX5+O16RkKeaKC7v2TALtRrtdilPS4M4SylrM
         GHXlP6a/aQ+5Y8t3mnXeVYQlMhNDUIlc/wBvO9p7CAepUavGH027FmJL5D+/EbuXwvpM
         tnvg==
X-Gm-Message-State: AOAM533jxozZT1yDy41yOyMfOdBG/clLBSRk1o6uUuQZ2iEg3/4QZfXz
        agpaS/tdJ1UbSP2nbz4ozU8=
X-Google-Smtp-Source: ABdhPJwZFDc036TJFPF6Iku8nQFDac4JkNH43ch+62ffBTNkLHjy9R5SfdL/VuB3Z7L+Sy3GRez3kQ==
X-Received: by 2002:a17:906:3192:: with SMTP id 18mr14830278ejy.246.1633821371899;
        Sat, 09 Oct 2021 16:16:11 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id d18sm1469022ejo.80.2021.10.09.16.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 16:16:11 -0700 (PDT)
Date:   Sun, 10 Oct 2021 01:16:09 +0200
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
Subject: Re: [net-next PATCH v2 13/15] dt-bindings: net: dsa: qca8k: document
 open drain binding
Message-ID: <YWIiuVSeAsvZEEUx@Ansuel-xps.localdomain>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
 <20211008002225.2426-14-ansuelsmth@gmail.com>
 <YWHPccukYpemv77x@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWHPccukYpemv77x@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 09, 2021 at 07:20:49PM +0200, Andrew Lunn wrote:
> On Fri, Oct 08, 2021 at 02:22:23AM +0200, Ansuel Smith wrote:
> > Document new binding qca,power_on_sel used to enable Power-on-strapping
> > select reg and qca,led_open_drain to set led to open drain mode.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > index b9cccb657373..9fb4db65907e 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > @@ -13,6 +13,17 @@ Required properties:
> >  Optional properties:
> >  
> >  - reset-gpios: GPIO to be used to reset the whole device
> > +- qca,ignore-power-on-sel: Ignore power on pin strapping to configure led open
> > +                           drain or eeprom presence.
> 
> So strapping is only used for LEDs and EEPROM presence? Nothing else?
> Seems link MAC0/MAC6 swap would be a good candidate for strapping?
> 
> I just want to make it clear that if you select this option, you need
> to take care of X, Y and Z in DT.
> 
> 	Andrew

Sorry I missed this. Yes strapping is used only for LEDs and EEPROM. No
reference in Documentation about mac swap. Other strapping are related
to voltage selection and other hardware stuff. Thing that can't be set
from sw.

-- 
	Ansuel
