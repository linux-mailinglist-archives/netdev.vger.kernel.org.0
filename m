Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED8A59F2F8
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 07:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbiHXFHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 01:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiHXFHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 01:07:35 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3ECB696FB;
        Tue, 23 Aug 2022 22:07:34 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 27O57IFL098057;
        Wed, 24 Aug 2022 00:07:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1661317638;
        bh=3uOkvUlu5GoWke75BGaH9SEPMxOBvvWpvt1lpr3l0RM=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=FM2/jVEVx7cddXHGRXrkjfn9pXOiFQLHAuS+72GCt1recDhcF2Mbcr33Rnant6zUW
         R2U4bY016RA5WQ+nwjasSv8rl2PABJZsE2UAvzPfwLm8wROhMyikJcM5UncbLBmMC2
         lmCs96DL+t3AXJIDlcwJNrn/ACM83VOXAZPKEcDM=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 27O57I1Y016301
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 24 Aug 2022 00:07:18 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Wed, 24
 Aug 2022 00:07:18 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Wed, 24 Aug 2022 00:07:18 -0500
Received: from [10.24.69.79] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 27O57ELd057025;
        Wed, 24 Aug 2022 00:07:15 -0500
Message-ID: <54b0435b-3aa6-d6c7-9411-818205b9ac71@ti.com>
Date:   Wed, 24 Aug 2022 10:37:14 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [EXTERNAL] [PATCH net-next] net: ethernet: ti: davinci_mdio: fix
 build for mdio bitbang uses
Content-Language: en-US
To:     Randy Dunlap <rdunlap@infradead.org>, <netdev@vger.kernel.org>
CC:     Grygorii Strashko <grygorii.strashko@ti.com>,
        <linux-omap@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
References: <20220824024216.4939-1-rdunlap@infradead.org>
From:   Ravi Gunasekaran <r-gunasekaran@ti.com>
In-Reply-To: <20220824024216.4939-1-rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Randy,


On 24/08/22 8:12 am, Randy Dunlap wrote:
> davinci_mdio.c uses mdio bitbang APIs, so it should select
> MDIO_BITBANG to prevent build errors.
> 
> arm-linux-gnueabi-ld: drivers/net/ethernet/ti/davinci_mdio.o: in function `davinci_mdio_remove':
> drivers/net/ethernet/ti/davinci_mdio.c:649: undefined reference to `free_mdio_bitbang'
> arm-linux-gnueabi-ld: drivers/net/ethernet/ti/davinci_mdio.o: in function `davinci_mdio_probe':
> drivers/net/ethernet/ti/davinci_mdio.c:545: undefined reference to `alloc_mdio_bitbang'
> arm-linux-gnueabi-ld: drivers/net/ethernet/ti/davinci_mdio.o: in function `davinci_mdiobb_read':
> drivers/net/ethernet/ti/davinci_mdio.c:236: undefined reference to `mdiobb_read'
> arm-linux-gnueabi-ld: drivers/net/ethernet/ti/davinci_mdio.o: in function `davinci_mdiobb_write':
> drivers/net/ethernet/ti/davinci_mdio.c:253: undefined reference to `mdiobb_write'
> 
> Fixes: d04807b80691 ("net: ethernet: ti: davinci_mdio: Add workaround for errata i2329")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Grygorii Strashko <grygorii.strashko@ti.com>
> Cc: Ravi Gunasekaran <r-gunasekaran@ti.com>
> Cc: linux-omap@vger.kernel.org
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
> Cc: Sudip Mukherjee (Codethink) <sudipm.mukherjee@gmail.com>
> ---
>   drivers/net/ethernet/ti/Kconfig |    1 +
>   1 file changed, 1 insertion(+)
> 
> --- a/drivers/net/ethernet/ti/Kconfig
> +++ b/drivers/net/ethernet/ti/Kconfig
> @@ -33,6 +33,7 @@ config TI_DAVINCI_MDIO
>   	tristate "TI DaVinci MDIO Support"
>   	depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || ARCH_KEYSTONE || ARCH_K3 || COMPILE_TEST
>   	select PHYLIB
> +	select MDIO_BITBANG
>   	help
>   	  This driver supports TI's DaVinci MDIO module.
>   
Thanks for posting this patch before me.

-- 
Regards,
Ravi
