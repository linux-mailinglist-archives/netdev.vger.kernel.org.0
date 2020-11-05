Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1FA02A756D
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 03:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387735AbgKEC0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 21:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387699AbgKEC0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 21:26:14 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F74C0613CF;
        Wed,  4 Nov 2020 18:26:14 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id j18so173037pfa.0;
        Wed, 04 Nov 2020 18:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=aN2VJlOwLJDzq5SW3NAeCQ4IQzHScs1tSJ+sWZ4PuuE=;
        b=cmApw21x6XMxEXGLvq0E/VHQ5RQ5zN1kYwizsAUJbtXZC6BpIc/Ou/vL0ZjJ+fnHrN
         kH/ESE5lPiUOBwchmb2U0JJ/tkAQMcYPAlVEk7UrcCGayeX2iaXk0O9NNV3hWPH1yha7
         XzdQ67B6j515pZVC9GIzpshAk8fAGXGs2s7Clj+SyGeF22ya9DfsnnglgMNlVHAUClI/
         Lepoy67FE4s5BKHKpLzP4SdkSRF5VTS5IiWAtjbHwPhDQnmayyMepPHkcoGFRhr63uBL
         juOPRs6xHJBEm3vQN8rm3HB+dNbiNO9qgJtqCFuw018xmhZpYEaXUxiuIhU64y6UC8ay
         l5FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=aN2VJlOwLJDzq5SW3NAeCQ4IQzHScs1tSJ+sWZ4PuuE=;
        b=Z6lcyl+oK/Hd1yV9Z4ryS93tJtsQuzB9/VqyqY3cYgpv8pSHpHOZFUTfxMnapycsZ1
         WvY5b8BpuPapJYPWpBHyJTH2bMaFvbRoeVE1n6vu/JRMdh/5lPyrzWwW7Zc9ORJUlU3F
         TRynxLud5K2XM6F2o13AhbH/Bq3J7oYT+Z4NXSkx/ZkYGej3UJdxWoxYb0N6b00qCFDh
         9PzyRK4SYGHkdKeuXT4lQgBLkxvnosCM90a1Ar7hDHglt+fH+PNcj6vS1/1TBYPm4khy
         oFTtZFAsTMlRNHa9gUfJBfKhA22Knj3gq1HEHhhLdRwkxBX02Ub3YTQC2+RnB6LtjD8I
         1PDQ==
X-Gm-Message-State: AOAM533kwYwwQZBUO5CGSqjcxMZbNuZHcYwpHuvaLILkrDek2cDEytor
        yGEOqX2wZL3JEtEjRwWMTo8=
X-Google-Smtp-Source: ABdhPJxedl4jUMzUMl4EsKLOilb+nrQqtC+i0oWgXRlmi8E85vynkCFiwkEY3jGq9+pVrKTDZ6WATw==
X-Received: by 2002:a17:90a:aa85:: with SMTP id l5mr123666pjq.119.1604543173469;
        Wed, 04 Nov 2020 18:26:13 -0800 (PST)
Received: from [192.168.0.104] ([49.207.201.182])
        by smtp.gmail.com with ESMTPSA id e10sm197790pfl.162.2020.11.04.18.26.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 18:26:12 -0800 (PST)
Subject: Re: [RESEND PATCH v3] net: usb: usbnet: update
 __usbnet_{read|write}_cmd() to use new API
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
References: <20201102173946.13800-1-anant.thazhemadam@gmail.com>
 <20201104162444.66b5cc56@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Message-ID: <dc3a4901-9aad-3064-4131-bc3fc82f965f@gmail.com>
Date:   Thu, 5 Nov 2020 07:56:08 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201104162444.66b5cc56@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 05/11/20 5:54 am, Jakub Kicinski wrote:
> On Mon,  2 Nov 2020 23:09:46 +0530 Anant Thazhemadam wrote:
>> Currently, __usbnet_{read|write}_cmd() use usb_control_msg().
>> However, this could lead to potential partial reads/writes being
>> considered valid, and since most of the callers of
>> usbnet_{read|write}_cmd() don't take partial reads/writes into account
>> (only checking for negative error number is done), and this can lead to
>> issues.
>>
>> However, the new usb_control_msg_{send|recv}() APIs don't allow partial
>> reads and writes.
>> Using the new APIs also relaxes the return value checking that must
>> be done after usbnet_{read|write}_cmd() is called.
>>
>> Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
> So you're changing the semantics without updating the callers?
>
> I'm confused. 
>
> Is this supposed to be applied to some tree which already has the
> callers fixed?
>
> At a quick scan at least drivers/net/usb/plusb.c* would get confused 
> as it compares the return value to zero and 0 used to mean "nothing
> transferred", now it means "all good", no? 
>
> * I haven't looked at all the other callers

I see. I checked most of the callers that directly called the functions,
but it seems to have slipped my mind that these callers were also
wrappers, and to check the callers for these wrapper.
I apologize for the oversight.
I'll perform a more in-depth analysis of all the callers, fix this mistake,
and send in a patch series instead, that update all the callers too.
Would that be alright?

Thank you for your time.

Thanks,
Anant
