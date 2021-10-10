Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2738E428362
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 21:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbhJJTeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 15:34:08 -0400
Received: from mail-oi1-f173.google.com ([209.85.167.173]:40672 "EHLO
        mail-oi1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbhJJTeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 15:34:04 -0400
Received: by mail-oi1-f173.google.com with SMTP id n63so21629448oif.7;
        Sun, 10 Oct 2021 12:32:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=vjkhCUUdOAJupIZyq/RaQw7WVueC2al6gsubBxanD5I=;
        b=7NHNJL8Qfxp/u3FeFaLxuhxe6xxaVhveExiZKeb/XkUafwUTAIocuegzTldKeOT1s/
         82z656Z/AIQPedaZtLjdNlDOzKssQtawFjvFnk6RjZeDx5ymYeFWRkpPvrsB/eGdQty4
         xZx8Lv92paL08dzteDAs8tE9nRgDZXZTTDk+x50HCUnw6ftB9q1trqSUuJhAiePUGtYr
         XtPBix+JRU6S0+VSNhG7GmDGYVt2LaBUTE06/gNua4aZtnZebgUtEeAWGIzL7pbRJxjm
         OYAPOCd5tfiVilX7ilETMhlxrt8zAGqDg2kdAHSfPiexMadSVJZ3V9GiEu0oYg28aRvW
         UtSA==
X-Gm-Message-State: AOAM530Odu54rCmONbaY83XvcdlnQTZfZm/Yzehv4EpggVQCHINsmDDr
        ++AlLWuGnK9cT1uxngxmusSfW0k1jg==
X-Google-Smtp-Source: ABdhPJy0WCsod6NuMiAjXjV0rTr2RY2zZMYRxOxUmNioDXahaWss/NoaFhv5uK8Lr7zpSwrT8Tw0Kw==
X-Received: by 2002:a05:6808:1387:: with SMTP id c7mr15156081oiw.151.1633894325291;
        Sun, 10 Oct 2021 12:32:05 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id s18sm1267425oij.3.2021.10.10.12.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 12:32:04 -0700 (PDT)
Received: (nullmailer pid 3158672 invoked by uid 1000);
        Sun, 10 Oct 2021 19:31:56 -0000
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     linux-nfc@lists.01.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Charles Gorand <charles.gorand@effinnov.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <20211010142317.168259-6-krzysztof.kozlowski@canonical.com>
References: <20211010142317.168259-1-krzysztof.kozlowski@canonical.com> <20211010142317.168259-6-krzysztof.kozlowski@canonical.com>
Subject: Re: [PATCH 6/7] dt-bindings: nfc: ti,trf7970a: convert to dtschema
Date:   Sun, 10 Oct 2021 14:31:56 -0500
Message-Id: <1633894316.452946.3158671.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 Oct 2021 16:23:16 +0200, Krzysztof Kozlowski wrote:
> Convert the TI TRF7970A NFC to DT schema format.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  .../bindings/net/nfc/ti,trf7970a.yaml         | 98 +++++++++++++++++++
>  .../devicetree/bindings/net/nfc/trf7970a.txt  | 43 --------
>  MAINTAINERS                                   |  2 +-
>  3 files changed, 99 insertions(+), 44 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/nfc/ti,trf7970a.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/nfc/trf7970a.txt
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/1539014


nfc@0: 't5t-rmb-extra-byte-quirk', 'vin-voltage-override' do not match any of the regexes: 'pinctrl-[0-9]+'
	arch/arm/boot/dts/imx6dl-prtrvt.dt.yaml

