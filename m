Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E110E6B8710
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjCNAiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjCNAhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:37:53 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F9291B60;
        Mon, 13 Mar 2023 17:36:59 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id c19so15143323qtn.13;
        Mon, 13 Mar 2023 17:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678754217;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0v7cQTegYqpn3oU15n8gUDA+lUC+sfjfkg41b46HJto=;
        b=D/uc/AbMfQOkMw+RSamk9Y+w9TaQNy7/6SQ5VPs9kdnktjfmYSAsLA+bojio983F46
         K6CtlhxUYkepFqKciil33dCDqrJ8lW4xbEhR0INr4PTTBPWoqRPCJ3pDeDvjB8SIbLGG
         lsfxUVjelwvOcBBM53NUhV7jkGu8SBYgiaXjheaPH2MExzSpweWCURnwjAUSkuE7qmWy
         51Ynf1reS8nLlGEid3sUrWXqHZuFlPyCi1BoZmeVf5W3/IGKkByxMYAzf6i8HayRSp3H
         /4o7elYsX0mfpy7inD4GIkzD2lERACvHXywWOQtbtd3QdW7fZ3JDFQRxh4jNZiG6qYMp
         DKEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678754217;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0v7cQTegYqpn3oU15n8gUDA+lUC+sfjfkg41b46HJto=;
        b=j65eDJp43fR37xo3T1kyg3o/2gvJkTSwmv9nE0a7ukgNbGzgjUK8RhiQC1657npN6/
         8kdQnmUiX+yv9XvqMRDfV0qqWCHP1yHoXhz9ljb/8tAnBZWVLqswfOm1WycETDSOQSce
         ibo5QG9h+VMoYhm84Odd1c0FItDEeKwGytJigwXEbpShMV0IttyS1+wY4/lXE4IEGjfY
         yiqZh2M8pxVWNVhTMFZQpqJ8RZCrC6s7+yILq448+DnaXs0+XnVFY03AEKVVHe/jzBlG
         Rr+JIR8qnqrd/htqcTgYT7hX6oQFqEOa62rwGI8zj8uZgqOEYkVeuBOPpqYIxYBEmdzt
         AtVg==
X-Gm-Message-State: AO0yUKV5QrZFzSaUsEgUpD1bi/iirt81HmqjsoZVWo0v9Z1BlFxho+Ix
        Y18x0rJDQJnuZSOFekocZFa3LuPcelnmYg==
X-Google-Smtp-Source: AK7set/kdX1whggTZ6Mo9SZGRo8vg1npwYzAm8/Wj/XbiaSeKB/pE1J5tRPe2yFFN9fAfuJpbjGt6A==
X-Received: by 2002:ac8:5bc9:0:b0:3bf:cd81:3a31 with SMTP id b9-20020ac85bc9000000b003bfcd813a31mr63361468qtb.65.1678754217745;
        Mon, 13 Mar 2023 17:36:57 -0700 (PDT)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id i68-20020a378647000000b007416c11ea03sm726389qkd.26.2023.03.13.17.36.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 17:36:57 -0700 (PDT)
Message-ID: <094ab51d-d99f-ee08-4e8b-946cc85ccfd6@gmail.com>
Date:   Mon, 13 Mar 2023 20:36:56 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v2 0/9] net: sunhme: Probe/IRQ cleanups
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>,
        debian-sparc@lists.debian.org, rescue@sunhelp.org, sparc@gentoo.org
References: <20230311181905.3593904-1-seanga2@gmail.com>
 <20230313172738.3508810f@kernel.org>
From:   Sean Anderson <seanga2@gmail.com>
In-Reply-To: <20230313172738.3508810f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/13/23 20:27, Jakub Kicinski wrote:
> On Sat, 11 Mar 2023 13:18:56 -0500 Sean Anderson wrote:
>> Well, I've had these patches kicking around in my tree since last October, so I
>> guess I had better get around to posting them. This series is mainly a
>> cleanup/consolidation of the probe process, with some interrupt changes as well.
>> Some of these changes are SBUS- (AKA SPARC-) specific, so this should really get
>> some testing there as well to ensure nothing breaks. I've CC'd a few SPARC
>> mailing lists in hopes that someone there can try this out. I also have an SBUS
>> card I ordered by mistake if anyone has a SPARC computer but lacks this card.
>>
>> I had originally planned on adding phylib support to this driver in the hopes of
>> being able to use real phy drivers, but I don't think I'm going to end up doing
>> that. I wanted to be able to use an external (homegrown) phy, but as it turns
>> out you can't buy MII cables in $CURRENTYEAR for under $250 a pop, and even if
>> you could get them you can't buy the connectors either. Oh well...
> 
> Doesn't apply to net-next, please note we're using the branch called
> *main* now.

Looks like I based this on another patch but forgot to send it. I've resent the series
with this patch squashed in.

--Sean
