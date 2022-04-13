Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8382E4FF6AB
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 14:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbiDMM1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 08:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiDMM1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 08:27:05 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB763AA73
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 05:24:42 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id x33so3233004lfu.1
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 05:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9Oc3Y+1/1zJT3PGdvfoKkBQJDZ8DDy0dU1mG6lfWGK8=;
        b=NpVEEXAMmPFBuidmAWcIdCxqUqRerGvX9LZOVatxXA0wyBq0PFfV5t1lUETxXmWPb+
         mGwpBxiRS9irL3NBpt98MSxoroZ3KgY1m2eYBEHDfdgK55eXZ10RoQe5mtvXp9Tyg39i
         34KadW5cRBdybL92R0Hw1Z58zu0xg+8O0Wmf3BNw2SKXHnK2gJCQZAOFBDc+zqmVdErN
         OqMSue+94KEUhXBlrZZDq+7mZVNWQwpyObIdWhdYwlB4FolvRbDRN7zl1bOcZGMXo03G
         WqTrR4aC1f3P5npnXue88XPr7hfb8oOIjYOA4KqJgmAy7frj7Tu7C4vbgf+J4by5sUHm
         pSFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9Oc3Y+1/1zJT3PGdvfoKkBQJDZ8DDy0dU1mG6lfWGK8=;
        b=SEvdmwRbnocxne0ATc6Kj6GCqTJvxk/495kqy58RHhCCUApEsYbpFp/SWtVGPxnLfI
         VQbloSxhFSMC+7EEk3uXeDLkz8q05yKdj1LB0sz3Wlp5Hm1eJj7/QOxI075U8WUO01TG
         XsFGhW++3eclzguhteCY24GO9E4dPAQHEsbSoqDN2mEVw8AIGQXBLsMdsgtaZEEwZwEi
         E3a126AzCJcAvgEYob0sWqG606XSoNOo0wLQYLoCLOkeOIVvRjKoiEjKRBQEQONj4UMb
         gapEHN1e33wf9VnGQlC//hPu1fSX0d35P/wkj6hc/r6xwDf8D6vZeb+Zo9Do/X5IKGZy
         ebwg==
X-Gm-Message-State: AOAM531VoqLB6BJB4UZ4tCRsnEMSiP2742o8/YB+jd36JZIxwqU9A87Y
        LrJazM/mgvkLfd+P9zuAlxXvdXpoLUABRw==
X-Google-Smtp-Source: ABdhPJxHx2MlyPogfzRSijBgj395zgzxBJZ4jp1CIxfNcKzbjxgOsfIVUwb9y60C2HvqfYIF1lCeXg==
X-Received: by 2002:ac2:522c:0:b0:46d:576:d20d with SMTP id i12-20020ac2522c000000b0046d0576d20dmr948200lfl.182.1649852680341;
        Wed, 13 Apr 2022 05:24:40 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id q24-20020a194318000000b0046d08bb2bf3sm52447lfa.150.2022.04.13.05.24.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 05:24:39 -0700 (PDT)
Message-ID: <2a82cf39-48b9-2c6c-f662-c1d1bce391ba@gmail.com>
Date:   Wed, 13 Apr 2022 14:24:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC net-next] net: tc: flow indirect framework issue
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>,
        Baowen Zheng <baowen.zheng@corigine.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roid@nvidia.com" <roid@nvidia.com>,
        "vladbu@nvidia.com" <vladbu@nvidia.com>,
        Eli Cohen <elic@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20220413055248.1959073-1-mattias.forsblad@gmail.com>
 <DM5PR1301MB2172F573F9314D43F79D8F26E7EC9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <20220413090705.zkfrp2fjhejqdj6a@skbuf>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <20220413090705.zkfrp2fjhejqdj6a@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-13 11:07, Vladimir Oltean wrote:
> Hi Baowen,
> 
> On Wed, Apr 13, 2022 at 07:05:39AM +0000, Baowen Zheng wrote:
>> Hi Mattias, in my understand, your problem may because you register
>> your callback here. I am not sure why you choose to register your hook
>> here(after the interface is added to the bridge to just trigger the
>> callback in necessary case.)
> 
>> Then your function is called and add your cb to the tcf_block. But
>> since the matchall filter has been created so you can not get your
>> callback triggered. 
> 
> The bridge device has a certain lifetime, and the physical port device
> has a different and completely independent lifetime. So the port device
> may join the bridge when the bridge already has some filters on its
> ingress chain.
> 
> Even with the indirect flow block callback registered at module load
> stage as you suggest, the port driver needs to have a reason to
> intercept a tc filter on a certain bridge. And when the port isn't a
> member (yet) of that bridge, it has no reason to.
> 
> Of course, you could make the port driver speculatively monitor all tc
> filters installed on all bridges in the system (related or unrelated to
> ports belonging to this driver), just to not miss callbacks which may be
> needed later. But that is quite suboptimal.
> 
> Mattias' question comes from the fact that there is already some logic
> in flow_indr_dev_register() to replay missed flow block binding events,
> added by Eli Cohen in commit 74fc4f828769 ("net: Fix offloading indirect
> devices dependency on qdisc order creation"). That logic works, but it
> replays only the binding, not the actual filters, which again, would be
> necessary.
> 
>> Maybe you can try to regist your callback in your module load stage I
>> think your callback will be triggered, or change the command order as: 
>> tc qdisc add dev br0 clsact
>> ip link set dev swp0 master br0
>> tc filter add dev br0 ingress pref 1 proto all matchall action drop
>> I am not sure whether it will take effect.
> 
> I think the idea is to make the given command order work, not to change it.

Re-ordering the tc commands doesn't solve the issue when all ports leave the
bridge, which will lead to flow_indr_dev_unregister() and later re-joins
the bridge (flow_indr_dev_register()). We'll need filter replay for this.
