Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75BB459C549
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 19:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236064AbiHVRqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 13:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236039AbiHVRqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 13:46:02 -0400
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6786042AD4;
        Mon, 22 Aug 2022 10:46:01 -0700 (PDT)
Received: by mail-oi1-f179.google.com with SMTP id o204so5575319oia.12;
        Mon, 22 Aug 2022 10:46:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=ifHDFxdQQ4rKGhhjDb2X0gYbrmGOuiotWdJhKeoht1I=;
        b=Ge2NEWfFb3EGCaGZatQ8RWme71AW2B6G2kQaejUwe38keilg6VxDtttC9wClmVT8H/
         +zhFnv0fxEzPb+MZJLG+bnw7C0xWx0jOSV91VYM10bayduiknBA8qYFj0Gxuhlysz6z8
         WCjyiPNzQhRE60Ku9+QI+7Wz0K6uq+ThaCRW9pARXIhlcl7choFnlzaVW8ZLWTXCx1jg
         Xo0YtqnXOd/flV+WdsWp4L2SEzQ6fldV7Jn6eBqzE8SdD/uJxyAhqrU/ZiFNVK4D3k5o
         J1a/ZRyk6OuvnDCNPET93qJuOIfZHKaEljuAkteHYNA0d/i0rg2Bb77XShB9nDb7tMsg
         OuJA==
X-Gm-Message-State: ACgBeo39XQN+AeZs3QAWhkrEAcT56PCFUgypMKRyd2Fi9LvfDOThukwN
        jwDtxxxWwZwP7Ckz3E+9jg==
X-Google-Smtp-Source: AA6agR5QsREs07ny8eIvz2gV/Ar/7vPkMTzYP+oipTqEbuZIqX+RuZlDjP55UFVzlilAKJUOEVqv8w==
X-Received: by 2002:aca:5bc3:0:b0:345:30a2:89da with SMTP id p186-20020aca5bc3000000b0034530a289damr6755128oib.3.1661190360670;
        Mon, 22 Aug 2022 10:46:00 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id k188-20020a4a4ac5000000b0042859bebfebsm2605613oob.45.2022.08.22.10.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 10:46:00 -0700 (PDT)
Received: (nullmailer pid 39462 invoked by uid 1000);
        Mon, 22 Aug 2022 17:45:59 -0000
Date:   Mon, 22 Aug 2022 12:45:59 -0500
From:   Rob Herring <robh@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH net-next v4 2/8] dt-bindings: net: fman: Add additional
 interface properties
Message-ID: <20220822174559.GA39398-robh@kernel.org>
References: <20220804194705.459670-1-sean.anderson@seco.com>
 <20220804194705.459670-3-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804194705.459670-3-sean.anderson@seco.com>
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

On Thu, 04 Aug 2022 15:46:59 -0400, Sean Anderson wrote:
> At the moment, mEMACs are configured almost completely based on the
> phy-connection-type. That is, if the phy interface is RGMII, it assumed
> that RGMII is supported. For some interfaces, it is assumed that the
> RCW/bootloader has set up the SerDes properly. This is generally OK, but
> restricts runtime reconfiguration. The actual link state is never
> reported.
> 
> To address these shortcomings, the driver will need additional
> information. First, it needs to know how to access the PCS/PMAs (in
> order to configure them and get the link status). The SGMII PCS/PMA is
> the only currently-described PCS/PMA. Add the XFI and QSGMII PCS/PMAs as
> well. The XFI (and 10GBASE-KR) PCS/PMA is a c45 "phy" which sits on the
> same MDIO bus as SGMII PCS/PMA. By default they will have conflicting
> addresses, but they are also not enabled at the same time by default.
> Therefore, we can let the XFI PCS/PMA be the default when
> phy-connection-type is xgmii. This will allow for
> backwards-compatibility.
> 
> QSGMII, however, cannot work with the current binding. This is because
> the QSGMII PCS/PMAs are only present on one MAC's MDIO bus. At the
> moment this is worked around by having every MAC write to the PCS/PMA
> addresses (without checking if they are present). This only works if
> each MAC has the same configuration, and only if we don't need to know
> the status. Because the QSGMII PCS/PMA will typically be located on a
> different MDIO bus than the MAC's SGMII PCS/PMA, there is no fallback
> for the QSGMII PCS/PMA.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
> (no changes since v3)
> 
> Changes in v3:
> - Add vendor prefix 'fsl,' to rgmii and mii properties.
> - Set maxItems for pcs-names
> - Remove phy-* properties from example because dt-schema complains and I
>   can't be bothered to figure out how to make it work.
> - Add pcs-handle as a preferred version of pcsphy-handle
> - Deprecate pcsphy-handle
> - Remove mii/rmii properties
> 
> Changes in v2:
> - Better document how we select which PCS to use in the default case
> 
>  .../bindings/net/fsl,fman-dtsec.yaml          | 53 ++++++++++++++-----
>  .../devicetree/bindings/net/fsl-fman.txt      |  5 +-
>  2 files changed, 43 insertions(+), 15 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
