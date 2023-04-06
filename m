Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC076D8FD5
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 08:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235732AbjDFGzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 02:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235705AbjDFGy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 02:54:59 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF4AAD09;
        Wed,  5 Apr 2023 23:54:33 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 3366sIPm100035;
        Thu, 6 Apr 2023 01:54:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1680764058;
        bh=v+uscHIJUtjNPid3oUE4ixMM5r8S9AuEpMcESFmmVcA=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=pZiIO7/CHHfD2BnFwzjGqSO65P7XDMjWiOhReTa4ZoXjJqUD20pildmKCWtrxlLJV
         hoeisNQjlExLtIVTHSyzk11r5pfXtHPJVCF4+5HSykiyH7tvb5g3Q5Fw3lqlNvi8R8
         QaulBt3PG5j1awyHQZHvF92jonb2olR8sKOJvC9w=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 3366sIaS116965
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 6 Apr 2023 01:54:18 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Thu, 6
 Apr 2023 01:54:18 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Thu, 6 Apr 2023 01:54:18 -0500
Received: from [10.24.69.114] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 3366sCca000927;
        Thu, 6 Apr 2023 01:54:13 -0500
Message-ID: <86ee5333-6d65-d28b-0dd5-40dfe485d48b@ti.com>
Date:   Thu, 6 Apr 2023 12:24:12 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v7 0/4] Introduce PRU platform consumer API
To:     MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>
CC:     <linux-remoteproc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <srk@ti.com>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20230404115336.599430-1-danishanwar@ti.com>
Content-Language: en-US
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <20230404115336.599430-1-danishanwar@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-3.9 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/04/23 17:23, MD Danish Anwar wrote:
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
> This is the v7 of the old patch series [9].
> 

Hi Mathieu, Can you please review this series. I have addressed comments made
by you in v5. I have also addressed Simon's comment in v6 and removed redundant
macros from pruss.h header file.

> Changes from v6 [9] to v7:
> *) Addressed Simon's comment on patch 3 of this series and dropped unnecassary
> macros from the patch.
> 
> Changes from v5 [1] to v6:
> *) Added Reviewed by tags of Roger and Tony to the patches.
> *) Added Acked by tag of Mathieu to patch 2 of this series.
> *) Added NULL check for @mux in pruss_cfg_get_gpmux() API.
> *) Added comment to the pruss_get() function documentation mentioning it is
> expected the caller will have done a pru_rproc_get() on @rproc.
> *) Fixed compilation warning "warning: ‘pruss_cfg_update’ defined but not used"
> in patch 3 by squashing patch 3 [7] and patch 5 [8] of previous revision
> together. Squashed patch 5 instead of patch 4 with patch 3 because patch 5 uses
> both read() and update() APIs where as patch 4 only uses update() API.
> Previously pruss_cfg_read()/update() APIs were intoroduced in patch 3
> and used in patch 4 and 5. Now these APIs are introduced as well as used in 
> patch 3.
> 


-- 
Thanks and Regards,
Danish.
