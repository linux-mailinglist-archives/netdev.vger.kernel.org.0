Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6DA143189F
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbhJRMQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:16:09 -0400
Received: from mail-ot1-f49.google.com ([209.85.210.49]:40799 "EHLO
        mail-ot1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbhJRMQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 08:16:08 -0400
Received: by mail-ot1-f49.google.com with SMTP id s18-20020a0568301e1200b0054e77a16651so219997otr.7;
        Mon, 18 Oct 2021 05:13:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=WBwVmJRA9jHYx97goTq2YBnHx5m4DkWOs/nHLFWmPK8=;
        b=ine0NeJjSu32hcmBK66V5hEERQmtFn7bZam5rnYDdySVTIDm1dRjH2aTRh4DPO8J6n
         NBNsT9cKo/kls2oUUA8wztUo6nWpNzvwe2vDTesWQAtVgz7CO7cWHsAJfb3jlKsXjyFr
         N3lDnH+hmlawA41KOZCoHokEX9I09VWqGrwugxFRqVWLj62nceYcUewTKRXG6Ycb9oZE
         X/lOPsg6mV8eDotGzZ8Kay+sF4pq5oiK+Q8x2AThCRtZlEuER2d6wAgEZetbS95bTCZq
         Q/+yl3uLypRw+VCIX4qp9x9vBOThfGdKZIUTgb5TcmwlEpnPj10ikdEkKTKVcnRRuInT
         baOA==
X-Gm-Message-State: AOAM53313OO2Ra+HlNLGv1dzO1Ao18pd/lyp5bQt70g0r1IlCQSfUt6C
        tu584dhaCeAjkeTPqzvMkA==
X-Google-Smtp-Source: ABdhPJwZUUe+FY/YopTOf0d39emzYA495qgKB42FtPd05e1NUcWV0zHVanfuIq4go7Xk4GV6uef0Zg==
X-Received: by 2002:a9d:6206:: with SMTP id g6mr10530175otj.6.1634559236564;
        Mon, 18 Oct 2021 05:13:56 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id l25sm2473661oot.36.2021.10.18.05.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 05:13:55 -0700 (PDT)
Received: (nullmailer pid 2074241 invoked by uid 1000);
        Mon, 18 Oct 2021 12:13:53 -0000
From:   Rob Herring <robh@kernel.org>
To:     David Heidelberg <david@ixit.cz>
Cc:     linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        ~okias/devicetree@lists.sr.ht, devicetree@vger.kernel.org
In-Reply-To: <20211017160210.85543-1-david@ixit.cz>
References: <20211017160210.85543-1-david@ixit.cz>
Subject: Re: [PATCH v4] dt-bindings: net: nfc: nxp,pn544: Convert txt bindings to yaml
Date:   Mon, 18 Oct 2021 07:13:53 -0500
Message-Id: <1634559233.484644.2074240.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 17 Oct 2021 18:02:10 +0200, David Heidelberg wrote:
> Convert bindings for NXP PN544 NFC driver to YAML syntax.
> 
> Signed-off-by: David Heidelberg <david@ixit.cz>
> ---
> v2
>  - Krzysztof is a maintainer
>  - pintctrl dropped
>  - 4 space indent for example
>  - nfc node name
> v3
>  - remove whole pinctrl
> v4
>  - drop clock-frequency, which is inherited by i2c bus
> 
>  .../bindings/net/nfc/nxp,pn544.yaml           | 56 +++++++++++++++++++
>  .../devicetree/bindings/net/nfc/pn544.txt     | 33 -----------
>  2 files changed, 56 insertions(+), 33 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/nfc/nxp,pn544.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/nfc/pn544.txt
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/1542257


nfc@28: 'clock-frequency' does not match any of the regexes: 'pinctrl-[0-9]+'
	arch/arm/boot/dts/tegra30-asus-nexus7-grouper-E1565.dt.yaml
	arch/arm/boot/dts/tegra30-asus-nexus7-grouper-PM269.dt.yaml

nfc@2a: 'clock-frequency' does not match any of the regexes: 'pinctrl-[0-9]+'
	arch/arm/boot/dts/tegra30-asus-nexus7-tilapia-E1565.dt.yaml

