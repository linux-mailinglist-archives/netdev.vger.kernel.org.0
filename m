Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE803534AF9
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 09:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbiEZHsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 03:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiEZHsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 03:48:51 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC4BA7E05
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 00:48:51 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id m14-20020a17090a414e00b001df77d29587so3737864pjg.2
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 00:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZrWTITH47jn82jllXuxPyMP5S5UEHWgQ2grdmjVduX4=;
        b=enm1G9YAsPsmUfoFKax1D1EYOHZZROaDvpQi5dqIKfRl4FzncVtXbstEOg4OzZ7syM
         CeFjJjoygVaQiIDyDxVN6HZSUq64Ub6GkkuIQCbgLOlDFRN4zm7P2DYMeV5RFGGQX5zR
         2Xt4O4D6ap35gEUyLDS1EWYZSCR0bLQ3iEj8C8K67gE97CEYPYc9ZCKXsFN9oritMj/C
         ERgNDV/itAhI5nFg4HG9WW0I/g3pjMs7mw2C/4vzpWINNBuSWVGMXRcjnkVcBlBRsudR
         CkWNJsPml/OgTZ7jDACSIEyI5QO61a9HaQudlh/WNmF898RvBW8xet4k43I+ZE5Rllkq
         ecYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZrWTITH47jn82jllXuxPyMP5S5UEHWgQ2grdmjVduX4=;
        b=oYUStR1P1mJZzwrO3OjEZQDvWkFI5AeWkNTZn26ngAi287DGtVAn10EtDGbz3nwbTX
         X90tFCjN+0ysWHV14YVDMBrPX20x0EK/Y0+ZdlRt7QNGMblChPvBGd1JwDvLJe9V+jK/
         LG2iZ/iT4e8kCP9gIQHP+kionMdd6Mn5Rh5zR0eC0VJ/mzPujUWsMNLJIdZXLpajc3Fq
         Hdt2ucMYI4Vs91tN4ITBCvCTgtIUA3ruLjAqPA6xuhhMiDhcJCj/Lm+kS2FMB4h/zxAk
         TFr/U5U05U7JSAvmHFAyH1jwPSlwm/1N+/Dc+bkfB3SUM5zSRviPwUnojAp1qhZOGjXb
         YDbQ==
X-Gm-Message-State: AOAM533bBWCyTgq1/FYfRGPat2CbtzybvEacYi8iUimFRycikWqXbj0m
        ilqNd29dSPio5gvmSks8uXM=
X-Google-Smtp-Source: ABdhPJz9vZeLpSCo9qaCHoG0dqTL2QzDYBO9PqvoYklSd9GBOQMkNdV8o2zBsHvxQ41VQvhfMiYPEA==
X-Received: by 2002:a17:90a:5c84:b0:1dc:9b42:f2cf with SMTP id r4-20020a17090a5c8400b001dc9b42f2cfmr1273608pji.123.1653551330717;
        Thu, 26 May 2022 00:48:50 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id p39-20020a056a000a2700b0050dc76281fasm738756pfh.212.2022.05.26.00.48.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 May 2022 00:48:49 -0700 (PDT)
Message-ID: <d68b1960-768a-e3f2-c401-bf8a1945d293@gmail.com>
Date:   Thu, 26 May 2022 16:48:29 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net 0/3] amt: fix several bugs
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org
References: <20220523161708.29518-1-ap420073@gmail.com>
 <20220525214748.35fd8cf6@kernel.org>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <20220525214748.35fd8cf6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/26/22 13:47, Jakub Kicinski wrote:

Hi Jakub,
Thanks a lot for your review!

 > On Mon, 23 May 2022 16:17:05 +0000 Taehee Yoo wrote:
 >> This patchset fixes several bugs in amt module
 >>
 >> First patch fixes typo.
 >>
 >> Second patch fixes wrong return value of amt_update_handler().
 >> A relay finds a tunnel if it receives an update message from the 
gateway.
 >> If it can't find a tunnel, amt_update_handler() should return an error,
 >> not success. But it always returns success.
 >>
 >> Third patch fixes a possible memory leak in amt_rcv().
 >> A skb would not be freed if an amt interface doesn't have a socket.
 >
 > Please double check you're not missing pskb_may_pull() calls.
 > E.g. in amt_update_handler()? There's more.

As you pointed, I found that I missed pskb_may_pull() calls in 
amt_multicast_data_handler() and amt_update_handler().
So, I will do some more checks and then send a patch.

Thank you so much!
Taehee Yoo
