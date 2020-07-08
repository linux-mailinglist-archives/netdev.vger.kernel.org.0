Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329962192EF
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 23:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgGHV4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 17:56:17 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:34860 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgGHV4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 17:56:16 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 068LuC59004572;
        Wed, 8 Jul 2020 16:56:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1594245373;
        bh=/FmrMhOLIf0f4ej7rvFqgcuLfWYaObEbOFKtWPp7tJg=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=YFjWX+LOPOuMc2Ua+7E05GVowA/a0Ou3riNdlbZBNhOSP55J47tghw007SQ1ijQGl
         45qrd1s4SF95eWyUPtBIjD2QXeeOtSTNIiXcRBFJ8mLW9qRhFL/eUzOC4QD+pNBXH3
         0Dlg03tCP4XULSOAVg0lm82QQCnvOZHZpy1An9SM=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 068LuCTZ064071
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 8 Jul 2020 16:56:12 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 8 Jul
 2020 16:56:12 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 8 Jul 2020 16:56:12 -0500
Received: from [10.250.32.229] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 068LuCp1028736;
        Wed, 8 Jul 2020 16:56:12 -0500
Subject: Re: [PATCH net-next 2/2] dt-bindings: dp83869: Fix the type of device
To:     Fabio Estevam <festevam@gmail.com>, <davem@davemloft.net>
CC:     <robh+dt@kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>
References: <20200708212422.7599-1-festevam@gmail.com>
 <20200708212422.7599-2-festevam@gmail.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <06997357-b62a-8a60-7483-9eec5a706eb3@ti.com>
Date:   Wed, 8 Jul 2020 16:56:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200708212422.7599-2-festevam@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fabio
On 7/8/20 4:24 PM, Fabio Estevam wrote:
> DP83869 is an Ethernet PHY, not a charger, so fix the documentation
> accordingly.
>
> Fixes: 4d66c56f7efe ("dt-bindings: net: dp83869: Add TI dp83869 phy")
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> ---
>   Documentation/devicetree/bindings/net/ti,dp83869.yaml | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/net/ti,dp83869.yaml b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
> index 71e90a3e4652..cf40b469c719 100644
> --- a/Documentation/devicetree/bindings/net/ti,dp83869.yaml
> +++ b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
> @@ -24,7 +24,7 @@ description: |
>     conversions.  The DP83869HM can also support Bridge Conversion from RGMII to
>     SGMII and SGMII to RGMII.
>   
> -  Specifications about the charger can be found at:
> +  Specifications about the Ethernet PHY can be found at:
>       http://www.ti.com/lit/ds/symlink/dp83869hm.pdf
>   
>   properties:


Acked-by: Dan Murphy <dmurphy@ti.com>

