Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789A428BC04
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 17:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390093AbgJLPeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 11:34:11 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:38802 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390076AbgJLPeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 11:34:11 -0400
Received: by mail-oi1-f194.google.com with SMTP id h10so6447418oie.5;
        Mon, 12 Oct 2020 08:34:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yH7pwuj6aDPry47UxD5seXqTX0RCln/LrihgtVI0KrI=;
        b=Re9pUUYPsUwbyQPGPuxsaP3QyjF6tZOLjyovGY56zdB08ik15EUU9lz6ky4rSj+LxO
         xJtrHnBC5M15GpraUibNJW/vJbR+zagGHsDS6Ylm685OttOOYXR/OaZ45sSPwDHDK0vu
         2jbErMgQfL4AoPdN8cf1L2cHmdSSUeuqLw1V/1VcL2DqpK3zxPR5C5OnauVb/MhwXXn5
         dYxLKtDz/xwu66r1ra2zzB5NyCURtBhOFNvPIOGJhi/8xLPDZbs9TUIv2sSSk5AMpIyL
         qTOGZq6CcDjHFgJ+ZpyAyGTq/+smbfqgCcxsXZiRRB4sDATFBIpiLJ216H1HxYP1VoY9
         sp9A==
X-Gm-Message-State: AOAM531vvU/XVm3VnEZjL5YO0HHF8hne36yojRsrdARH9PfbMvveyyB+
        e8TIM1ZF8JlGlcS8Lb4VPOuvQa8UQfdk
X-Google-Smtp-Source: ABdhPJxdhAZwzIPrUakClUoKKQgxW4+bRdUuktTipl2x2JvJ74I2wXS5IDDG8BnmrxssZxJf8oQDcA==
X-Received: by 2002:aca:f40b:: with SMTP id s11mr10554362oih.66.1602516849115;
        Mon, 12 Oct 2020 08:34:09 -0700 (PDT)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id p4sm1065874oib.9.2020.10.12.08.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 08:34:08 -0700 (PDT)
Received: (nullmailer pid 1589228 invoked by uid 1000);
        Mon, 12 Oct 2020 15:34:07 -0000
Date:   Mon, 12 Oct 2020 10:34:07 -0500
From:   Rob Herring <robh@kernel.org>
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] dt-bindings: usb: convert usb-device.txt to YAML
 schema
Message-ID: <20201012153407.GA1588894@bogus>
References: <3db52d534065dcf28e9a10b8129bea3eced0193e.1602318869.git.chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3db52d534065dcf28e9a10b8129bea3eced0193e.1602318869.git.chunfeng.yun@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Oct 2020 16:43:11 +0800, Chunfeng Yun wrote:
> Convert usb-device.txt to YAML schema usb-device.yaml
> 
> Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
> ---
> v2: new patch suggested by Rob
> ---
>  .../devicetree/bindings/usb/usb-device.txt    | 102 --------------
>  .../devicetree/bindings/usb/usb-device.yaml   | 129 ++++++++++++++++++
>  2 files changed, 129 insertions(+), 102 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/usb/usb-device.txt
>  create mode 100644 Documentation/devicetree/bindings/usb/usb-device.yaml
> 


My bot found errors running 'make dt_binding_check' on your patch:

