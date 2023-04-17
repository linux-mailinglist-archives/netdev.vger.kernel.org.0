Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C3F6E4632
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 13:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbjDQLRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 07:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbjDQLRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 07:17:31 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6043493EB;
        Mon, 17 Apr 2023 04:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681730195; x=1713266195;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+OV6QAPstFh42nYNRUk7hKpFpD9JDrBVvGjP7eZkvHc=;
  b=K7nuqbVWv0NbmaGBYSyx++mGIkQgs8aIoGqKb/HdKltsrYnES67l97LD
   Sef67m8c7l9R5A9CTBN3oXW3ZSE32URB4G868ujqWo234jdA4cMkKxu8Y
   5PyYDl3x10/a+4oYDMiWfDSpo5RwWQ6GPOCYoHPnVA6WYhRmtW4cPF+nI
   tHdfPH+f+386h72/KzxtnuCNZ5NkGHcTgeKVe4mfm0wCTUW30ai9XdYPW
   XrZxvnjMuLY0sOi2+fb+2FS1NO2rhjKiC45bt9gJtruJKHuYVIBX5Y0Ro
   igsaRpsdo4WsArw01GcY5SauhRmQJHoWUZchWtMK99kizXPZk9l+GVoSM
   w==;
X-IronPort-AV: E=Sophos;i="5.99,204,1677567600"; 
   d="scan'208";a="209385723"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Apr 2023 04:13:33 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 17 Apr 2023 04:13:33 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 17 Apr 2023 04:13:33 -0700
Date:   Mon, 17 Apr 2023 13:13:32 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Alain Volmat <avolmat@me.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        <patrice.chotard@foss.st.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dt-bindings: net: dwmac: sti: remove
 stih415/sti416/stid127
Message-ID: <20230417111332.fcmkgtzdireraet7@soft-dev3-1>
References: <20230416195857.61284-1-avolmat@me.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230416195857.61284-1-avolmat@me.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/16/2023 21:58, Alain Volmat wrote:
> 
> Remove compatible for stih415/stih416 and stid127 which are
> no more supported.

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> 
> Signed-off-by: Alain Volmat <avolmat@me.com>
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
> Patch previously sent as part of serie: https://lore.kernel.org/all/20230209091659.1409-9-avolmat@me.com/
> 
>  Documentation/devicetree/bindings/net/sti-dwmac.txt | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/sti-dwmac.txt b/Documentation/devicetree/bindings/net/sti-dwmac.txt
> index 062c5174add3..42cd075456ab 100644
> --- a/Documentation/devicetree/bindings/net/sti-dwmac.txt
> +++ b/Documentation/devicetree/bindings/net/sti-dwmac.txt
> @@ -7,8 +7,7 @@ and what is needed on STi platforms to program the stmmac glue logic.
>  The device node has following properties.
> 
>  Required properties:
> - - compatible  : Can be "st,stih415-dwmac", "st,stih416-dwmac",
> -   "st,stih407-dwmac", "st,stid127-dwmac".
> + - compatible  : "st,stih407-dwmac"
>   - st,syscon : Should be phandle/offset pair. The phandle to the syscon node which
>     encompases the glue register, and the offset of the control register.
>   - st,gmac_en: this is to enable the gmac into a dedicated sysctl control
> --
> 2.34.1
> 

-- 
/Horatiu
