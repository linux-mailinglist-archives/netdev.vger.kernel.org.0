Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4332F0997
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 20:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbhAJT6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 14:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbhAJT6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 14:58:33 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA530C061786;
        Sun, 10 Jan 2021 11:57:52 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id d26so14261027wrb.12;
        Sun, 10 Jan 2021 11:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fMHd+rFMIZGIdOUS2XaVVtZCKMLmT1TrsxLocIOEBNo=;
        b=NrZyGFtScewJhDlkLgEEAt5y7OiCki9AGmuDZ0DcGRjIY6Bu8b/QBVt8g2X7GsAgSC
         ZgyhyhU5ondohWihqHSWbj6aIc9eYMrgzcCdaOQ/+k+YoSa4WKxO2PBlxa+OfheBFnDu
         WdF1B1lk8PpqsNOgxAQy5ALwWBYygy+5xJm/IIuJjZQt6MM486UD3DIgpnHd1ctqjtMc
         x2GIrtcKe9cbhYg+zLZpgkQ2vl4Rfwx/TH0X3mPv/w43WkNNiRrl58l02MRskxT527Bk
         ecQlKqdY7kd5+5twd3Mcpl5KyEZ7k1/S653OANMO+tE8pvZzT/pXf/AqUj60vJmtvyeP
         37OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fMHd+rFMIZGIdOUS2XaVVtZCKMLmT1TrsxLocIOEBNo=;
        b=halimBGG5bw4SCQxUPdBe+xbG45fIPl6GnKnBzwP4NR2AFBpcN7x+p9wT5prO5r/fW
         T0IgbsK2HCRAMQlmlL8sxpUieQr+5XAj36h5U4u6El9u3CJWqHKfGs/40OFQhqnc2hRR
         zR8+/x6hKSjU5ZYPAZQ7xIz8FyynQ7h+aOOLzwM2Hk7bC4E97o2s/kwTt9kUgrfC8nci
         yfqbeQfui7JyBjsWScqEVGAXYTirlP3UkcVlsI1NM6N8zuDaKjqq7HsxqUBwdA0Bo5X+
         02QBuO3yYo2a/1Xuk1L2mx5Z6AxgyVDDdYr2VO0/eEsOfAinp7HQ/p41JsWev+U+7iKI
         mE/Q==
X-Gm-Message-State: AOAM533P3ceignAYacPCKPoEuJFNwiWKKSaqJ5THVV0xxDMcC5zAh9LS
        ULDFhohWoS/yLitUZ7iOMtP4zfs5jd0=
X-Google-Smtp-Source: ABdhPJwQ62LMKc4SuXQG05f8om2MHtI5/YbAoV70LNKJ8s7ukrNTpbRFGwgF3QwfyM4EaxpkV/cxxA==
X-Received: by 2002:a05:6000:10c4:: with SMTP id b4mr13454440wrx.170.1610308671692;
        Sun, 10 Jan 2021 11:57:51 -0800 (PST)
Received: from [192.168.1.143] ([170.253.51.130])
        by smtp.gmail.com with UTF8SMTPSA id v20sm22813757wra.19.2021.01.10.11.57.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jan 2021 11:57:51 -0800 (PST)
Subject: Re: [PATCH v2] netdevice.7: Update documentation for SIOCGIFADDR
 SIOCSIFADDR SIOCDIFADDR
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
References: <20210102140254.16714-1-pali@kernel.org>
 <20210102183952.4155-1-pali@kernel.org>
 <20210110163824.awdrmf3etndlyuls@pali>
Cc:     linux-man@vger.kernel.org, netdev@vger.kernel.org
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Message-ID: <16eaf3ce-3e76-5e34-5909-be065502abca@gmail.com>
Date:   Sun, 10 Jan 2021 20:57:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:84.0) Gecko/20100101
 Thunderbird/84.0
MIME-Version: 1.0
In-Reply-To: <20210110163824.awdrmf3etndlyuls@pali>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ CC += netdev ]

