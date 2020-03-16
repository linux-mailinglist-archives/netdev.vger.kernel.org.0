Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 139E418749C
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 22:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732685AbgCPVQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 17:16:49 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:48872 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732634AbgCPVQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 17:16:49 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02GLGk5I053421;
        Mon, 16 Mar 2020 16:16:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584393406;
        bh=auIeyhTBM5VkG3uumINphWmH9dle8E51uTezycsVdfw=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=AW2GJDjDqJALwoiACZrVEaZ547mHy7rGecQNGU7yiSaOnmjRGQXae6HVSf3WZLgqh
         p/vEpeiN9SwW7v/0GRuIBepJQP0m+/OnaaaveMWGhcXE/NrEpSXaxe1622zZn2q8Jf
         Jc3UpgovJzlR0msqclGmu5V8oOF+fWC9ITLliKe8=
Received: from DFLE101.ent.ti.com (dfle101.ent.ti.com [10.64.6.22])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02GLGkP3032895
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 16 Mar 2020 16:16:46 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Mon, 16
 Mar 2020 16:16:45 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Mon, 16 Mar 2020 16:16:46 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02GLGgmi060747;
        Mon, 16 Mar 2020 16:16:43 -0500
Subject: Re: [for-next PATCH v2 1/5] phy: ti: gmii-sel: simplify config
 dependencies between net drivers and gmii phy
To:     Kishon Vijay Abraham I <kishon@ti.com>
CC:     Murali Karicheri <m-karicheri2@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sekhar Nori <nsekhar@ti.com>, Rob Herring <robh+dt@kernel.org>,
        netdev <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200303160029.345-1-grygorii.strashko@ti.com>
 <20200303160029.345-2-grygorii.strashko@ti.com>
 <20200316140859.GA30922@a0393678ub>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <128961a1-8437-741d-96cc-ed24b790cabf@ti.com>
Date:   Mon, 16 Mar 2020 23:16:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200316140859.GA30922@a0393678ub>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16/03/2020 16:08, Kishon Vijay Abraham I wrote:
> On Tue, Mar 03, 2020 at 06:00:25PM +0200, Grygorii Strashko wrote:
>> The phy-gmii-sel can be only auto selected in Kconfig and now the pretty
>> complex Kconfig dependencies are defined for phy-gmii-sel driver, which
>> also need to be updated every time phy-gmii-sel is re-used for any new
>> networking driver.
>>
>> Simplify Kconfig definition for phy-gmii-sel PHY driver - drop all
>> dependencies and from networking drivers and rely on using 'imply
>> PHY_TI_GMII_SEL' in Kconfig definitions for networking drivers instead.
>>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> Acked-by: Kishon Vijay Abraham I <kishon@ti.com>

Thanks you, Kishon.

I'll include this patch in next version of my series to
add networking support for k3 am65x/j721e soc.

-- 
Best regards,
grygorii
