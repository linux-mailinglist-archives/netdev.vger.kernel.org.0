Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489DF432842
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 22:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbhJRUSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 16:18:45 -0400
Received: from mail-ot1-f50.google.com ([209.85.210.50]:38608 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233582AbhJRUSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 16:18:45 -0400
Received: by mail-ot1-f50.google.com with SMTP id l10-20020a056830154a00b00552b74d629aso8909otp.5;
        Mon, 18 Oct 2021 13:16:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DkTccuyX6WdyCpMvIoMZf6lk42lmBP8Qsa+heaznsnE=;
        b=Kvg5PKz7YiL3Qmr2ogeifdb+/fWZCRcdOCHWBHG6POmekHE1ppvTYp/15Oq2b89/J3
         hMfbsSUx6BjO73veBU4shnITFmvRN+qnfNq/tr95KqAR19sfjvcPJRwuCjMfmEGmgxHK
         1keP3hbsYqdraVKgm3G/bORz+lq2VPQDgWSwq0McARflQbxN4XPh505r6pmB+z8yqSbT
         J8aZ/pWNtKn2EyI7clv2aD27m06Wt7OlkjuREbN8Hh3Zx/A4wjmVB7/9ey32pM6sBjhG
         A6yzF7kkr9NV8l1pdx21IZG+4+A975Hti2zU18dpIDMpWz77H1rIbkjyhA1Qj3K4XVN4
         GN5g==
X-Gm-Message-State: AOAM532sighfduR+Vwwf33BnJx1+XFCjJIKIt7Qqv/Xo/l/qLaeFwJGW
        /QJKW5Lb8/LwXK51XntIxQ==
X-Google-Smtp-Source: ABdhPJzodzpX7xmy9vqoF35BJCHRxREFXB9bcBEonI7F8Wv8Y9lo5MDmgxJLE+bDN3z1euPcD0J+aA==
X-Received: by 2002:a9d:3e17:: with SMTP id a23mr1729719otd.46.1634588192775;
        Mon, 18 Oct 2021 13:16:32 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id bp21sm3116630oib.31.2021.10.18.13.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 13:16:32 -0700 (PDT)
Received: (nullmailer pid 2882555 invoked by uid 1000);
        Mon, 18 Oct 2021 20:16:31 -0000
Date:   Mon, 18 Oct 2021 15:16:31 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Charles Gorand <charles.gorand@effinnov.com>,
        None@robh.at.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 3/8] dt-bindings: nfc: nxp,pn532: convert to dtschema
Message-ID: <YW3WH3bKPeaF1Ww1@robh.at.kernel.org>
References: <20211011073934.34340-1-krzysztof.kozlowski@canonical.com>
 <20211011073934.34340-4-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011073934.34340-4-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Oct 2021 09:39:29 +0200, Krzysztof Kozlowski wrote:
> Convert the NXP PN532 NFC controller to DT schema format.
> 
> Drop the "clock-frequency" property during conversion because it is a
> property of I2C bus controller, not I2C slave device.  It was also never
> used by the driver.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  .../bindings/net/nfc/nxp,pn532.yaml           | 65 +++++++++++++++++++
>  .../devicetree/bindings/net/nfc/pn532.txt     | 46 -------------
>  2 files changed, 65 insertions(+), 46 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/nfc/nxp,pn532.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/nfc/pn532.txt
> 

Applied, thanks!
