Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB8055C964
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240846AbiF0XFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 19:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240751AbiF0XFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 19:05:49 -0400
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94FD22507;
        Mon, 27 Jun 2022 16:05:48 -0700 (PDT)
Received: by mail-io1-f49.google.com with SMTP id u20so11201008iob.8;
        Mon, 27 Jun 2022 16:05:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RsbxMGrAEPpDrcq9SD5GCJ241orHnQShiio8WLL4UIU=;
        b=vosbjv9Rzy6oFghQx+giSZ32iDKT/5vZrxBqa9FuukA6j5Q7zOPTG/Sejx74FzMej7
         3v4Gf2D+7iwxNOmZCCE8tYi0wyF6LM71ynZ8MY3z7Sx7p5Yag10buDDpkzOxfZuB7iHB
         jtqwnH9OVmhj2BwkoTr3RfV1rccKMF8k0hNDSH/8YCQJBC2rUkHNogRfjbqHUbcA5pKQ
         73Xdvd2YFzNdnGVW1qc/+7Sh9VvodTAjYzK5HOAxS21aOlPquIYK+lO/kcOz8HhWzpXK
         6m5OidXPFYeG9K1aLRSjtGoNGCGCZVvdJ1al+b327Fj1+3JhQmSq3zBRCM6dj2FpHVqi
         PNPw==
X-Gm-Message-State: AJIora9qy1BoJBXBDXA+s3e0GiiENXs5thgLngsQeGMflpmOZm9x7GJ9
        zzrIF/Jq3fxbsVcKt/C+1A==
X-Google-Smtp-Source: AGRyM1usk/wrttz5ONExBVqjv9hoJ7YL8ko7p4t0WyBusRIAayBBYIv7q93475PYWubiuUWy74YCpg==
X-Received: by 2002:a02:a08d:0:b0:33c:6a7d:87db with SMTP id g13-20020a02a08d000000b0033c6a7d87dbmr7505895jah.64.1656371147890;
        Mon, 27 Jun 2022 16:05:47 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id t64-20020a025443000000b0033b73557de4sm5156297jaa.93.2022.06.27.16.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 16:05:47 -0700 (PDT)
Received: (nullmailer pid 3134751 invoked by uid 1000);
        Mon, 27 Jun 2022 23:05:45 -0000
Date:   Mon, 27 Jun 2022 17:05:45 -0600
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 02/28] dt-bindings: net: fman: Add additional
 interface properties
Message-ID: <20220627230545.GA3128808-robh@kernel.org>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
 <20220617203312.3799646-3-sean.anderson@seco.com>
 <d483da73-c5a1-2474-4992-f7ce9947d5ba@linaro.org>
 <4b305b67-7bc1-d188-23b8-6e5c7e81813b@seco.com>
 <9c0513dd-67ce-0d6a-f2a5-58e981f0d55c@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c0513dd-67ce-0d6a-f2a5-58e981f0d55c@linaro.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 19, 2022 at 12:33:22PM +0200, Krzysztof Kozlowski wrote:
