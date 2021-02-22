Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0C832143F
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 11:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhBVKhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 05:37:08 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:50196 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbhBVKg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 05:36:59 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 11MAZE4x020286;
        Mon, 22 Feb 2021 04:35:14 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1613990114;
        bh=1frvgHuwt9UE4V3scZaSJep38W1gkW3f9joP9vN7Sds=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=p+dl95Aa3fEp+HKrSCJKVXnxtQoc0/qmL28hLJXTB+0z20RrBDs0Q2du+1kD4vGxp
         rjuiMXKWk7Em3jSPZK36u3QQr/r8D3tU3Cc2ckDkQ0axdMOmlWohWV+wX2PTtQPBdK
         pugAG9QrapMhZoefDdWBRVhnYmku/Srff5X5xuHc=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 11MAZEAo096611
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 22 Feb 2021 04:35:14 -0600
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 22
 Feb 2021 04:35:13 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 22 Feb 2021 04:35:13 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 11MAZBj9122528;
        Mon, 22 Feb 2021 04:35:11 -0600
Subject: Re: linux-next: manual merge of the devicetree tree with the net-next
 tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Rob Herring <robherring2@gmail.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Rob Herring <robh@kernel.org>
References: <20210121132645.0a9edc15@canb.auug.org.au>
 <20210215075321.0f3ea0de@canb.auug.org.au>
 <20210222192306.400c6a50@canb.auug.org.au>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <bbddedcf-fa9b-95bd-1e10-5a46da88f305@ti.com>
Date:   Mon, 22 Feb 2021 12:35:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210222192306.400c6a50@canb.auug.org.au>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22/02/2021 10:23, Stephen Rothwell wrote:
> Hi all,
> 
> On Mon, 15 Feb 2021 07:53:21 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> On Thu, 21 Jan 2021 13:26:45 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>
>>> Today's linux-next merge of the devicetree tree got a conflict in:
>>>
>>>    Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>>>
>>> between commit:
>>>
>>>    19d9a846d9fc ("dt-binding: net: ti: k3-am654-cpsw-nuss: update bindings for am64x cpsw3g")
>>>
>>> from the net-next tree and commit:
>>>
>>>    0499220d6dad ("dt-bindings: Add missing array size constraints")
>>>
>>> from the devicetree tree.
>>>
>>> I fixed it up (see below) and can carry the fix as necessary. This
>>> is now fixed as far as linux-next is concerned, but any non trivial
>>> conflicts should be mentioned to your upstream maintainer when your tree
>>> is submitted for merging.  You may also want to consider cooperating
>>> with the maintainer of the conflicting tree to minimise any particularly
>>> complex conflicts.
>>>
>>> diff --cc Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>>> index 3fae9a5f0c6a,097c5cc6c853..000000000000
>>> --- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>>> +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>>> @@@ -72,7 -66,8 +72,8 @@@ properties
>>>      dma-coherent: true
>>>    
>>>      clocks:
>>> +     maxItems: 1
>>>   -    description: CPSW2G NUSS functional clock
>>>   +    description: CPSWxG NUSS functional clock
>>>    
>>>      clock-names:
>>>        items:
>>
>> With the merge window about to open, this is a reminder that this
>> conflict still exists.
> 
> This is now a conflict between the devicetree tree and Linus' tree.
> 

Sorry for inconvenience, is there anything I can do to help resolve it?
(Changes went through a different trees)

-- 
Best regards,
grygorii