/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/media/amlogic,meson-gx-ao-cec.example.dt.yaml: cec@100: compatible:0: 'amlogic,meson-gx-ao-cec' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/media/amlogic,meson-gx-ao-cec.example.dt.yaml: cec@100: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/media/st,stm32-cec.example.dt.yaml: cec@40006c00: compatible:0: 'st,stm32-cec' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/media/st,stm32-cec.example.dt.yaml: cec@40006c00: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/regulator/google,cros-ec-regulator.example.dt.yaml: ec@0: compatible:0: 'google,cros-ec-spi' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/regulator/google,cros-ec-regulator.example.dt.yaml: ec@0: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/regulator/qcom,usb-vbus-regulator.example.dt.yaml: dcdc@1100: compatible:0: 'qcom,pm8150b-vbus-reg' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/regulator/qcom,usb-vbus-regulator.example.dt.yaml: dcdc@1100: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/chrome/google,cros-ec-typec.example.dt.yaml: ec@0: compatible:0: 'google,cros-ec-spi' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/chrome/google,cros-ec-typec.example.dt.yaml: ec@0: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/dac/lltc,ltc1660.example.dt.yaml: dac@0: compatible:0: 'lltc,ltc1660' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/dac/lltc,ltc1660.example.dt.yaml: dac@0: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/dac/st,stm32-dac.example.dt.yaml: dac@40017000: compatible:0: 'st,stm32h7-dac-core' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/dac/st,stm32-dac.example.dt.yaml: dac@40017000: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/dac/st,stm32-dac.example.dt.yaml: dac@1: compatible:0: 'st,stm32-dac' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/dac/st,stm32-dac.example.dt.yaml: dac@1: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/dac/st,stm32-dac.example.dt.yaml: dac@2: compatible:0: 'st,stm32-dac' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/dac/st,stm32-dac.example.dt.yaml: dac@2: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/microchip,mcp3911.example.dt.yaml: adc@0: compatible:0: 'microchip,mcp3911' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/microchip,mcp3911.example.dt.yaml: adc@0: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/ingenic,adc.example.dt.yaml: adc@10070000: compatible:0: 'ingenic,jz4740-adc' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/ingenic,adc.example.dt.yaml: adc@10070000: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/adi,ad7192.example.dt.yaml: adc@0: compatible:0: 'adi,ad7192' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/adi,ad7192.example.dt.yaml: adc@0: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/samsung,exynos-adc.example.dt.yaml: adc@12d10000: compatible:0: 'samsung,exynos-adc-v1' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/samsung,exynos-adc.example.dt.yaml: adc@12d10000: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/samsung,exynos-adc.example.dt.yaml: adc@126c0000: compatible:0: 'samsung,exynos3250-adc' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/samsung,exynos-adc.example.dt.yaml: adc@126c0000: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/adi,ad7923.example.dt.yaml: adc@0: compatible:0: 'adi,ad7928' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/adi,ad7923.example.dt.yaml: adc@0: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/maxim,max1241.example.dt.yaml: adc@0: compatible:0: 'maxim,max1241' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/maxim,max1241.example.dt.yaml: adc@0: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/adi,ad9467.example.dt.yaml: adc@0: compatible:0: 'adi,ad9467' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/adi,ad9467.example.dt.yaml: adc@0: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.example.dt.yaml: adc@40012000: compatible:0: 'st,stm32f4-adc-core' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.example.dt.yaml: adc@40012000: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.example.dt.yaml: adc@0: compatible:0: 'st,stm32f4-adc' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.example.dt.yaml: adc@0: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.example.dt.yaml: adc@48003000: compatible:0: 'st,stm32mp1-adc-core' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.example.dt.yaml: adc@48003000: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.example.dt.yaml: adc@0: compatible:0: 'st,stm32mp1-adc' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.example.dt.yaml: adc@0: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/adi,ad7292.example.dt.yaml: adc@0: compatible:0: 'adi,ad7292' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/adi,ad7292.example.dt.yaml: adc@0: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/adi,ad7606.example.dt.yaml: adc@0: compatible:0: 'adi,ad7606-8' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/adi,ad7606.example.dt.yaml: adc@0: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/adi,ad7780.example.dt.yaml: adc@0: compatible:0: 'adi,ad7780' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/adi,ad7780.example.dt.yaml: adc@0: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/maxim,max1238.example.dt.yaml: adc@36: compatible:0: 'maxim,max1238' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/maxim,max1238.example.dt.yaml: adc@36: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/maxim,max1363.example.dt.yaml: adc@36: compatible:0: 'maxim,max1363' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/maxim,max1363.example.dt.yaml: adc@36: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/ti,ads8688.example.dt.yaml: adc@0: compatible:0: 'ti,ads8688' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/ti,ads8688.example.dt.yaml: adc@0: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/lltc,ltc2496.example.dt.yaml: adc@0: compatible:0: 'lltc,ltc2496' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/lltc,ltc2496.example.dt.yaml: adc@0: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/adi,ad7091r5.example.dt.yaml: adc@2f: compatible:0: 'adi,ad7091r5' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/adi,ad7091r5.example.dt.yaml: adc@2f: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/adi,ad7124.example.dt.yaml: adc@0: compatible:0: 'adi,ad7124-4' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/adi,ad7124.example.dt.yaml: adc@0: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.example.dt.yaml: adc@3100: compatible:0: 'qcom,spmi-vadc' does not match '^usb[0-9a-f]+,[0-9a-f]+$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.example.dt.yaml: adc@3100: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/temperature/adi,ltc2983.example.dt.yaml: adc@10: 'compatile' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/usb/usb-device.yaml


See https://patchwork.ozlabs.org/patch/1379982

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure dt-schema is up to date:

pip3 install git+https://github.com/devicetree-org/dt-schema.git@master --upgrade

Please check and re-submit.

