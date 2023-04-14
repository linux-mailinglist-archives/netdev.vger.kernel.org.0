Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 108E86E1C39
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 08:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjDNGNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 02:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjDNGNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 02:13:14 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8314C2D;
        Thu, 13 Apr 2023 23:13:12 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33E6CvUM121911;
        Fri, 14 Apr 2023 01:12:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1681452777;
        bh=5fzgEE5rhEgibICZ0O25CWXhfNZmGZDqlt0vq4RXvyM=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=URVsDq7rIRMqNYXlhoOuQJmyn0xTjbHWqn4Juvnls0SIrvnYAYRllnFPrDu4Dfc3S
         yiiWHAEWiLDp0Ad9P77YDV7rBeWPdsTR6xVd1nHgBSocBpBDY7SysXraIGnRnNMWvu
         qooD9ng3eJxu0rTDOE686cgGhxfV085TkyWawdPg=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33E6CvA9027034
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 14 Apr 2023 01:12:57 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Fri, 14
 Apr 2023 01:12:57 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Fri, 14 Apr 2023 01:12:57 -0500
Received: from [172.24.145.182] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33E6CrH8054033;
        Fri, 14 Apr 2023 01:12:53 -0500
Message-ID: <8552c377-b2e9-749a-9f0c-7c444fe012c6@ti.com>
Date:   Fri, 14 Apr 2023 11:42:52 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [RFC PATCH 0/5] Enable multiple MCAN on AM62x
Content-Language: en-US
To:     Judith Mendez <jm@ti.com>,
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
From:   Vignesh Raghavendra <vigneshr@ti.com>
In-Reply-To: <20230413223051.24455-1-jm@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Judith,

On 14/04/23 04:00, Judith Mendez wrote:
> Judith Mendez (5):
>   arm64: dts: ti: Add AM62x MCAN MAIN domain transceiver overlay
>   arm64: defconfig: Enable MCAN driver
>   dt-binding: can: m_can: Remove required interrupt attributes
>   arm64: dts: ti: Enable multiple MCAN for AM62x in MCU MCAN overlay
>   can: m_can: Add hrtimer to generate software interrupt

This is fine for RFC, but next time, please split DT and defconfig
changes (1/5,2/5, and 4/5) to separate series as they have to go via
arm64 tree.

-- 
Regards
Vignesh
