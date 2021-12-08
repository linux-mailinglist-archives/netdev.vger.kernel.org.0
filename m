Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8186D46CB3E
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 04:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243379AbhLHDE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 22:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234660AbhLHDEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 22:04:55 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A62C061574;
        Tue,  7 Dec 2021 19:01:24 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id t19so2217965oij.1;
        Tue, 07 Dec 2021 19:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=aESiVO6Qu9V5g79b5unLwF9L8lrVbWO7t1bif/3ir2s=;
        b=Hz9suid567cwCYwBsKaZLSbD+BMALATLBVyWF47Fsd3eMgwTn38thpNpqhKrKULavK
         YMYvVeXHrrbd85OuR/j/VmSmOFEw/sl0cnx49dtuOVN/Mcw4kRsCVUBzwOVdBKBWxI2A
         MaQeUEoBvDWcTu5HNoOvRLg++U+UeA8aiqKvRwJIOmHiJBGaJF9zTGwaNCvY/mAGse7W
         vgz7zhbUvS1BEapdSYoumC2/b+lziL0G7A0++qcDofEOKm2TC4du3m1rh+1k8zYLgt/o
         QzTqxrxawp8AoVEoPEa2IyzDEfFsHSs176eAJa0dZZQ8fLccodQ48n2bJJYVdRSGvH9H
         zp4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aESiVO6Qu9V5g79b5unLwF9L8lrVbWO7t1bif/3ir2s=;
        b=yOe48JMulPozu7xnhZSInW3durMhV2g4zD4Zd378FTFzbaQ+DufQNSS37KCPT6keLL
         vAK+uDFVemMfFoWnwf8eTZmSr2y1xUxsaY7gyCqWomveEAyVM2z+btEgDEVXPuOK9fA5
         U+6IyzoZRdK7e0BBcVW988nJATY4jXfoKaoBLr6feV2iM6sXgflU0ANgokwHok6OFEy7
         /uHGpgWo8AApm3Je7BnLJp4q1JMjqkLu6Ws+UvUmrAarb+7UdldaI2rabQvOZGkjO9cX
         kAyGauRgm5ZitoCZuzw8VDHdgqncq7PvqxlFQo2ml6lLCn8GKsOL1D7pgsaHltnYq+yF
         dFtw==
X-Gm-Message-State: AOAM5315y3CNq1uRO/xfYewpUem5zFUeKCG28sFLyEH49+Gfu/KxvcKN
        tjMwb9jQ6x9/cWzJkO0h1QQ=
X-Google-Smtp-Source: ABdhPJwOKuKpAVys+s2DOgsy0wllei85Qsz4kDWl8z9giZhoWunNCSTpc/K6TL2MuE3Mm6+KS/oD6A==
X-Received: by 2002:a54:4f94:: with SMTP id g20mr9133464oiy.10.1638932479416;
        Tue, 07 Dec 2021 19:01:19 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id e21sm279660ote.72.2021.12.07.19.01.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 19:01:18 -0800 (PST)
Message-ID: <230a5b4f-2cbf-4911-5231-b05bf6a44571@gmail.com>
Date:   Tue, 7 Dec 2021 20:01:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v2] selftests: net: Correct case name
Content-Language: en-US
To:     "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jie2x Zhou <jie2x.zhou@intel.com>,
        "Li Zhijian(intel)" <zhijianx.li@intel.com>
References: <20211202022841.23248-1-lizhijian@cn.fujitsu.com>
 <bbb91e78-018f-c09c-47db-119010c810c2@fujitsu.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <bbb91e78-018f-c09c-47db-119010c810c2@fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/6/21 11:05 PM, lizhijian@fujitsu.com wrote:
>> #################################################################
>> With VRF
>>
>> TEST: Raw socket bind to local address - ns-A IP                              [ OK ]
>> TEST: Raw socket bind to local address after device bind - ns-A IP            [ OK ]
>> TEST: Raw socket bind to local address after VRF bind - ns-A IP               [ OK ]
>> TEST: Raw socket bind to local address - VRF IP                               [FAIL]
>>
> 
> i found that above case failed with "server: error binding socket: 99: Cannot assign requested address"
> i have manually check it with below command after setup(), same errors:
> 
> # ip netns exec ns-A nettest -s -R -P icmp -l 172.16.3.1 -b
> 05:55:11 server: error binding socket: 99: Cannot assign requested address
> 
> But when i specified specific network interface, it works
> # ip netns exec ns-A nettest -s -R -P icmp -l 172.16.3.1 -b -I red
> # echo $?
> 0
> # ip netns exec ns-A nettest -s -R -P icmp -l 172.16.3.1 -b
> 06:01:55 server: error binding socket: 99: Cannot assign requested address
> # echo $?
> 1
> 
> 
> So i wonder if i missed something ?
> 

That test should be a negative test as is the first one in that group -
in both cases the address bind should fail since the socket is not in
the VRF but the address is. The first on currently shows "OK" but that
is because of 5cad8bce26e01 that made changes to the config to validate
MD5 changes. Will send a patch to fix.

