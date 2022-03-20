Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22E84E1E55
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 00:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343842AbiCTX5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 19:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238451AbiCTX5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 19:57:37 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A0D17F3CA
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 16:56:12 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id v19-20020a056820101300b0032488bb70f5so3239373oor.5
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 16:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5f4rsnnVV5V9cxNeclLxIudo/rCO8obouFsnQkZhptE=;
        b=joEW3+NcWWxtZcT2+JcufUCAcpCO/bWZrBW59qHRf7KiZrum5+eDXJV611g4ZGmHhm
         tP6ducu/Pr0J/to4ZfeL3Xe/KXh97K/vzAuB72pf7Xcwn9zPR2AwGVL7sEl4wKnHAhBd
         Kxn2M6GcqmJPSRSXABBMUpgpQL2SqYHh8x4tsj1cpHJh0gkqUNvGIuVd46WjEIq2ExC5
         SDvXjYuTgM3+GwDx1yyj1tUXdOEQL+opttJwwpJe/eLtXFJZr+In1+2GFWr3e8isbvOX
         c4n8B2f1Iplit+ddxnDGTlIivlys6KWJIUdaWrCSK0cEfi89ExL8XZo/oo3f1chOMUFj
         IzSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5f4rsnnVV5V9cxNeclLxIudo/rCO8obouFsnQkZhptE=;
        b=G9k5fB2jAmTYfRuGsGptrs55E1gjhtZGlV3dyrSMEXdPdkxzgwA81e/Ib/LEVa0txA
         SHDu7UZhyNgdYvyRnHdCbxLp+a4Xu5KtqzYiwrvzHdbwqbdkShF7jt97GNERVlRSZm/J
         BnydPbukJkCqtowBlDhZJn/JcJ5+tKrBoqE5mUHJwSbVZL/sl+VcfQOZnSeciZDmflEm
         KgeXDO3Z2KeHt+t1IETTiTeMNcnhO/pzYAqRojqRFt0H9Kf3/r2MUfbtkZf7NbX0JDI2
         tyvV+ucx3uuQgLOKGb1celxIqaqccWPWiF4Nl4PxLRXx/d0P0v0AU9lDNUMRfFUyj2VD
         /ogA==
X-Gm-Message-State: AOAM530Ng54/V7M0Bm6g2NRW7MkW0hcJW8t0terduRiMJrQ5Wo+XQihS
        s2F+1YQ7T77xbic999BVTuo=
X-Google-Smtp-Source: ABdhPJzyrNJMnAihoMZtz6EucOSJ76475iEmoXTGgH5cmvtXqkJhrtvKRPSOPc1J3r9jneezyh09Bw==
X-Received: by 2002:a05:6870:7097:b0:dd:f298:8ba7 with SMTP id v23-20020a056870709700b000ddf2988ba7mr3010485oae.279.1647820572163;
        Sun, 20 Mar 2022 16:56:12 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.58])
        by smtp.googlemail.com with ESMTPSA id p14-20020a9d744e000000b005b235f5cf92sm6893135otk.65.2022.03.20.16.56.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Mar 2022 16:56:11 -0700 (PDT)
Message-ID: <f416bcfc-9463-b848-74a4-59e688a355ca@gmail.com>
Date:   Sun, 20 Mar 2022 17:56:10 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH iproute2-next] ip/geneve: add support for
 IFLA_GENEVE_INNER_PROTO_INHERIT
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, roopa@nvidia.com
References: <20220319085740.1833561-1-eyal.birger@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220319085740.1833561-1-eyal.birger@gmail.com>
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

On 3/19/22 2:57 AM, Eyal Birger wrote:
> @@ -182,6 +184,10 @@ static int geneve_parse_opt(struct link_util *lu, int argc, char **argv,
>  			check_duparg(&attrs, IFLA_GENEVE_UDP_ZERO_CSUM6_RX,
>  				     *argv, *argv);
>  			udp6zerocsumrx = 0;
> +		} else if (!matches(*argv, "innerprotoinherit")) {

changed matches to strcmp (not taking any more usage of matches) and
applied to iproute2-next.