> On 18/06/2022 17:55, Sean Anderson wrote:
> > Hi Krzysztof,
> > 
> > On 6/17/22 9:16 PM, Krzysztof Kozlowski wrote:
> >> On 17/06/2022 13:32, Sean Anderson wrote:
> >>> At the moment, MEMACs are configured almost completely based on the
> >>> phy-connection-type. That is, if the phy interface is RGMII, it assumed
> >>> that RGMII is supported. For some interfaces, it is assumed that the
> >>> RCW/bootloader has set up the SerDes properly. The actual link state is
> >>> never reported.
> >>>
> >>> To address these shortcomings, the driver will need additional
> >>> information. First, it needs to know how to access the PCS/PMAs (in
> >>> order to configure them and get the link status). The SGMII PCS/PMA is
> >>> the only currently-described PCS/PMA. Add the XFI and QSGMII PCS/PMAs as
> >>> well. The XFI (and 1GBase-KR) PCS/PMA is a c45 "phy" which sits on the
> >>> same MDIO bus as SGMII PCS/PMA. By default they will have conflicting
> >>> addresses, but they are also not enabled at the same time by default.
> >>> Therefore, we can let the default address for the XFI PCS/PMA be the
> >>> same as for SGMII. This will allow for backwards-compatibility.
> >>>
> >>> QSGMII, however, cannot work with the current binding. This is because
> >>> the QSGMII PCS/PMAs are only present on one MAC's MDIO bus. At the
> >>> moment this is worked around by having every MAC write to the PCS/PMA
> >>> addresses (without checking if they are present). This only works if
> >>> each MAC has the same configuration, and only if we don't need to know
> >>> the status. Because the QSGMII PCS/PMA will typically be located on a
> >>> different MDIO bus than the MAC's SGMII PCS/PMA, there is no fallback
> >>> for the QSGMII PCS/PMA.
> >>>
> >>> MEMACs (across all SoCs) support the following protocols:
> >>>
> >>> - MII
> >>> - RGMII
> >>> - SGMII, 1000Base-X, and 1000Base-KX
> >>> - 2500Base-X (aka 2.5G SGMII)
> >>> - QSGMII
> >>> - 10GBase-R (aka XFI) and 10GBase-KR
> >>> - XAUI and HiGig
> >>>
> >>> Each line documents a set of orthogonal protocols (e.g. XAUI is
> >>> supported if and only if HiGig is supported). Additionally,
> >>>
> >>> - XAUI implies support for 10GBase-R
> >>> - 10GBase-R is supported if and only if RGMII is not supported
> >>> - 2500Base-X implies support for 1000Base-X
> >>> - MII implies support for RGMII
> >>>
> >>> To switch between different protocols, we must reconfigure the SerDes.
> >>> This is done by using the standard phys property. We can also use it to
> >>> validate whether different protocols are supported (e.g. using
> >>> phy_validate). This will work for serial protocols, but not RGMII or
> >>> MII. Additionally, we still need to be compatible when there is no
> >>> SerDes.
> >>>
> >>> While we can detect 10G support by examining the port speed (as set by
> >>> fsl,fman-10g-port), we cannot determine support for any of the other
> >>> protocols based on the existing binding. In fact, the binding works
> >>> against us in some respects, because pcsphy-handle is required even if
> >>> there is no possible PCS/PMA for that MAC. To allow for backwards-
> >>> compatibility, we use a boolean-style property for RGMII (instead of
> >>> presence/absence-style). When the property for RGMII is missing, we will
> >>> assume that it is supported. The exception is MII, since no existing
> >>> device trees use it (as far as I could tell).
> >>>
> >>> Unfortunately, QSGMII support will be broken for old device trees. There
> >>> is nothing we can do about this because of the PCS/PMA situation (as
> >>> described above).
> >>>
> >>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> >>
> >> Thanks for the patch but you add too many new properties. The file
> >> should be converted to YAML/DT schema first.
> > 
> > Perhaps. However, conversion to yaml is a non-trivial task, especially for
> > a complicated binding such as this one. I am more than happy to rework this
> > patch to be based on a yaml conversion, but I do not have the bandwidth to
> > do so myself.
> 
> I understand. Although since 2020  - since when we expect the bindings
> to be in YAML - this file grew by 6 properties, because each person
> extends it instead of converting. Each person uses the same excuse...
> 
> You add here 5 more, so it would be 11 new properties in total.
> 
> > 
> > If you have any comments on the binding changes themselves, that would be
> > much appreciated.
> 
> Maybe Rob will ack it, but for me the change is too big to be accepted
> in TXT, so no from me.

Above my threshold for not first converting too. Really, I'm pretty 
close to saying no .txt file changes at all. Maybe compatible string 
updates only, people should be rewarded for not changing their h/w.

Rob
