Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4238509181
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 22:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351911AbiDTUnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 16:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351281AbiDTUnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 16:43:42 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7582F3B6
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 13:40:55 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-e604f712ecso3244804fac.9
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 13:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5FKQx2kOmM2yUfHRAXrsxx27LVaXyAnBHZOtiXAmoO4=;
        b=hZA2uOmwzaQUA4/an247aYCCl8KVsTjMME75qDexMpMA0HuW9q/+trI4Ct76Xf6FEF
         bwT4j6KjzxIFgXBilQ+UVKjxBFMToVHoKP7yuKWToPpFAKsE0KnaOTKf4igePSrKAYAG
         UDcijlbMc35ZD/Rn1d/vxyLsSR5qhPo3994V0HbD/rnHjuEmif5JheD3W1w/QPznLe8X
         x6iNLazjBUYgN54HGM7EWK/N6oT0lzLX99pTgGDSlQKMSCXHYas/pCVuaGJLnCG7bZZF
         ZHERVot1T4CdLB5vOD7ATMUE6TyRe+3fD23pDH7iST8FpBojAQYWyx9Np4UE0+p4r4WH
         w9Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5FKQx2kOmM2yUfHRAXrsxx27LVaXyAnBHZOtiXAmoO4=;
        b=uvi8ZbnHF0HjX7NV2cE+YrJErqhjb/i9qI2M5yUTH/vUiK6me3tJi6ShZ+XLZOcM30
         QTgv5yQrcIjJDSwp8DPgnghYvayIUEgwASSqN+oa43ABS8bY8lMB4YXhP4PS2v+Rloit
         tI0pEzOiv5BFY27YtW8DeWY0zpTOjQI0Xgu1eJu1/63FyKhxT/Sh2JnqZlmpcVHvE68t
         xX+ISnXacxtphwnFVOqu4Xucu7dt6MsafeLKp8jKJ9kcHAg4enBX9LcQTfgFiPgHnqaP
         FAqx4GXA2Z0KtXpAS51ACW+2P9hadvdSWJwEi4udengWEM8pvwm0VLKVOnWdZ5qPNTQm
         1j9Q==
X-Gm-Message-State: AOAM530h4UUzcULxKxduQWEnSR/e3PymRegD2RJGCSwNDH2mtsJMvVRL
        TxCHdiir1k1JsRV0u9joQWhBfNjKoMaGgQ==
X-Google-Smtp-Source: ABdhPJwc8fY1SZG7oXjZY3nQuDAyNDdvHg8+Tf/X2FkEecygEcRGLOQh1H+973igxS24lEf7MxRbsA==
X-Received: by 2002:a05:6870:95a4:b0:d7:18b5:f927 with SMTP id k36-20020a05687095a400b000d718b5f927mr2338563oao.45.1650487254742;
        Wed, 20 Apr 2022 13:40:54 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.69])
        by smtp.googlemail.com with ESMTPSA id f21-20020a056830205500b005cdb59d5d34sm6847977otp.81.2022.04.20.13.40.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Apr 2022 13:40:54 -0700 (PDT)
Message-ID: <a5fdf1dc-61ef-29ba-91c3-5339c4086ec8@gmail.com>
Date:   Wed, 20 Apr 2022 14:40:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: IPv6 multicast with VRF
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20220420165457.kd5yz6a6itqfcysj@skbuf>
 <97eaffb8-2125-834e-641f-c99c097b6ee2@gmail.com>
 <20220420191824.wgdh5tr3mzisalsh@skbuf>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220420191824.wgdh5tr3mzisalsh@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/20/22 1:18 PM, Vladimir Oltean wrote:
> On Wed, Apr 20, 2022 at 12:59:45PM -0600, David Ahern wrote:
>> Did you adjust the FIB rules? See the documentation in the kernel repo.
> 
> Sorry, I don't understand what you mean by "adjusting". I tried various
> forms of adding an IPv6 multicast route on eth0, to multiple tables,
> some routes more generic and some more specific, and none seem to match
> when eth0 is under a VRF, for a reason I don't really know. This does
> not occur with IPv4 multicast, by the way.
> 
> By documentation I think you mean Documentation/networking/vrf.rst.
> I went through it but I didn't notice something that would make me
> realize what the issue is.

try this:
    https://static.sched.com/hosted_files/ossna2017/fe/vrf-tutorial-oss.pdf
slide 79 and on

> 
>> And add a device scope to the `get`. e.g.,
>>
>>     ip -6 route get ff02::1%eth0
> 
> I'm probably not understanding this, because:
> 
>  ip -6 route get ff02::1%eth0
> Error: inet6 prefix is expected rather than "ff02::1%eth0".

ip -6 ro get oif eth0 ff02::1

(too many syntax differences between tools)
