Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1E0160E113
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 14:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbiJZMmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 08:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233881AbiJZMmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 08:42:25 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74F37B29B
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 05:41:46 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id a14so23319206wru.5
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 05:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TH9w5IsJvdlZfuLzN2rgdQlDOUdotI8JIGVVxQ+Ul5c=;
        b=KM2gdfEvcruQH7q+H5g45KX2FFUE7oeo/b/fyl9gM1d04vOdp6v0L5wAIv4AraNfCB
         qt/C+zixIvHd3c5ymhXYJklvrmNF2vdCTuagEIeEAG0KyYGdrBq2HIQa55uVc2YdHgSB
         LzKDk2rdjsyQWh0gKddMsiuS556ZcVFQGCqoIzu1OgY8RvRZ98EiaS9ZFCj/+65knUqZ
         lx10wy97KuHhrNDIi6AaxiYCk2KiaweTS/bgYbQZwsULFBq4VGOeQcRiqYX1ou9zjQTb
         GWRJeod8p45QJ+2KDzEg5JWqABQ4NWZLZpv4TCgC121zVoB1XsJRZMbTD2uoA8sS4+m1
         oY5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TH9w5IsJvdlZfuLzN2rgdQlDOUdotI8JIGVVxQ+Ul5c=;
        b=kJOv2BoKz7oeJ3hxkguBnkJSFI/1PTusLpq15JkZZUXj9NM66xWwcl9pkXNSmBGoj3
         37rhbvcyeTcO5CFJ2H1+k+syrgBnRq4ETr539sNJDDF+9zUCu9GuQ+EzacG63S0RkKJT
         oz0sDtJHO8bc16q9qczT2hFIqhN/zYYZCy/fTiy3nk++QSvCRRwQGI88yqTlA2u1Hx2H
         +7tVZgL9ZSZc+0IegGxWHxP+UQn59ksyu4MEiAS3BKMMFDCGqdxpqNeItAw1+JgKtrKj
         OOGDK+NZCOID4fDpTluFzs2wHtop3fQOd8n/wdenbNB8K2UMvXhKe94ZlyJif9ILLO8u
         bJUA==
X-Gm-Message-State: ACrzQf1ywNYcV77lw9oGp5z3f9oYLPAutFsL9n0O2T1xamvJeD6VgDF5
        0YmwXgIWLL9aaG+yTZvONYs=
X-Google-Smtp-Source: AMsMyM4jGNPg8xUKB6PEpKJ9qRl37uhUoQIiuPvjvfurimSG7l/uClnmdTd7r6KFjIkZIj3FUXqzHQ==
X-Received: by 2002:a5d:4043:0:b0:236:5b5a:ae10 with SMTP id w3-20020a5d4043000000b002365b5aae10mr15990441wrp.400.1666788105161;
        Wed, 26 Oct 2022 05:41:45 -0700 (PDT)
Received: from [192.168.0.121] (buscust41-118.static.cytanet.com.cy. [212.31.107.118])
        by smtp.googlemail.com with ESMTPSA id bp4-20020a5d5a84000000b0022e57e66824sm6504375wrb.99.2022.10.26.05.41.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Oct 2022 05:41:44 -0700 (PDT)
Message-ID: <9753a024-5499-af09-ccc2-21c3c614ea64@gmail.com>
Date:   Wed, 26 Oct 2022 15:41:42 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: Bug in netlink monitor
To:     nicolas.dichtel@6wind.com, netdev@vger.kernel.org
References: <2528510b-3463-8a8b-25c2-9402a8a78fcd@gmail.com>
 <037d30a7-15e3-34c7-8fdd-2cf356430355@6wind.com>
Content-Language: en-US
From:   George Shuklin <george.shuklin@gmail.com>
In-Reply-To: <037d30a7-15e3-34c7-8fdd-2cf356430355@6wind.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/10/2022 11:34, Nicolas Dichtel wrote:
> Le 25/10/2022 à 13:18, George Shuklin a écrit :
>> I found that if veth interface is created in a namespace using netns option for
>> ip, no events are logged in `ip monitor all-nsid`.
>>
>> Steps to reproduce:
>>
>>
>> (console1)
>>
>> ip monitor all-nsid
>>
>>
>> (console 2)
>>
>> ip net add foobar
>>
>> ip link add netns foobar type veth
>>
>>
>> Expected results:
>>
>> Output in `ip monitor`. Actual result: no output, (but there are two new veth
>> interaces in foobar namespace).
>>
>> Additional observation: namespace 'foobar' does not have id in output of `ip net`:
> This is why.
> https://man7.org/linux/man-pages/man8/ip-monitor.8.html
>
> "       If the all-nsid option is set, the program listens to all network
>         namespaces that have a nsid assigned into the network namespace
>         were the program is running"
>
> You can assign one with:
> ip netns set foobar auto
>
Oh, I missed that.

But I think it's making things a bit odd, because there are network 
events in the system which are not visible in `ip monitor` (no matter 
what options are set).

Are there a way to see _all_ network events?


