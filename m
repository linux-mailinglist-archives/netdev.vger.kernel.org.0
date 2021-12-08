Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E75A46CBF6
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 05:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbhLHEKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 23:10:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhLHEKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 23:10:38 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52ABDC061746;
        Tue,  7 Dec 2021 20:07:07 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id 35-20020a9d08a6000000b00579cd5e605eso1520769otf.0;
        Tue, 07 Dec 2021 20:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=J1Cas4poEz1Mrdo4InZGCavY0d12rgjaEauykbzPkok=;
        b=YCkDBbWf67pMleWLVuIen/Zr+LpsjyrRgQ/6A/xDIowIiNNGtFgZM95/+AiuX7j/i6
         ClGbspx4jl2Y7EugAYuX7NIJbzorIYpVBKKjG0hFQ3KMBiTkbOQcgvTPv1+0MK6Wz72u
         B5gLbqyAlwb4AFoMG+rhxgsmz5QVXThGvZCrT9BtmV7PeVI8j3Xrd4VlmFYN+OyYTKLs
         fHdyaijwo8SP9HWsF7Yv6Zh1K6IfkX8F6fo/c0g0hLGSCmdXeS8PDebFbna4kpQiZBss
         8yjHEMxgDo7lT6aiFpiZnrgIbHCfcwvfsMYNq4gd+pYdpwk6yiBnQNuiUAehlBTt4cHG
         ZSsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=J1Cas4poEz1Mrdo4InZGCavY0d12rgjaEauykbzPkok=;
        b=qF64iM0WcxvGtlXvS4fZtlVnwgXTWeIugmwaDDH5NeGjQj3ejo1OueQVzRoqrWJnMV
         nAmlRLodfWWWfvmtIaUfIQH3tQAEjFrDkBdbqlMLuTkBgRoe/W2UnylQyHPFWRAkzDFg
         nWvdhcs2UBBNCjf2VHCtHXD7rQHqA9/SA8CZSttgavnThGNjb7TjBYQHHrit4uKs5T15
         tBg3q+RVzLuay1jQfF5qPAXZ8tYhL5mqw8ew8ULpU+1bhZ+FgOdFeUW6GHXWeG07Jox1
         I7A5/0ZHmEVBiI5+A1Q4muXkNsedE0TZA2vGBPNOJ+zqknmSzzlB1yQCxSeSQXhUy4mk
         hBjA==
X-Gm-Message-State: AOAM531V0Cxc/tJchbq+0I2TfMIg9wj51tEANgThnFaavhFpjjwJjIpo
        Ry5+P12eTNG787Ooullx3ls=
X-Google-Smtp-Source: ABdhPJxHIf9QDS8tU0ZqQ6vjrWGOzD878CLx/Vneend68ixdAvJcbizcGAQJ8wTpGgMnEVR/qd0D6g==
X-Received: by 2002:a05:6830:1447:: with SMTP id w7mr38520417otp.199.1638936426673;
        Tue, 07 Dec 2021 20:07:06 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id i3sm314651ooq.39.2021.12.07.20.07.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 20:07:06 -0800 (PST)
Message-ID: <8e3bb197-3f56-a9a7-b75d-4a6343276ec7@gmail.com>
Date:   Tue, 7 Dec 2021 21:07:04 -0700
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
 <41a78a37-6136-ba45-d8fa-c7af4ee772b9@gmail.com>
 <4d92af7d-5a84-4a5d-fd98-37f969ac4c23@fujitsu.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <4d92af7d-5a84-4a5d-fd98-37f969ac4c23@fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/21 8:38 PM, lizhijian@fujitsu.com wrote:
> 
> 
> On 08/12/2021 11:14, David Ahern wrote:
>> On 12/6/21 11:05 PM, lizhijian@fujitsu.com wrote:
>>>> # TESTS=bind6 ./fcnal-test.sh
>>>>
>>>> ###########################################################################
>>>> IPv6 address binds
>>>> ###########################################################################
>>>>
>>>>
>>>> #################################################################
>>>> No VRF
>>>>
>>>> TEST: Raw socket bind to local address - ns-A IPv6                            [FAIL]
>> This one passes for me.
> Err, i didn't notice this one when i sent this mail. Since it was passed too in my
> previous multiple runs.
> 
> 
> 
> 
>>
>> Can you run the test with '-v -p'? -v will give you the command line
>> that is failing. -p will pause the tests at the failure. From there you
>> can do:
>>
>> ip netns exec ns-A bash
>>
>> Look at the routing - no VRF is involved so the address should be local
>> to the device and the loopback. Run the test manually to see if it
>> really is failing.
> 
> thanks for your advice, i will take a look if it appears again.
> 
> 
> 
>>
>>
>>>> TEST: Raw socket bind to local address after device bind - ns-A IPv6          [ OK ]
>>>> TEST: Raw socket bind to local address - ns-A loopback IPv6                   [ OK ]
>>>> TEST: Raw socket bind to local address after device bind - ns-A loopback IPv6  [ OK ]
>>>> TEST: TCP socket bind to local address - ns-A IPv6                            [ OK ]
>>>> TEST: TCP socket bind to local address after device bind - ns-A IPv6          [ OK ]
>>>> TEST: TCP socket bind to out of scope local address - ns-A loopback IPv6      [FAIL]
>> This one seems to be a new problem. The socket is bound to eth1 and the
>> address bind is to an address on loopback. That should not be working.

actually that one should be commented out similar to the test at the end
of ipv4_addr_bind_novrf. It documents unexpected behavior - binding to a
device should limit the addresses it can bind to but the kernel does
not. Legacy behavior.

> 
> My colleague had another thread with the verbose detailed message
> https://lore.kernel.org/netdev/PH0PR11MB4792DC680F7E383D72C2E8C5C56E9@PH0PR11MB4792.namprd11.prod.outlook.com/
> 
> 
> 
>>
>>>> #################################################################
>>>> With VRF
>>>>
>>>> TEST: Raw socket bind to local address after vrf bind - ns-A IPv6             [ OK ]
>>>> TEST: Raw socket bind to local address after device bind - ns-A IPv6          [ OK ]
>>>> TEST: Raw socket bind to local address after vrf bind - VRF IPv6              [ OK ]
>>>> TEST: Raw socket bind to local address after device bind - VRF IPv6           [ OK ]
>>>> TEST: Raw socket bind to invalid local address after vrf bind - ns-A loopback IPv6  [ OK ]
>>>> TEST: TCP socket bind to local address with VRF bind - ns-A IPv6              [ OK ]
>>>> TEST: TCP socket bind to local address with VRF bind - VRF IPv6               [ OK ]
>>>> TEST: TCP socket bind to local address with device bind - ns-A IPv6           [ OK ]
>>>> TEST: TCP socket bind to VRF address with device bind - VRF IPv6              [FAIL]
>> This failure is similar to the last one. Need to see if a recent commit
>> changed something.
> 

similarly here. Want to send a patch that comments them out with the
same explanation as in ipv4_addr_bind_novrf?

Both fail on v5.8 so I do not believe a recent change affected either
test. I guess these bind tests slipped through the cracks with the
misname in the TESTS variable. Thanks for the patch to fix that.

Also, make sure you always cc the author of the Fixes tag when sending
patches.

