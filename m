Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9E5342985
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 01:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhCTArQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 20:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhCTAqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 20:46:49 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B812AC061760
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 17:46:37 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id ay2so3701895plb.3
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 17:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DfHr2OZC6ti7xti2x8rAsEs6q9sE7h/2w6wYEFfglPc=;
        b=pgjkJLNq63YpyfO4Wp23LV3Upmbtlx5uAo7Cd4IyOyeeK2xNTzPWJatWe9jmkA85jF
         1pwPA1uo5Bm03X0kbWt23DNqYCRnBvuTNv1hvP8LlW0vRc9HrzhaB1P+8L4mONCfmNrw
         X6dgL9n3WITlxU26X7etlxoNQ5JneoGYlI4S0uHM7ozw8t1PoG3wnYCF/ZgeZeEOo7Ff
         HPkNwVVeI3ifw6SkzkV4ii7JPn4VRKaQm33WANmQBfyzkKVCv307wAL5MMn3U7XajgYH
         NgstZsVrW4j7d9nCUGVFwCnE9HRjjQAtDeK1D6btrppur1LF4wYueRcbPpChM2y8WYEC
         ++7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DfHr2OZC6ti7xti2x8rAsEs6q9sE7h/2w6wYEFfglPc=;
        b=uCc0lZuqxGwhoF584Wt7yYw1sqPomgrYAgx/fP9+u5LNM0DJWu7GQIZmnJiEIDjqZ/
         jr84oMPUlOPMJj3Jv2aAlZl/XigrGVrPcsG6smuBRJUP0Sls2XoagPe29QqkfsKDcMKQ
         7J+od+eHK5j4PyPK8DA97Yv0hJniNrAqhV1B5abSs9vfsSgAKap9nhqX26e5Vah9rh/U
         gFV+eoCmJylz/7K4UKBdIFOcFZ6bRFrrgf+FThif4a+LXg/UD4GVwQbdGOfJ0/M3cO9b
         y5lkvkN0OpRjnhyw4x4sJ7eUHhzNr2hPWzwqPyaSyN7OLGjV77CfwytS+lZ2f+BpirHx
         KZZQ==
X-Gm-Message-State: AOAM533PSnST6478JHl6OisD4DvcoXxerVHz6Xq/dhA18OMuUf5+CMn+
        IP5IAvX5nPVvy/dFNiPMtNo=
X-Google-Smtp-Source: ABdhPJwBOf2y94TgLkQdt02ArqWg/IPMijqfsp+kadLgTXNirMFB4NWnUNjVELEcbmRbJvBRpdyhkQ==
X-Received: by 2002:a17:90a:2c09:: with SMTP id m9mr1143309pjd.3.1616201197016;
        Fri, 19 Mar 2021 17:46:37 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 202sm6422104pfu.46.2021.03.19.17.46.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 17:46:36 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: cosmetic fix
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
References: <20210319143149.823-1-kabel@kernel.org>
 <20210319185820.h5afsvzm4fqfsezm@skbuf> <20210319204732.320582ef@kernel.org>
 <e6bfbd22-aee7-eaba-46cd-50853d243c78@gmail.com>
 <20210319235440.3b964108@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <38346eab-9a83-12e6-ed87-53bcfae1e587@gmail.com>
Date:   Fri, 19 Mar 2021 17:46:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210319235440.3b964108@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/19/2021 3:54 PM, Marek Behún wrote:
> On Fri, 19 Mar 2021 15:14:52 -0700
> Florian Fainelli <f.fainelli@gmail.com> wrote:
> 
>> On 3/19/2021 12:47 PM, Marek Behún wrote:
>>> On Fri, 19 Mar 2021 20:58:20 +0200
>>> Vladimir Oltean <olteanv@gmail.com> wrote:
>>>   
>>>> On Fri, Mar 19, 2021 at 03:31:49PM +0100, Marek Behún wrote:  
>>>>> We know that the `lane == MV88E6393X_PORT0_LANE`, so we can pass `lane`
>>>>> to mv88e6390_serdes_read() instead of MV88E6393X_PORT0_LANE.
>>>>>
>>>>> All other occurances in this function are using the `lane` variable.
>>>>>
>>>>> It seems I forgot to change it at this one place after refactoring.
>>>>>
>>>>> Signed-off-by: Marek Behún <kabel@kernel.org>
>>>>> Fixes: de776d0d316f7 ("net: dsa: mv88e6xxx: add support for ...")
>>>>> ---    
>>>>
>>>> Either do the Fixes tag according to the documented convention:
>>>> git show de776d0d316f7 --pretty=fixes  
>>>
>>> THX, did not know about this.
>>>   
>>>> Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x family")
>>>>
>>>> or even better, drop it.  
>>>
>>> Why better to drop it?  
>>
>> To differentiate an essential/functional fix from a cosmetic fix. If all
>> cosmetic fixes got Fixes: tag that would get out of hands quickly.
> 
> IMO in this case the Fixes tag is not necessary beacuse the base commit
> is not in any stable kernel yet.

This is not necessarily an argument that I would use, even if the commit
you are fixing is only in net-next, when it is a functional, and the
emphasis on the functional aspect of the code, providing a Fixes: tag is
really nice as it allows people that do backports or else to identify
the commits as an ensemble.

> 
> But if the base commit was in a stable kernel already, and this
> cosmetic fix was sent into net-next / net, I think the Fixes tag should
> be there, in order for it to get applied into stable releases so that
> future fixes could be applied cleanly.
> 
> Or am I wrong? This is how I understand this whole system...

Your reasoning is not wrong, for cosmetic changes that do not result in
functional changes, I would say that the Fixes: is optional.
-- 
Florian
