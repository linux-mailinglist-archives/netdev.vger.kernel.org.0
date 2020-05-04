Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699861C317A
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 05:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgEDDkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 23:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbgEDDkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 23:40:39 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FFEC061A0E
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 20:40:38 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id k22so12347311eds.6
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 20:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=WF2Hl2LJ8qhAFZKEyl8hGYbf2PR8TYNsy3HiW11DVqI=;
        b=OSimv1tKgn39kCEp3ljkGuRbCvJx1yvlKAKq/f/8U4HqRz7AKcNT1Arx7tq1Uuvv1o
         qUvYEU7fZQGrm+dVuZINjMOVnYZFyb/dJUH2OtaAV7D2F4Tt1UuEMb4lxQYbqG1pzWuO
         LgV1t6dikYWjw0OdBASALM36oXzX9AWS6LJWp5KU7jrFR3cTVUPR0c0tp6Rvvn1dCzHp
         IFfgk6t7VjzS27k3QVGQeOni9dL2udr8/HI96+yRynvrIdhK1hLtphbgO5buzpofaRc2
         ca/fPjl1Wq0MxoEKzSGAQgeCt8ew52/riHhT/3YXP0xtvhHojJTgjVTgdWhjfSakp9kh
         LnfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WF2Hl2LJ8qhAFZKEyl8hGYbf2PR8TYNsy3HiW11DVqI=;
        b=QYT2O5ZC/4Zf7JohLrD6LOQ/XSB7hygJ4uYdDrI010lzUP1j3qfP3wL2pv7DWnrPqf
         hdeg71APvAk7ZMR8A5nNXNhYzjIzGvrcJRr8rVvcgLwk9jrFXyI+gLf05IG6aQQQQARq
         34sMXPozLvP/mJxF+JlBU+zfmcvPFuMfJvSBhBMl084jrHfeQSqkJrBqugBOIKvC/2E8
         zKUsRRM9v7XE1/SmaE15kvrnthob1oS0+/HkvpxuyCbLqkag8ptdSGDnoGg76iHNmjyV
         X4cmgjGVLeJGA21v1zKrAPm5ZNcKx+wnDp4cKrE24+YsEQttpYqi9StGsfGYAq6Bll/V
         6R0Q==
X-Gm-Message-State: AGi0PuYIqQXTmdYgNQlx4RKQDO4qHYKWKsK/2Q+8vzL0kSFhdSHBUz48
        3X9ycga4B69A6g8IQ7n9Mnw09FFF
X-Google-Smtp-Source: APiQypK38w7Rx5ynZJQqsVgNxnoEvMihRTWi25UOTCTjcpm5y7AvfN8JZcHjQ5d21EXWdQvygzEvWQ==
X-Received: by 2002:aa7:d655:: with SMTP id v21mr13333420edr.355.1588563637225;
        Sun, 03 May 2020 20:40:37 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 10sm1378006ejt.80.2020.05.03.20.40.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2020 20:40:36 -0700 (PDT)
Subject: Re: Net: [DSA]: dsa-loop kernel panic
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     Allen <allen.pais@oracle.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <9d7ac811-f3c9-ff13-5b81-259daa8c424f@oracle.com>
 <dd42f431-d555-fcd2-b25e-50aeecbb513b@gmail.com>
 <c998f49c-0119-7d8c-7cbc-ab8beadfa82d@oracle.com>
 <1ec3b421-dee5-e291-ac17-5d2f713b9aae@gmail.com>
 <9a4912aa-3129-1774-5f21-2f6fb4afafb2@oracle.com>
 <a15245fb-a9a4-4bcd-8459-fe3cbcc03119@gmail.com>
Message-ID: <82bc0bdf-e4f6-2b85-d2ad-54632b287a60@gmail.com>
Date:   Sun, 3 May 2020 20:40:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <a15245fb-a9a4-4bcd-8459-fe3cbcc03119@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/3/2020 2:06 PM, Florian Fainelli wrote:
> Le 2020-05-01 à 10:58, Allen a écrit :
>>>>
>>>>   It maps to "eth0". Please let me know if you need further details.
>>>
>>> I suppose I should have been clearer, what network device driver created
>>> eth0?
>>>
>>
>>  This was seen on a VM.
>> eth0 [52:54:00:c1:cd:65]: virtio_net (up)
> 
> I have reproduced it here with virtio_net and am now looking into this,
> at first glance it does not look like we are properly holding the device
> reference count for the case where DSA was probed via platform device
> configuration.

There is a DSA master reference counting issue, but with dsa-loop, the
DSA master is already properly reference counted thanks to the
dev_get_by_name() call, I will keep digging.
-- 
Florian
