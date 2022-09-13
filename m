Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 810EC5B6CCC
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 14:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbiIMMKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 08:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbiIMMJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 08:09:57 -0400
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87601140A9;
        Tue, 13 Sep 2022 05:09:53 -0700 (PDT)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-127f5411b9cso31491741fac.4;
        Tue, 13 Sep 2022 05:09:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=kNXciWA6BqdgfNcUPpkPpH5Ss8dwhE8tUSEE2Y2K5zI=;
        b=N7jWvy57UMsnkdIfAyAD5u+DY8DjhnDMTirUpP1Hd0QRc+uAFtr+RtTfH5BLYr1bos
         dCfsEafyMSHSmBGu0dIyjRu8qK8/Lk8pE2RlxHuuiD6CccG5ad05EMhsuEDf/n8dw3cX
         8HUXBczA+RrUB6wDIP4sPnX0ubjhWR5Dz9JGlBVkrQ+wu7ic+GY6QIRGPMKYcTqLJblD
         wR6n5VEzKHNRa1HKExbyiHvTGGf7O9uiPSr2zh3cwFfB9aMGQvKB3HOOO/aXtyLwrz1/
         4qA+JkT6D0sK0vhfFjTVE8Y6EuYzBTaVhdUM58seapuqhFGj3GKj5JQGVklJ4wHTm165
         KjeQ==
X-Gm-Message-State: ACgBeo3jOf2k/TFhvK6XjcOgXE4rBLeGHCmJnd4HoVIC6mLB44VwBJi3
        COfEXrIh0AsaIEtL9ZEi7w==
X-Google-Smtp-Source: AA6agR5fZkyuOciAWUtELSCP3YTFTV07Zglo2sV7ZS9BdibB4YNvxHRswAOzTZuQE7Lzs2KdWa6ZNA==
X-Received: by 2002:a05:6808:10d4:b0:344:f380:cf8c with SMTP id s20-20020a05680810d400b00344f380cf8cmr1408701ois.27.1663070992324;
        Tue, 13 Sep 2022 05:09:52 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id a4-20020a9d5c84000000b006370b948974sm5766977oti.32.2022.09.13.05.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 05:09:51 -0700 (PDT)
Received: (nullmailer pid 3410040 invoked by uid 1000);
        Tue, 13 Sep 2022 12:09:50 -0000
Date:   Tue, 13 Sep 2022 07:09:50 -0500
From:   Rob Herring <robh@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 01/12] arm64: dts: mediatek: mt7986: add support
 for Wireless Ethernet Dispatch
Message-ID: <20220913120950.GA3397630-robh@kernel.org>
References: <cover.1662661555.git.lorenzo@kernel.org>
 <e034b4b71437bce747b128382f1504d5cdc6974b.1662661555.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e034b4b71437bce747b128382f1504d5cdc6974b.1662661555.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 08, 2022 at 09:33:35PM +0200, Lorenzo Bianconi wrote:
> Introduce wed0 and wed1 nodes in order to enable offloading forwarding
> between ethernet and wireless devices on the mt7986 chipset.
> 
> Co-developed-by: Bo Jiao <Bo.Jiao@mediatek.com>
> Signed-off-by: Bo Jiao <Bo.Jiao@mediatek.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
> index e3a407d03551..419d056b8369 100644
> --- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
> +++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
> @@ -222,6 +222,25 @@ ethsys: syscon@15000000 {
>  			 #reset-cells = <1>;
>  		};
>  
> +		wed_pcie: wed_pcie@10003000 {
> +			compatible = "mediatek,wed";

This is undocumented. It needs a binding.

> +			reg = <0 0x10003000 0 0x10>;
> +		};
> +
> +		wed0: wed@15010000 {
> +			compatible = "mediatek,wed", "syscon";

Some are syscon's and some are not?

> +			reg = <0 0x15010000 0 0x1000>;
> +			interrupt-parent = <&gic>;
> +			interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
> +		};
> +
> +		wed1: wed@15011000 {
> +			compatible = "mediatek,wed", "syscon";
> +			reg = <0 0x15011000 0 0x1000>;
> +			interrupt-parent = <&gic>;
> +			interrupts = <GIC_SPI 206 IRQ_TYPE_LEVEL_HIGH>;
> +		};
> +
>  		eth: ethernet@15100000 {
>  			compatible = "mediatek,mt7986-eth";
>  			reg = <0 0x15100000 0 0x80000>;
> @@ -256,6 +275,7 @@ eth: ethernet@15100000 {
>  						 <&apmixedsys CLK_APMIXED_SGMPLL>;
>  			mediatek,ethsys = <&ethsys>;
>  			mediatek,sgmiisys = <&sgmiisys0>, <&sgmiisys1>;
> +			mediatek,wed = <&wed0>, <&wed1>;
>  			#reset-cells = <1>;
>  			#address-cells = <1>;
>  			#size-cells = <0>;
> -- 
> 2.37.3
> 
> 
