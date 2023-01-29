Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0CD67FE01
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 11:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbjA2KIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 05:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjA2KIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 05:08:05 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF014EC42
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 02:08:03 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id ml19so752191ejb.0
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 02:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DqgkF38GQImRFpT8l0bOcZbRmQDjRs1Al/kqBAXFHTo=;
        b=dK75uQOO1cNpYPDE6GEY6mNreQC86/sFydc4f1X2NgUKMgHZLZeeQr3Jtc12nOZOav
         1OYl6Sj+zvONqzYphvS5TbyxQKXioaec7SxOB+rqUBkDzuXFtazvcR9a7goCUHYn5DHD
         UvhZGthalHhwAPjSr7rgxn2H2EOIhelGXhpxuZ/3fgEZfzlsoEC9LD1GxySQJ9LYSL+J
         dWAnrZeBlj9Lby95PGzc1auMe0Y2YcZ5DgchS8qjRmdHyjm4Mi3ieGt+Em/Kdfl58SLW
         bIm4vFUaWGNAgEFMS9zTg3x2OiYhQhj9f9LYJbxw8r1AZuUnI4CQFNQO/6nJWA+nFl5c
         xtRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DqgkF38GQImRFpT8l0bOcZbRmQDjRs1Al/kqBAXFHTo=;
        b=XmdbSilc4SD1pd3rK4F0yMaMsJ3wGLcPSNiAy5Iyua8ulnsJgBnQ5BWDGrFuQG8XGc
         ajEUDNizu6Qa4R68wjJ70NpR3rztTF7fpf5CxAPJq/OYiIAeRcd3Yjy6kcwwiy07zOyZ
         e4wE0puOdte0YQnJsImm5tsOjvfRF/dEbmNQazos3Vtau4AiwH1ch2vSJvL4olQRyzt9
         Fdv8mEbYI0MOoQv9FXwng1oHOlkEpLbn7Q5RxuOL8M0827qbTtdq+ucWf7Kv9H9zCkn7
         z47KSsGsx3370DsH4yAo7v1jBIrCkjeeZXr/jO18fMpphehVN95aZedx9+iFKrBJb5HR
         Chaw==
X-Gm-Message-State: AO0yUKUBYm+YTMXLgLXONUGMamPh5FvP6DOxyAw9lUkc8cRW+kw9Oc+l
        Oa8JWcdEf8tZMy6ITkgQ7xnptA==
X-Google-Smtp-Source: AK7set8JJeVkdlBJrd5tT7nF98WD7Uwzkg8BRvgtYDKfvwWHSSPzcE6hzbjkGzLnDtKef69gH9uBKQ==
X-Received: by 2002:a17:906:cc8a:b0:878:72d0:2817 with SMTP id oq10-20020a170906cc8a00b0087872d02817mr11979080ejb.29.1674986882144;
        Sun, 29 Jan 2023 02:08:02 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id x10-20020a170906710a00b0088842b00241sm100126ejj.114.2023.01.29.02.08.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jan 2023 02:08:01 -0800 (PST)
Message-ID: <feafb8fa-d0dc-57b6-d126-4944b2240775@blackwall.org>
Date:   Sun, 29 Jan 2023 12:08:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next 09/16] selftests: forwarding: Move IGMP- and
 MLD-related functions to lib
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, Ido Schimmel <idosch@nvidia.com>
References: <cover.1674752051.git.petrm@nvidia.com>
 <c3f7ba006ca61292dba6d6389f30a38a70731a8e.1674752051.git.petrm@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <c3f7ba006ca61292dba6d6389f30a38a70731a8e.1674752051.git.petrm@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2023 19:01, Petr Machata wrote:
> These functions will be helpful for other testsuites as well. Extract them
> to a common place.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  .../selftests/net/forwarding/bridge_mdb.sh    | 49 -------------------
>  tools/testing/selftests/net/forwarding/lib.sh | 49 +++++++++++++++++++
>  2 files changed, 49 insertions(+), 49 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


