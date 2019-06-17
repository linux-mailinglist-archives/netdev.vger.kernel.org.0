Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8107B486A8
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 17:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbfFQPJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 11:09:37 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:59626 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbfFQPJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 11:09:37 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5HF9QuK078617;
        Mon, 17 Jun 2019 10:09:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1560784166;
        bh=rTV+SbefbDzPyGHW1pgcLCQYe9fYpv1qPT94iYiJ7RY=;
        h=Subject:From:To:CC:References:Date:In-Reply-To;
        b=lUr0x2tVaSTlbCLsfbI/X2vkSqoBl9kvvbSUDVLW5SUlVAOHHt1FZ4QBhtobls8QP
         L8TO799xCuH9/hfiHgmmOv/K1otnnZw7y/kIStLLXjhCOZ8Z2nFC+0FFUr3m0GpN5o
         /xI99dToHkRREEauRLeibCRMngedGR2BulqoOMNM=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5HF9Q7g029558
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Jun 2019 10:09:26 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Mon, 17
 Jun 2019 10:09:25 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Mon, 17 Jun 2019 10:09:25 -0500
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5HF9PFk034523;
        Mon, 17 Jun 2019 10:09:25 -0500
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
Message-ID: <6fa79302-ad32-7f43-f9d5-af70aa789284@ti.com>
Date:   Mon, 17 Jun 2019 10:09:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <0f6c41c8-0071-ed3a-9e65-caf02a0fbefe@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marc

On 6/10/19 11:35 AM, Dan Murphy wrote:
> Bump
>
> On 6/6/19 8:16 AM, Dan Murphy wrote:
>> Marc
>>
>> Bump
>>
>> On 5/31/19 6:51 AM, Dan Murphy wrote:
>>> Marc
>>>
>>> On 5/15/19 3:54 PM, Dan Murphy wrote:
>>>> Marc
>>>>
>>>> On 5/9/19 11:11 AM, Dan Murphy wrote:
>>>>> Create a m_can platform framework that peripheral
>>>>> devices can register to and use common code and register sets.
>>>>> The peripheral devices may provide read/write and configuration
>>>>> support of the IP.
>>>>>
>>>>> Acked-by: Wolfgang Grandegger <wg@grandegger.com>
>>>>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>>>>> ---
>>>>>
>>>>> v12 - Update the m_can_read/write functions to create a backtrace 
>>>>> if the callback
>>>>> pointer is NULL. - https://lore.kernel.org/patchwork/patch/1052302/
>>>>>
>>>> Is this able to be merged now?
>>>
>>> ping

Wondering if there is anything else we need to do?

The part has officially shipped and we had hoped to have driver support 
in Linux as part of the announcement.

Dan


>>>
>>>
>>>> Dan
>>>>
>>>> <snip>
