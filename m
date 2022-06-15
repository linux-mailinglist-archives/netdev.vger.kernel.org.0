Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD7B54C36C
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 10:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243711AbiFOIZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 04:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbiFOIZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 04:25:56 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C88D220E0
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 01:25:55 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id bg6so21829461ejb.0
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 01:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=81G8W5HZcsZGBz+5OMYMDedtIQ5UWl4XrEoXghNc1ZE=;
        b=WSsJPme3UHq4EYU7YhodN3CicGBI3v0oOn1cW+Quch7x+MGYPc3bXuJL0PHrLzOqJL
         iMEPA+pZLwol8Nqzs5Vq0uV4k7Mm45A+2iMrgdFHLjcrnEFO4+DV9FpyPAeHyvBhMSbH
         aINNLbd5xviC6a4ZCCm5w7AdXLPhwzF83Oku913g78TOLuLKqmMet24Luyvcnl+iPaVh
         DHT37bdC+uP1inQ2H1avWvoHRVM6qhd1x5Ch8JB9SeRo6Nb1OuCkfpR36napHiJEYrSW
         YYaYAD496PxAcBW1dv0/FV4rraUJKsu+roC4Ie40IgyGwk1/dkr3LJG0s10ZVD/xJoIJ
         B3YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=81G8W5HZcsZGBz+5OMYMDedtIQ5UWl4XrEoXghNc1ZE=;
        b=eC/D+u50XZgpwZ5cjYMvSz4V8/BNDOz4SKGcNPyW8fQ5jn5wOQd7cAwWe2B/lbN/r4
         lzSeElo9BL5R4MvYQLyu9FeRcpDmDnjghHM3VqcUdDWpi8AkXMZAInxO/Ft2Gjvb4pdn
         0zUQzEk0Gs/la/bLt+FTvqBSmWP4orla4zY2+Mg+mTL/CTLpazzF7YnEBPGONNbOcd64
         gJch5KeeaAasuqlmZwSYQygocDK38Zs06cIPksu2Qa/eBiaueCSUJF/VxvSlE9ECODS0
         m67M2SWf65lbBfl+6f0+8PqNc6nzFoGYM8TjnwTRk4XMc9c0UnobTdNtGjotOHFz1bsW
         4lkw==
X-Gm-Message-State: AJIora+UivuSOAljhxJDEzQxXJhWIGG7cSnddZ2+srwsa7eEVSs7OHmf
        PofVpPHce7Jyl8ye7LPK6jIP/Q==
X-Google-Smtp-Source: ABdhPJw/nxLUNfgfq7Tf+SWDbebDvzIN2ukH/zpWSGYnc3mjPW6Wy0LCWzPoS2Ue5sJJRfhXCzxMSA==
X-Received: by 2002:a17:906:7d47:b0:715:7ec3:e3ad with SMTP id l7-20020a1709067d4700b007157ec3e3admr3499566ejp.12.1655281554807;
        Wed, 15 Jun 2022 01:25:54 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id o18-20020a17090608d200b006ff802baf5dsm5970651eje.54.2022.06.15.01.25.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 01:25:54 -0700 (PDT)
Message-ID: <eb011e1f-c264-eca6-8526-c0660a7e7844@blackwall.org>
Date:   Wed, 15 Jun 2022 11:25:53 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next] net: bridge: allow add/remove permanent mdb
 entries on disabled ports
Content-Language: en-US
To:     Casper Andersson <casper.casan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Joachim Wiberg <troglobit@gmail.com>
References: <20220614063223.zvtrdrh7pbkv3b4v@wse-c0155>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220614063223.zvtrdrh7pbkv3b4v@wse-c0155>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/06/2022 09:32, Casper Andersson wrote:
> Adding mdb entries on disabled ports allows you to do setup before
> accepting any traffic, avoiding any time where the port is not in the
> multicast group.
> 
> Signed-off-by: Casper Andersson <casper.casan@gmail.com>
> ---
>  net/bridge/br_mdb.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 

Sounds and looks good to me. Ideally you should send a small selftest to
make sure this case is covered and someone won't break it in the future.

Thanks,
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>



