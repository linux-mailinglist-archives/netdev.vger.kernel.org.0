Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E74D611D5B
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 00:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiJ1WVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 18:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiJ1WVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 18:21:15 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574221B94DA;
        Fri, 28 Oct 2022 15:21:14 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id x26so4412803qki.0;
        Fri, 28 Oct 2022 15:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+kPjlthmRGeQ3jSGHjf7vrNFBiBx6ozzwhOsHNDsKNY=;
        b=VyDeFetPk6huY+E9r0l88HYv/XVXbEZvXtfb8UbttRqm2YqxaVebOyl2YJMnGMkIpF
         qMIPp42lk8jX2PM/kBrhG/v2sNYu3p5XSrAslxc2BKnWpqnsvKPSsLABYdvGqkmLy6Ed
         TmRGjt5UvGJrWr/FLv+/4fVEYay0A0b4fUngZ5hIXq+RYUUDdLFstyNdk6DeHqM0Xm2V
         uHax6GvfPPahC/gPtJWsW3GlH2O0rcBMU1caBKtCjjbslNOTnBoBsLW7iVu0ePXi+q1z
         Ldq8xJUSysp+beDnG110k2AvDnOUANDn6fuehExPuVNH55KrpyXe3m3WL47JJmIbIMme
         0pyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+kPjlthmRGeQ3jSGHjf7vrNFBiBx6ozzwhOsHNDsKNY=;
        b=p24DKUla3yU4z3cqwYZ2QtM77ieJNq5zyr9jcyHz1DLXrpDS7eyB2ieoCy2NL1wcHs
         egOLLNZ3t1eXOyy/JFct+57r1stmPbugkJbILg5qz1nd3iP6Etbj7Ii98mYfO4+mo9ZK
         UCq7rNjgT/OzqPeBj3Lwlr06Em+YjQL+BNaPcyKQjfGXzdUdmD0KR6RU7tGI6U1VlgF5
         Tz+klahK5YiyvuoJfXtjfTtru39ufOisZaAWLu1Dug2Hr5EFYwJsNIQOX5bozg1/o1Vr
         q7q6RqwyvfAaViwlv4bB1zLcG53BCLQD4Kca7dZ14TkUxciiomfX5dFnuBbu+VVTPOo4
         QfRw==
X-Gm-Message-State: ACrzQf1s9N45VIB5K4pcTRSFqyi075zxo4ja2ovK2V/o5EQKdFbht2CE
        /ix6GjMjuSfqksVtFjI5mvoDBL7WwHfllA==
X-Google-Smtp-Source: AMsMyM5GC2/ZQFCLAkrQPeM2hri/qfzh28sKJAiDMG/pDdrIwsq6/NGCj4Bdh567YXiMGG23UQYjiQ==
X-Received: by 2002:a05:620a:294e:b0:6a7:750b:abf8 with SMTP id n14-20020a05620a294e00b006a7750babf8mr1180375qkp.513.1666995673041;
        Fri, 28 Oct 2022 15:21:13 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d13-20020a05620a240d00b006f0fc145ae5sm3928198qkn.15.2022.10.28.15.21.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 15:21:12 -0700 (PDT)
Message-ID: <23b2c508-ca5b-0319-1aac-2989de40e175@gmail.com>
Date:   Fri, 28 Oct 2022 15:21:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH net-next] net: systemport: Add support for RDMA overflow
 statistic counter
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20221028221643.3207713-1-f.fainelli@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221028221643.3207713-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 10/28/22 15:16, Florian Fainelli wrote:
> RDMA overflows can happen if the Ethernet controller does not have
> enough bandwidth allocated at the memory controller level, report RDMA
> overflows and deal with saturation, similar to the RBUF overflow
> counter.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Change-Id: I718d806832f807e0d578c252810ba88637e5f5b4

Whoops, Change-Id should not be there, let me send a v2.
-- 
Florian

