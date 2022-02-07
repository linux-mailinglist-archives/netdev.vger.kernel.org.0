Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C78DC4ACA92
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 21:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiBGUq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 15:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242732AbiBGUay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 15:30:54 -0500
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5E0C0401DA;
        Mon,  7 Feb 2022 12:30:53 -0800 (PST)
Received: by mail-oi1-f175.google.com with SMTP id 4so18280642oil.11;
        Mon, 07 Feb 2022 12:30:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=M80jk/mTnmzTCyOAgobT1zJYrEwWUPQbcvoyxfMNQ0k=;
        b=rsmIPlkDo6uBj+fENhZ36oww2mWNGioHWmiBVGOy6mhJL1UVymKmqHUbn6/S6RjVci
         LA9vg1aUK0sjv7skcFsF3QldXNx6zhbdPbaltU97Q4buGY/VGNKlNP/eOVjxITWRs7qJ
         sYWInDiTt5/9kIKAmYA3k9zWc3ffNYdFqWoMG6UgTrU+4UimtPBONlg8sSZ75YdfOu8Y
         WFZp3ulf1eJ0DfMbFYLQdsBSREuL8WixiWGF2/ZoN8yVaB9D5l//uAJ8I9OHqfy97cgP
         okx4CE2Da0jB85DMQl0JNHnhPmW/EA+YSQVB9KncoeX67lPcpoyb1OPazTxYLEvpJ4sS
         YuPA==
X-Gm-Message-State: AOAM530nD5USLj1P3lOvXtu2LLSPnvIPN7PUQcRDv8dgyBTZdPu0UicP
        9oYqlh649iLRTjoUOv/Nsw==
X-Google-Smtp-Source: ABdhPJxrtjY8DN4oMg8J59VZ53F3yuhMoNXTZzes8GFgKwzEEiGAyqNyAURzasKssSKB+fI+cBpThA==
X-Received: by 2002:a05:6808:1513:: with SMTP id u19mr309040oiw.205.1644265853047;
        Mon, 07 Feb 2022 12:30:53 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id bc36sm4343256oob.45.2022.02.07.12.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 12:30:52 -0800 (PST)
Received: (nullmailer pid 855870 invoked by uid 1000);
        Mon, 07 Feb 2022 20:30:51 -0000
Date:   Mon, 7 Feb 2022 14:30:51 -0600
From:   Rob Herring <robh@kernel.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        devicetree@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Vinod Koul <vkoul@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Holger Brunck <holger.brunck@hitachienergy.com>,
        linux-phy@lists.infradead.org
Subject: Re: [PATCH devicetree v3] dt-bindings: phy: Add `tx-p2p-microvolt`
 property binding
Message-ID: <YgGBe0BS/d0lOVtU@robh.at.kernel.org>
References: <20220119131117.30245-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220119131117.30245-1-kabel@kernel.org>
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

On Wed, 19 Jan 2022 14:11:17 +0100, Marek Behún wrote:
> Common PHYs and network PCSes often have the possibility to specify
> peak-to-peak voltage on the differential pair - the default voltage
> sometimes needs to be changed for a particular board.
> 
> Add properties `tx-p2p-microvolt` and `tx-p2p-microvolt-names` for this
> purpose. The second property is needed to specify the mode for the
> corresponding voltage in the `tx-p2p-microvolt` property, if the voltage
> is to be used only for speficic mode. More voltage-mode pairs can be
> specified.
> 
> Example usage with only one voltage (it will be used for all supported
> PHY modes, the `tx-p2p-microvolt-names` property is not needed in this
> case):
> 
>   tx-p2p-microvolt = <915000>;
> 
> Example usage with voltages for multiple modes:
> 
>   tx-p2p-microvolt = <915000>, <1100000>, <1200000>;
>   tx-p2p-microvolt-names = "2500base-x", "usb", "pcie";
> 
> Add these properties into a separate file phy/transmit-amplitude.yaml,
> which should be referenced by any binding that uses it.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
> Change since v2:
> - removed 'select:' as requested by Rob. Instead the schema should be
>   referenced by any binding that uses it. This also fixed indentation
>   warnings from Rob's bot, since they warned about lines in the select
>   statement
> ---
>  .../bindings/phy/transmit-amplitude.yaml      | 103 ++++++++++++++++++
>  1 file changed, 103 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/transmit-amplitude.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
