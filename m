Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A2F2F2CF2
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 11:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391704AbhALKdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 05:33:49 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11434 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387441AbhALKdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 05:33:49 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffd7ae40004>; Tue, 12 Jan 2021 02:33:08 -0800
Received: from [172.27.15.36] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 Jan
 2021 10:33:06 +0000
Subject: Re: [PATCH iproute2 v3 1/1] build: Fix link errors on some systems
To:     Petr Machata <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        "Stephen Hemminger" <stephen@networkplumber.org>
References: <20210110071622.608572-1-roid@nvidia.com>
 <87pn2b76xw.fsf@nvidia.com>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <d36a9875-d15e-5170-86b3-70047439a8ea@nvidia.com>
Date:   Tue, 12 Jan 2021 12:33:04 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <87pn2b76xw.fsf@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610447588; bh=PJRsfkFD2kiTuVIGjlAKG3+MRVSAb80oPm7RQZa/jpw=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=DaheHsDiQYkUZyL/BMfZGSP7oegUx1JpL8bb8T8UYvV6Jy0p11EpqM6AtwOyAmZpt
         mw+k6JadVLl9KH54LVAGa6PksYJMB8L05sx5Vq/aiiXT1ATDDYs6GNsm1Z2i2HUKQP
         iJ7M7QeTrmxR8JuTjy/1Cx4JX23B2tcL3Vxcb3ZL15HezJ76tE92UCjA4rQCLKnl/5
         w0DRLBNnOjkfLhKGwmKsn3ea2X6UXmk/+8PKMIWsSoGhQS9sBQ5++8ALfk5sE2zdpn
         SaTwOBaVELe1jZhS3zwoLdZabrDfCY43wONDQOR33cB+x/PznJUh9cZfvdgF3VBOWC
         uhEeECZjoyRCA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-01-11 6:51 PM, Petr Machata wrote:
> 
> Roi Dayan <roid@nvidia.com> writes:
> 
>> diff --git a/lib/json_print_math.c b/lib/json_print_math.c
>> new file mode 100644
>> index 000000000000..3d560defcd3e
>> --- /dev/null
>> +++ b/lib/json_print_math.c
>> @@ -0,0 +1,46 @@
>> +/*
>> + * json_print_math.c		"print regular or json output, based on json_writer".
>> + *
>> + *             This program is free software; you can redistribute it and/or
>> + *             modify it under the terms of the GNU General Public License
>> + *             as published by the Free Software Foundation; either version
>> + *             2 of the License, or (at your option) any later version.
>> + *
> 
> This should have a SPDX tag instead of the license excerpt:
> 
> // SPDX-License-Identifier: GPL-2.0+
> 
>> + * Authors:    Julien Fortin, <julien@cumulusnetworks.com>
>> + */
> 
> sprint_size() comes from TC and predates iproute2 git repo (2004),
> whereas Cumulus Networks was around from 2010. So the authorship
> declaration is likely inaccurate. I think it's also unnecessary, and
> would just drop it.
> 
>> diff --git a/lib/utils_math.c b/lib/utils_math.c
>> new file mode 100644
>> index 000000000000..d67affeb16c2
>> --- /dev/null
>> +++ b/lib/utils_math.c
>> @@ -0,0 +1,133 @@
>> +/*
>> + * utils.c
>> + *
>> + *		This program is free software; you can redistribute it and/or
>> + *		modify it under the terms of the GNU General Public License
>> + *		as published by the Free Software Foundation; either version
>> + *		2 of the License, or (at your option) any later version.
>> + *
>> + * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
> 
> The same here re license and authorship. The latter might in fact be
> accurate in this case, but I would still drop it :)
> 
> Otherwise this looks good to me.
> 

great thanks. sending v4 with the updates.
