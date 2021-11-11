Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D830444CFD8
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 03:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234292AbhKKCNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 21:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233698AbhKKCNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 21:13:12 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34090C0797BC
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 18:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=DamVpS/zsJJCjaEuEGxupiRyIApd7Zpv1oOomJiqAYI=; b=2TnbSOlL++auhbXRXRS7nVdE4J
        Iv+4b/S/lGCFhRe2/QIGOG8xxio42y00pfoMAFTCosxQupjq86O3f0zCBdkDtHJUxZmQfi2NEWZ8o
        DsV4qEEwF8VAxE+k4orZfy7kyZ2r5qItqpxVEJLfHgvnco8WWHc3X2PCFaVnVd3OuIKAHCAZNyEPG
        PUkUDY8C/2cE14dzUNSqi+DvTgykG0MPoWM7qHz/J6E+QzJcyx8IrKxtgXGdrCZxZbpL3sQZf/Vdw
        mAm2p9hSm1elf+I8glyJFzyApzoDRe7U7mvv+pCKt6fkhwpshyZfe4y5GMfqEEU/UXRzVvTuBm9Lo
        XoCeEzsw==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mkzWj-006lHo-Go; Thu, 11 Nov 2021 02:09:21 +0000
Subject: Re: [PATCH] ptp: ptp_clockmatrix: repair non-kernel-doc comment
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Min Li <min.li.xe@renesas.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20211110225306.13483-1-rdunlap@infradead.org>
 <20211110174955.3fb02cde@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <d9933dbe-a41b-772f-9d53-b3a08a0ad401@infradead.org>
Date:   Wed, 10 Nov 2021 18:09:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211110174955.3fb02cde@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/10/21 5:49 PM, Jakub Kicinski wrote:
> On Wed, 10 Nov 2021 14:53:06 -0800 Randy Dunlap wrote:
>> Do not use "/**" to begin a comment that is not in kernel-doc format.
>>
>> Prevents this docs build warning:
>>
>> drivers/ptp/ptp_clockmatrix.c:1679: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>>      * Maximum absolute value for write phase offset in picoseconds
>>
>> Fixes: 794c3dffacc16 ("ptp: ptp_clockmatrix: Add support for FW 5.2 (8A34005)")
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Cc: Min Li <min.li.xe@renesas.com>
>> Cc: Richard Cochran <richardcochran@gmail.com>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> ---
>>   drivers/ptp/ptp_clockmatrix.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> --- linux-next-20211110.orig/drivers/ptp/ptp_clockmatrix.c
>> +++ linux-next-20211110/drivers/ptp/ptp_clockmatrix.c
>> @@ -1699,7 +1699,7 @@ static int initialize_dco_operating_mode
>>   
>>   /* PTP Hardware Clock interface */
>>   
>> -/**
>> +/*
>>    * Maximum absolute value for write phase offset in picoseconds
>>    *
>>    * @channel:  channel
> 
> Looks like it documents parameters to the function, should we either
> fix it to make it valid kdoc or remove the params (which TBH aren't
> really adding much value)?
> 

a. It would be the only kernel-doc in that source file and
b. we usually want to document exported or at least non-static
functions and don't try very hard to document static ones.

I don't care much about whether we remove the other comments
that are there...
If you want them removed, I can do that.

-- 
~Randy
