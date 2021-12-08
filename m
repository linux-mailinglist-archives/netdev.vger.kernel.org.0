Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A29C46CB71
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 04:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243719AbhLHDSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 22:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232839AbhLHDSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 22:18:09 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCDFCC061574;
        Tue,  7 Dec 2021 19:14:38 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id n104-20020a9d2071000000b005799790cf0bso1341528ota.5;
        Tue, 07 Dec 2021 19:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=329pizNCH1ZkgEomsqbDzFQr/D0jbhcoaCg4ZLi5oTI=;
        b=HM76PKAZ6OvvFbM4N7jwgmOKGcTgB8Sy9i0CT1q+OJmLmKedpkNqIcbvXIf/iJO80H
         JQFVZ7NWazZQDQqE+8r1whRknq3UtW3SwTd23GXsUhu8yl1T4tbc3dtDCJg9lghDcS/7
         o+HkOMarbJ/iyWuR7L2eO5githjH+5u/xFcfkSzTjvMQP15bPiQfvGlDJuw0UfFNYYD1
         tL4hMhpgw5ERbGIaqIKEkipSKmBP9YLWXwmfhq0L3n2xzOFMp+Gu1kDAu9tQuCzBUrvS
         3ZdRNCIWdqcY8SL5cTsBvMV8K79hfn1ojb5hbRoVA6s5wjItHtjlKuSklw8ATt2EpnbN
         NwkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=329pizNCH1ZkgEomsqbDzFQr/D0jbhcoaCg4ZLi5oTI=;
        b=k9BfIHAYmXvaGbuqLfZmj5OeWCLjeEESdtJNmnzYcdtT1ec2fr5w/fq9gUTYpRGIbo
         Exl3mLNhm1ztusV7HMBjqIznwb/KkzvXdOK1repXIu2Wa30Rmo2nQoNcjsQrYuEl4EWP
         1oTNxvXqriI13fHJOAnNCc1sT23TjcmgAfkkvwSAoMNrPlgvknxsix+eXnRWBT14wEMD
         CYedWUna8hpa3NVpCK/QLDBSh2DbRVytKQUm5a0phzST+gh4PV7e4rRrQvFg8UIUuiia
         UyTskp4EiLpfu8cVP2TlYstuuxxFWMNWlE9cld73Ecv88zUo+EDOd4a5owcVV+Atn01r
         sIJw==
X-Gm-Message-State: AOAM532nLErLZSpwuS80up8KPJG7iDD2R9TmQdD7VJEie8TEygAave8A
        Ts1a3awr21nIaEzJx5sfyL0=
X-Google-Smtp-Source: ABdhPJy8wCuAbQNhdLmlL5kBWdbR4KYfaf+COvXc2VVciuWQDXVEehPxogVUROlgnaarnCzR5Lq/qA==
X-Received: by 2002:a05:6830:280d:: with SMTP id w13mr38026526otu.101.1638933278033;
        Tue, 07 Dec 2021 19:14:38 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id bj8sm424307oib.51.2021.12.07.19.14.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 19:14:37 -0800 (PST)
Message-ID: <41a78a37-6136-ba45-d8fa-c7af4ee772b9@gmail.com>
Date:   Tue, 7 Dec 2021 20:14:36 -0700
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
>> # TESTS=bind6 ./fcnal-test.sh
>>
>> ###########################################################################
>> IPv6 address binds
>> ###########################################################################
>>
>>
>> #################################################################
>> No VRF
>>
>> TEST: Raw socket bind to local address - ns-A IPv6                            [FAIL]

This one passes for me.

Can you run the test with '-v -p'? -v will give you the command line
that is failing. -p will pause the tests at the failure. From there you
can do:

ip netns exec ns-A bash

Look at the routing - no VRF is involved so the address should be local
to the device and the loopback. Run the test manually to see if it
really is failing.


>> TEST: Raw socket bind to local address after device bind - ns-A IPv6          [ OK ]
>> TEST: Raw socket bind to local address - ns-A loopback IPv6                   [ OK ]
>> TEST: Raw socket bind to local address after device bind - ns-A loopback IPv6  [ OK ]
>> TEST: TCP socket bind to local address - ns-A IPv6                            [ OK ]
>> TEST: TCP socket bind to local address after device bind - ns-A IPv6          [ OK ]
>> TEST: TCP socket bind to out of scope local address - ns-A loopback IPv6      [FAIL]

This one seems to be a new problem. The socket is bound to eth1 and the
address bind is to an address on loopback. That should not be working.

>>
>> #################################################################
>> With VRF
>>
>> TEST: Raw socket bind to local address after vrf bind - ns-A IPv6             [ OK ]
>> TEST: Raw socket bind to local address after device bind - ns-A IPv6          [ OK ]
>> TEST: Raw socket bind to local address after vrf bind - VRF IPv6              [ OK ]
>> TEST: Raw socket bind to local address after device bind - VRF IPv6           [ OK ]
>> TEST: Raw socket bind to invalid local address after vrf bind - ns-A loopback IPv6  [ OK ]
>> TEST: TCP socket bind to local address with VRF bind - ns-A IPv6              [ OK ]
>> TEST: TCP socket bind to local address with VRF bind - VRF IPv6               [ OK ]
>> TEST: TCP socket bind to local address with device bind - ns-A IPv6           [ OK ]
>> TEST: TCP socket bind to VRF address with device bind - VRF IPv6              [FAIL]

This failure is similar to the last one. Need to see if a recent commit
changed something.


>> TEST: TCP socket bind to invalid local address for VRF - ns-A loopback IPv6   [ OK ]
>> TEST: TCP socket bind to invalid local address for device bind - ns-A loopback IPv6  [ OK ]
> 
> 
> Thanks
> Zhijian
> 
> 
