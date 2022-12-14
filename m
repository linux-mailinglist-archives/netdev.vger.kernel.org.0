Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20B164CADD
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 14:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238564AbiLNNOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 08:14:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238325AbiLNNOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 08:14:24 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7A01A81F
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 05:14:12 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id z26so10357756lfu.8
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 05:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oEPa49EoZyOp2GNkXcrTo+JxApLnu9iXrz0aJN5z9gs=;
        b=eF5k9LeOwp/zHbDjBCgLnGn1hr7TIfzlMQLukCFEKSabwd+Z7vjn4ROnxZB5xEv2lC
         u6ExrC2jhyi1xps7anGH0ymnK6HTGFf24naSBKUQof4+K2rFWoVzkV3DUoyZRrfY9aKd
         wNP7cBHEQZDzGGrJEmGDX37F22sFq3CYcjBErH3OQ/L2e+eLCG/W8H0rZ585DXDhDLyx
         XtIXQqzhzT0BXAnbk0r5rFg9HxRyCaM+GawnnAfil+f2xiGyU9oWPC9whpfV/0F7Ci+l
         BHVd+4MnpNUu5DJHUbE0KDwHSS9C7TVXhhcA1LK6busGGtifsF73B/VHXtJfIthThl0Q
         wwvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oEPa49EoZyOp2GNkXcrTo+JxApLnu9iXrz0aJN5z9gs=;
        b=LDgvJI7mQTvjZvZXqIgjgRHe1iMi/aPbLa1AwxgH+mFT8cBN5fLFZgF7r36m0KJR1Z
         Oq7EB9m8RgACa3F4NpV23WdipAc+KlFO8qyIEEnf0XflERvl6BGsqdhMnzcRS6pbGjVy
         Jy5uhafvjp7I0oyZ77962jtxp82cj+Fnp/vTU4qpl3yzli0XQKJjYy8Mx0DjL3bES80Q
         RdFmYitPTs9cPo6dbvRt7jQW5hjOB2/WZclNVwOTyL7sIt436RY75Jas0f7KD/FymaOY
         m7c+ZjQswFXi1FBxOgESePnuOeS1kfN9VjyR29oGrd6Rs4CAsjiTyr9cARZe8Jauhmpe
         oA1w==
X-Gm-Message-State: ANoB5pmV50L0e+ZQJdLylO0ekGxFVrupSe8vsWcGnqjgutaFEAf+M7+6
        1f9R1SQ+fUTd0qSJ/RjaN1fg9Pohjtw4oH05
X-Google-Smtp-Source: AA0mqf5Jffq8wB2QzbZlw3NKa0AbUqnckNfkEva1Qu1KkoQ5ki9UkL0wA4MT/kr6bgR8eXonbioHFw==
X-Received: by 2002:a05:6512:41e:b0:4b5:7925:8707 with SMTP id u30-20020a056512041e00b004b579258707mr6746363lfk.26.1671023650438;
        Wed, 14 Dec 2022 05:14:10 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id o11-20020ac25e2b000000b004b5732080d1sm801553lfg.150.2022.12.14.05.14.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Dec 2022 05:14:10 -0800 (PST)
Message-ID: <13e55ef1-24fd-6b78-8b67-792c7452fe79@linaro.org>
Date:   Wed, 14 Dec 2022 14:14:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net v3] nfc: pn533: Clear nfc_target before being used
Content-Language: en-US
To:     Minsuk Kang <linuxlovemin@yonsei.ac.kr>, netdev@vger.kernel.org
Cc:     linma@zju.edu.cn, davem@davemloft.net, sameo@linux.intel.com,
        linville@tuxdriver.com, dokyungs@yonsei.ac.kr,
        jisoo.jang@yonsei.ac.kr
References: <20221214015139.119673-1-linuxlovemin@yonsei.ac.kr>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221214015139.119673-1-linuxlovemin@yonsei.ac.kr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/12/2022 02:51, Minsuk Kang wrote:
> Fix a slab-out-of-bounds read that occurs in nla_put() called from
> nfc_genl_send_target() when target->sensb_res_len, which is duplicated
> from an nfc_target in pn533, is too large as the nfc_target is not
> properly initialized and retains garbage values. Clear nfc_targets with
> memset() before they are used.
> 
> Found by a modified version of syzkaller.
> 
> BUG: KASAN: slab-out-of-bounds in nla_put
> Call Trace:
>  memcpy
>  nla_put
>  nfc_genl_dump_targets
>  genl_lock_dumpit
>  netlink_dump
>  __netlink_dump_start
>  genl_family_rcv_msg_dumpit
>  genl_rcv_msg
>  netlink_rcv_skb
>  genl_rcv
>  netlink_unicast
>  netlink_sendmsg
>  sock_sendmsg
>  ____sys_sendmsg
>  ___sys_sendmsg
>  __sys_sendmsg
>  do_syscall_64
> 
> Fixes: 673088fb42d0 ("NFC: pn533: Send ATR_REQ directly for active device detection")
> Fixes: 361f3cb7f9cf ("NFC: DEP link hook implementation for pn533")
> Signed-off-by: Minsuk Kang <linuxlovemin@yonsei.ac.kr>
> ---
> v2->v3:
>   Remove an inappropriate tag


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

