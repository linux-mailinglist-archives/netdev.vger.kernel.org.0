Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674665834BA
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 23:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237007AbiG0VKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 17:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237050AbiG0VKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 17:10:25 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C495F4E628
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 14:07:53 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id h21-20020a17090aa89500b001f31a61b91dso594337pjq.4
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 14:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=053BAybkkGVP2XqZV691jOeIMeJB36zO3WFHTK5UVWk=;
        b=DdZGH9rWQMcsHKERvjoQllE0R0SxqL8D1pQYg8oh6bzyf3zngz4QNNalQkIbwiYJJs
         9PfCJpH3o98PrnGFB20Ko51nPP1LGKui2NsSjgZ0bQhGqvMUyCOgcXeSBTf5sbOicz9c
         OnAjHtYvgC5lHnIPiQ4C6Bk5IRgtwOfZ6dAO1mZQS7CXfhg9dG8Fd3M03mgvlyEn0EWW
         kpzK2Utu5d58cHa1c8YTk0yp2uAE9aYI9dKfniBg5qD96re1h4R3Gu5FXnWbpjweEvpv
         2acsUKAxGg4ztgDtoVpCSoK88mS79d0RKmgTy2AsTn2WPOS1ub+FlKb+HcxsoanW3ZQ1
         iU1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=053BAybkkGVP2XqZV691jOeIMeJB36zO3WFHTK5UVWk=;
        b=cBUpZVufVlxsZTNyU8+tdJrMQUzdiV+6OHc2x8w08NkSOMIz0ZyQVNwVXttvQUeAwP
         R7bLo5gUTgGJU3XOmatYNDJ3N5L4LcamUGtEfVNUcLorheaOUhIlUKUzwgQoVw3aq89y
         6QW8c/B4LKGL7tnGHo6Pd/Q/d/MeehV3TqKnG5TdGRfXo34p8g7uN2rVLmMsqk9263Ih
         A1RlSAZw9Pd6dFK3yv8IMtv2ZObShPtA3WVmSEwIPQvWeLxV8I55GGkEQw7U6EWkBkKn
         Shxek2L2S+G8/4cKBg6RVeFpvyKd0wrxliN+TjKzThYZoo5VXCCmGcxh1g3/PraWJKmf
         2AhA==
X-Gm-Message-State: AJIora+QNx0Z6ldZP5JhIYqMkOt9h6Ja6n7O0djwOYotENtlTMAkcD7m
        bOuZlJ8mbVBqOzwrZOXOhS9vfLsA8GQ=
X-Google-Smtp-Source: AGRyM1stThVclVq1dDtGs0hQih+mYbTg4f44JpHETMq3lLFbh4ZUVx6n+2t2psB8rmVOScr4MoO98Q==
X-Received: by 2002:a17:902:eb88:b0:16d:9b10:1407 with SMTP id q8-20020a170902eb8800b0016d9b101407mr10202202plg.56.1658956073074;
        Wed, 27 Jul 2022 14:07:53 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id oa15-20020a17090b1bcf00b001ef89019352sm6659081pjb.3.2022.07.27.14.07.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jul 2022 14:07:52 -0700 (PDT)
Message-ID: <7dba0e0b-b3d8-a40e-23dd-3cc7999b8fc4@gmail.com>
Date:   Wed, 27 Jul 2022 14:07:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: net: dsa: lantiq_gswip: getting the first selftests to pass
Content-Language: en-US
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Aleksander Jan Bajkowski <olek2@wp.pl>
References: <CAFBinCDX5XRyMyOd-+c_Zkn6dawtBpQ9DaPkA4FDC5agL-t8CA@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CAFBinCDX5XRyMyOd-+c_Zkn6dawtBpQ9DaPkA4FDC5agL-t8CA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/22 13:36, Martin Blumenstingl wrote:
> Hello,
> 
> there are some pending issues with the Lantiq GSWIP driver.
> Vladimir suggested to get the kernel selftests to pass in a first step.
> I am starting with
> tools/testing/selftests/drivers/net/dsa/local_termination.sh as my
> understanding is that this contains the most basic tests and should be
> the first step.

Since I am in the process of re-designing my test rack at home with DSA devices, how do you run the selftests out of curiosity? Is there a nice diagram that explains how to get a physical connection set-up?

