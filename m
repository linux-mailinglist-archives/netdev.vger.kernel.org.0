Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 005E94B050F
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 06:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233784AbiBJFaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 00:30:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbiBJFaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 00:30:02 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E869110A1;
        Wed,  9 Feb 2022 21:30:03 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id h7-20020a17090a648700b001b927560c2bso3284290pjj.1;
        Wed, 09 Feb 2022 21:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VuCJ7K5SeMohW1YsUjQ2FAv4U3pm6pjgJmJW6BkHw6U=;
        b=S1mHNeRUCnicyhOCL+zoqpFwgt+nTPNgqrTPK6DVoQRptANFHPf2HaehlWMfCMDW9P
         Y4gb6iQXNPBuDlzgzVFRvrfi7ZVzYBQxGlUY3pqFNuDiJhqFpeGN5rc4SQP8VR+5RdYT
         qmzA+s1PQbsKBLgmXTmdizEvl+iyCS63IqNCsRzNeX8ECstIw3lNXCMdn+XswGEwqVcb
         DGOSRgLxeDZhw+4EzQUN7JYTPRDJyoOqqYciTJE7YytwyMu/P3D/ZaGM4WgJkx1ZQhWs
         4mHmzQnWlQf7LIQxZckI3Kjzfavvd/rDAvPCnA5WbbiWcukSpsqz/iMDCwPcFyhlUX/V
         wGiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VuCJ7K5SeMohW1YsUjQ2FAv4U3pm6pjgJmJW6BkHw6U=;
        b=DcSs4y/JUohG3lOyxx2BpSbJ4IxN20Yq7X+eUVsmDR34xHKNp0HBpQUpSe74u/TE5d
         CGp51FH4Ujz7rsQAXMpWlme70STLDqDkmiYRXMG+D+WW/dhPeq0mZZd9dR2ZWPDkroyk
         df7fcuDZTpPUyf2MjExW5JyAqKJO2om80j6Auz5GnyL3rSdeCTZe35tQw2acdIgQf36n
         0YqaXcTan+Wtym0XThE0xBtYMvw7/UDBrbaAPPfFbqEtFCmDQMf/mOnTMzaKGKCFSeih
         xdakNOSS2Pu3uU0Jibf+L210nc1zD+Sd33BtXbvtcz6qjW5L2mHcuOSy7YGB2Q0Eld7a
         NV5A==
X-Gm-Message-State: AOAM533u9LsbRNAKxQJTDjHtCNIUhxlkoAXQf4sFUk+0zCo4eN5rsezU
        q4cyjiFEaV1zPnITcQ9X+4M=
X-Google-Smtp-Source: ABdhPJxfui1Ef7WUMqgyHKEXNP/fK6QRPFX/TKGCQ2BSb5/SQg84QVU+vD+9UDabHefQVtQ3tbwWSw==
X-Received: by 2002:a17:902:6903:: with SMTP id j3mr5687413plk.23.1644471003380;
        Wed, 09 Feb 2022 21:30:03 -0800 (PST)
Received: from [10.0.2.64] ([209.37.97.194])
        by smtp.googlemail.com with ESMTPSA id g12sm20658072pfm.119.2022.02.09.21.30.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 21:30:03 -0800 (PST)
Message-ID: <c76228c0-c8e1-eeef-7721-96f0822b21d2@gmail.com>
Date:   Wed, 9 Feb 2022 21:30:01 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next 01/11] net: ping6: remove a pr_debug() statement
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, lorenzo@google.com,
        maze@google.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org
References: <20220210003649.3120861-1-kuba@kernel.org>
 <20220210003649.3120861-2-kuba@kernel.org>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220210003649.3120861-2-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/9/22 4:36 PM, Jakub Kicinski wrote:
> We have ftrace and BPF today, there's no need for printing arguments
> at the start of a function.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/ipv6/ping.c | 2 --
>  1 file changed, 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


