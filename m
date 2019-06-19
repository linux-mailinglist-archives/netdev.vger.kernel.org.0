Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5435D4C104
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 20:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730224AbfFSSq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 14:46:58 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:33417 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730120AbfFSSq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 14:46:57 -0400
Received: by mail-io1-f68.google.com with SMTP id u13so87950iop.0
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 11:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=gA4iP3Dal7CMDgIEIiKlLJQb/ozg2j3g2x2kx2O3zEA=;
        b=aY5pH4UoNncWtP3OUZG8/Cl7YuHgSRVusXJkDYEwRpZUhpRKo/NnIceURFC47Ws+DN
         X3WNVpUDWACtolFlcgecsZA/XusiosJ8mFXcoFzNsBzxXDqX0xofhrvlWOeRQeB9H8BZ
         aoo8m81BgRSumyR3HZzuWZ20r3TgOJQM7wD5s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gA4iP3Dal7CMDgIEIiKlLJQb/ozg2j3g2x2kx2O3zEA=;
        b=EuB34XSAokSY+BdIhrLv0nyIG8gf7dbEl+EFFBkTlyzmNwOOJ6QXImHihAHbj2wJkb
         M4CDCblxwLxO2ci9CYMjAJctUMffQscVCF3UbZIMq36s8ATwcbdnuvaD01fa7VawXwz1
         KOyAtUFvA4vpw0vbP9zzJYSfHj3W4ZW3XzBsP9iD/AyGCNJ3o3uQiIezxmjHTTzKZnuz
         4MDpS2+umLMKZqezf6x2kose1RB1g2qQNJoeESvZOsQtEwh8e/3v19vMRBLKyM3aLEWC
         D/nOlPgxlvC1slju7OWFQPOtYLRqBrK2z/+vRy7PC/00PzRk+uIty+w6YBjHQoYDXNq+
         IsTA==
X-Gm-Message-State: APjAAAVH/lwtrpAujCmvBHHkc/+ebC79yewLr1lK+v8swxU60zvUs01e
        fxiwjfNnKJBhJmw6C0zZMgzQMQ==
X-Google-Smtp-Source: APXvYqx94eAM6fPNxcc7SoqCHG3LcZXxlr4pXp3Ne1lQ5Mo3axPiRjb2wivSkh7sJAnRIC3LCIDGxQ==
X-Received: by 2002:a02:84e6:: with SMTP id f93mr1573091jai.73.1560970016826;
        Wed, 19 Jun 2019 11:46:56 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id f4sm18272367iok.56.2019.06.19.11.46.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 11:46:56 -0700 (PDT)
Subject: Re: Fwd: [PATCH] net: fddi: skfp: Include generic PCI definitions
 from pci_regs.h
To:     Puranjay Mohan <puranjay12@gmail.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20190619174556.21194-1-puranjay12@gmail.com>
 <e49daf89-1bf0-77e8-c71f-ec0802f25f6c@linuxfoundation.org>
 <20190619182122.GA4827@arch>
 <CANk7y0h8gC6JR=FWXQC=vYWrPxFT2KFwi6zQaThjhzAMwG9gGw@mail.gmail.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <330fefa3-5301-42b8-4e59-cd0b743e8220@linuxfoundation.org>
Date:   Wed, 19 Jun 2019 12:46:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CANk7y0h8gC6JR=FWXQC=vYWrPxFT2KFwi6zQaThjhzAMwG9gGw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/19/19 12:31 PM, Puranjay Mohan wrote:
> On Wed, Jun 19, 2019 at 12:04:19PM -0600, Shuah Khan wrote:
>> On 6/19/19 11:45 AM, Puranjay Mohan wrote:
>>> Include the generic PCI definitions from include/uapi/linux/pci_regs.h
>>> change PCI_REV_ID to PCI_REVISION_ID to make it compatible with the
>>> generic define.
>>> This driver uses only one generic PCI define.
>>>
>>> Signed-off-by: Puranjay Mohan <puranjay12@gmail.com>
>>> ---
>>>    drivers/net/fddi/skfp/drvfbi.c | 3 ++-
>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/fddi/skfp/drvfbi.c b/drivers/net/fddi/skfp/drvfbi.c
>>> index bdd5700e71fa..38f6d943385d 100644
>>> --- a/drivers/net/fddi/skfp/drvfbi.c
>>> +++ b/drivers/net/fddi/skfp/drvfbi.c
>>> @@ -20,6 +20,7 @@
>>>    #include "h/supern_2.h"
>>>    #include "h/skfbiinc.h"
>>>    #include <linux/bitrev.h>
>>> +#include <uapi/linux/pci_regs.h>
>>>    #ifndef   lint
>>>    static const char ID_sccs[] = "@(#)drvfbi.c       1.63 99/02/11 (C) SK " ;
>>> @@ -127,7 +128,7 @@ static void card_start(struct s_smc *smc)
>>>       *       at very first before any other initialization functions is
>>>       *       executed.
>>>       */
>>> -   rev_id = inp(PCI_C(PCI_REV_ID)) ;
>>> +   rev_id = inp(PCI_C(PCI_REVISION_ID)) ;
>>>      if ((rev_id & 0xf0) == SK_ML_ID_1 || (rev_id & 0xf0) == SK_ML_ID_2) {
>>>              smc->hw.hw_is_64bit = TRUE ;
>>>      } else {
>>>
>>
>> Why not delete the PCI_REV_ID define in:
>>
>> drivers/net/fddi/skfp/h/skfbi.h
>>
> I have removed all generic  PCI definitions from skfbi.h in the next
> patch which I have sent, I wanted to keep it organised by sending two
> patches
> 

Yeah. I saw your second patch come in after I sent my response. :)

>> It looks like this header has duplicate PCI config space header defines,
>> not just this one. Some of them are slightly different names:
>>
>> e.g:
>>
>> #define PCI_CACHE_LSZ   0x0c    /*  8 bit       Cache Line Size */
>>
>> Looks like it defines the standard PCI config space instead of
>> including and using the standard defines from uapi/linux/pci_regs.h
>>
> It defines many duplicate definitions in skfbi.h, but only uses one of
> them, hence they are removed in the next patch as told by bjorn.
> It uses only one generic PCI define in driver code, i.e. PCI_REV_ID, it
> has been replaced by PCI_REVISION_ID to make it work with the define
> included with uapi/linux/pci_regs.h
>> Something to look into.
>>

Sounds like a plan.

thanks,
-- Shuah
