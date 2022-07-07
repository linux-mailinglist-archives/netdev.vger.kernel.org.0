Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBC656A513
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 16:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235182AbiGGOIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 10:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbiGGOIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 10:08:21 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E548220E4
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 07:08:19 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id l23so847286ejr.5
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 07:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=6rY/dl2MwiNlzvD+cvp/Yehm/zk9+xvHGZcTY6Q3tHo=;
        b=t2gX55YR3zd30kvhnujoohIF5s3d5CO/xyZejpLQSF+S5o/KrNLttMvJGTX1oeAjn9
         vUCeZ3TJi/rcNK7qQ1Ct4cYa2MdcUQ5w3TAQWCzbegoVLC9jJUqhZsuk6UC9qRFYK0Jq
         4Pa/LZd9tsDU9Smmw84BbYJ60cIMADLrUl16WWi4ggOr+WMPbloLywj0iIASQzgtvL+W
         twSlbGH2fS+itudRcqd43RuWsrM5v+Zi/wuYlFYG7umyfM8/7pMf2mkdyeF2eMljZLjd
         3h+JBbNnjz573UvruSiquB6tfr6VgxiQdqKw/qQLBOn3YYt16vK+C8JF0HVcIuu7SsYb
         Tvuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=6rY/dl2MwiNlzvD+cvp/Yehm/zk9+xvHGZcTY6Q3tHo=;
        b=Ta7ywQpJsoMxpN/J/KDSSGVuCe9ATE3u0cbAYgNPwCC0+cvNz+omVfw+ASAF4pKwXT
         X1jWYtkcR854/xBiP0kzbmE5lGGyrUciGXmJtRBO31EC15hU3UeldlsVb6iuElOOA+T3
         eqzIK9GAwrcgRpYMPqRUBGFvOaZ18TTs7wGkwYY0+8CzwLomRvZiTtViev8+ia+4LZPP
         vVxrqtVbApU8sACI3blUjmhVSv6fa7gMF4OZ4LpMCDjYUxrwosP+q/BDiNjy7rjlYXIy
         WrkRPJTjv7UQPUL3/1Zx5nIumJbewZTM9jRvjJzvImIre7GX+eb+wyOa1lswiJ51fGFw
         7KSw==
X-Gm-Message-State: AJIora8fZ5MJoZ838ql+j/QIcz8pA0WpymesXke2+Ruu00SkKKHRV3Zr
        5JwJ9CvRtQ+QanuscxB48WJSjA==
X-Google-Smtp-Source: AGRyM1vXnwj82Bxvke8sMoKXBGchoAelH3wU3m1m1FqidsNi8nJ6cJffAXN/13LDMJAzzvjAwflz7w==
X-Received: by 2002:a17:906:a3ca:b0:726:2bd2:87bc with SMTP id ca10-20020a170906a3ca00b007262bd287bcmr44834471ejb.226.1657202898091;
        Thu, 07 Jul 2022 07:08:18 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id d11-20020a170906304b00b0072abb95c9f4sm6590052ejd.193.2022.07.07.07.08.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jul 2022 07:08:17 -0700 (PDT)
Message-ID: <37d59561-6ce8-6c5f-5d31-5c37a0a3d231@blackwall.org>
Date:   Thu, 7 Jul 2022 17:08:15 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH V3 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
Content-Language: en-US
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
References: <20220524152144.40527-2-schultz.hans+netdev@gmail.com>
 <01e6e35c-f5c9-9776-1263-058f84014ed9@blackwall.org>
 <86zgj6oqa9.fsf@gmail.com>
 <b78fb006-04c4-5a25-7ba5-94428cc9591a@blackwall.org>
 <86fskyggdo.fsf@gmail.com>
 <040a1551-2a9f-18d0-9987-f196bb429c1b@blackwall.org>
 <86v8tu7za3.fsf@gmail.com>
 <4bf1c80d-0f18-f444-3005-59a45797bcfd@blackwall.org>
 <20220706181316.r5l5rzjysxow2j7l@skbuf>
 <7cf30a3e-a562-d582-4391-072a2c98ab05@blackwall.org>
 <20220706202130.ehzxnnqnduaq3rmt@skbuf>
 <fe456fb0-4f68-f93e-d4a9-66e3bc56d547@blackwall.org>
In-Reply-To: <fe456fb0-4f68-f93e-d4a9-66e3bc56d547@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/07/2022 00:01, Nikolay Aleksandrov wrote:
> On 06/07/2022 23:21, Vladimir Oltean wrote:
>> On Wed, Jul 06, 2022 at 10:38:04PM +0300, Nikolay Aleksandrov wrote:
[snip]
> I already said it's ok to add hard configurable limits if they're done properly performance-wise.
> Any distribution can choose to set some default limits after the option exists.
> 

Just fyi, and to avoid duplicate efforts, I already have patches for global and per-port software
fdb limits that I'll polish and submit soon (depending on time availability, of course). If I find
more time I might add per-vlan limits as well to the set. They use embedded netlink attributes
to config and dump, so we can easily extend them later (e.g. different action on limit hit, limit
statistics etc).

