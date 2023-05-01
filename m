Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96B4D6F333B
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 17:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbjEAPzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 11:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232878AbjEAPy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 11:54:56 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED3B1727;
        Mon,  1 May 2023 08:54:50 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 341FsTPV098494;
        Mon, 1 May 2023 10:54:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1682956469;
        bh=4coXDpE0/Y5EQZ9gowVWKeuRdJ9toGycs3TMmHan6v4=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=nFmrLDZ/IrJtzFdnLS5d0N5RSmbZFPLp9RakxxOvs9j1H6in8m6uMn9cPnAyLbJ+H
         1SVn4+igCSeAKLhv/8l5mCxrxkFKym6/EPdy44GKDTCFxf8E3iXJNCjWdolSBfQujv
         hSyd8p8Wv92rFUh3ym2zMDw1kGSpmkp+L/Gav9dI=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 341FsTYA028981
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 1 May 2023 10:54:29 -0500
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Mon, 1
 May 2023 10:54:29 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Mon, 1 May 2023 10:54:29 -0500
Received: from [128.247.81.102] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 341FsTRA116139;
        Mon, 1 May 2023 10:54:29 -0500
Message-ID: <4e406c96-3f47-1695-324f-a9e45be8c142@ti.com>
Date:   Mon, 1 May 2023 10:54:29 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v2 3/4] DO_NOT_MERGE arm64: dts: ti: Add AM62x MCAN MAIN
 domain transceiver overlay
Content-Language: en-US
To:     Nishanth Menon <nm@ti.com>
CC:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Schuyler Patton <spatton@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>
References: <20230424195402.516-1-jm@ti.com> <20230424195402.516-4-jm@ti.com>
 <20230425124722.pnp7rkuanoml2zvj@nanny>
From:   "Mendez, Judith" <jm@ti.com>
In-Reply-To: <20230425124722.pnp7rkuanoml2zvj@nanny>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Nishanth,

On 4/25/2023 7:47 AM, Nishanth Menon wrote:
> On 14:54-20230424, Judith Mendez wrote:
>> Add an overlay for main domain MCAN on AM62x SK. The AM62x
>> SK board does not have on-board CAN transceiver so instead
>> of changing the DTB permanently, add an overlay to enable
>> MAIN domain MCAN and support for 1 CAN transceiver.
>>
>> Signed-off-by: Judith Mendez <jm@ti.com>
>> ---
>>   arch/arm64/boot/dts/ti/Makefile               |  2 ++
>>   .../boot/dts/ti/k3-am625-sk-mcan-main.dtso    | 35 +++++++++++++++++++
>>   2 files changed, 37 insertions(+)
>>   create mode 100644 arch/arm64/boot/dts/ti/k3-am625-sk-mcan-main.dtso
>>
> 
> Just a headsup - for a formal patch, for the overlay, please ensure we
> provide link to the specific board. I dont want to end up with 1000s
> of overlay files, each enabling one specific peripheral instance of a
> small subgroup of peripheral instance. Overlays should be describing a
> real platform with product link.

Will add in the next submission, thanks.

regards,
Judith
