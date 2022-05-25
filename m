Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 431E85337F9
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 10:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbiEYIG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 04:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235607AbiEYIGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 04:06:54 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7AD814AC
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 01:06:48 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id x12so4705447wrg.2
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 01:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cVq7pwXv2//Gfr1cHlRRSEheHaq4li61MQakSnDYkHk=;
        b=NSbOEN1kEirXXcI0n+Rf9Sy90jmua25IOlwq3lBlny6ebWLJYupmHvohFiRfMPOYyq
         4F5ikMXUckwPZMYV4cy1mkymCR7C/+/APrT91TE45m53C/G8or+AB0C7YnLnAmuFqZxj
         a/5bJX+7SKQT+s4uAyqsGz5KEfN+/60UTN5yTFZEQNyAHD1BVJT73zQdK0VlccjJONE9
         6R2aYtGZx2oDjYvCVCmv2sLZ5HSRUx3w3LKH4wb4s0fzsiBa9yitlqNtoveAi/tXQGzZ
         HxQ1a1kqvyEtO1SgEEEkCr31sl8DHd8EzzaECAtIi2qlVGJgviVNf+Z4TdWIH4CvIbxt
         nT8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cVq7pwXv2//Gfr1cHlRRSEheHaq4li61MQakSnDYkHk=;
        b=uALPvO7Q74PfLRbNBzJabhicxicLlQp/9feeTdyyHqKwL8mIehgLyS6/nRQULPKmN8
         S+hlkwOsMWZa8XE58sVz+9rhR5T6aaz3iVd3RWh5QgXOdS5QBfrpBRjn1suqP7ZaS2iT
         gC6RTgKPisms1TMKVxwYt3p/bEBNGnK5sLV3B2FSjZkwG+NHbYAbqj5PotFrH/v3+AG7
         eahD70bqfLrVe6jw6O2bdrqxN4ltwBmzwORmomjAjcmuawrmGzpfh2QvbhRvjvDPafWy
         v6Yil8Y19capKsUIXQ9sm6VyTuFRRzYb2A9BkMxMccypPC34yPy8w3V1pVnIIiNwR+V0
         tnlg==
X-Gm-Message-State: AOAM532XZWOreayE3AHUiv5FPjSejU47NnyI3EJ4iEh8sCZHLXt4j4Ek
        HFXGU2j5mh+AOci74SQCYpcLjA==
X-Google-Smtp-Source: ABdhPJxxUHRzsWG9Ga2j1bOgOyilkp0ZbdgwfH/TcJtO2mh86zxzRwq60XFA/9neVmDozoa29iR3JA==
X-Received: by 2002:adf:d1a8:0:b0:20f:f808:2ac8 with SMTP id w8-20020adfd1a8000000b0020ff8082ac8mr4694627wrc.495.1653466007320;
        Wed, 25 May 2022 01:06:47 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id x8-20020a7bc208000000b0039765a7add4sm1038032wmi.29.2022.05.25.01.06.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 01:06:46 -0700 (PDT)
Message-ID: <b78fb006-04c4-5a25-7ba5-94428cc9591a@blackwall.org>
Date:   Wed, 25 May 2022 11:06:44 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH V3 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
Content-Language: en-US
To:     Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
 <20220524152144.40527-2-schultz.hans+netdev@gmail.com>
 <01e6e35c-f5c9-9776-1263-058f84014ed9@blackwall.org>
 <86zgj6oqa9.fsf@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <86zgj6oqa9.fsf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/05/2022 19:21, Hans Schultz wrote:
>>
>> Hi Hans,
>> So this approach has a fundamental problem, f->dst is changed without any synchronization
>> you cannot rely on it and thus you cannot account for these entries properly. We must be very
>> careful if we try to add any new synchronization not to affect performance as well.
>> More below...
>>
>>> @@ -319,6 +326,9 @@ static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
>>>  	if (test_bit(BR_FDB_STATIC, &f->flags))
>>>  		fdb_del_hw_addr(br, f->key.addr.addr);
>>>  
>>> +	if (test_bit(BR_FDB_ENTRY_LOCKED, &f->flags) && !test_bit(BR_FDB_OFFLOADED, &f->flags))
>>> +		atomic_dec(&f->dst->locked_entry_cnt);
>>
>> Sorry but you cannot do this for multiple reasons:
>>  - f->dst can be NULL
>>  - f->dst changes without any synchronization
>>  - there is no synchronization between fdb's flags and its ->dst
>>
>> Cheers,
>>  Nik
> 
> Hi Nik,
> 
> if a port is decoupled from the bridge, the locked entries would of
> course be invalid, so maybe if adding and removing a port is accounted
> for wrt locked entries and the count of locked entries, would that not
> work?
> 
> Best,
> Hans

Hi Hans,
Unfortunately you need the correct amount of locked entries per-port if you want
to limit their number per-port, instead of globally. So you need a consistent
fdb view with all its attributes when changing its dst in this case, which would
require new locking because you have multiple dependent struct fields and it will
kill roaming/learning scalability. I don't think this use case is worth the complexity it
will bring, so I'd suggest an alternative - you can monitor the number of locked entries
per-port from a user-space agent and disable port learning or some similar solution that
doesn't require any complex kernel changes. Is the limit a requirement to add the feature?

I have an idea how to do it and to minimize the performance hit if it really is needed
but it'll add a lot of complexity which I'd like to avoid if possible.

Cheers,
 Nik

