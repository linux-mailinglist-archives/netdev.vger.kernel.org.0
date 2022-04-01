Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E774D4EE8FB
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 09:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235725AbiDAHUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 03:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbiDAHUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 03:20:49 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B3FAE7A
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 00:18:58 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id dr20so3935568ejc.6
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 00:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/nn4TtWS1K0piUifej8dXFq6c7qD5qtN3oxafeLTSwI=;
        b=R0Qa1g43ByS/Q+6U+jlkmnMVnCNU8dT2Yokon18Axb6Fx5oRq3D2aOUNS5wRCwjx/Y
         bO6LNMZrn2kPzmcIJqd+xvwDVn8JsvkkCSje0HrVAbDASo0EMoYE6b5EerZpuYScqaVI
         mpeE1+CScWLQ7/1TXJPllKDI/blShJAM61brPaVWyJqKB/D9WFWvQdwAb3eQ7a8aOptb
         46RmNq1hqdrTnhrqETwXNBRhA+PstNt+fP3jHj+DK4ewqlovJlGK4T9FmR6bsHAjcbKL
         JKvDoXWlfsy3EKM/xICuw7XfxadU8rxqpcsRNznNtJLhEFQawpTV/JUCxXbG33W9EABh
         Riwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/nn4TtWS1K0piUifej8dXFq6c7qD5qtN3oxafeLTSwI=;
        b=bhijwXlLC6p5c8LWEjlZsORL4zqu3bbKWvLhlWJUI0p+czVkJK8LYJxF5Stw7/iUq3
         rFiIDhhWBFP1ux9fRchc+9HMCtoGE2GWZQPo65XliLeTMNQu6q9xp+YMtNFlHMwOGzkZ
         EzOXZtnMeJWyEMd5XqAlH2wRwRPV4w4zTBIgZ4swhq8CqSoO6g4VBaeHymBPUl0Lb3rs
         IR/+0wshOq8yZ91U/PuwzfdtLZAbz8ET37NFqFNcmBvRWN7u/MksiWWP+RCvND5PERv1
         RuVujsjQ4UK+U1MCPOBW2Z8hMGB9J2lAzY/a3F43uCaUPQnGgd3AbmcrV2HC2NeXTUn7
         NO8Q==
X-Gm-Message-State: AOAM530a4vuG1hK2y6tLPeUDP/UmD0Aku7hYBh6E7HMAN05wvwQKV/Tk
        ie0SwsTJvzXzNyEimZijCBZPFJqtn8CP9LzDMsk=
X-Google-Smtp-Source: ABdhPJx3fPuyGP3xGSNqYs98ZS/qcVOnL8vKwQthp+SBgGKxjzGWG33Q1+jvQzueTDyXZVSeBYmi+w==
X-Received: by 2002:a17:907:7fa9:b0:6e4:ba80:3799 with SMTP id qk41-20020a1709077fa900b006e4ba803799mr4077822ejc.564.1648797536591;
        Fri, 01 Apr 2022 00:18:56 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id a21-20020a170906275500b006d10c07fabesm693470ejd.201.2022.04.01.00.18.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 00:18:56 -0700 (PDT)
Message-ID: <40dcace9-150a-ed7a-5347-636ab4b3a693@blackwall.org>
Date:   Fri, 1 Apr 2022 10:18:54 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net 0/2] net: ipv4: fix nexthop route delete warning
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, donaldsharp72@gmail.com,
        philippe.guibert@outlook.com, kuba@kernel.org, davem@davemloft.net,
        idosch@idosch.org
References: <20220331154615.108214-1-razor@blackwall.org>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220331154615.108214-1-razor@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/03/2022 18:46, Nikolay Aleksandrov wrote:
> Hi,
> The first patch fixes a warning that can be triggered by deleting a
> nexthop route and specifying a device (more info in its commit msg).
> And the second patch adds a selftest for that case.
> 
> For the fix the alternative would be to do matching on the nexthop's
> attributes but I think we shouldn't since it's old-style route deletion
> and nexthops are managed through a different interface, so I chose to
> don't do any matching if the fib_info is a nexthop route and the user
> specified old-style attributes to match on (e.g. device in this case)
> which preserves the current behaviour and avoids the warning.
> 
> Thanks,
>  Nik
> 
> Nikolay Aleksandrov (2):
>   net: ipv4: fix route with nexthop object delete warning
>   selftests: net: add delete nexthop route warning test
> 
>  net/ipv4/fib_semantics.c                    |  7 ++++++-
>  tools/testing/selftests/net/fib_nexthops.sh | 13 +++++++++++++
>  2 files changed, 19 insertions(+), 1 deletion(-)
> 

I'll send v2 with an updated comment in the selftest and added tags.

Thanks,
 Nik

