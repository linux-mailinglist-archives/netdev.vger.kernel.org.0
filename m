Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9BEA23EBA2
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 12:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgHGKld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 06:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgHGKlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 06:41:31 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D64C061574
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 03:41:31 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id p4so1278432qkf.0
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 03:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FEfR0xWqFhKje75ZmzKBpijzxIbkwKMRmNayRkhh4iQ=;
        b=a+4NE7nuuZqGNm9p6C2xdcmMZhkQZK67WiZtxxB3WqE29GowRYYhGMGmc2doXzgLG5
         X7kPpOr8kbYFCe8/H/Ouc0LhJMtiNJLns8pTZFTdaypDGRgG6H8d65AoXfN8mu+k6qvm
         6LnmsRCUNgQPXD1DdE51BL6tigTE2vJ2qeqLSU97Is2AdYgzBQfF98d7fBP7nW1CCZbT
         nPrD0JoAzjdFAqTIK9ArI7v3NgVaEOMPvHSxEy1iRuTng/3+YTokJo/7PqzvEV5SdN+1
         S4b6YiphhidVbDIETx3+tYJcC5i8Jda19Myg3ek6qx6kNhDXhD8ji4045ll1Jqzjwklu
         BDGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FEfR0xWqFhKje75ZmzKBpijzxIbkwKMRmNayRkhh4iQ=;
        b=isS+33K+AIS9O1S1Jm8LtfTxalWSesPOHU9gbywcXOnz2K2GPzstkCfpgqUpmEY3ho
         u26HyU1picBSlA+VrSYh3EFi5UAWnIjaX9bJqV2EnVccekrXyIKByMxeTV50Uqlh09Be
         k8We4pgJGxepRqN6sGlTq2+cBTRx05vBFwG2IUJ8b30P+H0TliNfceepkMObKPshMtJJ
         sb8IVV3MZLnSN2te4Xso5IU/VIcPxzU+LIaskxfwkg7YopBA/xfd5JSJCYSt2oihH6vZ
         sa00BG7llaYI3aOmWBu4wHtIgnJ/d9oiFUdqqnJRsZyzGexyee2JuxqpEpOFRbcHCR5C
         kq2Q==
X-Gm-Message-State: AOAM531WX5w1gjcl+1/HWWkWn04X7K4Q8lA/hujRj7ua5Wrk4sk3yWTY
        g+oM7eHSmwJYTGk2vLcvd1a0zQ==
X-Google-Smtp-Source: ABdhPJxkQbm3hfsA3h6gQZYyLG6AuJijvzSn572etO/eWFV1dPfgrsOFk1rf1QfwTo4gjjPifg7ufQ==
X-Received: by 2002:a37:9a93:: with SMTP id c141mr12712847qke.145.1596796890868;
        Fri, 07 Aug 2020 03:41:30 -0700 (PDT)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-06-184-148-45-213.dsl.bell.ca. [184.148.45.213])
        by smtp.googlemail.com with ESMTPSA id 84sm5873703qkl.11.2020.08.07.03.41.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 03:41:29 -0700 (PDT)
Subject: Re: [PATCH net-next v2 0/3] ] TC datapath hash api
From:   Jamal Hadi Salim <jhs@mojatatu.com>
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
 <c4d819f5-1a0f-2a12-6a4d-ce523f51c571@mojatatu.com>
Message-ID: <cd59f9e3-1bc3-0e2b-3c77-52373567bb73@mojatatu.com>
Date:   Fri, 7 Aug 2020 06:41:29 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <c4d819f5-1a0f-2a12-6a4d-ce523f51c571@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-10 8:04 a.m., Jamal Hadi Salim wrote:
> On 2020-07-09 8:19 a.m., Jiri Pirko wrote:
>> Thu, Jul 09, 2020 at 01:00:26PM CEST, jhs@mojatatu.com wrote:

>>>
>>> Main point is: classifying based on hash(and for that
>>> matter any other metadata like mark) is needed as a general
>>> utility for the system and should not be only available for
>>> flower. The one big reason we allow all kinds of classifiers
>>> in tc is in the name of "do one thing and do it well".
>>
>> Sure. That classifier can exist, no problem. At the same time, flower
>> can match on it as well. There are already multiple examples of
>> classifiers matching on the same thing. I don't see any problem there.
>>
> 
> I keep pointing to the issues and we keep circling back
> to your desire to add it to flower. I emphatize with the
> desire to have flower as a one stop shop for all things classification
> but this is at the expense of other classifiers. I too need this for 
> offloading  as well as getting the RSS proper feature i described.ets 
> make progress.
> You go ahead - i will submit a version to add it as a separate
> hash classifier.
> 

Some cycles opened up - I will work on this in the next day or
two now that your patches are in...

cheers,
jamal
