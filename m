Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F7536B108
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 11:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbhDZJud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 05:50:33 -0400
Received: from regular1.263xmail.com ([211.150.70.198]:48262 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbhDZJuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 05:50:32 -0400
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Apr 2021 05:50:31 EDT
Received: from localhost (unknown [192.168.167.69])
        by regular1.263xmail.com (Postfix) with ESMTP id 1C056760;
        Mon, 26 Apr 2021 17:49:49 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-ANTISPAM-LEVEL: 2
X-SKE-CHECKED: 1
X-ABS-CHECKED: 1
Received: from [172.16.12.8] (unknown [58.22.7.114])
        by smtp.263.net (postfix) whith ESMTP id P19994T140046592108288S1619430587182149_;
        Mon, 26 Apr 2021 17:49:48 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <e95a8b415f5e16b8e0881a892c3347bd>
X-RL-SENDER: david.wu@rock-chips.com
X-SENDER: wdc@rock-chips.com
X-LOGIN-NAME: david.wu@rock-chips.com
X-FST-TO: kernel@collabora.com
X-RCPT-COUNT: 13
X-SENDER-IP: 58.22.7.114
X-ATTACHMENT-NUM: 0
X-System-Flag: 0
Subject: Re: [PATCH 2/3] dt-bindings: net: dwmac: Add Rockchip DWMAC support
To:     Ezequiel Garcia <ezequiel@collabora.com>, netdev@vger.kernel.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>,
        Johan Jonker <jbx6244@gmail.com>, kernel@collabora.com
References: <20210426024118.18717-1-ezequiel@collabora.com>
 <20210426024118.18717-2-ezequiel@collabora.com>
From:   David Wu <david.wu@rock-chips.com>
Message-ID: <c82d5147-3545-03d5-47cc-cc93161d3414@rock-chips.com>
Date:   Mon, 26 Apr 2021 17:49:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210426024118.18717-2-ezequiel@collabora.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ezequiel,

Good work,  this is what I plan to do.
Thank you.

Reviewed-by: David Wu <david.wu@rock-chips.com>

ÔÚ 2021/4/26 ÉÏÎç10:41, Ezequiel Garcia Ð´µÀ:
> Add Rockchip DWMAC controllers, which are based on snps,dwmac.
> Some of the SoCs require up to eight clocks, so maxItems
> for clocks and clock-names need to be increased.
> 
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>   .../devicetree/bindings/net/snps,dwmac.yaml         | 13 +++++++++++--
>   1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index 0642b0f59491..2edd8bea993e 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -56,6 +56,15 @@ properties:
>           - amlogic,meson8m2-dwmac
>           - amlogic,meson-gxbb-dwmac
>           - amlogic,meson-axg-dwmac
> +        - rockchip,px30-gmac
> +        - rockchip,rk3128-gmac
> +        - rockchip,rk3228-gmac
> +        - rockchip,rk3288-gmac
> +        - rockchip,rk3328-gmac
> +        - rockchip,rk3366-gmac
> +        - rockchip,rk3368-gmac
> +        - rockchip,rk3399-gmac
> +        - rockchip,rv1108-gmac
>           - snps,dwmac
>           - snps,dwmac-3.50a
>           - snps,dwmac-3.610
> @@ -89,7 +98,7 @@ properties:
>   
>     clocks:
>       minItems: 1
> -    maxItems: 5
> +    maxItems: 8
>       additionalItems: true
>       items:
>         - description: GMAC main clock
> @@ -101,7 +110,7 @@ properties:
>   
>     clock-names:
>       minItems: 1
> -    maxItems: 5
> +    maxItems: 8
>       additionalItems: true
>       contains:
>         enum:
> 


