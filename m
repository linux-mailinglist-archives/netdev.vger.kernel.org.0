Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C837B4EB8E8
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 05:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242322AbiC3Df7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 23:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236663AbiC3Df5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 23:35:57 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59D73BA76;
        Tue, 29 Mar 2022 20:34:09 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id y10so14296918pfa.7;
        Tue, 29 Mar 2022 20:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Mh0hbPn4yss3NV4x5S3GpMef15fJSajRI8UzUXwmWsg=;
        b=fXCp6VGODXdgRyRxFOHpSlcZNU+nwuNa8VLeZVWU1LEuK4GCkgwzDMeGrERbE0mms1
         XzthF1TrE0/vsGbzyldyhWbaN4yqhNqd3et39OZissLE9DKCAzMxLucDVHlicUkxw2z8
         PscmakU8pEA+UYkBYCZnTDm6cCeUr03dTTQ1BU17T+lmwsYK3awr2jAAFIqh/yWqXkvD
         n6Yn7NKqVCdRJdK9K7vwR8cUOQleYVbaGRY9B4gBYCj3G+ONhjEkf6wHO14doS1jnWsI
         txCh1EyKNSsuazd8SC6wL1LQd69jBhbMgSLjEvJ/FCLTdAmdsRXxYbE9b2FEbczhgT3Q
         TDwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Mh0hbPn4yss3NV4x5S3GpMef15fJSajRI8UzUXwmWsg=;
        b=4yJP8mgUrheC3YTFV7ykS572/lfa2zEgGK3l4fxsvlD+pM+zHCh8WN35NVZ+8ddwe/
         L+4M+yHdl+fWT54IU2cT+XitvNym/rjO++kO4zwNHgP3FcSKen2FR5TXQCJapEQGt+eb
         PqyfURGE4DMSzb8M/Ztfpm+3TSmS26VdssIZeUfG70wdpCzz/ldeGHcZFWczDgarY2k5
         VMYOf4wWlUhnz+fbYG+K47ydAtBjE/8Q+NTA36vRIFv2qmTZI7wtCEtrNTQ232wAiBb1
         WXijkwFe1YeM6dh4kgLMp6Q2Ohd2R8AmJVcKrPVmdr9TUTfUPo25uZIOrVvS0LO2zEsJ
         37qQ==
X-Gm-Message-State: AOAM533lLx3yWuU2Q7vE1D3EKffkR38gl2a04mpEs/mlucOqAu+s4kXt
        inRlUioWpWVSOtop13Bf0sNlCpVQi2c=
X-Google-Smtp-Source: ABdhPJyg3cJ8i558tijJ2c+irjj+vxjMn8x5QPgWjOoN/NChyCm0Ubwg2gUdiQPvARPtJxZQ70qhyQ==
X-Received: by 2002:a05:6a00:228f:b0:4fa:e4c9:7b3b with SMTP id f15-20020a056a00228f00b004fae4c97b3bmr30241764pfe.61.1648611249389;
        Tue, 29 Mar 2022 20:34:09 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id 3-20020a17090a034300b001c779e82af6sm4248432pjf.48.2022.03.29.20.34.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Mar 2022 20:34:08 -0700 (PDT)
Message-ID: <cc4f5e3a-2c17-064f-d787-e12a8d9ffc38@gmail.com>
Date:   Tue, 29 Mar 2022 20:34:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net v2 10/14] docs: netdev: make the testing requirement
 more stringent
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch
References: <20220329050830.2755213-1-kuba@kernel.org>
 <20220329050830.2755213-11-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220329050830.2755213-11-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
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



On 3/28/2022 10:08 PM, Jakub Kicinski wrote:
> These days we often ask for selftests so let's update our
> testing requirements.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
