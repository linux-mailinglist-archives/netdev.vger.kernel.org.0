Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9415812B0BD
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 03:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfL0CsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 21:48:03 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34320 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfL0CsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 21:48:03 -0500
Received: by mail-pg1-f193.google.com with SMTP id r11so13785032pgf.1;
        Thu, 26 Dec 2019 18:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UZv5gn63+09cZaXP5yF58v8/QZ99pHZtcetMaJiITuU=;
        b=GLwaGxujY+79QfujNaYUMxmL+EVBChUdoCaZ4u2JLQRaV7KDGggMVc6D4VO6E824ow
         XYKDVp7CVZRX4Y6/XOpV+Z3DI5T+i4avvrBLgTz8gCrUAjdkQzylyyOpy6VLu14ObWKd
         F7/G57Bmr2csI/mAr2aZ0OWf0fJ4WoTnqJsaVjJeuQOIxrBaZMFW4TBetL5leUYeT938
         fSa1gMrKsrT0yolonFBp70eiJXw4DavmrhXqQtE0+gi3Io3JWHYGrmPHc/xOnABxFqGu
         kojtVTqN5uq5gVj9oCVS62ksPUqZ4nCvDSI06mMLVgLqNsygBRmc9LwrF2/RmGnAzFBU
         qHlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UZv5gn63+09cZaXP5yF58v8/QZ99pHZtcetMaJiITuU=;
        b=oMDQbzJW0nDwPX3SyXSgItFSy5KyUdJe9V9WilczeqAaSAUvquBEd+pdyp8KzkC1Vb
         nwjPFHhV1Z+61o4BI8sXyvLwn9xVvDlSNaAhAHQ+b9ex+az82plOdVsHLPNCihjj+X9n
         5vo0GG7qRvDV8oRGdPTegtjAyIuB7/Qwdk66B7vbbnlWqitjt89w8wUKyNKKiiFoGswq
         xlppJVTXwvnVBcJpvDL40sbqnXeZWc+O3R5NAC7WFHN0zk/HM2qg0PQKVAVbHqcBgd5Y
         f5Xmka84LRqhwu6YNSzeG37K/dtdJ7xhGbzzZZyX6NoSu7amPLZsXllocwMchYO3a2vl
         k7LQ==
X-Gm-Message-State: APjAAAVOBxzBcAnX1aaMOrW1h5Z9iSvXfVUcmXgcYdQUaIVK7HBMbNP3
        bmqJKAW295y1MboZb/t+S8Ns/3FgZsGw6Q==
X-Google-Smtp-Source: APXvYqx7lGuBpagLCMAnvw3niboFCUzdhessqvkkWV1rl49znxPNMa3upuwo5U2+YMoruguSzEq3Pw==
X-Received: by 2002:aa7:9315:: with SMTP id 21mr36446898pfj.162.1577414882405;
        Thu, 26 Dec 2019 18:48:02 -0800 (PST)
Received: from ?IPv6:2408:84e4:530:1c98:7d8b:68a3:1bb6:ae1d? ([2408:84e4:530:1c98:7d8b:68a3:1bb6:ae1d])
        by smtp.gmail.com with ESMTPSA id r20sm35534187pgu.89.2019.12.26.18.47.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Dec 2019 18:48:01 -0800 (PST)
Subject: Re: [PATCH net-next] sctp: move trace_sctp_probe_path into
 sctp_outq_sack
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, nhorman@tuxdriver.com,
        linux-sctp@vger.kernel.org
References: <20191226122917.431-1-qdkevin.kou@gmail.com>
 <43c9d517-aea4-1c6d-540b-8ffda6f04109@gmail.com>
 <20191226.153835.1092744996447366504.davem@davemloft.net>
 <20191227022801.GI5058@localhost.localdomain>
From:   Kevin Kou <qdkevin.kou@gmail.com>
Message-ID: <647b9a55-6236-5d67-6ba8-8a62e828f89c@gmail.com>
Date:   Fri, 27 Dec 2019 10:47:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:72.0) Gecko/20100101
 Thunderbird/72.0
MIME-Version: 1.0
In-Reply-To: <20191227022801.GI5058@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/12/27 10:28, Marcelo Ricardo Leitner wrote:
> On Thu, Dec 26, 2019 at 03:38:35PM -0800, David Miller wrote:
>> From: Kevin Kou <qdkevin.kou@gmail.com>
>> Date: Fri, 27 Dec 2019 07:09:07 +0800
>>
>>>
>>>
>>>> From: Kevin Kou <qdkevin.kou@xxxxxxxxx>
>>>> Date: Thu, 26 Dec 2019 12:29:17 +0000
>>>>
>>>>> This patch is to remove trace_sctp_probe_path from the TP_fast_assign
>>>>> part of TRACE_EVENT(sctp_probe) to avoid the nest of entry function,
>>>>> and trigger sctp_probe_path_trace in sctp_outq_sack.
>>>> ...
>>>>
>>>> Applied, but why did you remove the trace enabled check, just out of
>>>> curiosity?
>>>
>>> Actually, the check in trace_sctp_probe_path_enabled also done in
>>> trace_sctp_probe_path according to the Macro definition, both check
>>> if (static_key_false(&__tracepoint_##name.key)).
>>
>> Indeed, thanks for the explanation.
> 
> It was duplicated, yes, but it was also a small optimization:
> 
> if (enabled) {
>    for (X times) {
>      if (enabled) {
>      }
>    }
> }
> 
> So it wouldn't traverse the list if not needed.  But X is usually 1 or
> 2 and this list is already traversed multiple times in this code path.
> 

Yes, It is a small optimization indeed. let me changed a little, do 
testing and resend another patch. Thanks for your comments, Marcelo.


