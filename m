Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D39F96BBFBE
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 23:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbjCOW05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 18:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjCOW04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 18:26:56 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730E49E056;
        Wed, 15 Mar 2023 15:26:49 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id r4so5192689ilt.8;
        Wed, 15 Mar 2023 15:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678919209;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=glTNUtMFWjiZCDetBfpQcyLtsMmbcSbrV4Z5n8lOfN4=;
        b=cY6dkWK2ojaquvdJA6Y8gskWtuSpKVvQZvFFVY6RVkkkf68f1M1e6yjspPHRx6gr7p
         o2j2zT+InUGS9/mlmg+hBq5hTGM+SBDKpOhSwG5ixY4QvcDstwT7s2rgrN3xJqAZp1mr
         EYQN/2e/ClqYsSgPrs+AGFMVgOE9iAJouXmYJbTTWjBXGI1rGrW6z9irqEVDG5Ytc/Aw
         XCqI4lTeLOM3yXNDsRbf3stzv14Bvr9+sCt+PauMAyqqcThw4FWpcvweE5dgAtuZiSMq
         roA63bnZh2UIN8eG7Aby2AgQ0LlaCHqPh1G8n70R9cGeXF2yFKEzcfV9QsObma7umiMq
         nhKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678919209;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=glTNUtMFWjiZCDetBfpQcyLtsMmbcSbrV4Z5n8lOfN4=;
        b=5l3KYSyJYeiwDyODjR8nhMqhQf6E0Ed0c4KwMaQEQw2NO6v9ifFLj71+0Hku2fbkto
         rtYNg2ycYyfOLlN7gwISPhHHAyWz1ixJDWMnSgQ/ZqM7grFZn40CKFgHVnetnM1H0lpk
         GsO+ah16ADCf96ZIWjQwXn+TszkMPefyGz3BXmsDzELeKx93prfIJrss+0dr12vb5LPi
         QJTAEDy/0oobtPZNiUzOf8wrjzwgF4GeZCPjvUoltQa/j9NC6FcXPN+WQm1WKjKxaTi7
         k4uqB0guKPPYMqsFA8BMyvOJ29shl2IwZqwwu/V4bINRW1m4GjYRtF3VRvug4d6IRXB2
         Tf4A==
X-Gm-Message-State: AO0yUKW28cllBXNPDNxz2/SzPMOS+wLFvhbzA9L03+XOzfHR0OtAksJa
        upNXn526n4rYCAxc0TgBIfY=
X-Google-Smtp-Source: AK7set8sj7wvf99sifD6T3WFl6h2ulXOV/x3X/ayGH3zpQsVK3stFoxL7d0yOmSw8nRQpGxMkbXLWQ==
X-Received: by 2002:a05:6e02:1c01:b0:323:ad6:5357 with SMTP id l1-20020a056e021c0100b003230ad65357mr6796619ilh.28.1678919208768;
        Wed, 15 Mar 2023 15:26:48 -0700 (PDT)
Received: from ?IPV6:2601:282:800:7ed0:4c27:4181:1cd6:29d4? ([2601:282:800:7ed0:4c27:4181:1cd6:29d4])
        by smtp.googlemail.com with ESMTPSA id v5-20020a92c6c5000000b00313b281ecd2sm1906394ilm.70.2023.03.15.15.26.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 15:26:48 -0700 (PDT)
Message-ID: <5f97f6d5-d979-d501-a090-b5a69f33fa45@gmail.com>
Date:   Wed, 15 Mar 2023 16:26:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [patch V2 1/4] net: dst: Prevent false sharing vs.
 dst_entry::__refcnt
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
References: <20230307125358.772287565@linutronix.de>
 <20230307125538.818862491@linutronix.de> <20230315133659.4d608eb0@kernel.org>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20230315133659.4d608eb0@kernel.org>
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

On 3/15/23 2:36 PM, Jakub Kicinski wrote:
> On Tue,  7 Mar 2023 13:57:42 +0100 (CET) Thomas Gleixner wrote:
>> Move the rt[6i]_uncached[_list] members out of struct rtable and struct
>> rt6_info into struct dst_entry to provide padding and move the lwtstate
>> member after that so it ends up in the same cache line.
> 
> Eric, David, looks reasonable? 

Reviewed-by: David Ahern <dsahern@kernel.org>

