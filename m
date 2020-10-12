Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB4D28BD14
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 18:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390026AbgJLQAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 12:00:41 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:40950 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389771AbgJLQAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 12:00:41 -0400
Received: by mail-ot1-f65.google.com with SMTP id l4so16261663ota.7;
        Mon, 12 Oct 2020 09:00:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sKQvgCFfoUK383C3nmDjkaV64Iaz4htqCFpPTHjis94=;
        b=DVGuDgmr7+LBzZaET5scApmNjHjps1RWmBneflL8cIMP36vBlb4m88JvD1NrjbSbN7
         2e8hRxt6Fue9Z30muGGYssHYDSIJ2wzoPrJe9OmrCCXW8ChuiJ5s8xX8oEcDF0SvKM1W
         m4WNy2CcYnP3gL/9rCGnX0WeeH3+97SSfzjrRMze1DXpBOQUEb9M7frQBET8EfHqC4/w
         lvfJrKhGRfKWqeDq5L2Gr/7aUQ3bSRYf03k5Bdzmcscmrn6Mw7UGblXAZEhmo0NlZrXY
         QJ5uxjyntzkOeZf7PrqeJb4mGb3+QBqSslIzxyJjMhhQXPf/UEJ5Kxa2lZB3yB2+3a6i
         CUEA==
X-Gm-Message-State: AOAM533m2fRE2pMWHgqg35MZTdz4V8Ex0bGVKP5JRbQ6eriKayMPVBG9
        0XbqAQs45UNinatFOpWQFQ==
X-Google-Smtp-Source: ABdhPJxkLahxePnE9AL27oE1+P/rxoCNJR5P+a+QdCW4mRzABSit5agAwmV+5vq3bUnnU+pwFw6YXg==
X-Received: by 2002:a9d:3e4:: with SMTP id f91mr20173294otf.244.1602518440260;
        Mon, 12 Oct 2020 09:00:40 -0700 (PDT)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id k73sm8849333otk.63.2020.10.12.09.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 09:00:39 -0700 (PDT)
Received: (nullmailer pid 1622059 invoked by uid 1000);
        Mon, 12 Oct 2020 16:00:38 -0000
Date:   Mon, 12 Oct 2020 11:00:38 -0500
From:   Rob Herring <robh@kernel.org>
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2 2/4] dt-bindings: usb: add properties for hard wired
 devices
Message-ID: <20201012160038.GA1618651@bogus>
References: <3db52d534065dcf28e9a10b8129bea3eced0193e.1602318869.git.chunfeng.yun@mediatek.com>
 <bd71ed260efd162d25e0491988d61fcf1e589bc0.1602318869.git.chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd71ed260efd162d25e0491988d61fcf1e589bc0.1602318869.git.chunfeng.yun@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 04:43:12PM +0800, Chunfeng Yun wrote:
> Add some optional properties which are needed for hard wired devices
> 
> Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
> ---
> v2 changes suggested by Rob:
>    1. modify pattern to support any USB class
>    2. refer to usb-device.yaml instead of usb-device.txt
> ---
>  .../devicetree/bindings/usb/usb-hcd.yaml      | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)

You can fold this into the first patch. While not explicit before, it 
was implied.

Rob

> 
> diff --git a/Documentation/devicetree/bindings/usb/usb-hcd.yaml b/Documentation/devicetree/bindings/usb/usb-hcd.yaml
> index 7263b7f2b510..42b295afdf32 100644
> --- a/Documentation/devicetree/bindings/usb/usb-hcd.yaml
> +++ b/Documentation/devicetree/bindings/usb/usb-hcd.yaml
> @@ -22,9 +22,28 @@ properties:
>      description:
>        Name specifier for the USB PHY
>  
> +  "#address-cells":
> +    const: 1
> +
> +  "#size-cells":
> +    const: 0
> +
> +patternProperties:
> +  "^[a-f]+@[0-9a-f]+$":

Just define the unit-address here: "@[0-9a-f]+$"
> +    type: object
> +    $ref: /usb/usb-device.yaml
> +    description: The hard wired USB devices

Need to also define 'reg' and 'compatible' here.

> +
>  examples:
>    - |
>      usb {
>          phys = <&usb2_phy1>, <&usb3_phy1>;
>          phy-names = "usb";
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        hub@1 {
> +            compatible = "usb5e3,610";
> +            reg = <1>;
> +        };
>      };
> -- 
> 2.18.0
