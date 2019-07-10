Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7396264603
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 14:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfGJMJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 08:09:01 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:48910 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfGJMJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 08:09:01 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x6AC8jrT096577;
        Wed, 10 Jul 2019 07:08:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1562760525;
        bh=3uaV5/1Xpl1hokqp82127RZGNTU01EDKfs+fFQxZX1A=;
        h=Subject:From:To:CC:References:Date:In-Reply-To;
        b=b6QMnsOo0nzCu/sKptwufP1G1LN/K+03mZATvrGL5DJXPpdxebWR71nteMVuiDHBq
         bx8X5tuoQjaUFiMI7g43jjTXER5WwhHd/9oLNQ4w0df7OaXMQOh9FR2oJGSw0kp0Rg
         Wyl0SIUNhothMq3HmpKIY+K/wjR2QEAcIiRMcmes=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x6AC8jS8049964
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 10 Jul 2019 07:08:45 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Wed, 10
 Jul 2019 07:08:45 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Wed, 10 Jul 2019 07:08:44 -0500
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id x6AC8ioC115395;
        Wed, 10 Jul 2019 07:08:44 -0500
Subject: Re: [PATCH v12 1/5] can: m_can: Create a m_can platform framework
From:   Dan Murphy <dmurphy@ti.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20190509161109.10499-1-dmurphy@ti.com>
 <dbb7bdef-820d-5dcc-d7b5-a82bc1b076fb@ti.com>
 <a8e3f2d3-18c3-3bdb-1318-8964afc7e032@ti.com>
 <93530d94-ec65-de82-448e-f2460dd39fb9@ti.com>
 <0f6c41c8-0071-ed3a-9e65-caf02a0fbefe@ti.com>
 <6fa79302-ad32-7f43-f9d5-af70aa789284@ti.com>
Message-ID: <f236a88a-485c-9002-1e4a-9a5ad0e1c81f@ti.com>
Date:   Wed, 10 Jul 2019 07:08:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <6fa79302-ad32-7f43-f9d5-af70aa789284@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

On 6/17/19 10:09 AM, Dan Murphy wrote:
> Marc
>
> On 6/10/19 11:35 AM, Dan Murphy wrote:
>> Bump
>>
>> On 6/6/19 8:16 AM, Dan Murphy wrote:
>>> Marc
>>>
>>> Bump
>>>
>>> On 5/31/19 6:51 AM, Dan Murphy wrote:
>>>> Marc
>>>>
>>>> On 5/15/19 3:54 PM, Dan Murphy wrote:
>>>>> Marc
>>>>>
>>>>> On 5/9/19 11:11 AM, Dan Murphy wrote:
>>>>>> Create a m_can platform framework that peripheral
>>>>>> devices can register to and use common code and register sets.
>>>>>> The peripheral devices may provide read/write and configuration
>>>>>> support of the IP.
>>>>>>
>>>>>> Acked-by: Wolfgang Grandegger <wg@grandegger.com>
>>>>>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>>>>>> ---
>>>>>>
>>>>>> v12 - Update the m_can_read/write functions to create a backtrace 
>>>>>> if the callback
>>>>>> pointer is NULL. - https://lore.kernel.org/patchwork/patch/1052302/
>>>>>>
>>>>> Is this able to be merged now?
>>>>
>>>> ping
>
> Wondering if there is anything else we need to do?
>
> The part has officially shipped and we had hoped to have driver 
> support in Linux as part of the announcement.
>
Is this being sent in a PR for 5.3?

Dan


> Dan
>
>
>>>>
>>>>
>>>>> Dan
>>>>>
>>>>> <snip>
