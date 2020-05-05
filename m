Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6FC1C5322
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 12:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbgEEK06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 06:26:58 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:38854 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgEEK06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 06:26:58 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 045AQm5c022773;
        Tue, 5 May 2020 05:26:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588674408;
        bh=DLomNfMRqwHmSyzWUGmjQc0v1EWBSRCnyaW1Xb6Iwnw=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=GK0KKi8wd3BFB5dZarUtDsz5/IdaPoZ8QEjc1FxGSqSqGNfZbKoNfsztXvvljObN8
         ua/fWSEP97ycNKo6srLnGd0jibf/ouo4mWHJxINnU1LiIESAa42qsiforudyVg9nrq
         9O8K0VkM4i5YzvOi9wDIxyciV1g1k0swCoYg/AIU=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 045AQmxR017712;
        Tue, 5 May 2020 05:26:48 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 5 May
 2020 05:26:48 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 5 May 2020 05:26:47 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 045AQiqA040195;
        Tue, 5 May 2020 05:26:45 -0500
Subject: Re: [PATCH net-next 1/7] dt-binding: ti: am65x: document common
 platform time sync cpts module
To:     Rob Herring <robh@kernel.org>
CC:     Richard Cochran <richardcochran@gmail.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Tero Kristo <t-kristo@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, <netdev@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>
References: <20200501205011.14899-1-grygorii.strashko@ti.com>
 <20200501205011.14899-2-grygorii.strashko@ti.com>
 <20200505040511.GB8509@bogus>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <845264f3-66be-fc0b-7456-60bdcc91bc11@ti.com>
Date:   Tue, 5 May 2020 13:26:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200505040511.GB8509@bogus>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/05/2020 07:05, Rob Herring wrote:
> On Fri, 1 May 2020 23:50:05 +0300, Grygorii Strashko wrote:
>> Document device tree bindings for TI AM654/J721E SoC The Common Platform
>> Time Sync (CPTS) module. The CPTS module is used to facilitate host control
>> of time sync operations. Main features of CPTS module are:
>>    - selection of multiple external clock sources
>>    - 64-bit timestamp mode in ns with ppm and nudge adjustment.
>>    - control of time sync events via interrupt or polling
>>    - hardware timestamp of ext. events (HWx_TS_PUSH)
>>    - periodic generator function outputs (TS_GENFx)
>>    - PPS in combination with timesync router
>>    - Depending on integration it enables compliance with the IEEE 1588-2008
>> standard for a precision clock synchronization protocol, Ethernet Enhanced
>> Scheduled Traffic Operations (CPTS_ESTFn) and PCIe Subsystem Precision Time
>> Measurement (PTM).
>>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
>>   .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   |   7 +
>>   .../bindings/net/ti,k3-am654-cpts.yaml        | 152 ++++++++++++++++++
>>   2 files changed, 159 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
>>
> 
> My bot found errors running 'make dt_binding_check' on your patch:
> 
> Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml: $id: relative path/filename doesn't match actual path or filename
> 	expected: http://devicetree.org/schemas/net/ti,k3-am654-cpts.yaml#
> Unknown file referenced: [Errno 2] No such file or directory: '/usr/local/lib/python3.6/dist-packages/dtschema/schemas/net/ti,am654-cpts.yaml'
> Documentation/devicetree/bindings/Makefile:12: recipe for target 'Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.example.dts' failed
> make[1]: *** [Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.example.dts] Error 255
> make[1]: *** Waiting for unfinished jobs....
> Makefile:1300: recipe for target 'dt_binding_check' failed
> make: *** [dt_binding_check] Error 2
> 
> See https://patchwork.ozlabs.org/patch/1281460
> 
> If you already ran 'make dt_binding_check' and didn't see the above
> error(s), then make sure dt-schema is up to date:
> 
> pip3 install git+https://github.com/devicetree-org/dt-schema.git@master --upgrade
> 
> Please check and re-submit.
> 

I've sent fix for this.

-- 
Best regards,
grygorii
