Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCFB24E278
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 23:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgHUVNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 17:13:54 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:55644 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgHUVNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 17:13:52 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07LLDjNF040124;
        Fri, 21 Aug 2020 16:13:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1598044425;
        bh=WwdW1q9vNwz6qCi6gk0mJU/6nFPX5njwv0KN/zOhsSE=;
        h=Subject:From:To:References:Date:In-Reply-To;
        b=KD3N13aaRHy67nc+d6u0/bJ2w+bNoEYUT2vNJ49sByFbLbKftGTe0S03uOC703Uvy
         p/+34ujvZT+FRr77f1fUW99r7xC9LOaDAviEvXq6ttv/pcEM/2NpsNJd/9lzsddwam
         YhT7Zc19zzziIboizJr7A1Wy5mBBNKkzRqehryLc=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 07LLDjNE097715
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Aug 2020 16:13:45 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 21
 Aug 2020 16:13:45 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 21 Aug 2020 16:13:45 -0500
Received: from [10.250.65.199] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07LLDia1055288;
        Fri, 21 Aug 2020 16:13:44 -0500
Subject: Re: [PATCH iproute2 v5 0/2] iplink: hsr: add support for creating PRP
 device
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <vinicius.gomes@intel.com>,
        <stephen@networkplumber.org>
References: <20200817211737.576-1-m-karicheri2@ti.com>
 <44143c5d-ba93-363f-ca74-f9d7833c403f@ti.com>
Message-ID: <64c3e8a9-94b1-b47c-93e7-186d98eb5e10@ti.com>
Date:   Fri, 21 Aug 2020 17:13:44 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <44143c5d-ba93-363f-ca74-f9d7833c403f@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen,

On 8/19/20 5:21 PM, Murali Karicheri wrote:
> Hi, Stephen,
> 
> On 8/17/20 5:17 PM, Murali Karicheri wrote:
>> This series enhances the iproute2 iplink module to add support
>> for creating PRP device similar to HSR. The kernel part of this
>> is already merged to v5.9 master
>>
>> v5 - addressed comment from Stephen Hemminger
>>     - Sending this with a iproute2 prefix so that this can
>>       be merged to v5.9 iprout2 if possible.
>> v3 of the series is rebased to iproute2-next/master at
>> git://git.kernel.org/pub/scm/network/iproute2/iproute2-next
>> and send as v4.
>>
>> Please apply this if looks good.
>>
>>
>> Murali Karicheri (2):
>>    iplink: hsr: add support for creating PRP device similar to HSR
>>    ip: iplink: prp: update man page for new parameter
>>
>>   ip/iplink_hsr.c       | 17 +++++++++++++++--
>>   man/man8/ip-link.8.in |  9 ++++++++-
>>   2 files changed, 23 insertions(+), 3 deletions(-)
>>
> Can we merge this version please?

Ping .... Thank you!
-- 
Murali Karicheri
Texas Instruments
