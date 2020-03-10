Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC218180B97
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgCJWdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:33:16 -0400
Received: from mail-qv1-f66.google.com ([209.85.219.66]:41368 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgCJWdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:33:16 -0400
Received: by mail-qv1-f66.google.com with SMTP id a10so2726762qvq.8;
        Tue, 10 Mar 2020 15:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pVD18NhyaMMMqN+6KXGbkok/K5Bbuh2l+ajlQsVKc1M=;
        b=myVbfeZqSBSRE4KNut7qxpYfnvp1NSfftn65Ow96DACw/EYE+TlpBYdCDFR/yyxTpe
         cNUuWkdm/Y3wbV2NmyPdcVfZECuaOBerzOSgRgJ20D+JGVFAHBRT7aTTjbiVTX8Oe2d/
         xmNf780sw/XnVVBtFGHnBv/VdJEbnkiYyUz/LDfHSwNAOiKocEc7UmTyIcUBYG8cpuDj
         pgB+ZH3J7TTD0wYhUNzptKFKm0pVfDst5u5+OFV1D+5LTJjP9Pv2x8psoZ+OoW48u4ng
         zjjrKozYxTJ9GyedRTl+W8+mpP2Da8yWkOH/gXowaUAO0oglN+GSmDrItwqS+cmbpSFF
         3c6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pVD18NhyaMMMqN+6KXGbkok/K5Bbuh2l+ajlQsVKc1M=;
        b=O7MtBQe7ZYB5mnSc21rfipoEX+GRUpLzgJNWxAXPRrS6ZZoX/ye55iUIr7HJRU5mVU
         mlSau64Cc+a/KVdSGaFHhuw20+XTbRdC91dnnrWBErZPO9GC659LvtHck0+F0HHWr64J
         ixi0kELxY8YYigWgC+zTIT0GNGNt69rx8NKqclDGkxwnVJBgi4ZsLTabWbafmkijqakh
         HOfhb42bUfN55PWVVE9stnD5tTqV6X+uCbnAI3KpBjDEoB+4XYvKNhNEXS4Le6UEDPT3
         E/UI5M+w6z998i3FKS0FMt7ICvwmoceZ+uuheuNRNp37PiZN+YbG6BJOI+Y7nIY6DtdR
         3jBg==
X-Gm-Message-State: ANhLgQ2SD5uf18yckITly7Tu/0KA0II/op3wZlrcBNpbDv0GuvLp2n+F
        TRiO5orC8NmxoWEgp9ZVgxIoT6u3
X-Google-Smtp-Source: ADFU+vuWNvKHn2C94d4ZgerU295hOZCYmRIIpW83R0v703S9f4A8inI/arQIndC8lcPhdFqTxn2PJw==
X-Received: by 2002:a0c:c1cd:: with SMTP id v13mr376112qvh.77.1583879595132;
        Tue, 10 Mar 2020 15:33:15 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11d1::111b? ([2620:10d:c091:480::fee])
        by smtp.gmail.com with ESMTPSA id k11sm1957530qtu.70.2020.03.10.15.33.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 15:33:14 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH][next] zd1211rw/zd_usb.h: Replace zero-length array with
 flexible-array member
To:     Joe Perches <joe@perches.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200305111216.GA24982@embeddedor>
 <87k13yq2jo.fsf@kamboji.qca.qualcomm.com>
 <256881484c5db07e47c611a56550642a6f6bd8e9.camel@perches.com>
 <87blpapyu5.fsf@kamboji.qca.qualcomm.com>
 <1bb7270f-545b-23ca-aa27-5b3c52fba1be@embeddedor.com>
 <87r1y0nwip.fsf@kamboji.qca.qualcomm.com>
 <48ff1333-0a14-36d8-9565-a7f13a06c974@embeddedor.com>
 <021d1125-3ffd-39ef-395a-b796c527bde4@gmail.com>
 <fb3395d7-e932-10ac-1feb-ab2ceb63424e@embeddedor.com>
 <937b0b529509ec1641453ef7c13f38e2d7cc813e.camel@perches.com>
 <c2aa4d8d-1c39-1903-2b49-382f2143e181@embeddedor.com>
 <8b6213e51131deacbdac29a8d9c088ae49933724.camel@perches.com>
Message-ID: <e65fd08d-984f-0bdc-5fbf-6abceacf819a@gmail.com>
Date:   Tue, 10 Mar 2020 18:33:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <8b6213e51131deacbdac29a8d9c088ae49933724.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/20 6:28 PM, Joe Perches wrote:
> On Tue, 2020-03-10 at 17:21 -0500, Gustavo A. R. Silva wrote:
>> On 3/10/20 5:15 PM, Joe Perches wrote:
>>> As far as I can tell, it doesn't actually make a difference as
>>> all the compilers produce the same object code with either form.
>>>
>>
>> That's precisely why we can implement these changes, cleanly(the fact
>> that the compiler produces the same object code). So, the resulting
>> object code is not the point here.
> 
> You are making Jes' point.
> 
> There's nothing wrong with making changes just for consistent
> style across the kernel.
> 
> This change is exactly that.
> 
> I have no objection to this patch.
> 
> Jes does, though Jes is not a maintainer of this file.

I responded to this thread because my previous comments to files I
maintain were ignored.

This is a bulk change across the tree, so it affects a lot of places.

> I think "churn" arguments are overstated.

Again, the changes are not harmful to the code, but add no value. So far
I haven't seen any good arguments for making these changes, and having
this kind of churn is a nuisance for anyone hitting patch conflicts due
to them.

Jes
