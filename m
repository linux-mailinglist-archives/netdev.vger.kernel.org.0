Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFBA0108D4
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 16:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfEAOKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 10:10:34 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:53130 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbfEAOKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 10:10:34 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x41EAO6G050410;
        Wed, 1 May 2019 09:10:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1556719824;
        bh=bAMCoxbOD2B1PLsePYRKKsn9nDsgrie3svDUTp4kGi4=;
        h=Subject:From:To:CC:References:Date:In-Reply-To;
        b=HIfpV4nkLVfesPuy3NXtH+ew99tBBr98ofmw3JTAH8dUUU5PeJE2NZNa0TUsW1oMt
         Gw7KE5eocXLxH/5UV/L4N59Fg0+NLwi/SK0xCdaKeQ1CFNRBoJ6XS0QE/8vwN6ygI1
         8huTUqaDqOddNP55/HYrQu9JjVnp1P8wfnp7wyZo=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x41EAOWB044005
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 1 May 2019 09:10:24 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Wed, 1 May
 2019 09:10:23 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Wed, 1 May 2019 09:10:23 -0500
Received: from [10.250.90.63] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id x41EANNr088527;
        Wed, 1 May 2019 09:10:23 -0500
Subject: Re: [PATCH v11 1/5] can: m_can: Create a m_can platform framework
From:   Dan Murphy <dmurphy@ti.com>
To:     Wolfgang Grandegger <wg@grandegger.com>, <mkl@pengutronix.de>,
        <davem@davemloft.net>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20190319172651.10012-1-dmurphy@ti.com>
 <3ce79402-00f1-d7e6-955e-1ad7eb00d0de@ti.com>
 <c05a6a22-c162-518d-683a-18731bd67e38@grandegger.com>
 <2d594ba8-e4e4-14f9-1eb0-8f753c79eb54@ti.com>
Message-ID: <a8b9fcca-dc35-3ca4-e3eb-109bc534e804@ti.com>
Date:   Wed, 1 May 2019 09:10:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <2d594ba8-e4e4-14f9-1eb0-8f753c79eb54@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

On 4/18/19 9:36 AM, Dan Murphy wrote:
> Marc
> 
> On 4/2/19 7:17 AM, Wolfgang Grandegger wrote:
>> Hello Dan,
>>
>> Am 02.04.19 um 14:03 schrieb Dan Murphy:
>>> Wolfgang
>>>
>>> On 3/19/19 12:26 PM, Dan Murphy wrote:
>>>> Create a m_can platform framework that peripheral
>>>> devices can register to and use common code and register sets.
>>>> The peripheral devices may provide read/write and configuration
>>>> support of the IP.
>>>>
>>>> Acked-by: Wolfgang Grandegger <wg@grandegger.com>
>>>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>>>> ---
>>>>
>>>
>>> Wondering if this will be going into 5.1 PR?
>>
>> it's Marc who is doing the upstreaming ... and maybe a final review as well.
>>
> 
> Can you tell me if this will be taken?

This patchset has gone unresponded to from the maintainers for quite some time.

I have numerous customers using this patchset from my public repo and they want the
driver in the mainline kernel.

Is there any help or anything needed to get this merged for 5.2?

Dan

> 
> Dan
> 
>> Wolfgang.
>>
