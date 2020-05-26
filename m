Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B83A1E313C
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 23:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389678AbgEZVdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 17:33:14 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:52192 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388740AbgEZVdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 17:33:14 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04QLX8rf000603;
        Tue, 26 May 2020 16:33:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590528788;
        bh=BlTc2XD4wveY6Y5v42t1Iy3n20uEtWA8G60rMOOS12M=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=fj8x4BcIDJiQKBswYbydlLW1JBAuSaRwx4NH0Ka2036RykFLtbC4ZWm4Lzn7aFWk3
         Lyu1RAR7BnYlLGOpYen7MixGckUHqpEoRANIHWkiQ2puVTYDWsGEKVqr9mVDoTxBg8
         J2k7iLndDXfXN/DbPqU6kQ6C+vsporWRx16+z1wU=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04QLX8oJ045675
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 26 May 2020 16:33:08 -0500
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 26
 May 2020 16:33:07 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 26 May 2020 16:33:07 -0500
Received: from [10.250.74.234] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04QLX7jN024529;
        Tue, 26 May 2020 16:33:07 -0500
Subject: Re: [net-next RFC PATCH 00/13] net: hsr: Add PRP driver
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
References: <20200506163033.3843-1-m-karicheri2@ti.com>
 <87r1vdkxes.fsf@intel.com>
 <CA+h21hqiV71wc0v=-KkPbWNyXSY+-oiz+DsQLAe1XEJw7eP=_Q@mail.gmail.com>
 <a7d1ebef-7161-9ecc-09ca-83f868ff7dac@ti.com>
 <CA+h21hp+khuj0jV9+keDuzPDe11Xz1Rs8KKkt=n8MeWVHkcmvQ@mail.gmail.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <2e9e56e4-be15-9745-f984-15f9188cdf80@ti.com>
Date:   Tue, 26 May 2020 17:33:06 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hp+khuj0jV9+keDuzPDe11Xz1Rs8KKkt=n8MeWVHkcmvQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir

On 5/26/20 2:25 PM, Vladimir Oltean wrote:
> Hi Murali,
> 
> On Tue, 26 May 2020 at 17:12, Murali Karicheri <m-karicheri2@ti.com> wrote:
>>
>> Hi Vladimir,
>>
> 
>> I haven't looked the spec for 802.1CB. If they re-use HSR/PRP Tag in the
>> L2 protocol it make sense to enhance the driver. Else I don't see any
>> re-use possibility. Do you know the above?
>>
>> Thanks
>>
>> Murali
> 
> IEEE 802.1CB redundancy tag sits between Source MAC address and
> Ethertype or any VLAN tag, is 6 bytes in length, of which:
> - first 2 bytes are the 0xf1c1 EtherType
> - next 2 bytes are reserved
> - last 2 bytes are the sequence number
> There is also a pre-standard version of the IEEE 802.1CB redundancy
> tag, which is only 4 bytes in length. I assume vendors of pre-standard
> equipment will want to have support for this 4-byte tag as well, as
> well as a mechanism of converting between HSR/PRP/pre-standard 802.1CB
> tag on one set of ports, and 802.1CB on another set of ports.
> 
Thanks for sharing the details. I also took a quick glance at the
802.1CB spec today. It answered also my above question
1) In addition to FRER tag, it also includes HSR tag and PRP trailer
that can be provisioned through management objects.
2) Now I think I get what Vinicius refers to the interoperability. there
can be HSR tag received on ingress port and PRP on the egress port of
a relay function.

Essentially tag usage is configurable on a stream basis. Since both
HSR and PRP functions for frame formatting and decoding would be
re-usable. In addition driver could be enhanced for FRER functions.

Regards,

Murali
>>
>> --
>> Murali Karicheri
>> Texas Instruments
> 
> Thanks,
> -Vladimir
> 

-- 
Murali Karicheri
Texas Instruments
