Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C864CBCC8
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 12:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbiCCLgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 06:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbiCCLgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 06:36:06 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC7B11798E
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 03:33:55 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id a1so4237857qta.13
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 03:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2zfn0STloHC/ho5NLwvX2dsmBz/Y19a3Vtih2CJ9ZGo=;
        b=IN83AiXY/beWC7Ks547SAXsF+3zg/qJgnVQ+JFBhHqJURaZInWlzhQ5M1mzT7tS5XO
         locY+KfP7nTZJU4I1OdRC6WwqFy7e/8LSH4eWGetgaHJk14Pq3LsrA+iogT3wTTy2Xb5
         p0XvUblIrDyAnNRFCUhhuA3XqyUCYd12Q5QloZP2Ux8NZhh6wO8QaMaE8w+VGLl8pUCv
         vrdygfuKS44HY6cvbtvHRnrG/ht+AHLzJAOgveBRpHCPL9j9FjhXuC+uGvQy4rR+HRLV
         JftzWWZpyMeA1aeTLqzSywN7Nt4Un99YlRTSzQ+KfAo0kXo2Ht2iQSfvHfZ5YJclZjH2
         oUpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2zfn0STloHC/ho5NLwvX2dsmBz/Y19a3Vtih2CJ9ZGo=;
        b=qeXdpkvx26JuRJmX6k+ERp8Z9eGJwSaa+hyH1cRwF/3KuifNlq+tcAAgL2gDuIn3ao
         LUuZMBC6Jwaptjye2RvEmUAALIPKOi+7ThHAM0EGZta1QTaCm2HH+m1kJb5EukK62kFN
         KT4JMQ5+jo0BN7qZHF90oCrK8XEv2R7EGu8f+GB4G02ZiLfK3AuuYBaalSXz9loWVV5b
         AMqxa6M90l7bMIcP0YOIcQLBILu+YV9pcp7QO18nsT9JyPmid965nGjRMYWAER1o1WML
         iK9Q+aTq8ulYFX0kMppuSCVWzxRgElv6wuC0JKVIi9/lCUqtNDonePexGNp7gvwuHKsz
         9Jyg==
X-Gm-Message-State: AOAM530FxXtqQRAOBaMCVztqAbh9TRVjsv0sgQKCMPiaK2VPPasIUu7U
        aa1aKDKUkcA8ycWpWU4V8Y8/BA==
X-Google-Smtp-Source: ABdhPJySOdGMUSYG84gaVF17wEj9gJt/NPp1eQd2GGCpJ8GwxqP4hbHmJzK1EU2bu2/+6rbm0d4nWQ==
X-Received: by 2002:ac8:7f0b:0:b0:2e0:e49:e785 with SMTP id f11-20020ac87f0b000000b002e00e49e785mr14443415qtk.424.1646307234122;
        Thu, 03 Mar 2022 03:33:54 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-25-174-95-97-66.dsl.bell.ca. [174.95.97.66])
        by smtp.googlemail.com with ESMTPSA id h14-20020ac8584e000000b002ddf8b971b2sm1371222qth.87.2022.03.03.03.33.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 03:33:53 -0800 (PST)
Message-ID: <702ea05e-c9e3-8b2a-21df-59f3980a5818@mojatatu.com>
Date:   Thu, 3 Mar 2022 06:33:52 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [net-next v9 0/2] net: sched: allow user to select txqueue
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     xiangxia.m.yue@gmail.com, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
References: <20220222112326.15070-1-xiangxia.m.yue@gmail.com>
 <20220302112420.4bc0cd79@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20220302112420.4bc0cd79@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-03-02 14:24, Jakub Kicinski wrote:
> On Tue, 22 Feb 2022 19:23:24 +0800 xiangxia.m.yue@gmail.com wrote:
>> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>>
>> Patch 1 allow user to select txqueue in clsact hook.
>> Patch 2 support skbhash, classid, cpuid to select txqueue.
> 
> Jamal, you had feedback on the previous version,
> does this one look good?

No it doesnt.
Maybe i wasnt clear enough to Tonghao because they sent out
a patch right after that discussion which didnt address my
last comments. Here's my take:

Out of the three options in 2/2 that Tonghao showed - I agree with
Cong on the last two (cpu and class): that user space can correctly set
policy without needing the specified mechanisms being added to the
kernel.
skbhash otoh is meaningful.

Patch 1 is useful irrespective of patch 2.

cheers,
jamal
