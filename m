Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847B06C8837
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 23:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbjCXWTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 18:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjCXWTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 18:19:37 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25555262;
        Fri, 24 Mar 2023 15:19:36 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso2972820pjb.2;
        Fri, 24 Mar 2023 15:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679696376;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TfZyPgzazkD1zAKOlgLm3H2FuXzdTctjEB+xnAu24Bg=;
        b=PESw3GTQBmb7szuSSM/fpqtEHp2qP0SZJrgfhQ9GLIkqvFEJDzen+cFKEinLt1ipTx
         niEiQmfLUdOlhsMPyFVskB12lq4n1P5knf2EDyicx8/2ZogeBUAnnspXfzi0pcHEOYqE
         0mXbMRlSbVotdG0PCwXMCacs79TqP+wpA79dt0sPUJSbah7k9u/nm9+Y4SAKATokPxHw
         3k03C1VUmrbh8hRtuUVpJCf/s1pq3pGtn7DrH11Msf969oXt086mCiueVe0FtDVdRZ8z
         CQalSxGsiYglf0MBV+OwsraW10WoA2fxudyGoO33Ooz8mxe3NO5OThi7a0TVEIIlESmx
         bfxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679696376;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TfZyPgzazkD1zAKOlgLm3H2FuXzdTctjEB+xnAu24Bg=;
        b=1eHfiBAsGjN+tfiL3okwyEBEnWLGSTl94KuZE+7KiVGbs3OvureqrEVPSYTs3nqp9v
         ksaWz5/rvfTeaPG8WEgQREUctC7TG608q/dJX3y7/MZ5ZXfTi1yzvQiC8GBzOckrMOWY
         HH08A+vj9y9Yez1P6FWNmJ0CDx7oOsYA1MrCwD7mQELok+2VjYHepIlXAp4qP7TtWjmN
         6K8HulG6o/a3Cey33dgb1+zs939ikB7vpTjtWwRVfo9adSf9BfMFgTSGLjBZZsvgAJxS
         oY/qpsBsSbiGRSdKv1hpdaZr8d64vDNEENamhl07fGfWef2kCGePU9H5DAK+02d3uwMd
         cmrQ==
X-Gm-Message-State: AAQBX9fCkIaA+bJBROwjhypS9xeDXW7WpMzdTAK1o6IRkAV9/z8qN+4F
        mTut31i8/610ceVKAbWi+p4=
X-Google-Smtp-Source: AKy350Z3xMvwvLnLk3EJmtCOBLQDtqmmIl5VVIhEx/jYQEYInhelkRG6HtEXe1F0NEeIu0PpFZJWIQ==
X-Received: by 2002:a17:90b:33ce:b0:23d:4b01:b27 with SMTP id lk14-20020a17090b33ce00b0023d4b010b27mr4796947pjb.10.1679696376393;
        Fri, 24 Mar 2023 15:19:36 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id nk13-20020a17090b194d00b0023b3179f0fcsm404030pjb.6.2023.03.24.15.19.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 15:19:35 -0700 (PDT)
Message-ID: <f17a0943-d74d-2b65-6d4d-9279dafdbce7@gmail.com>
Date:   Fri, 24 Mar 2023 15:19:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net v2 1/6] net: dsa: microchip: ksz8: fix ksz8_fdb_dump()
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
References: <20230324080608.3428714-1-o.rempel@pengutronix.de>
 <20230324080608.3428714-2-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230324080608.3428714-2-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/23 01:06, Oleksij Rempel wrote:
> Before this patch, the ksz8_fdb_dump() function had several issues, such
> as uninitialized variables and incorrect usage of source port as a bit
> mask. These problems caused inaccurate reporting of vid information and
> port assignment in the bridge fdb.
> 
> Fixes: e587be759e6e ("net: dsa: microchip: update fdb add/del/dump in ksz_common")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

