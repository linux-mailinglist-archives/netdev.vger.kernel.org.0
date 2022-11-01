Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBCA5614470
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 06:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiKAF6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 01:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKAF6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 01:58:09 -0400
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C951409C;
        Mon, 31 Oct 2022 22:58:08 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id g12so18755790wrs.10;
        Mon, 31 Oct 2022 22:58:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FDri6rK/T5wv70oAKwTmqQtVY1Vxzs93fKJXgIcFPp4=;
        b=IRb8iNeR5PTPcoPD9vydC6M2EqLbcMuIfrRX5d/+TymKPn73gv5b1rUL1jdxI0htbJ
         x0O/srijF93w4RCrIhLqjJDe9fxQec3+Nwu8eDy1jevYqAzsA23j0u49aEyW9JpN31Dm
         zmOUjQ593+VXsVBOrEwXP32D/V0RhqZGbjRjzLM9SeTFfn6zoRWhJAv6qkV83PdJFsyB
         oCwLkG1mGEFCY1fNL6I7BoobXnGQlp1XqARH9+OH6t+Ns/PKi0JduVIkrGCDRlWFwg+C
         bp0XGuuVkC/bk7XGGpExHA8nz28GHXnfvh57pwHAQyRy2SjrPj7NkXzisy6m21MkaUVE
         PSDA==
X-Gm-Message-State: ACrzQf0Gu90O+baZnnlD7hqhXuFdrL8RVJCOr+FIAuun8R70ibTygQeP
        m1h31Ud03kjkNMZ7j3DIVs0=
X-Google-Smtp-Source: AMsMyM7UI7bi4YwA0k+uX/sWJ5q0x+pfrkM+7gsj9jH50FHa53pnmcxZAxDz/zX1qaeWlQyaETC/vg==
X-Received: by 2002:a5d:524e:0:b0:236:6a61:3b92 with SMTP id k14-20020a5d524e000000b002366a613b92mr10474144wrc.328.1667282287007;
        Mon, 31 Oct 2022 22:58:07 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id m23-20020a05600c3b1700b003b4ff30e566sm373237wms.3.2022.10.31.22.58.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Oct 2022 22:58:06 -0700 (PDT)
Message-ID: <29259fbf-ee4c-764e-8158-274bb3914b9f@kernel.org>
Date:   Tue, 1 Nov 2022 06:58:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, Martin Liska <mliska@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org
References: <20221031114424.10438-1-jirislaby@kernel.org>
 <Y1/IoR44xGaVTRUf@zx2c4.com>
From:   Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCH] wireguard (gcc13): cast enum limits members to int in
 prints
In-Reply-To: <Y1/IoR44xGaVTRUf@zx2c4.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 31. 10. 22, 14:07, Jason A. Donenfeld wrote:
> On Mon, Oct 31, 2022 at 12:44:24PM +0100, Jiri Slaby (SUSE) wrote:
>> Since gcc13, each member of an enum has the same type as the enum [1]. And
>> that is inherited from its members. Provided "REKEY_AFTER_MESSAGES = 1ULL
>> << 60", the named type is unsigned long.
>>
>> This generates warnings with gcc-13:
>>    error: format '%d' expects argument of type 'int', but argument 6 has type 'long unsigned int'
>>
>> Cast the enum members to int when printing them.
>>
>> Alternatively, we can cast it to ulong (to silence gcc < 12) and use %lu.
>> Alternatively, we can move REKEY_AFTER_MESSAGES away from the enum.
>>
>> [1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=36113
> 
> Huh, interesting situation. It's interesting that 1<<60 even works at
> all on old gccs. I guess that in this case, it just takes the type of
> the actual constant, rather than of the enum type?

Exactly, on gcc <= 12, every enum member has a type depending solely on 
its value. And yes, using anything outside <INT_MIN, INT_MAX> is 
undefined (but obviously works). As well as using anything else than 
_constants_.

thanks,
-- 
js
suse labs

