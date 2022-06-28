Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B3F55E6BD
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346574AbiF1Oqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 10:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346214AbiF1Oql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 10:46:41 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F782E085;
        Tue, 28 Jun 2022 07:46:40 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id jb13so11274598plb.9;
        Tue, 28 Jun 2022 07:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0PttLrl7XzFT/DEx+fCRDXEzmtLQpluLTks1IMGMmBg=;
        b=lN3bOoP2kYrFIINdnvZW/U3+4JXVSc7UBijEkw5HwTnsZJE6iWecvoCvZmr8Vo1X4u
         GDhEXQyuhE0Fd4H5r7mV/KYmRKO80+Nyb30xwNNoSuAty6Why5IZ4kyLk4MV1FnhzeDS
         7rnpZbZkEqGoPgE+XspcKiRRah4ES5DN/Fe7ik1Jutd7IamXbNCEKJPYC7KkV2x7dHY7
         e5mFaaKNojIxk8W83EysIpSVTg0Jm9rGaurF7/bqbc5ofU4Y8Yvcvz0J/8Xm+efMZ93U
         /7IK42i+4lzbIqoohy9eOSn1SBO9mxYbP8JkpyJrRHBUyv5dyVxyL2YmAuy8ptulFpog
         z8lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0PttLrl7XzFT/DEx+fCRDXEzmtLQpluLTks1IMGMmBg=;
        b=syxJ4NMvBxAipFbwjHB4Y+x9kXneQVnQDtjWOrDimcqYKcRpKhJZLmlyq6nGjuCJOb
         XXRU/2CcQN3/nQSxU9eluNMwAb9aTdQiapEFMGorD6sAwVFkYGsxZRbyywHKRUKZdFT4
         gh5H52cTd5SUoD8k1vuVoo2rv5haXzQtIY8QMLXjt803noyWl/HUntigkkR+INNNFg7d
         4oXjflHOOGa3d4UulTguLkTgTuPhMRx/u4X3RuvCGxyochdROVsJ7bz9wRowJC0ouIjd
         xzj0hQRsHqvMAPcbgDqKGYiXkJYRRI6fTEcP+G2sN+oplV2/kbGYzvxwdCb6yc22cUa5
         qwTw==
X-Gm-Message-State: AJIora+HI1I95S80ULcgEeosSL/j+JwuK7uwY1Y4Tkr/fe3UYUhFkXAi
        bNJSgMESM6q50nZFvkZcrm8=
X-Google-Smtp-Source: AGRyM1tKpFw5r1POn/3CA5HmCjwUu7gNX0Wo3qEufctgXHk5mNL08xP+g5VODiaEfo6qCo28ADa7PA==
X-Received: by 2002:a17:902:7102:b0:168:dcbe:7c50 with SMTP id a2-20020a170902710200b00168dcbe7c50mr5465892pll.116.1656427600078;
        Tue, 28 Jun 2022 07:46:40 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:c569:fa46:5b43:1b1e? ([2600:8802:b00:4a48:c569:fa46:5b43:1b1e])
        by smtp.gmail.com with ESMTPSA id jf20-20020a170903269400b0015e8d4eb25fsm9329014plb.169.2022.06.28.07.46.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 07:46:39 -0700 (PDT)
Message-ID: <8ec75f24-bf35-2331-0fbb-49e12bc45f73@gmail.com>
Date:   Tue, 28 Jun 2022 07:46:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v2 2/4] net: dsa: ar9331: add support for pause
 stats
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
 <20220628085155.2591201-3-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220628085155.2591201-3-o.rempel@pengutronix.de>
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
> Add support for pause stats.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
