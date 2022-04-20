Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6863508FE2
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 20:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347713AbiDTTCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 15:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347663AbiDTTCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 15:02:36 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B013B5
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 11:59:47 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id i11-20020a9d4a8b000000b005cda3b9754aso1704951otf.12
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 11:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bFeKqM5lLcYzfm2c+Use5atDZ/urcpHiDcNOgl2xTwI=;
        b=FK4i7H8Tq0tP3l4+dtGLqVOGUSG+EO2YLtEA+NYrFclg6bz490PVk1gmx+LQVM+Dfv
         1DdUUdh+SiQi+rLctR07cSfGxUJ5EunAEDzFjVegTaMJiCnK09W6a+w/tlP2t0a36Lsk
         /rZKGrjim/2n0QIJBlQDnelg+wVBDXK8L/GjvC1E3vgf8JHPkbQVoUkF/6+RaRGIBGAs
         +1VRIlGflecRdFI/5YZ6bUyqv5V5CjyEwJRCQZMVphI07Q5+y5hzAX06IV27CavaiQyq
         VYx4iuQpV2Q4b5ypBb3sRuIR+cYebrrIkp1MG0ddVhEsdYOnMnvlrO2nn0jcgpQUzyDN
         DI4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bFeKqM5lLcYzfm2c+Use5atDZ/urcpHiDcNOgl2xTwI=;
        b=5vJDBE7OXB5QOgVw3JwU3E3GVzWwkX9Jeanbf4WI35r6wezOpk8LqQGre0WZldIj7K
         +1DGmL3dI+EeCpkiXN8XHGp19fATzEt8yzUQnYUMEbUlEBQSaLtcDoakDvc9RvNGmMsC
         ZoqdAti+HC7HKhEDqEKRIJQfm6MnVhv4TpUFRNL08gV480uZ+5KzKpp5kc0yJZD30On/
         zGJXAwPp4jsiLIMVPfTcV2tuOHgrcprR2vjcu31olLMTS2xtFufO5MVT+wO+Kv0n9owY
         YDqs17eovF84WiFewmifJBLR7Ow/wmgKEaMabzxb2cl35Q88SpKDcNU0mSf2h5PKs3pL
         Qw9w==
X-Gm-Message-State: AOAM531J85srGwQw5tjXgRSjdfB+avVz4KpiltXLhBlYSUPaIx0PVm3C
        WXiZWNEzlB1QjBOEJdMOXw/+BmgiS4xdTw==
X-Google-Smtp-Source: ABdhPJzMgIsbtblsQT17hFcrUJVvpI1PvZ59meREglffepmLOD3fxNKFsQ/tcVq4myqORbhQe5MFlA==
X-Received: by 2002:a9d:346:0:b0:605:42c1:1643 with SMTP id 64-20020a9d0346000000b0060542c11643mr7681130otv.60.1650481186743;
        Wed, 20 Apr 2022 11:59:46 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.69])
        by smtp.googlemail.com with ESMTPSA id l16-20020a9d6a90000000b0060548d240d4sm4507677otq.74.2022.04.20.11.59.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Apr 2022 11:59:46 -0700 (PDT)
Message-ID: <97eaffb8-2125-834e-641f-c99c097b6ee2@gmail.com>
Date:   Wed, 20 Apr 2022 12:59:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: IPv6 multicast with VRF
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20220420165457.kd5yz6a6itqfcysj@skbuf>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220420165457.kd5yz6a6itqfcysj@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/20/22 10:54 AM, Vladimir Oltean wrote:
> Hi,
> 
> I don't have experience with either IPv6 multicast or VRF, yet I need to
> send some IPv6 multicast packets from a device enslaved to a VRF, and I
> don't really know what's wrong with the routing table setup.
> 
> The system is configured in the following way:
> 
>  ip link set dev eth0 up
> 
>  # The kernel kindly creates a ff00::/8 route for IPv6 multicast traffic
>  # in the local table, and I think this is what makes multicast route
>  # lookups find the egress device.
>  ip -6 route show table local
> local ::1 dev lo proto kernel metric 0 pref medium
> local fe80::204:9fff:fe05:f4ab dev eth0 proto kernel metric 0 pref medium
> multicast ff00::/8 dev eth0 proto kernel metric 256 pref medium
> 
>  ip -6 route get ff02::1
> multicast ff02::1 dev eth0 table local proto kernel src fe80::204:9fff:fe05:f4ab metric 256 pref medium
> 
>  ip link add dev vrf0 type vrf table 3 && ip link set dev vrf0 up
> 
>  ip -4 route add table 3 unreachable default metric 4278198272
> 
>  ip -6 route add table 3 unreachable default metric 4278198272
> 
>  ip link set dev eth0 master vrf0
> 
> The problem seems to be that, although the "ff00::/8 dev eth0" route
> migrates from table 255 to table 3, route lookups after this point fail
> to find it and return -ENETUNREACH (ip6_null_entry).
> 
>  ip -6 route show table local
> local ::1 dev lo proto kernel metric 0 pref medium
> 
>  ip -6 route show table main
> ::1 dev lo proto kernel metric 256 pref medium
> 
>  ip -6 route show table 3
> local fe80::204:9fff:fe05:f4ab dev eth0 proto kernel metric 0 pref medium
> fe80::/64 dev eth0 proto kernel metric 256 pref medium
> multicast ff00::/8 dev eth0 proto kernel metric 256 pref medium
> unreachable default dev lo metric 4278198272 pref medium
> 
>  ip -6 route get ff02::1
> RTNETLINK answers: Network is unreachable
> 
>  ip -6 route get vrf vrf0 ff02::1
> RTNETLINK answers: Network is unreachable
> 
> I'm not exactly sure what is missing?

Did you adjust the FIB rules? See the documentation in the kernel repo.

And add a device scope to the `get`. e.g.,

    ip -6 route get ff02::1%eth0

