Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A359921B4A7
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 14:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgGJMEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 08:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgGJMEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 08:04:42 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3823C08C5CE
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 05:04:41 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id b25so4177946qto.2
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 05:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TO/FwLfDqKyNxUpgNb1/gwnM+CmO89AyK0AEgrpL/gA=;
        b=dLh7pfmai6bsg4lQX3SwhVV2F9KhZpee/AizY/60kCDtJsCzYTuIBUMIM45IZMBGpb
         TUHkVm4yWag81llAMHp2ymCchOL5oJjr5b0xqt9oltpgT/WD0dO6c5/LliHrBpcMIBPp
         czeL5/75+QCuLckO2THRGznyBUlJKepxqT0vTyCibsg1QWXpppxLvl59oykAjKNnfDOu
         5iQGY8FeI24eFi5RDTQZnZ2U7wp99UgpZZEkBX+l+71PEivaVZUa8DCy6Jpt2kECL9Ij
         9HheiCqu1TvH/ZC+NjRZqtn+e/2ZL17vzSlhaJe3nSCt0N52742ntaanX/pHX9AqB0cT
         k3Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TO/FwLfDqKyNxUpgNb1/gwnM+CmO89AyK0AEgrpL/gA=;
        b=l/VWkWiDqNkNM86LHsTdpIqpU8MfKyC3uf+44IRMP8pCdZZ1E22A7FGywfg994KNfU
         g8J+cCJlujIKQqHa0w5X2CmOU5ZlMEmaiFy3byMwyEDwiJfQAx6CBROWO8clrXQSxKGk
         mZkPB29VrRhpv9faq18PZYOt1aShznKADyvezFQpsak9EosaUQIeMohK6DWcaSJPJkeR
         1BwELbZz4X787CKb3iKUEewzj6SRdYKzkY5Jedw4XnUc1T0uJT2rDCe+RFkkGgYHIzS6
         9eWsqM4l/c50bDcSBCs+mPyiWkbtjopRIp+/+gyKDj7fGyoM9eVhS1w+Y7rnX14m2IBe
         Ejsw==
X-Gm-Message-State: AOAM533p07w3/4v74k1AqCZXGk8sVAqlLPmP3B62oqiv4bPyIE2ag6wE
        agZVt2O3KHlCN7IGFB0sPRZo0A==
X-Google-Smtp-Source: ABdhPJxz64RLhfP7y0eijmgmhxx/dvur9HEuD2eUDa0SdzpwnGgENf4QnoOcIsQvLI0M/Uo3nMJ35g==
X-Received: by 2002:aed:247a:: with SMTP id s55mr46461990qtc.247.1594382681044;
        Fri, 10 Jul 2020 05:04:41 -0700 (PDT)
Received: from [192.168.43.235] ([204.48.95.144])
        by smtp.googlemail.com with ESMTPSA id x4sm6292216qkl.130.2020.07.10.05.04.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 05:04:40 -0700 (PDT)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Re: [PATCH net-next v2 0/3] ] TC datapath hash api
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ariel Levkovich <lariel@mellanox.com>, netdev@vger.kernel.org,
        kuba@kernel.org, xiyou.wangcong@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
References: <20200701184719.8421-1-lariel@mellanox.com>
 <13b36fb1-f93e-dad7-9dba-575909197652@mojatatu.com>
 <20200707100556.GB2251@nanopsycho.orion>
 <20877e09-45f2-fa89-d11c-4ae73c9a7310@mojatatu.com>
 <20200708144508.GB3667@nanopsycho.orion>
 <908144ff-315c-c743-ed2e-93466d40523c@mojatatu.com>
 <20200709121919.GC3667@nanopsycho.orion>
Message-ID: <c4d819f5-1a0f-2a12-6a4d-ce523f51c571@mojatatu.com>
Date:   Fri, 10 Jul 2020 08:04:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200709121919.GC3667@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-09 8:19 a.m., Jiri Pirko wrote:
> Thu, Jul 09, 2020 at 01:00:26PM CEST, jhs@mojatatu.com wrote:
>> On 2020-07-08 10:45 a.m., Jiri Pirko wrote:
>>> Wed, Jul 08, 2020 at 03:54:14PM CEST, jhs@mojatatu.com wrote:
>>>> On 2020-07-07 6:05 a.m., Jiri Pirko wrote:

>> Nothing to do with how a driver offloads. That part is fine.
>>
>> By "flower's algorithm" I mean the fact you have to parse and
>> create the flow cache from scratch on ingress - that slows down
>> the ingress path. Compare, from cpu cycles pov, to say fw
> 
> Could you point to the specific code please?
> 
> The skb->hash is only accessed if the user sets it up for matching.
> I don't understand what slowdown you are talking about :/
> 

Compare the lookup approach taken by flower in ->classify vs fw.
Then add a few hundred(or thousands of) rules.

> 
>> classifier which dereferences skbmark and uses it as a key
>> to lookup a hash table.
>> An skbhash classifier would look the same as fw in its
>> approach.
>> subtle point i was making was: if your goal was to save cpu cycles
>> by offloading the lookup(whose result you then use to do
>> less work on the host) then you need all the cycles you can
>> save.
>>
>> Main point is: classifying based on hash(and for that
>> matter any other metadata like mark) is needed as a general
>> utility for the system and should not be only available for
>> flower. The one big reason we allow all kinds of classifiers
>> in tc is in the name of "do one thing and do it well".
> 
> Sure. That classifier can exist, no problem. At the same time, flower
> can match on it as well. There are already multiple examples of
> classifiers matching on the same thing. I don't see any problem there.
> 

I keep pointing to the issues and we keep circling back
to your desire to add it to flower. I emphatize with the
desire to have flower as a one stop shop for all things classification
but this is at the expense of other classifiers. I too need this for 
offloading  as well as getting the RSS proper feature i described.ets 
make progress.
You go ahead - i will submit a version to add it as a separate
hash classifier.

cheers,
jamal
