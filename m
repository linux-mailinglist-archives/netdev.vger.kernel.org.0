Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D28E71245DB
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfLRLen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:34:43 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55201 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbfLRLem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 06:34:42 -0500
Received: by mail-wm1-f68.google.com with SMTP id b19so1461270wmj.4
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 03:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wFs75/j1aHZclp/5rGoLDMPNAtBzpcDUR0+/l6BDakU=;
        b=0D+UJnz54bq4psEWyqYpeLuw9y16/0BtCxkEj55CVqdlSjPSSwHstqN09GEMpaIUm0
         qmlwCpr9igNmzRnz7CkenNqg70Yhm5IwP9OuaKELADjRBcZgIPrf9Z7ge9p8hssqLhbN
         lajJjhy05U80q0d0eC1EB+WFDDoUE/elOTzZKHSq4toFcFqsDwHxEfaq8jtwa6WBNevP
         3SmNIgiJEGwY+eRHL5DQwT3pBq25A6U+E9ie/6g0L7iSOO+4caFBlq6/YTB2cLuA8Sqw
         dMNxOHsqcDzp0zKFh7mazvPFkFVFA2XCRyfUo9DYWStzwpLwqtKzjQrbmt/GbXTncPOo
         AP4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wFs75/j1aHZclp/5rGoLDMPNAtBzpcDUR0+/l6BDakU=;
        b=n7UMcs7lyCY4MX7R9r6rB5rawXZdteVG2BOM1Yz5wBNO+e4oVLSyNKTwKLgQ5xWNVN
         pu4atSPEspD5NrPEso/wsJdPsN3NrvCnNfphZ7WBnCVQDP3F8TNl/pQ9lbEhExeTfvd3
         Od63tbxwDsD4fjz9xAR4Z3qzCeh3Szd++j/uYDhmbc5NUvm/KRnLp9Jc3yCBjkQP9OsG
         LX0JHCDDomjqo2G0/5FaX/KE8S6XXM+K88OVKnhS3mgt8RFZ6jMU8wwLl85gyZe2m6FW
         F9MyYElSJtgW3f+UwVWv+q46qrEdJ8xuLyLKKEmqAACXlfNLoSLp0NYilxDYzP+9403v
         udIg==
X-Gm-Message-State: APjAAAXaplmN42aDiJMjwsCkwpFQU9KydK+7O2MJB5aGh6OkOXqbNp4a
        5O63bb4F1BHw9/vnfdHx75CTlg==
X-Google-Smtp-Source: APXvYqyCjnkcjG7bxZqA9N58tKBlxXdKuUOWJVrBrebNtLJJISHUZ4xcnBkc1JJxrzWLDogESw5xxg==
X-Received: by 2002:a7b:c318:: with SMTP id k24mr2843500wmj.54.1576668879688;
        Wed, 18 Dec 2019 03:34:39 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id y20sm2074955wmi.25.2019.12.18.03.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 03:34:38 -0800 (PST)
Date:   Wed, 18 Dec 2019 12:34:38 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        Maxime Ripard <mripard@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] dt-bindings: Add missing 'properties' keyword enclosing
 'snps,tso'
Message-ID: <20191218113437.GC22367@netronome.com>
References: <20191217163946.25052-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217163946.25052-1-robh@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 10:39:46AM -0600, Rob Herring wrote:
> DT property definitions must be under a 'properties' keyword. This was
> missing for 'snps,tso' in an if/then clause. A meta-schema fix will
> catch future errors like this.
> 
> Fixes: 7db3545aef5f ("dt-bindings: net: stmmac: Convert the binding to a schemas")
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Rob Herring <robh@kernel.org>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

We still seem to be some distance from having all DT match the schema.

