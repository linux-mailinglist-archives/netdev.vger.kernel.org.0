Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77AF42C7A2A
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 18:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbgK2RIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 12:08:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42861 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725830AbgK2RIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 12:08:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606669644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TyjVqTa6NUPGToY9p6hor+b7VRN4ayK0LceC/nKvy/8=;
        b=ZaMizYOKNep+3m0+JUy15Qlo+z9EzAS09CUQmKsD+V8Agd0EHH5xwOqfBe+3aaxHeThgV0
        nLbpexWPFphZYxTAcLuOcbhWuIlSy0ASiwl4wRTbCb7VFMdkeV6gdjKeLJ5y+G0BMelcX4
        plnSHaf/1gJ2lzfvL837PV0GY7oKbcs=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-ggbI37ATNt296nYGXSiInQ-1; Sun, 29 Nov 2020 12:07:22 -0500
X-MC-Unique: ggbI37ATNt296nYGXSiInQ-1
Received: by mail-qk1-f200.google.com with SMTP id q206so3277794qka.14
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 09:07:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=TyjVqTa6NUPGToY9p6hor+b7VRN4ayK0LceC/nKvy/8=;
        b=OFjRcCCCbKSpryLTKt7QHI0RdV9275uSBlcJqoK/RxRjc0QMzZ2hqB5OlE7LAbUzwq
         B3os9zETM5BSTinrNXupPFd561oTbRBwcbESgZ+AMqEnLijWovLKCl8IafVVlAqHpFzq
         9m8uBLhYn5m7+DA0XUT6wfKtEHBqqmk2ChDZQeZ7Mv2nMmrntxQT5N95ytPcJX7Gq/YK
         L2O1rpwowmKBB5Cs5EaeBLUPg0nP6tBc1AUDr5L9fXXEysHJt5dSQLP7G+4CiG3CPmWC
         hsy+l8K4BkIYJNFOuzEwPqRWi2iNOmTsssvYfBRgRXYTVCy9yX8IywxCUN9VZaqvKzFX
         1miQ==
X-Gm-Message-State: AOAM532/KvBwsdwUYhKOoL8m0iqHP8izeY0ZVaE3z9toVIsYKRE4MG+T
        XbsRzwQQZhO8fVQVQPkHMbiVnvu32Iq0O4ZkBQg4mhBu+Gj9AGuhh9gAvbJbSxvuz6akj3jsmc3
        emBp/CvfREIXaZs18
X-Received: by 2002:ac8:6b92:: with SMTP id z18mr17731425qts.30.1606669641856;
        Sun, 29 Nov 2020 09:07:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzcKPSJbIDZTeENhugPtBcfNSXqYBW9nMvLxq75Tw/YbveHMS/XqeAavLpXoiwr+j9jZP/yKQ==
X-Received: by 2002:ac8:6b92:: with SMTP id z18mr17731398qts.30.1606669641579;
        Sun, 29 Nov 2020 09:07:21 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id r125sm12970308qke.129.2020.11.29.09.07.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Nov 2020 09:07:21 -0800 (PST)
Subject: Re: [PATCH] NFS: remove trailing semicolon in macro definition
To:     Trond Myklebust <trondmy@hammerspace.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>
Cc:     "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20201127194325.2881566-1-trix@redhat.com>
 <96657eff83195fba1762cb046b3f15d337e5daad.camel@hammerspace.com>
 <110444322a9c301c520c1e57e9a6f02b29ad25c1.camel@hammerspace.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <4805ce94-b522-b774-031c-7091b7ac7c5e@redhat.com>
Date:   Sun, 29 Nov 2020 09:07:19 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <110444322a9c301c520c1e57e9a6f02b29ad25c1.camel@hammerspace.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/29/20 8:50 AM, Trond Myklebust wrote:
> On Sun, 2020-11-29 at 16:42 +0000, Trond Myklebust wrote:
>> Hi Tom,
>>
>> On Fri, 2020-11-27 at 11:43 -0800, trix@redhat.com wrote:
>>> From: Tom Rix <trix@redhat.com>
>>>
>>> The macro use will already have a semicolon.
>>>
>>> Signed-off-by: Tom Rix <trix@redhat.com>
>>> ---
>>>  net/sunrpc/auth_gss/gss_generic_token.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/net/sunrpc/auth_gss/gss_generic_token.c
>>> b/net/sunrpc/auth_gss/gss_generic_token.c
>>> index fe97f3106536..9ae22d797390 100644
>>> --- a/net/sunrpc/auth_gss/gss_generic_token.c
>>> +++ b/net/sunrpc/auth_gss/gss_generic_token.c
>>> @@ -46,7 +46,7 @@
>>>  /* TWRITE_STR from gssapiP_generic.h */
>>>  #define TWRITE_STR(ptr, str, len) \
>>>         memcpy((ptr), (char *) (str), (len)); \
>>> -       (ptr) += (len);
>>> +       (ptr) += (len)
>>>  
>>>  /* XXXX this code currently makes the assumption that a mech oid
>>> will
>>>     never be longer than 127 bytes.  This assumption is not
>>> inherent
>>> in
>> There is exactly 1 use of this macro in the code AFAICS. Can we
>> please
>> just get rid of it, and make the code trivially easier to read?
>>
>
> BTW: To illustrate just how obfuscating this kind of macro can be, note
> that the line you are changing above will be completely optimised away
> in the 1 use case we're talking about. It is bumping a pointer value
> that immediately gets discarded.

Yes, I agree.

I was wondering about expanding treewide, all the single shot macros defined/used in c files.

other fixers that cleanup unused variables would remove the unneeded expansions like this one.

