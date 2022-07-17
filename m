Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472505777FC
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 21:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbiGQT2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 15:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiGQT2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 15:28:22 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E98812AE7
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 12:28:22 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id o15so9970502pjh.1
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 12:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=x2x7sIk8StiBh4ry98pPJBG4g+ZtkoAFEDFs8D/U3UU=;
        b=IH9H6lbVYUFOH9JJC61JW60BqXHneNY6BBnGGJQ2LfkakA3y8Vgke9pL/BPdTU+uVp
         zyX5H/sFfVI16qU/eddMzXBOlWbYU4JXpzXWzfsaDt9wmBBGV1KgL8WKh4OarUwU9NjD
         3UFQuC+8eaAYHCakACaXgZJSQ8PrjWbYng0Mqiqx6OtXDxnvJ0MIWQYnh7TmWvjmxDWy
         8w9kiMXwX5yl6qX3CDkcK1EzqUlhFajp019aAEZr20R5uNvntIUs4jwO7n6rCnpTzOfA
         578Yde1Oq0AAMVAvFkIWupVIKVWfl7gHx5qbki6JT38gG3m1gq0lKpGzcz22Gk488yxc
         /X+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=x2x7sIk8StiBh4ry98pPJBG4g+ZtkoAFEDFs8D/U3UU=;
        b=P4DVlVVf2H+coUVMY+7jNaplcM3FEG227wACnjD52ijGLlaL75m22lQ5LuUYXLvm4C
         0ibgxAb/O/WSfhDodz1rB3c5n+s6WEmuJvTb6N3JJBjpw8u0zaX0gv3f/etcDn8mElWz
         9dlbCkxs4yDmuebTrMtyzUq4PkhTs83dXDuuKJe1IXnYU1Nyk6dTh4T+Ga6YUZIVpqFY
         8BAe4qDQdn1PsO7ME46vD18Nl9SwNLIfHezCVCqw0LK66w2O2VWqpq+sxnOm3fTbE2Vj
         K/hSQAIrkp1Kr8i7iFPliHLk22rIUdXA6Ud/92JmZxb4x1EZNpH8BkroM0DQTLznlnbt
         D+Zg==
X-Gm-Message-State: AJIora9bxJGX6N5S+Fda+82GSpkHeg+eUel3otG9EhRaUkS+AN+ld4xc
        M6oi3U0TkX0dKhQIPYf5lww=
X-Google-Smtp-Source: AGRyM1u/fNOhYqXUcWTzi38zBzmui5oV5lROrQI8my7UiBdrS+TkpAcrcCcexhbZpTBiiw9gjMf5nw==
X-Received: by 2002:a17:90a:6c46:b0:1f1:b72f:ce26 with SMTP id x64-20020a17090a6c4600b001f1b72fce26mr5074829pjj.190.1658086101549;
        Sun, 17 Jul 2022 12:28:21 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5? ([2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5])
        by smtp.gmail.com with ESMTPSA id q10-20020aa7842a000000b0052516db7123sm7608519pfn.35.2022.07.17.12.28.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jul 2022 12:28:21 -0700 (PDT)
Message-ID: <0a8d88e3-b459-cc3f-36f3-e4450aaaad97@gmail.com>
Date:   Sun, 17 Jul 2022 12:28:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net 00/15] Update DSA documentation
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/2022 11:53 AM, Vladimir Oltean wrote:
> These are some updates of dsa.rst, since it hasn't kept up with
> development (in some cases, even since 2017). I've added Fixes: tags as
> I thought was appropriate.

Thanks for updating the documentation and going the extra mile wit 
providing Fixes: tag.
-- 
Florian
