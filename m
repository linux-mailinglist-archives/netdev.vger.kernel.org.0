Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2033469B635
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 00:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjBQXK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 18:10:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjBQXKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 18:10:25 -0500
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F3022A2E;
        Fri, 17 Feb 2023 15:10:24 -0800 (PST)
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-1718b38d3ceso2594256fac.0;
        Fri, 17 Feb 2023 15:10:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yKQ7HUQ19YHYNCinZiTfNw1jKPbH2w3EEubtXUOOTSQ=;
        b=TUCLcZrHG8PJaLwuWsHXiWb68ftBX1eBlaGdI1EtGxpJdo7Svq6/SEXXKvNqTfnjwY
         5/RgBM3L+IFAZKQEaU3CoPyZ0Nmno8gtZZAkfsAE3Ir5cm3zLP9WiCaVEXaOhh0ViP5a
         iOGP6BMh1QwO1dexY4TPgk53rxVx/0Hjy0DiQhNFSIMeKg/mBrrjxlmI/Q5Vl+IhpKao
         nikltINh+AE5v6V3SqiNtmTPi6IZTuwt/yxOl5QAdfLGv9+Q8dx/L8UXeFj19xSC65mk
         J7P1t005gBdFLbL65DM3FqQdn1gtj1Hix66cT51ihAkKL65gBfbDuCq+mQWssepyS8i2
         cCYg==
X-Gm-Message-State: AO0yUKWRFh55Zp5jlJ34TJS/XjZogKOspuEssEwNCnjD7eYx5G1c1z16
        JzGeg6YsD5rLVXd93Ve+6R/SnvgrRA==
X-Google-Smtp-Source: AK7set9fLPkg0yKORr/D/XglLiElC4PsjDfJZgA+4C6EekrPMHMQtaKaiiTrXYqBkej6oKIb5JAYgA==
X-Received: by 2002:a05:6871:8e86:b0:16d:c23a:a117 with SMTP id zq6-20020a0568718e8600b0016dc23aa117mr117105oab.1.1676675423565;
        Fri, 17 Feb 2023 15:10:23 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id n6-20020a056870e40600b00163c90c1513sm2182724oag.28.2023.02.17.15.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 15:10:23 -0800 (PST)
Received: (nullmailer pid 2236402 invoked by uid 1000);
        Fri, 17 Feb 2023 23:10:20 -0000
Date:   Fri, 17 Feb 2023 17:10:20 -0600
From:   Rob Herring <robh@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Lee Jones <lee@kernel.org>, linux-leds@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        devicetree@vger.kernel.org, John Crispin <john@phrozen.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, Arun.Ramadoss@microchip.com
Subject: Re: [PATCH v8 12/13] dt-bindings: net: phy: Document support for
 leds node
Message-ID: <20230217231020.GB2217008-robh@kernel.org>
References: <20230216013230.22978-1-ansuelsmth@gmail.com>
 <20230216013230.22978-13-ansuelsmth@gmail.com>
 <167651373836.1183034.17900591036429665419.robh@kernel.org>
 <63ee9801.df0a0220.a106.72a3@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63ee9801.df0a0220.a106.72a3@mx.google.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 11:00:49AM +0100, Christian Marangi wrote:
> On Wed, Feb 15, 2023 at 08:32:11PM -0600, Rob Herring wrote:
> > 
> > On Thu, 16 Feb 2023 02:32:29 +0100, Christian Marangi wrote:
> > > Document support for leds node in phy and add an example for it.
> > > Phy led will have to match led-phy pattern and should be treated as a
> > > generic led.
> > > 
> > > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > > ---
> > >  .../devicetree/bindings/net/ethernet-phy.yaml | 22 +++++++++++++++++++
> > >  1 file changed, 22 insertions(+)
> > > 
> > 
> > My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> > on your patch (DT_CHECKER_FLAGS is new in v5.13):
> > 
> > yamllint warnings/errors:
> > 
> > dtschema/dtc warnings/errors:
> > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/ethernet-phy.example.dtb: ethernet-phy@0: leds:led-phy@0:linux,default-trigger: 'oneOf' conditional failed, one must be fixed:
> > 	'netdev' is not one of ['backlight', 'default-on', 'heartbeat', 'disk-activity', 'ide-disk', 'timer', 'pattern']
> > 	'netdev' does not match '^mmc[0-9]+$'
> > 	'netdev' does not match '^cpu[0-9]*$'
> > 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > 
> 
> Hi, I could be wrong but this should be fixed by the previous patch that
> adds netdev to the trigger list.

If so, then it didn't apply for me which is what PW says. So what tree 
does this series apply too? linux-next? That's a tree no one can apply 
patches from.

Rob

