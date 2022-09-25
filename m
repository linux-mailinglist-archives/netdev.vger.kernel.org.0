Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8423C5E9181
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 09:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiIYHl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 03:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiIYHlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 03:41:25 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7819831208
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 00:41:24 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id l12so4303853ljg.9
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 00:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Rs39/HXzNF0cbNfE++RSurDjAf1yqeZyClwZp9nN+wE=;
        b=gavvFpokLjr39E/R1wSFBy7HEtxiB1qqze1KESM80YIqMxl6enYZrX0WiWB7ao6JMp
         N7G/OyZYZJ9N1X6CJWqVM9cXmAEAlk8Kzibi44NfDoPwGJYOPl3GFOE8NsjI6eCxRjOd
         p2aiSf6mXsWp8LXkdJlymDl424ydrV0vmZiV43zTRC99Ht6fVD6VH5Qc0o6kMl2oveot
         TMtY2KglOLcfLF6eJ+WL+LvfhVex5H/ray5F9+PRoRmqH+wohmPAyZCC+SSRaj8+C98U
         7oy6MsXewhfiBam8itwoTIb7Bq8kPBqoGgkJy57L4kq+WpxELNGcXWSV++KXgFYei9NR
         XSjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Rs39/HXzNF0cbNfE++RSurDjAf1yqeZyClwZp9nN+wE=;
        b=ZfkySDa65ftmlpNCKwN0yMBQesb8AUgtoDMcPs5faqK2BarRBGQT1dUET5h1d+q0L0
         L88t6wv5SRirRWpNwHZ1zwYJMWaVBVkQ40ZNiqjyMi4DCvyZZH/Bj9IRji5HvRDvuIXr
         AScmpaW/v9yDlFnm8h66UHxuT5y+EMndiAczB9dTxmqgA5HFCntCp5pYUcpB/Gs+RWfk
         YR1XHdCeP1VENu5NwhqGhGSsRPxJHX41A6f/vcWGThsde6/rYZ/C/gO3VWAeleDt596m
         LJtcDCrQFMoOC8CiIMj8KsDwM/AUVDyR86J02yDlrkSUqRHD5fpEWp66OElpNvpjeV4g
         BBBw==
X-Gm-Message-State: ACrzQf2SiRpZkSE+DlnOFtbW1IGgglHBbR/6Iy9IqSvlbN3yT/Uumz8o
        TBJtiprqj6591b4xp3QMzArOjQ==
X-Google-Smtp-Source: AMsMyM7+Sa/sbYlshCOz7MjrdZQCm2/vuT8upEGrhFYvW2lfV4xh3UrqYb2TSIg2PpbM0RArdUCEQg==
X-Received: by 2002:a05:651c:4d3:b0:26c:5188:513b with SMTP id e19-20020a05651c04d300b0026c5188513bmr5680628lji.407.1664091682873;
        Sun, 25 Sep 2022 00:41:22 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id a15-20020a2e980f000000b0026c5b72eea8sm1993316ljj.97.2022.09.25.00.41.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Sep 2022 00:41:22 -0700 (PDT)
Message-ID: <7c7f67d3-d42e-a053-256d-706cc9dfb947@linaro.org>
Date:   Sun, 25 Sep 2022 09:41:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH net-next v3 1/6] dt-bindings: net: tsnep: Allow
 dma-coherent
Content-Language: en-US
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org
References: <20220923202911.119729-1-gerhard@engleder-embedded.com>
 <20220923202911.119729-2-gerhard@engleder-embedded.com>
 <6e814bf8-7033-2f5d-9124-feaa6593a129@linaro.org>
 <773e8425-58ff-1f17-f0eb-2041f3114105@engleder-embedded.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <773e8425-58ff-1f17-f0eb-2041f3114105@engleder-embedded.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/09/2022 20:11, Gerhard Engleder wrote:
> On 24.09.22 11:15, Krzysztof Kozlowski wrote:
>> On 23/09/2022 22:29, Gerhard Engleder wrote:
>>> Fix the following dtbs_check error if dma-coherent is used:
>>>
>>> ...: 'dma-coherent' does not match any of the regexes: 'pinctrl-[0-9]+'
>>>  From schema: .../Documentation/devicetree/bindings/net/engleder,tsnep.yaml
>>
>> Skip last line - it's obvious. What instead you miss here - the
>> DTS/target which has this warning. I assume that some existing DTS uses
>> this property?
> 
> I will skip that line.
> 
> The binding is for an FPGA based Ethernet MAC. I'm working with
> an evaluation platform currently. The DTS for the evaluation platform
> is mainline, but my derived DTS was not accepted mainline. So there is
> no DTS. This is similar for other FPGA based devices.

If this is not coming from mainline, then there is no warning...  we are
not interested in warnings in out-of-tree code, because we are not
fixing them.

Best regards,
Krzysztof