I used to have between 2 and 4 Ethernet controllers dedicated to each port of the switch of the DUT so I could run bridge/standalone/bandwidth testing but I feel like this is a tad extreme and am cutting down on the number of Ethernet ports so I can put NVMe drives in the machine instead.

Thanks!

> 
> The good news is that not all tests are broken!
> There are eight tests which are not passing. Those eight can be split
> into two groups of four, because it's the same four tests that are
> failing for "standalone" and "bridge" interfaces:
> - Unicast IPv4 to unknown MAC address
> - Unicast IPv4 to unknown MAC address, allmulti
> - Multicast IPv4 to unknown group
> - Multicast IPv6 to unknown group
> 
> What they all have in common is the fact that we're expecting that no
> packets are received. But in reality packets are received. I manually
> confirmed this by examining the tcpdump file which is generated by the
> selftests.
> 
> Vladimir suggested in [0]:
>> [...] we'll need to make smaller steps, like disable address
>> learning on standalone ports, isolate FDBs, maybe offload the bridge TX
>> forwarding process (in order to populate the "Force no learning" bit in
>> tag_gswip.c properly), and only then will the local_termination test
>> also pass [...]
> 
> Based on the failing tests I am wondering which step would be a good
> one to start with.
> Is this problem that the selftests are seeing a flooding issue? In
> that case I suspect that the "interesting behavior" (of the GSWIP's
> flooding behavior) that Vladimir described in [1] would be a starting
> point.
> 
> Full local_termination.sh selftest output:
> TEST: lan2: Unicast IPv4 to primary MAC address                 [ OK ]
> TEST: lan2: Unicast IPv4 to macvlan MAC address                 [ OK ]
> TEST: lan2: Unicast IPv4 to unknown MAC address                 [FAIL]
>         reception succeeded, but should have failed
> TEST: lan2: Unicast IPv4 to unknown MAC address, promisc        [ OK ]
> TEST: lan2: Unicast IPv4 to unknown MAC address, allmulti       [FAIL]
>         reception succeeded, but should have failed
> TEST: lan2: Multicast IPv4 to joined group                      [ OK ]
> TEST: lan2: Multicast IPv4 to unknown group                     [FAIL]
>         reception succeeded, but should have failed
> TEST: lan2: Multicast IPv4 to unknown group, promisc            [ OK ]
> TEST: lan2: Multicast IPv4 to unknown group, allmulti           [ OK ]
> TEST: lan2: Multicast IPv6 to joined group                      [ OK ]
> TEST: lan2: Multicast IPv6 to unknown group                     [FAIL]
>         reception succeeded, but should have failed
> TEST: lan2: Multicast IPv6 to unknown group, promisc            [ OK ]
> TEST: lan2: Multicast IPv6 to unknown group, allmulti           [ OK ]
> TEST: br0: Unicast IPv4 to primary MAC address                  [ OK ]
> TEST: br0: Unicast IPv4 to macvlan MAC address                  [ OK ]
> TEST: br0: Unicast IPv4 to unknown MAC address                  [FAIL]
>         reception succeeded, but should have failed
> TEST: br0: Unicast IPv4 to unknown MAC address, promisc         [ OK ]
> TEST: br0: Unicast IPv4 to unknown MAC address, allmulti        [FAIL]
>         reception succeeded, but should have failed
> TEST: br0: Multicast IPv4 to joined group                       [ OK ]
> TEST: br0: Multicast IPv4 to unknown group                      [FAIL]
>         reception succeeded, but should have failed
> TEST: br0: Multicast IPv4 to unknown group, promisc             [ OK ]
> TEST: br0: Multicast IPv4 to unknown group, allmulti            [ OK ]
> TEST: br0: Multicast IPv6 to joined group                       [ OK ]
> TEST: br0: Multicast IPv6 to unknown group                      [FAIL]
>         reception succeeded, but should have failed
> TEST: br0: Multicast IPv6 to unknown group, promisc             [ OK ]
> TEST: br0: Multicast IPv6 to unknown group, allmulti            [ OK ]
> 
> 
> Thank you!
> Best regards,
> Martin
> 
> [0] https://lore.kernel.org/netdev/20220706210651.ozvjcwwp2hquzmhn@skbuf/
> [1] https://lore.kernel.org/netdev/20220702185652.dpzrxuitacqp6m3t@skbuf/


-- 
Florian
