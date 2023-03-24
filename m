Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 920B96C788D
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 08:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbjCXHN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 03:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjCXHN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 03:13:58 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB540D532;
        Fri, 24 Mar 2023 00:13:56 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32O7Dg2L053422;
        Fri, 24 Mar 2023 02:13:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1679642022;
        bh=ETyhzSkLMiBhoJJwftNzHfxbMQGF3UJPiIcYUOTMfoo=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=FELYO/Lf7I+Cevm4rqmagustqteOQbpDwaJIdp3/NlDM1dnil5keOnE3sozCA40eZ
         j2eZYIVenidTzkVbfKIFGfpAXqUDmT+WknpD8+lcUhVH+CDKZEUDsB9ohf8NVbEMy8
         zWJKQnWp3/GB7wNEU62OcIppp/9H095V+oxHsu8w=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32O7Dge5000485
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 24 Mar 2023 02:13:42 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Fri, 24
 Mar 2023 02:13:41 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Fri, 24 Mar 2023 02:13:41 -0500
Received: from [10.24.69.114] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32O7Da1n072365;
        Fri, 24 Mar 2023 02:13:37 -0500
Message-ID: <4c9276e4-0c00-d2e9-bf9d-08cc73a75b6f@ti.com>
Date:   Fri, 24 Mar 2023 12:43:36 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v5 0/5] Introduce PRU platform consumer API
Content-Language: en-US
To:     Mathieu Poirier <mathieu.poirier@linaro.org>,
        MD Danish Anwar <danishanwar@ti.com>
CC:     <linux-remoteproc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <srk@ti.com>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>, Tero Kristo <kristo@kernel.org>,
        Roger Quadros <rogerq@kernel.org>,
        "Andrew F. Davis" <afd@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Suman Anna <s-anna@ti.com>,
        Bjorn Andersson <andersson@kernel.org>
References: <20230323062451.2925996-1-danishanwar@ti.com>
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <20230323062451.2925996-1-danishanwar@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mathieu,

On 23/03/23 11:54, MD Danish Anwar wrote:
> Hi All,
> The Programmable Real-Time Unit and Industrial Communication Subsystem (PRU-ICSS
> or simply PRUSS) on various TI SoCs consists of dual 32-bit RISC cores
> (Programmable Real-Time Units, or PRUs) for program execution.
> 
> There are 3 foundation components for TI PRUSS subsystem: the PRUSS platform
> driver, the PRUSS INTC driver and the PRUSS remoteproc driver. All of them have
> already been merged and can be found under:
> 1) drivers/soc/ti/pruss.c
>    Documentation/devicetree/bindings/soc/ti/ti,pruss.yaml
> 2) drivers/irqchip/irq-pruss-intc.c
>    Documentation/devicetree/bindings/interrupt-controller/ti,pruss-intc.yaml
> 3) drivers/remoteproc/pru_rproc.c
>    Documentation/devicetree/bindings/remoteproc/ti,pru-consumer.yaml
> 
> The programmable nature of the PRUs provide flexibility to implement custom
> peripheral interfaces, fast real-time responses, or specialized data handling.
> Example of a PRU consumer drivers will be: 
>   - Software UART over PRUSS
>   - PRU-ICSS Ethernet EMAC
> 
> In order to make usage of common PRU resources and allow the consumer drivers 
> to configure the PRU hardware for specific usage the PRU API is introduced.
>
Roger has given his RBs for all the patches in this series. Tony has also given
his RB.

Can you please have a look at this series.

-- 
Thanks and Regards,
Danish.