On 1/10/21 5:38 PM, Pali Rohár wrote:
> On Saturday 02 January 2021 19:39:52 Pali Rohár wrote:
>> Also add description for struct in6_ifreq which is used for IPv6 addresses.
>>
>> SIOCSIFADDR and SIOCDIFADDR can be used to add or delete IPv6 address and
>> pppd is using these ioctls for a long time. Surprisingly SIOCDIFADDR cannot
>> be used for deleting IPv4 address but only for IPv6 addresses.
>>
>> Signed-off-by: Pali Rohár <pali@kernel.org>
>> ---
>>  man7/netdevice.7 | 50 +++++++++++++++++++++++++++++++++++++++++-------
>>  1 file changed, 43 insertions(+), 7 deletions(-)
> 
> Hello! Is something else needed for this patch?

Hello Pali,

Sorry, I forgot to comment a few more formatting/wording issues: see
below.  Apart from that, I'd prefer Michael to review this one.

Thanks,

Alex

> 
>> diff --git a/man7/netdevice.7 b/man7/netdevice.7
>> index 488e83d9a..12f94bfd7 100644
>> --- a/man7/netdevice.7
>> +++ b/man7/netdevice.7
>> @@ -55,9 +55,26 @@ struct ifreq {
>>  .EE
>>  .in
>>  .PP
>> +AF_INET6 is an exception.

[
.B AF_INET6
is an exception.
]

Sorry, this was my mistake on the previous review,
as I mixed expected output with actual code, and confused you.

>> +It passes an
>> +.I in6_ifreq
>> +structure:
>> +.PP
>> +.in +4n
>> +.EX
>> +struct in6_ifreq {
>> +    struct in6_addr     ifr6_addr;
>> +    u32                 ifr6_prefixlen;
>> +    int                 ifr6_ifindex; /* Interface index */
>> +};
>> +.EE
>> +.in
>> +.PP
>>  Normally, the user specifies which device to affect by setting
>>  .I ifr_name
>> -to the name of the interface.
>> +to the name of the interface or
>> +.I ifr6_ifindex
>> +to the index of the interface.
>>  All other members of the structure may
>>  share memory.
>>  .SS Ioctls
>> @@ -142,13 +159,32 @@ IFF_ISATAP:Interface is RFC4214 ISATAP interface.
>>  .PP
>>  Setting the extended (private) interface flags is a privileged operation.
>>  .TP
>> -.BR SIOCGIFADDR ", " SIOCSIFADDR
>> -Get or set the address of the device using
>> -.IR ifr_addr .
>> -Setting the interface address is a privileged operation.
>> -For compatibility, only
>> +.BR SIOCGIFADDR ", " SIOCSIFADDR ", " SIOCDIFADDR
>> +Get, set or delete the address of the device using

[Get, set, or delete ...]

Note the extra comma (Oxford comma).

>> +.IR ifr_addr ,
>> +or
>> +.I ifr6_addr
>> +with
>> +.IR ifr6_prefixlen .
>> +Setting or deleting the interface address is a privileged operation.
>> +For compatibility,
>> +.B SIOCGIFADDR
>> +returns only
>>  .B AF_INET
>> -addresses are accepted or returned.
>> +addresses,
>> +.B SIOCSIFADDR
>> +accepts
>> +.B AF_INET
>> +and
>> +.B AF_INET6
>> +addresses and

[addresses, and]

Rationale: clearly separate SIOCS* text from SIOCD* text.

>> +.B SIOCDIFADDR
>> +deletes only
>> +.B AF_INET6
>> +addresses.
>> +.B AF_INET
>> +address can be deleted by setting zero address via

Suggestion:

[
A
.B XXX
address ... by setting it to zero via
]

Although I don't know exactly how all this works,
so it's only a suggestion, but that needs some wording fix.

>> +.BR SIOCSIFADDR .
>>  .TP
>>  .BR SIOCGIFDSTADDR ", " SIOCSIFDSTADDR
>>  Get or set the destination address of a point-to-point device using
>> -- 
>> 2.20.1
>>


-- 
Alejandro Colomar
Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
