Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBA24D54BF
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 23:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344394AbiCJWnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 17:43:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344402AbiCJWne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 17:43:34 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688C4B53
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 14:42:31 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id mg21-20020a17090b371500b001bef9e4657cso9545778pjb.0
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 14:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=H0dJecyPS2t445Yyuaocacfsz4kMpFTNDFKZg5I5Xqo=;
        b=i2+4Hhkq0ffVuy/voAgJ7Oie2KiFixt/XYRgrrvr6dmSS6Qob5Wmq9eVqbssVG/Prz
         NZKOO3RZDuV1X5NCn3/n69tAPp9lX1Q8rfhM9oczaPrXHNiLC7k/Aqdn/AuwHiAldis2
         G2Gz0IpLA0/WkI4mr0CL1pkAmvljkK0MqjH7oZuZ0AeS0C2qPAhHZGoaVoB3Km3j5tE5
         1PZkCUi8Sjgri2Mi5KBmQGRAzr0wfrySJPF6OjoYKqatacXrXCJsZ0FohWDwgJKVE04B
         b7XCJdSrDWHSVxF2XGnY6kwky7gCnRwqeHHuDWF3JvOd1hc/hnbHvT62GCX8HpFGNF4G
         T0jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=H0dJecyPS2t445Yyuaocacfsz4kMpFTNDFKZg5I5Xqo=;
        b=HwGrKquO6OxvC4Cdd+SupZtyxa2IL3dsK9t1FzhOYx1fuGujMXkU8RCDcgLnFCSyif
         9RaxU+HscO0IHKYHZR5up9M3f6IIa2z/7dVeJODxvk9G94YG0mrxHx2RY10kqDOIhUkM
         uKmyPeO93CYK1ZSQh1tb2a2lhJRkH0nYf2t9EmfPEJSKz4Ix4GDKN55XNkmJe+gQlK2N
         dEQVaKsBDhXJmCpc0uj9nSjbLgSoxeFSQn8vYPNl/8GIN+ZJ6oziIUlbQf1joTBUEJ6P
         bwKFR1R1jvqvmzMSbe0AaU5UfbALmjgvb2P6EoG+BGkLb57ryD6CMTkmogXnushJekus
         JwWQ==
X-Gm-Message-State: AOAM530zn8cZ4psUvc6Vi2zUYqWv+QTUJJv+D6TnaaXMTvw4FeUN+1rQ
        xI9Vp3y+BvapMbRLEdi90p4brg==
X-Google-Smtp-Source: ABdhPJz+HM8Z5oVHOCVhGxstjdd7fA+IbJhbFxh8NNun6SGE5r59isngyOt7OckA9+Vcvc9xTcThVg==
X-Received: by 2002:a17:902:cccc:b0:14e:e89c:c669 with SMTP id z12-20020a170902cccc00b0014ee89cc669mr7408737ple.58.1646952150727;
        Thu, 10 Mar 2022 14:42:30 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id y10-20020a63b50a000000b0038088a28ec0sm6504255pge.22.2022.03.10.14.42.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 14:42:30 -0800 (PST)
Message-ID: <62a9b061-1cf5-dff1-c062-a3961de92dca@linaro.org>
Date:   Thu, 10 Mar 2022 14:42:29 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com
References: <CA+FuTScPUVpyK6WYXrePTg_533VF2wfPww4MOJYa17v0xbLeGQ@mail.gmail.com>
 <20220310221328.877987-1-tadeusz.struk@linaro.org>
 <20220310143011.00c21f53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH v2] net: ipv6: fix skb_over_panic in __ip6_append_data
In-Reply-To: <20220310143011.00c21f53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/22 14:30, Jakub Kicinski wrote:
>> +
>> +			/*
>> +			 *	Check if there is still room for payload
>> +			 */
> TBH I think the check is self-explanatory. Not worth a banner comment,
> for sure.

Ok

> 
>> +			if (fragheaderlen >= mtu) {
>> +				err = -EMSGSIZE;
>> +				kfree_skb(skb);
>> +				goto error;
>> +			}
> Not sure if Willem prefers this placement, but seems like we can lift
> this check out of the loop, as soon as fragheaderlen and mtu are known.
> 

He said to check it before the skb_put() and so I did.
The fragheaderlen is known early, but mtu can be updated inside the loop
by ip6_append_data_mtu() so I'm not sure we can do the check before that.

-- 
Thanks,
Tadeusz