$ ARCH=arm make dtbs_check DT_SCHEMA_FILES=Documentation/devicetree/bindings/net/snps,dwmac.yaml
.../linux/arch/arm/boot/dts/artpec6-devboard.dt.yaml: ethernet@f8010000: interrupt-names:1: 'eth_wake_irq' was expected
.../linux/arch/arm/boot/dts/meson6-atv1200.dt.yaml: ethernet@c9410000: 'phy-mode' is a required property
.../linux/arch/arm/boot/dts/meson8-minix-neo-x8.dt.yaml: ethernet@c9410000: 'phy-mode' is a required property
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_nand.dt.yaml: ethernet@ff800000: reset-names: Additional items are not allowed ('stmmaceth-ocp' was unexpected)
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_nand.dt.yaml: ethernet@ff800000: reset-names: ['stmmaceth', 'stmmaceth-ocp'] is too long
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_nand.dt.yaml: ethernet@ff800000: resets: [[4, 32], [4, 40]] is too long
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_nand.dt.yaml: ethernet@ff802000: reset-names: Additional items are not allowed ('stmmaceth-ocp' was unexpected)
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_nand.dt.yaml: ethernet@ff802000: reset-names: ['stmmaceth', 'stmmaceth-ocp'] is too long
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_nand.dt.yaml: ethernet@ff802000: resets: [[4, 33], [4, 41]] is too long
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_nand.dt.yaml: ethernet@ff804000: reset-names: Additional items are not allowed ('stmmaceth-ocp' was unexpected)
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_nand.dt.yaml: ethernet@ff804000: reset-names: ['stmmaceth', 'stmmaceth-ocp'] is too long
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_nand.dt.yaml: ethernet@ff804000: resets: [[4, 34], [4, 42]] is too long
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dt.yaml: ethernet@ff800000: reset-names: Additional items are not allowed ('stmmaceth-ocp' was unexpected)
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dt.yaml: ethernet@ff800000: reset-names: ['stmmaceth', 'stmmaceth-ocp'] is too long
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dt.yaml: ethernet@ff800000: resets: [[4, 32], [4, 40]] is too long
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dt.yaml: ethernet@ff802000: reset-names: Additional items are not allowed ('stmmaceth-ocp' was unexpected)
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dt.yaml: ethernet@ff802000: reset-names: ['stmmaceth', 'stmmaceth-ocp'] is too long
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dt.yaml: ethernet@ff802000: resets: [[4, 33], [4, 41]] is too long
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dt.yaml: ethernet@ff804000: reset-names: Additional items are not allowed ('stmmaceth-ocp' was unexpected)
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dt.yaml: ethernet@ff804000: reset-names: ['stmmaceth', 'stmmaceth-ocp'] is too long
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dt.yaml: ethernet@ff804000: resets: [[4, 34], [4, 42]] is too long
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_sdmmc.dt.yaml: ethernet@ff800000: reset-names: Additional items are not allowed ('stmmaceth-ocp' was unexpected)
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_sdmmc.dt.yaml: ethernet@ff800000: reset-names: ['stmmaceth', 'stmmaceth-ocp'] is too long
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_sdmmc.dt.yaml: ethernet@ff800000: resets: [[4, 32], [4, 40]] is too long
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_sdmmc.dt.yaml: ethernet@ff802000: reset-names: Additional items are not allowed ('stmmaceth-ocp' was unexpected)
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_sdmmc.dt.yaml: ethernet@ff802000: reset-names: ['stmmaceth', 'stmmaceth-ocp'] is too long
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_sdmmc.dt.yaml: ethernet@ff802000: resets: [[4, 33], [4, 41]] is too long
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_sdmmc.dt.yaml: ethernet@ff804000: reset-names: Additional items are not allowed ('stmmaceth-ocp' was unexpected)
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_sdmmc.dt.yaml: ethernet@ff804000: reset-names: ['stmmaceth', 'stmmaceth-ocp'] is too long
.../linux/arch/arm/boot/dts/socfpga_arria10_socdk_sdmmc.dt.yaml: ethernet@ff804000: resets: [[4, 34], [4, 42]] is too long
.../linux/arch/arm/boot/dts/spear1310-evb.dt.yaml: eth@e2000000: $nodename:0: 'eth@e2000000' does not match '^ethernet(@.*)?$'
.../linux/arch/arm/boot/dts/spear1310-evb.dt.yaml: eth@e2000000: compatible: None of ['st,spear600-gmac'] are valid under the given schema
.../linux/arch/arm/boot/dts/spear1310-evb.dt.yaml: eth@5c400000: $nodename:0: 'eth@5c400000' does not match '^ethernet(@.*)?$'
.../linux/arch/arm/boot/dts/spear1310-evb.dt.yaml: eth@5c400000: compatible: None of ['st,spear600-gmac'] are valid under the given schema
.../linux/arch/arm/boot/dts/spear1310-evb.dt.yaml: eth@5c500000: $nodename:0: 'eth@5c500000' does not match '^ethernet(@.*)?$'
.../linux/arch/arm/boot/dts/spear1310-evb.dt.yaml: eth@5c500000: compatible: None of ['st,spear600-gmac'] are valid under the given schema
.../linux/arch/arm/boot/dts/spear1310-evb.dt.yaml: eth@5c600000: $nodename:0: 'eth@5c600000' does not match '^ethernet(@.*)?$'
.../linux/arch/arm/boot/dts/spear1310-evb.dt.yaml: eth@5c600000: compatible: None of ['st,spear600-gmac'] are valid under the given schema
.../linux/arch/arm/boot/dts/spear1310-evb.dt.yaml: eth@5c700000: $nodename:0: 'eth@5c700000' does not match '^ethernet(@.*)?$'
.../linux/arch/arm/boot/dts/spear1310-evb.dt.yaml: eth@5c700000: compatible: None of ['st,spear600-gmac'] are valid under the given schema
.../linux/arch/arm/boot/dts/socfpga_cyclone5_vining_fpga.dt.yaml: ethernet@ff702000: snps,reset-delays-us: [[10000, 10000, 10000]] is too short
.../linux/arch/arm/boot/dts/spear1340-evb.dt.yaml: eth@e2000000: $nodename:0: 'eth@e2000000' does not match '^ethernet(@.*)?$'
.../linux/arch/arm/boot/dts/spear1340-evb.dt.yaml: eth@e2000000: compatible: None of ['st,spear600-gmac'] are valid under the given schema
.../linux/arch/arm/boot/dts/stih410-b2260.dt.yaml: dwmac@9630000: $nodename:0: 'dwmac@9630000' does not match '^ethernet(@.*)?$'
.../linux/arch/arm/boot/dts/stih410-b2260.dt.yaml: dwmac@9630000: snps,reset-delays-us: [[0, 10000, 1000000]] is too short
.../linux/arch/arm/boot/dts/stih407-b2120.dt.yaml: dwmac@9630000: $nodename:0: 'dwmac@9630000' does not match '^ethernet(@.*)?$'
.../linux/arch/arm/boot/dts/stih418-b2199.dt.yaml: dwmac@9630000: $nodename:0: 'dwmac@9630000' does not match '^ethernet(@.*)?$'
.../linux/arch/arm/boot/dts/stih410-b2120.dt.yaml: dwmac@9630000: $nodename:0: 'dwmac@9630000' does not match '^ethernet(@.*)?$'

