Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902DB29D2CD
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgJ1VfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:35:03 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:41464 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbgJ1Vew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:34:52 -0400
Received: by mail-wr1-f47.google.com with SMTP id s9so602795wro.8;
        Wed, 28 Oct 2020 14:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IuP949dG0+DWn31M04KK5J9UKxpCI760UAxwvXHAQsI=;
        b=cIteXMQo6F6Yf9S5Oep5D6H+WMxEFfLA69hgeToPpBCmkV1WhoijedmYslfxrSIGFC
         iafwpVMNETptExzz4KgKYmW7uzOq3Nf9WfEm4SpmhXrhTCmBA7vLvvUtKCAefN/FbGTu
         rWtnasUWKYqm7eMhAK3axEzNMWxFXMctJTsL9cwPrkWVhzBGi+uLdxuDSaJ9UH13pDEe
         RD6TeeGeFmtKLc6Ju6r+82lWNpwJino4D+TyQ7GjgLJTXfHTuETEjo0zU7yeyBNYXSWj
         TjbhjVKu72tbwpBY2y8lfvDwHfFIPSFiYhrmH5nsvJWVgtB14pze/WbUW2a9h/5adCcr
         Mrkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:cc:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IuP949dG0+DWn31M04KK5J9UKxpCI760UAxwvXHAQsI=;
        b=fi5fqhNOkw5o760atifaG+tpuQcwD1wD6rYWRHgsw+RLMMqVS0+5+zYGhEvSavG5mX
         MTDzqAEXUgv2FnUugMRkDja0s3tx+wTyoXTfDdSI4SXAIMLdYSz0XvvrRCWt8UN9ll6k
         3oSJQHACtS95wUkIJHTq7lgIdP8XUxZEiVmzH8I3d/vX8eJWFYKqiPT//o6zNT6YcdKF
         m+WbPjxX1BeTEKQF8DXwDicI0lQbw7848h6n5kIeMWSBQ2fLdhrXHHrfF/tdrjXdfyPQ
         EEijcFxNl9iiIN1J5JOuUgtkMacPz5kLqx8xoMIIX18pK5oXYZMv940a07u1Z/mYot4i
         0aYQ==
X-Gm-Message-State: AOAM530OYkcbjWmFmgZ8uNLl21T6SeI3RsNI8RAPgKUsV4Vg53FH/VBR
        V5NvETr8D5lr8RgZJyytPOyXZRrczGM=
X-Google-Smtp-Source: ABdhPJxTM75Qf+Bn0Vg9gcGZXmafWisSeQ4w9Pp5c5cWS9LSUKYsUsWm5DZ0jF86llL25rLEOvbFWQ==
X-Received: by 2002:a5d:4b12:: with SMTP id v18mr6532827wrq.259.1603865720043;
        Tue, 27 Oct 2020 23:15:20 -0700 (PDT)
Received: from ?IPv6:2001:a61:245a:d801:2e74:88ad:ef9:5218? ([2001:a61:245a:d801:2e74:88ad:ef9:5218])
        by smtp.gmail.com with ESMTPSA id v123sm4806754wme.7.2020.10.27.23.15.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2020 23:15:19 -0700 (PDT)
Cc:     mtk.manpages@gmail.com
Subject: Re: [patch] socket.7: document SO_INCOMING_NAPI_ID
To:     Sridhar Samudrala <sridhar.samudrala@intel.com>,
        linux-man@vger.kernel.org, netdev@vger.kernel.org
References: <1603847722-29024-1-git-send-email-sridhar.samudrala@intel.com>
 <b3df59a9-a2c3-20c8-7563-e974e596dd2a@gmail.com>
From:   "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Message-ID: <606f44d0-2542-9027-2154-3191e47f0a6f@gmail.com>
Date:   Wed, 28 Oct 2020 07:15:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <b3df59a9-a2c3-20c8-7563-e974e596dd2a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/28/20 7:13 AM, Michael Kerrisk (man-pages) wrote:
> On 10/28/20 2:15 AM, Sridhar Samudrala wrote:
>> Add documentation for SO_INCOMING_NAPI_ID in socket.7 man page.
> 
> Hello Sridhar,
> 
> Thank you!
> 
> Would it be possible for you to resubmit the patch, with a commit
> message that says how you obtained or verified the information.
> This info is useful for review, but also for understand changes
> when people look at the history in the future.

D'oh! One thing I should have checked before I hit send, I guess:

[[
commit 6d4339028b350efbf87c61e6d9e113e5373545c9
Author: Sridhar Samudrala <sridhar.samudrala@intel.com>
Date:   Fri Mar 24 10:08:36 2017 -0700

    net: Introduce SO_INCOMING_NAPI_ID
]]

But, it helps if you tell me that in the accompanying mail
message.

Thanks again for the patch. I';ll apply and fix the newlines.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
