Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8386855E605
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347205AbiF1OsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 10:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347430AbiF1Ort (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 10:47:49 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C092ED55;
        Tue, 28 Jun 2022 07:47:49 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id w19-20020a17090a8a1300b001ec79064d8dso16173119pjn.2;
        Tue, 28 Jun 2022 07:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BXzXMPRraOx++61I5HiXQxmi+n2UhItjFbQwWVVM4Ow=;
        b=OKsJEYw5tdOZKy7aXCItManEtTDj9UYO9SCXKpa+OhNYFrBtuO+EW9o9mqJt4AxhcS
         cCqjuCUu6K8HsdatBtsNSndSN0XzQ8qEIHw+pnlcw42Nk7i3A6oCerTYmZ0atlP9PZyC
         xvWeScrfzZSeTzYEAdLNsBjfx2AL9me9WC8iMxkNMMzIgqahLyPdinOPJc7iVbSwKuVs
         h8BRkQ8gZk2RtCFcf+c/1B9qSnDOERbLREZ89aPumg4AYvw8DV4PayWpGmFgThxLb+3e
         UXTNk4V1BFsfoBYcW8/knBrfbkffm1Q6noPawsN1+kud7vNju2rkoiuBEhNWoBzsINyR
         MmtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BXzXMPRraOx++61I5HiXQxmi+n2UhItjFbQwWVVM4Ow=;
        b=BCyg03P5Ar4sX40/DEdmRd0SQ8HTS+nTTtNf4/pfHPNl7HkOYBs91vaDbgQYB7HEUf
         qDWp6EP+DLvzpzap8CnVDLsJXeJD2D3z0YCIFpk4YIqJ1FAtPYV+15CG0pCtlygt6DOe
         1J30/CMgjP3awffVBpIBesrqcsS+98t/ScnMChZHINf3asYeP0D2B1e7G3Y2/sktklSb
         GUh5NYkAUZYalcHpo774WOzFGwPoBPMe0S5Z55MJM0yDgBIXDo55SkpButcprxmyilRj
         x2FEcOuyTEh3m7sbAWLaRXTsUKPCYHp9wH6fKSCRK5lXjdKYHxGZKnjByOHFmDz0ojK2
         sP0g==
X-Gm-Message-State: AJIora+KV/c97xgLBz4o2qvtGBAUyaSIPaWVqNfR/Ah+jzGUC3qwyy9c
        lt9BpD4AxVQY+w8+IxUYdqA=
X-Google-Smtp-Source: AGRyM1uWYTT09mk1/TqJ926mo4NJgBy/cpVUZqrnrdZKfJspA98VW0hlLq2xunE27c94f8Izi7Xw8A==
X-Received: by 2002:a17:90a:f318:b0:1ec:b74b:9b82 with SMTP id ca24-20020a17090af31800b001ecb74b9b82mr22578331pjb.198.1656427668720;
        Tue, 28 Jun 2022 07:47:48 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:c569:fa46:5b43:1b1e? ([2600:8802:b00:4a48:c569:fa46:5b43:1b1e])
        by smtp.gmail.com with ESMTPSA id t5-20020a17090abc4500b001ea629a431bsm9638054pjv.8.2022.06.28.07.47.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 07:47:48 -0700 (PDT)
Message-ID: <b2270c71-4f85-3d22-e39f-48457d2892f9@gmail.com>
Date:   Tue, 28 Jun 2022 07:47:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v2 4/4] net: dsa: microchip: count pause packets
 together will all other packets
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        UNGLinuxDriver@microchip.com
References: <20220628085155.2591201-1-o.rempel@pengutronix.de>
 <20220628085155.2591201-5-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220628085155.2591201-5-o.rempel@pengutronix.de>
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



On 6/28/2022 1:51 AM, Oleksij Rempel wrote:
> This switch is calculating tx/rx_bytes for all packets including pause.
> So, include rx/tx_pause counter to rx/tx_packets to make tx/rx_bytes fit
> to rx/tx_packets.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Might have been worth a comment above to explain why the pause frame 
counting is appropriate, or we can always go back to git log. Thanks!
-- 
Florian
