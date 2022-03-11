Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71CEE4D61FC
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 14:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348743AbiCKNEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 08:04:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348740AbiCKND7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 08:03:59 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F016B6580B
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 05:02:53 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id j29so5894966ila.4
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 05:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=GjFRD/9lEJoDZd2iHKsangrWSMTO+5I2agn/qVuV8qs=;
        b=mFwvW4rXhHFY/F7Hmapw3Rafdjg4wgiZVsST1HQiQHcQcDPio3iFZMTOVmwYR3+Vwp
         2+mCtb+tkPhSmYWZtrYicfUyy9ZByxewSj5V6NgpjwcAYfjKAWOwCgXJodJq3ra4vYyx
         S9LjsdPZ0RYrYFNFFZHh0xB2p38eSgzvv+PvWmyks5dMAmBHjTnG61TgtQ1D4AWKk0xb
         9YibeoiGSu5KPoTGcmIC2MP+aw9+UakeJ3Pe2uWfMS3ZTnCGp4GS1jpmpFxsen1vGw7l
         +XH2VbHgTkYcbkXAgQ1ni7Q8VI47/JiaHwO8SKCq4BAnZUg86stjL4918vAbkdET2UFU
         oOLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GjFRD/9lEJoDZd2iHKsangrWSMTO+5I2agn/qVuV8qs=;
        b=kyUwBjmo9+FyJacB32lYTLUCqVYXMKssZ0rekuz+zJYBTQkmR/UCBnx7NGelVAASnx
         bq1/bpsQTxGgWblEu0wnTkepgYIG2FG8yamFSkSfirWx1Y0U8I+wSeP7/+wQR2CX99WN
         TW9qUl+0CLXmZp7u++p3qczG+f0Ng5KLSrs6X4JLLAmBBeXaptgtHDXdy82rRoS7gFX0
         p+E3HZkIbHPd2D/QRdOy6KBUZbtmLLnmnuDfsD9JGuGJV60GQ1Wvz3F+q2dBGP/OHxtU
         kXYta3n1fZRAwSA45NqBfl7ftlkAc3pR9jN420+ukBPj4kLf6UIy5/Ew4KhPDs3Qp6xl
         nRzA==
X-Gm-Message-State: AOAM533bGG1udL9FMAob+ppsnMcVD/ETIO0Z88WSS3PpeIUS5ONRPbc7
        vnhoj2rxvZ/CEPi/Ow5PRTB9zKNeGeaRAuET
X-Google-Smtp-Source: ABdhPJxR9fs0AtdoSZ4y9wsmyyDoVP8I7fhsy0a9F0fDPMq6S4RGQRXFtLgHy4uQJiid5eIa0QtMCA==
X-Received: by 2002:a05:6e02:1baf:b0:2c2:46eb:a074 with SMTP id n15-20020a056e021baf00b002c246eba074mr7234018ili.263.1647003773245;
        Fri, 11 Mar 2022 05:02:53 -0800 (PST)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id l14-20020a056e0205ce00b002c782f5e905sm81979ils.74.2022.03.11.05.02.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Mar 2022 05:02:52 -0800 (PST)
Message-ID: <680f7662-7a7d-4e26-6fdf-e4d961895dcd@linaro.org>
Date:   Fri, 11 Mar 2022 07:02:50 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v2 6/7] net: ipa: embed interconnect array in the
 power structure
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, djakov@kernel.org, bjorn.andersson@linaro.org,
        mka@chromium.org, evgreen@chromium.org, cpratapa@codeaurora.org,
        avuyyuru@codeaurora.org, jponduru@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220309192037.667879-1-elder@linaro.org>
 <20220309192037.667879-7-elder@linaro.org>
 <20220310212523.633287d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <20220310212523.633287d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/22 11:25 PM, Jakub Kicinski wrote:
> On Wed,  9 Mar 2022 13:20:36 -0600 Alex Elder wrote:
>> -	power = kzalloc(sizeof(*power), GFP_KERNEL);
>> +	size = data->interconnect_count * sizeof(power->interconnect[0]);
>> +	power = kzalloc(sizeof(*power) + size, GFP_KERNEL);
> 
> struct_size(), can be a follow up

I can do that today; I'll look for other instances in the
driver where this could be done as well.  Thanks.

					-Alex
