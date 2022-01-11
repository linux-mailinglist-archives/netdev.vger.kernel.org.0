Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D07048B5FB
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 19:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242841AbiAKSpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 13:45:20 -0500
Received: from mail-ot1-f42.google.com ([209.85.210.42]:41517 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241456AbiAKSpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 13:45:20 -0500
Received: by mail-ot1-f42.google.com with SMTP id a12-20020a0568301dcc00b005919e149b4cso1583926otj.8;
        Tue, 11 Jan 2022 10:45:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F0e3m98RqwjSlzmyX1kOm+vOF2VQm1ViKY66pyPBG2s=;
        b=8Dmj46V2KKz2ydt3O+/Lg7d+MJE8wawHM8m7YjDwcubdwFNRERbIPAeVe+OrnYZbyo
         acmqkvv+heo45vQ4crT0PwXwsDu/qbiTHNvetPoWfYw2USc2Cde9mrOsfUCrII2OlQfH
         bb8iFX6VXOAhoSnp4PTrExHTk4+hbshMVlxF7/qNUy20v+hItc/46MCsOUw7HzI9sO2/
         /UMnug9MasAkZFfc+KDKBexCFj0RwSyCnwC0rhMpS5tzEOmXzDzWvsBWXcw2TeyGdy7d
         5Xgkq7tmfaK3Kk/D+SfcHEj8NzBkO1q3Wr7cGgd2ltH6toofdMbIwPz59Obb98wdLnX2
         wYUg==
X-Gm-Message-State: AOAM5304PTya0mZAoJIBISGBNPcen1D/0L6dqIBpWN582SXVlq9bInzl
        6XUoXT4KqtO86FruKB07rQ==
X-Google-Smtp-Source: ABdhPJxy8a1EpLFMlB6hTOJMVu4IhrR2rQpyht3PAS0epH89Pr9U2ltlySSjVA6xxzQVEcZbuo4ZRg==
X-Received: by 2002:a9d:6e91:: with SMTP id a17mr4265345otr.138.1641926719396;
        Tue, 11 Jan 2022 10:45:19 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id o12sm434552ooi.15.2022.01.11.10.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 10:45:18 -0800 (PST)
Received: (nullmailer pid 3304828 invoked by uid 1000);
        Tue, 11 Jan 2022 18:45:16 -0000
Date:   Tue, 11 Jan 2022 12:45:16 -0600
From:   Rob Herring <robh@kernel.org>
To:     Hector Martin <marcan@marcan.st>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wright Feng <wright.feng@infineon.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Kettenis <kettenis@openbsd.org>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        SHA-cyfmac-dev-list@infineon.com, Rob Herring <robh+dt@kernel.org>,
        linux-acpi@vger.kernel.org,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, Len Brown <lenb@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Sven Peter <sven@svenpeter.dev>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH v2 01/35] dt-bindings: net: bcm4329-fmac: Add Apple
 properties & chips
Message-ID: <Yd3QPF0KxD3RFfXM@robh.at.kernel.org>
References: <20220104072658.69756-1-marcan@marcan.st>
 <20220104072658.69756-2-marcan@marcan.st>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104072658.69756-2-marcan@marcan.st>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 04 Jan 2022 16:26:24 +0900, Hector Martin wrote:
> This binding is currently used for SDIO devices, but these chips are
> also used as PCIe devices on DT platforms and may be represented in the
> DT. Re-use the existing binding and add chip compatibles used by Apple
> T2 and M1 platforms (the T2 ones are not known to be used in DT
> platforms, but we might as well document them).
> 
> Then, add properties required for firmware selection and calibration on
> M1 machines.
> 
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Hector Martin <marcan@marcan.st>
> ---
>  .../net/wireless/brcm,bcm4329-fmac.yaml       | 37 +++++++++++++++++--
>  1 file changed, 34 insertions(+), 3 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
