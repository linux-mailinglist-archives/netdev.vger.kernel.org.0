Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E72C83DD2DA
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 11:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbhHBJVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 05:21:52 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:56540 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbhHBJVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 05:21:51 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 1729LXaf030014;
        Mon, 2 Aug 2021 04:21:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1627896093;
        bh=YMxXYRcOOZzWcRxCfyHyAuouRqLYkZ86TeNgdCgm/iQ=;
        h=Subject:CC:References:From:Date:In-Reply-To;
        b=n80Kv3u455hse6ybmRoxjnbFVdBL21hF4rjHIilz1k+xDjRBZ4ZV+knIZkilLL5Lm
         a/KPCGMxSM6gdOHaF8K3o4+rvjzRv6XXHOL+xwondg8Bx0HWZGkYg0/tvc6M4g/wwg
         An2SFwpe/hBOnEH9EfZJiVzBzlaKooBeAYVE9SKk=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 1729LXWM103605
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 2 Aug 2021 04:21:33 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 2 Aug
 2021 04:21:33 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Mon, 2 Aug 2021 04:21:33 -0500
Received: from [10.250.232.46] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 1729LRQL024144;
        Mon, 2 Aug 2021 04:21:28 -0500
Subject: Re: [PATCH] dt-bindings: net: can: Document power-domains property
CC:     Lokesh Vutla <lokeshvutla@ti.com>, Nishanth Menon <nm@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Sriram Dash <sriram.dash@samsung.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20210731045138.29912-1-a-govindraju@ti.com>
From:   Aswath Govindraju <a-govindraju@ti.com>
Message-ID: <00760fc2-6731-8bad-4d3a-993acbc86bcc@ti.com>
Date:   Mon, 2 Aug 2021 14:51:27 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210731045138.29912-1-a-govindraju@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On 31/07/21 10:21 am, Aswath Govindraju wrote:
> Document power-domains property for adding the Power domain provider.
> 
> Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
> ---

Posted respin v2[1] for this patch, after removing the reference in
description.

[1] - https://lore.kernel.org/patchwork/patch/1470806/

Thanks,
Aswath

>  Documentation/devicetree/bindings/net/can/bosch,m_can.yaml | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> index a7b5807c5543..d633fe1da870 100644
> --- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> +++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> @@ -104,6 +104,13 @@ properties:
>            maximum: 32
>      maxItems: 1
>  
> +  power-domains:
> +    description:
> +      Power domain provider node and an args specifier containing
> +      the can device id value. Please see,
> +      Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml
> +    maxItems: 1
> +
>    can-transceiver:
>      $ref: can-transceiver.yaml#
>  
> 

