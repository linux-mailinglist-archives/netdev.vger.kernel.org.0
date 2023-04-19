Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455366E7DBC
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbjDSPNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbjDSPM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:12:57 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A384B1988;
        Wed, 19 Apr 2023 08:12:55 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33JFCfKW021422;
        Wed, 19 Apr 2023 10:12:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1681917161;
        bh=yzdOdCedXGYszW/kSm/+v6xAAPi2uDa2BGQ6xPSX1Qw=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=G2zAdQ/WKg+yIe5PX3WrSTB/YrusrtPvUgQcPe+3DHW6XtTY+ldryWohP2vYmGbMU
         diyhS0YVGrewu2lb+pT6iQblsF3H3At4PIdYSPaJ4vcSmhL4PFF4OlkZyJaCD4ob8N
         aDBwaXr2qaTxIwQf/BJq0a3eI5LobzR8W1Q3niTA=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33JFCfFL116821
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Apr 2023 10:12:41 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 19
 Apr 2023 10:12:41 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 19 Apr 2023 10:12:41 -0500
Received: from [128.247.81.102] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33JFCe0m082677;
        Wed, 19 Apr 2023 10:12:40 -0500
Message-ID: <ede39204-3ba0-657b-4618-3e5395942a48@ti.com>
Date:   Wed, 19 Apr 2023 10:12:40 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC PATCH 0/5] Enable multiple MCAN on AM62x
Content-Language: en-US
To:     Vignesh Raghavendra <vigneshr@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>
CC:     Nishanth Menon <nm@ti.com>, Andrew Davis <afd@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        <linux-can@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        Schuyler Patton <spatton@ti.com>
References: <20230413223051.24455-1-jm@ti.com>
 <8552c377-b2e9-749a-9f0c-7c444fe012c6@ti.com>
From:   "Mendez, Judith" <jm@ti.com>
In-Reply-To: <8552c377-b2e9-749a-9f0c-7c444fe012c6@ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Vignesh,

On 4/14/2023 1:12 AM, Vignesh Raghavendra wrote:
> Hi Judith,
> 
> On 14/04/23 04:00, Judith Mendez wrote:
>> Judith Mendez (5):
>>    arm64: dts: ti: Add AM62x MCAN MAIN domain transceiver overlay
>>    arm64: defconfig: Enable MCAN driver
>>    dt-binding: can: m_can: Remove required interrupt attributes
>>    arm64: dts: ti: Enable multiple MCAN for AM62x in MCU MCAN overlay
>>    can: m_can: Add hrtimer to generate software interrupt
> 
> This is fine for RFC, but next time, please split DT and defconfig
> changes (1/5,2/5, and 4/5) to separate series as they have to go via
> arm64 tree.

Thanks, will do in the next respin.
