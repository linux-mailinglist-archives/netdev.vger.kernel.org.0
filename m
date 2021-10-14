Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A69742DDEF
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 17:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbhJNPUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 11:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbhJNPUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 11:20:00 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DBBC061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 08:17:55 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id t2so6046021qtx.8
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 08:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=A/Ao1/VZ7zK7qrSpRYFgCFChgYWpQjOIEy40S8T48Xc=;
        b=18Wy7iDGkLqXAzZ9IU2GsGwHTSOuE3d7XnSLg0WX1dM2dHqkK1IRGDCLPrmQ0dsFeF
         nr1fvqNVusZufxOpehH3+EaZNhEoLI3dBw7V4Cah++GH839Ro+TilG+9MEitHC98ohsH
         Od9Jtea1/+2IeRoatTb9LE1Q/TqJ1SDCxghokDnGa/HJs3++GCgJvkz4CzvHPPRfrPlU
         AbzdMIhxmNKzT2N54llMADiFdBSy63nMXxZ1+hoezGKhVJA+iwHFSqA7J7IOhj0Ifb2E
         FH7QfeU+Vuq4IpnwXRostXhtQPRu6l3oKg8bJ73ENgJWskoJxoikJIOU3SOjky5dSxn8
         E9tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=A/Ao1/VZ7zK7qrSpRYFgCFChgYWpQjOIEy40S8T48Xc=;
        b=wS3HKV4ZUL+qb6QoDsOTWC1hT5iA1aSNQhkegIvIDUQlrDq+kftLsyBuLB+0aSRO4y
         BZxOo+lmHle/95YKj5+LC2yotVPJnjduuJMa3y6W9IUBHfa3NeS0P4REcxvDkWPOftC+
         ka5fOIBVgU6YnH0j9v21JZ/WaJy3pJMnmJEKOiOy00SoL6k1nNXAOPgWROQ81wleosoD
         EcBMhq9T1rByKROryeuRTgzzKigefsapJRgOkEynvGpYHWJPliUS4dKAw2HinPxOXeem
         X2ySKeYXYYgsAPWoL/5UmuXfjZ13iEybaD5a8kdoXyBT4c5h/sSgD7NA9d3bMfZ3f/SH
         SXYg==
X-Gm-Message-State: AOAM533YMNAzAUuLWSi8zG0rDh4x9RfEK2ubIL1+SApC0YjbyGSaLeU9
        OTV2MIkbi2cHgrhqEXVe6LzAH2ByRx3Fww==
X-Google-Smtp-Source: ABdhPJxYwflFbswqioOmEQhUhZZnSR3K8H/u8+st6rLcwKQiToQDNF+38WVGGHbrqNRj+VwqS3hPdw==
X-Received: by 2002:a05:622a:190e:: with SMTP id w14mr3367039qtc.112.1634224674726;
        Thu, 14 Oct 2021 08:17:54 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id b8sm1486874qtr.82.2021.10.14.08.17.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 08:17:54 -0700 (PDT)
Message-ID: <6263102e-ddf2-def1-2dae-d4f69dc04eca@mojatatu.com>
Date:   Thu, 14 Oct 2021 11:17:53 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Anybody else getting unsubscribed from the list?
Content-Language: en-US
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
References: <1fd8d0ac-ba8a-4836-59ab-0ed3b0321775@mojatatu.com>
 <20211014144337.GB11651@ICIPI.localdomain>
 <ce98b6b2-1251-556d-e6c8-461467c3c604@mojatatu.com>
 <20211014145940.GC11651@ICIPI.localdomain>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20211014145940.GC11651@ICIPI.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ok, so common denominator seems to be google then...

Other than possibly an outage which would have affected
a large chunk of the list using gmail cant quiet explain it.

cheers,
jamal

On 2021-10-14 10:59, Stephen Suryaputra wrote:
> I believe it is around the 11th like what you experienced. I came to
> realize when I thought that the 12th seems to be very quiet in term of
> patches. I went to patchwork and saw that are patches on the day, so
> I suspected that I've been unsubscribed.
> 
> I'm using gmail like you see, so not sure if there was a long outage for
> gmail. Doubtful about gmail outage...
> 
> I didn't see any suspicious email around the 11th.
> 
> Regards,
> Stephen.
> 
> On Thu, Oct 14, 2021 at 10:51:15AM -0400, Jamal Hadi Salim wrote:
>> On 2021-10-14 10:43, Stephen Suryaputra wrote:
>>> +1. Had to re-subscribe.
>>>
>>
>> Thanks for confirming. Would be nice to be able maybe
>> to check somewhere when you suspect you are unsubscribed.
>> The mailing list is incredibly solid otherwise (amazing
>> spam filtering for one).
>>
>> cheers,
>> jamal

