Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97976311DF2
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 15:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhBFOve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 09:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbhBFOva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 09:51:30 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7EBCC061788;
        Sat,  6 Feb 2021 06:50:50 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id t8so10751974ljk.10;
        Sat, 06 Feb 2021 06:50:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=9fQ3za5MFsLQeP8KHF1nh2cbHTIxT+V+VYGsEDTAfio=;
        b=SjsYeZAUwDMDB1QHoqNemUYsppy2mlwz78H68eSVeCZgoZre/0I+zM1YgOW5+iAMr/
         466gS3dGSVZJ3bJk3MFjOj9CBzRVqwTRKqrK3xq6/M1L+tz8pbmcKRxRqfdOux3VEfup
         D7ynQZZuFc1fGTYvm/JANpCdVEMz4ISBMG4+EQMQCPFO/rCFtlPs/ArsqiztqiNfPPoE
         aADRUHfqk5Ne5J/u3tCv1JqHnV7z4A88B4uV+og1jsVBikT+QxDJq3nys39m5FYPlXKx
         WVfBY/2MdXIszin+bXIV0RjBKzaVKR3iL7MaDOWMsOSbFwmescLU951p09QC6UWlU+x4
         m51Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=9fQ3za5MFsLQeP8KHF1nh2cbHTIxT+V+VYGsEDTAfio=;
        b=T9ummudcER5Luav68FfBpEhXbpGGWwMAmfyGMuMYFlPmQRvuP60YcIctnzjDy5QMFo
         /tPpGHvYa81Hs496UG11nPDXQCpwAu9x26l9mARLo5ILaZXBzxbsxgS2KuUnUrCNcRzs
         XIgvAgOmMrX3QMxiL1RivoJpvWCXK6BHZFI2NaquEucvEZJB1hR9H05+6KQ9v3Szylq9
         KMHF1AQTRwEtISd0ZKwcvqkaIlxVyB7O5+lMxNDesMMI+LU560RIME16M55oeE3wVRsu
         27PO2Bn7q0bzhdhswSU0FU1ARHF2fydwAkqZY1UDYtwT012oFQBvSxfZ2WbJWPbef/ox
         v9Mg==
X-Gm-Message-State: AOAM531UZBE+C63v/TnD3qQXjgW+luH+eol8hj1I7n+ramXMABRlBmPQ
        dJkFcIu6fpkFBZA6hklvopKz4cXITaWPFw==
X-Google-Smtp-Source: ABdhPJzQWi2G+BwbIc/Bg8AP7wSd5BhtqhzOC0Q6lCl2RcX6puMGsnndJOsXpltKBeQlR+vmLBaI8A==
X-Received: by 2002:a2e:3612:: with SMTP id d18mr5633688lja.211.1612623049328;
        Sat, 06 Feb 2021 06:50:49 -0800 (PST)
Received: from [10.0.0.11] (user-5-173-242-247.play-internet.pl. [5.173.242.247])
        by smtp.googlemail.com with ESMTPSA id v18sm1335195ljj.55.2021.02.06.06.50.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Feb 2021 06:50:48 -0800 (PST)
From:   Lech Perczak <lech.perczak@gmail.com>
Subject: Re: [PATCH v2 1/2] net: usb: qmi_wwan: support ZTE P685M modem
To:     =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org
References: <20210205173904.13916-1-lech.perczak@gmail.com>
 <20210205173904.13916-2-lech.perczak@gmail.com>
 <87r1lt1do6.fsf@miraculix.mork.no>
Message-ID: <0264f3a2-d974-c405-fb08-18e5ca21bf76@gmail.com>
Date:   Sat, 6 Feb 2021 15:50:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <87r1lt1do6.fsf@miraculix.mork.no>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

W dniu 2021-02-06 o 15:19, Bjørn Mork pisze:
> Lech Perczak<lech.perczak@gmail.com>  writes:
>
>> The modem is used inside ZTE MF283+ router and carriers identify it as
>> such.
>> Interface mapping is:
>> 0: QCDM, 1: AT (PCUI), 2: AT (Modem), 3: QMI, 4: ADB
>>
>> T:  Bus=02 Lev=02 Prnt=02 Port=05 Cnt=01 Dev#=  3 Spd=480  MxCh= 0
>> D:  Ver= 2.01 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
>> P:  Vendor=19d2 ProdID=1275 Rev=f0.00
>> S:  Manufacturer=ZTE,Incorporated
>> S:  Product=ZTE Technologies MSM
>> S:  SerialNumber=P685M510ZTED0000CP&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&0
> This lookes weird.  But I guess that's really the string presented by
> this device?
Yes indeed. Looked weird to me too, but at least it confirms the model 
name found in Windows drivers.
>> C:* #Ifs= 5 Cfg#= 1 Atr=a0 MxPwr=500mA
>> I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
>> E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> I:* If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
>> E:  Ad=83(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
>> E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
>> E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
>> E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
>> E:  Ad=87(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
>> E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> I:* If#= 4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
>> E:  Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>>
>> Cc: Bjørn Mork<bjorn@mork.no>
>> Signed-off-by: Lech Perczak<lech.perczak@gmail.com>
> Patch looks fine to me.  But I don't think you can submit a net and usb
> serial patch in a series. These are two different subsystems.
>
> There's no dependency between the patches so you can just submit
> them as standalone patches.  I.e. no series.
Actually, there is, and I just noticed, that patches are in wrong order.
Without patch 2/2 for 'option' driver, there is possibility for that 
driver to steal
interface 3 from qmi_wwan, as currently it will match interface 3 as 
ff/ff/ff.

With that in mind I'm not really sure how to proceed.

What comes to my mind, is either submit this as series again, with 
ordering swapped,
or submit 2/2 first, wait for it to become merged, and then submit 1/2.

> Feel free to include
>
> Acked-by: Bjørn Mork<bjorn@mork.no>

Thank you.

--
With kind regards,
Lech

