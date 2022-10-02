Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 526865F266E
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 00:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiJBWxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 18:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiJBWxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 18:53:01 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A504B3CBDA
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 15:51:01 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id d8so6971441iof.11
        for <netdev@vger.kernel.org>; Sun, 02 Oct 2022 15:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Ks7F2FleJ5liHTL72cJfjRB9OID5EnwhA9cRFWON/n8=;
        b=SjIqRrOPPyV+eaDPuI9gdYOhRUS1ipGHR8wwyjydlu0po962dWyYg3TVrYf8yzqllV
         Sy3F2fu5rt3mB/zzwreMsW5qfW32Jg+QqncByaX3RP3kGYYXwHv+t+1EX99Ez+llJNiI
         CBwlV8iZIs2PvHQiEgLWTcndu1sXNbLGtikr2qX3KqNeEEI9h99xbN31AIwEazvaiEVJ
         kmXRVmjwAb6ic8MKvMIg6LwH50QVLRGXe41YvuUB1LaSML7CiNBh2TkFRAyq9bhVyet3
         ivYpBMRdbzegr7hke0r8o0KkVnlMIAkUhvI57IN9NSYdt7q72bO3r6BvibJc8idia2Gb
         5/1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Ks7F2FleJ5liHTL72cJfjRB9OID5EnwhA9cRFWON/n8=;
        b=PaKID62cAu5viajnDsOwBscIor9SKseGV+QZdrycF0QdZffAzzrPlD57qneyVqWYi+
         +6ULQBZKUKHylFG4/JgU64rF9fyjiCLsc9SpvSAlPhEWa54SSothdNsoZEoZfunoVeKk
         RSHLmEy5RRhRkczpaBuaA75LoiMUbOwzSit9vJCni/6w2cvUnYDdIhahGg2hJn9v5kkt
         WR0G0BWOJ+M/+lxMkVEUFigdoRNBHKejZxONdsendnsAYBhg9fe7L3WVTPANFOEjyPIu
         u2dKDgrA7fMTmFvnDmlcFJR8PCsW7mhmg/Yic+MimaZHXC9tAQ1IwpCIsJQkPNGR+QzH
         deEA==
X-Gm-Message-State: ACrzQf1e6TgALbk6g5Hc18nhiew1x6y+s411fehDi8+mSwzjjeUDdjG3
        MHJuBXJ1lUEPhpFfgzKiEIc=
X-Google-Smtp-Source: AMsMyM6krzWK85p5dULqbDfIyagWlk+QHZNOwPLZbt4aKiY9J3Kfv60CwigDG0O37EdU2j05SYzOog==
X-Received: by 2002:a05:6638:3390:b0:35a:a74e:44e3 with SMTP id h16-20020a056638339000b0035aa74e44e3mr8967663jav.77.1664751060553;
        Sun, 02 Oct 2022 15:51:00 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:75a0:fca2:49e5:d109? ([2601:282:800:dc80:75a0:fca2:49e5:d109])
        by smtp.googlemail.com with ESMTPSA id y16-20020a056602049000b006a0d1a30684sm3835533iov.33.2022.10.02.15.50.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Oct 2022 15:50:59 -0700 (PDT)
Message-ID: <06112b64-39c5-0dee-b419-872e94263457@gmail.com>
Date:   Sun, 2 Oct 2022 16:50:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH iproute2-next 3/3] f_flower: Introduce L2TPv3 support
Content-Language: en-US
To:     Wojciech Drewek <wojciech.drewek@intel.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, gnault@redhat.com
References: <20220927082318.289252-1-wojciech.drewek@intel.com>
 <20220927082318.289252-4-wojciech.drewek@intel.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220927082318.289252-4-wojciech.drewek@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/27/22 1:23 AM, Wojciech Drewek wrote:
> Add support for matching on L2TPv3 session ID.
> Session ID can be specified only when ip proto was
> set to IPPROTO_L2TP.
> 
> L2TPv3 might be transported over IP or over UDP,
> this implementation is only about L2TPv3 over IP.
> IPv6 is also supported, in this case next header
> is set to IPPROTO_L2TP.
> 
> Example filter:
>   # tc filter add dev eth0 ingress prio 1 protocol ip \
>       flower \
>         ip_proto l2tp \
>         l2tpv3_sid 1234 \
>         skip_sw \
>       action drop
> 
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
>  man/man8/tc-flower.8 | 11 +++++++++--
>  tc/f_flower.c        | 45 +++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 53 insertions(+), 3 deletions(-)
> 


I updated kernel headers to latest net-next tree. (uapi headers are
synched via a script.) This patch on top of that does not compile, so
something is missing. Please take a look and re-send.
