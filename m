Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F344C6AE81
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 20:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388387AbfGPSYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 14:24:13 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:46010 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388358AbfGPSYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 14:24:12 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id x6GINxjj086845;
        Tue, 16 Jul 2019 13:23:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1563301439;
        bh=vgEMom0MOTUH3LQO90CcdLSOmSDPgRDrlS4ZgPOl7iA=;
        h=Subject:From:To:CC:References:Date:In-Reply-To;
        b=butCZrEiOvRaX0N37+9UocADFRMjBdNCGxEaCtHC4iD3CJkNkULNNi3R/RFWpUjOt
         Tz4YHV7Fia/sJaOeB07TDua6QTJmhYjw08gTXWi61sXX82W8+AtU0lY+yw39COsLVm
         +NDIyCK6rfncdhpjCG8XI1wQufRagRLLxxn8BAtc=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x6GINx47037084
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jul 2019 13:23:59 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Tue, 16
 Jul 2019 13:23:59 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Tue, 16 Jul 2019 13:23:59 -0500
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x6GINxHA084472;
        Tue, 16 Jul 2019 13:23:59 -0500
Subject: Re: [PATCH v12 1/5] can: m_can: Create a m_can platform framework
From:   Dan Murphy <dmurphy@ti.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20190509161109.10499-1-dmurphy@ti.com>
 <dbb7bdef-820d-5dcc-d7b5-a82bc1b076fb@ti.com>
Message-ID: <c7547c28-6d6c-daf6-e8a2-822dcfbb1150@ti.com>
Date:   Tue, 16 Jul 2019 13:23:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <dbb7bdef-820d-5dcc-d7b5-a82bc1b076fb@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

On 5/15/19 3:54 PM, Dan Murphy wrote:
> Marc
>
> On 5/9/19 11:11 AM, Dan Murphy wrote:
>> Create a m_can platform framework that peripheral
>> devices can register to and use common code and register sets.
>> The peripheral devices may provide read/write and configuration
>> support of the IP.
>>
>> Acked-by: Wolfgang Grandegger <wg@grandegger.com>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
>>
>> v12 - Update the m_can_read/write functions to create a backtrace if the callback
>> pointer is NULL. - https://lore.kernel.org/patchwork/patch/1052302/
>>
> Is this able to be merged now?

Is there anyone out there maintaining this sub system?

Dan


> Dan
>
> <snip>
