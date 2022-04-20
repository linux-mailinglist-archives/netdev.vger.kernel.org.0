Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA24509147
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 22:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382052AbiDTUTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 16:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351156AbiDTUTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 16:19:03 -0400
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC443EF3B;
        Wed, 20 Apr 2022 13:16:16 -0700 (PDT)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-d6e29fb3d7so3184801fac.7;
        Wed, 20 Apr 2022 13:16:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qfLxNw/Z6CX1khyFmjfq8cACHEEegbYn3QHyCBKvKsY=;
        b=1+JuM08Au4CacNkNUEbZto/6GrAmnOtPMfP5UOAZvKuE63b6826O1uP5rTqa4BQgr9
         L2SZlxkmgj8Q8VfBOG4uTKXXhRatMd2LBzfTFxYZR6YywlXuWcIzqDVQiGPyIAHZgtUj
         1Tnj0E1EEo7oOPsg8ReFquvd9IUdFbHKtEi2EbkHtfYwj1WleiZ2Bs73XhUk7kTx7kMU
         Jq3lUzZEd2S4bb38pckR4t46yb/CnYTWs243B2N1AXy42TUCK1RJ+Qk/LOahNvmKXq9W
         RNspF2lFdxWXBMhXnwKa7rUGWKxR+HSqm3bgSv2jtL+mpLy79x5gQxVPoV0YKP+LZQoL
         J7Lw==
X-Gm-Message-State: AOAM531oqjfjsSMDoM5xbVoWvyphtUXgggD5fH0FSQxo8ZQZEhNEsQIP
        daW+VNnu2KZaxgUYCkViZA==
X-Google-Smtp-Source: ABdhPJxuOYvC5Gpqs6wwcVd4TuKcKNNOXwHGHLqV6hTp9CfiNJGQn5MwjgPanHyu1mjcrt0Vf0ieAQ==
X-Received: by 2002:a05:6870:b4aa:b0:e5:f100:608f with SMTP id y42-20020a056870b4aa00b000e5f100608fmr2357101oap.25.1650485775723;
        Wed, 20 Apr 2022 13:16:15 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id o17-20020a9d5c11000000b005b2611a13edsm6864486otk.61.2022.04.20.13.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 13:16:15 -0700 (PDT)
Received: (nullmailer pid 1777332 invoked by uid 1000);
        Wed, 20 Apr 2022 20:16:13 -0000
Date:   Wed, 20 Apr 2022 15:16:13 -0500
From:   Rob Herring <robh@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?iso-8859-1?Q?Miqu=E8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 09/12] ARM: dts: r9a06g032: describe MII
 converter
Message-ID: <YmBqDTXYiESRHLCW@robh.at.kernel.org>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-10-clement.leger@bootlin.com>
 <YlismVi8y3Vf6PZ0@lunn.ch>
 <20220415102453.1b5b3f77@fixe.home>
 <Yll+Tpnwo5410B9H@lunn.ch>
 <20220415163853.683c0b6d@fixe.home>
 <YlmLWv4Hsm2uk8pa@lunn.ch>
 <20220415172954.64e53086@fixe.home>
 <YlmbIjoIZ8Xb4Kh/@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlmbIjoIZ8Xb4Kh/@lunn.ch>
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

On Fri, Apr 15, 2022 at 06:19:46PM +0200, Andrew Lunn wrote:
> > I think it would be good to modify it like this:
> > 
> > eth-miic@44030000 {
> >     ...
> >   converters {
> >     mii_conv0: mii-conv@0 {
> >       // Even if useless, maybe keeping it for the sake of coherency
> >       renesas,miic-input = <MIIC_GMAC1>;
> >       reg = <0>;
> >     };
> 
> This is not a 'bus', so using reg, and @0, etc is i think wrong.  You
> just have a collection of properties.

'reg' can be for anything you need to address, not just buses.

Rob
