Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA6335F14C
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 12:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbhDNKLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 06:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233699AbhDNKJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 06:09:31 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1080C061574;
        Wed, 14 Apr 2021 03:09:08 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id 12so19308403wrz.7;
        Wed, 14 Apr 2021 03:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Tp67B742QCHa2XNTvhcxhiVJxWAG6Yxz+2slbmO2ils=;
        b=Ao/hjY28gEDzu8diL8Qcgh4IkiIUbBqGJHK+NqbuSJcXDmxFACSHKQFt2Y/0Hsbnno
         zQtCbWdicG5ZRw+GGt1lNo/ed4yRB4vaCqBMldeO/Sjadn1RG32VVfIPJ0zDy7QcCM1T
         iMbMNIx3Dwi7uBupTAn1Jqhgqd+8izO4k2EUDlvyajozSH8ekRrj6izSDou4+FnBRBFD
         g2lSIFQqJ/1QxCbRkxkzLUoqzlU0bpuKJel5TcIxlacV2ZkN8E8bETBrvTLIqIMrpqyw
         apdfCwKPfmGxW2WXMg/zLwx1EFE98LxH9YNeeAO1gpyD4il9aZmBsiOEIBYLufS8E2QK
         9nYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Tp67B742QCHa2XNTvhcxhiVJxWAG6Yxz+2slbmO2ils=;
        b=WRuIy3nfq8FJWYSxu+YmeLxqOlCXfCDTLcQVUVN6FO08ZQdUueYGWshohILPDcrkTw
         uXjgC9//sntlHn7w6z98UHGBh4Tl/CfzoHv+96R5TwG9HoCnuXU06FHyaUApzYXjlMIF
         NL75TczgrnEKIlsemr407OIsx3/j4n+Apae+MnjdeWEiXbLLq6WW2DUyl66FKH02zFIh
         V9JgkYtFkk2W+Ojs1VBp5y5BHJM8ZKgvWBQUlHb30knL1ZHaD6LjtNjbgd9Pv9yfO0T5
         /jfS9Imw/8kgZMHQPkNaPxkRi7fdCCJt5x9WWwPwcPT2oIckTRNsbX4KgnZBeLj9/TM4
         mLJQ==
X-Gm-Message-State: AOAM533eoJNMsYEdO6MNqNC6hFIQzWSdfuaWbuLylAe6Dv9u8lKqqtNC
        7bDSkTwKw7k3gIG1j23R6x6UcRBgyaI=
X-Google-Smtp-Source: ABdhPJyvJmCvKDjFdkcNDaeRC4I9IYuZsWmU6cDHET8qJhQ7wjbKtclKCzv0PbsWcDVjhLJllkDOEA==
X-Received: by 2002:adf:fe4f:: with SMTP id m15mr31369039wrs.67.1618394947689;
        Wed, 14 Apr 2021 03:09:07 -0700 (PDT)
Received: from [10.8.0.194] ([195.53.121.100])
        by smtp.gmail.com with ESMTPSA id m11sm22442968wri.44.2021.04.14.03.09.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 03:09:07 -0700 (PDT)
Subject: Re: arp(7) description of gc_stale_time
To:     Adam Liddell <ml+kernel.org@aliddell.com>, mtk.manpages@gmail.com
Cc:     linux-man@vger.kernel.org, netdev@vger.kernel.org
References: <6bbb488b-bee2-4ddb-873b-983973984c70@www.fastmail.com>
 <0fed7f03-605b-430b-bdfc-47a67af3f083@www.fastmail.com>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Message-ID: <94006afd-5ba5-ffd3-835e-22e2ca87dec3@gmail.com>
Date:   Wed, 14 Apr 2021 12:09:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <0fed7f03-605b-430b-bdfc-47a67af3f083@www.fastmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[CC += netdev]

On 4/12/21 12:13 AM, Adam Liddell wrote:
> Hi,
> 
> Any opinion on this?
> 
> Adam
> 
> On Tue, 16 Feb 2021, at 17:00, Adam Liddell wrote:
>> Hi,
>>
>> The arp(7) page's description of gc_stale_time doesn't quite describe
>> the behaviour correctly, at least as I understand it.
>>
>> The current description suggests this is the time interval at which a
>> loop will look for stale entries. However, this field is the threshold
>> for marking an entry dead for removal, based on when it was last used
>> (see net/core/neighbour.c lines 935-942) and whether the table is over
>> gc_thresh1. How often this check is done appears to be determined by
>> base_reachable_time (/2) and the third option gc_interval is not
>> involved in this process as far as I can tell, despite its name.
>>
>> Perhaps a draft alternate description could be something along the lines of:
>>
>> Determines the threshold for removing a cache entry after it was last
>> used and when the cache is larger than gc_thresh1. Defaults to 60
>> seconds.
>>

Hi Adam,

Thanks for the ping.  I don't know, sorry.
I added netdev@ so that maybe they can give an opinion.  In the 
man-pages, that text has been there since we use git, so I don't know 
who wrote it.

Thanks,

Alex


-- 
Alejandro Colomar
Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
