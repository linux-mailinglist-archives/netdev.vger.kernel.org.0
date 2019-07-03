Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFE45ED4E
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 22:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfGCUOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 16:14:51 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39454 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727087AbfGCUOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 16:14:50 -0400
Received: by mail-wr1-f67.google.com with SMTP id x4so4180383wrt.6;
        Wed, 03 Jul 2019 13:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WBfRrtE2AUjJNR4gQtkNz6C4Ih4H5C4/HnLfvNurTLE=;
        b=m75QlRBhAxn2WVHWttp32A4fbPXuLCsrvUgVySGzABKtmbdv0cqa7TbWGaWQPu1xnP
         4GQwU12hhWmQTX6OEOY+br9Me+QXKmh7NEPsM7Vy2+16/qv0AlC5Av7g4yrqvWbFt9ZX
         w8zjVzas+0kxPDibtCPIhA3rQXnSQkHKcWja5yPvJS1ElUZ2/uwPaLT5fEFVHpuflXp8
         6v2VN2fDbtCNawiVyeZon2bABdHkA8U1UjcINQseIw0tCqj2uG2ufXhiSy6ZIDGpZjrW
         ApVkx6jUCK3RzoATfSn9El6m8BOYJDDxqItTOqxdZQjjEBt1VCu3M+FqB9QnV77YgnLL
         Z27w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WBfRrtE2AUjJNR4gQtkNz6C4Ih4H5C4/HnLfvNurTLE=;
        b=HMAyTA8lLMWTmhj7YCOi2xuBghH404LAREkoZnnwRNFwccayg1BTud/knXxqXjXdez
         6w4SM2/55t4wf7hrluMNQEU7Bs+bhbLMCTN+bYVRBOTKGuEJGI3WjNF+necmfKA3ZHmU
         wfOZ1pE/1+0ms8M2C12xKy6QesvSfI0ksOBI+4uaZyZPDLnZHsxfzohsELuOHBwcoE0g
         X3kelNTiHqndGIt+NXDYsfNRSrCquuckQJN3KWPSmEx35CCGMO1p6TL8XZ+MKJ11f+b4
         6xSCsVLBlFUWC0zNtDHpWwPP3zcg8iO/ZJaOxNmx4WcYsiwrySCyk8TP+ueo/mpurC1o
         Z43w==
X-Gm-Message-State: APjAAAXazkb/VhwzVF2dpru2mIMbF8Rr28thGr5FIPL12INieSrW1yOa
        Xgk4pQA6r2RR3gcI1pWG0Hw=
X-Google-Smtp-Source: APXvYqzZvKG/LNrrMgkl4hBygW/G0g6FMChhpeglD+mK4TjOgqKfe9gbhCEJwKd4cJHKyFdYTiGkgQ==
X-Received: by 2002:a5d:500f:: with SMTP id e15mr18914764wrt.41.1562184887930;
        Wed, 03 Jul 2019 13:14:47 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:4503:872e:8227:c4e0? (p200300EA8BD60C004503872E8227C4E0.dip0.t-ipconnect.de. [2003:ea:8bd6:c00:4503:872e:8227:c4e0])
        by smtp.googlemail.com with ESMTPSA id t80sm3548106wmt.26.2019.07.03.13.14.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 13:14:47 -0700 (PDT)
Subject: Re: [PATCH v2 6/7] dt-bindings: net: realtek: Add property to
 configure LED mode
To:     Matthias Kaehlcke <mka@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
References: <20190703193724.246854-1-mka@chromium.org>
 <20190703193724.246854-6-mka@chromium.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <e7fa2c8c-d53e-2480-d239-e2c0b362dc4f@gmail.com>
Date:   Wed, 3 Jul 2019 22:13:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190703193724.246854-6-mka@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.07.2019 21:37, Matthias Kaehlcke wrote:
> The LED behavior of some Realtek PHYs is configurable. Add the
> property 'realtek,led-modes' to specify the configuration of the
> LEDs.
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
> Changes in v2:
> - patch added to the series
> ---
>  .../devicetree/bindings/net/realtek.txt         |  9 +++++++++
>  include/dt-bindings/net/realtek.h               | 17 +++++++++++++++++
>  2 files changed, 26 insertions(+)
>  create mode 100644 include/dt-bindings/net/realtek.h
> 
> diff --git a/Documentation/devicetree/bindings/net/realtek.txt b/Documentation/devicetree/bindings/net/realtek.txt
> index 71d386c78269..40b0d6f9ee21 100644
> --- a/Documentation/devicetree/bindings/net/realtek.txt
> +++ b/Documentation/devicetree/bindings/net/realtek.txt
> @@ -9,6 +9,12 @@ Optional properties:
>  
>  	SSC is only available on some Realtek PHYs (e.g. RTL8211E).
>  
> +- realtek,led-modes: LED mode configuration.
> +
> +	A 0..3 element vector, with each element configuring the operating
> +	mode of an LED. Omitted LEDs are turned off. Allowed values are
> +	defined in "include/dt-bindings/net/realtek.h".
> +
>  Example:
>  
>  mdio0 {
> @@ -20,5 +26,8 @@ mdio0 {
>  		reg = <1>;
>  		realtek,eee-led-mode-disable;
>  		realtek,enable-ssc;
> +		realtek,led-modes = <RTL8211E_LINK_ACTIVITY
> +				     RTL8211E_LINK_100
> +				     RTL8211E_LINK_1000>;
>  	};
>  };
> diff --git a/include/dt-bindings/net/realtek.h b/include/dt-bindings/net/realtek.h
> new file mode 100644
> index 000000000000..8d64f58d58f8
> --- /dev/null
> +++ b/include/dt-bindings/net/realtek.h
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _DT_BINDINGS_REALTEK_H
> +#define _DT_BINDINGS_REALTEK_H
> +
> +/* LED modes for RTL8211E PHY */
> +
> +#define RTL8211E_LINK_10		1
> +#define RTL8211E_LINK_100		2
> +#define RTL8211E_LINK_1000		4
> +#define RTL8211E_LINK_10_100		3
> +#define RTL8211E_LINK_10_1000		5
> +#define RTL8211E_LINK_100_1000		6
> +#define RTL8211E_LINK_10_100_1000	7
> +
> +#define RTL8211E_LINK_ACTIVITY		(1 << 16)

I don't see where this is used.

> +
> +#endif
> 

