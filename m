Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1AD55E83A
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347167AbiF1OrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 10:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347166AbiF1OrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 10:47:01 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6432FFE1;
        Tue, 28 Jun 2022 07:47:00 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id w24so12794551pjg.5;
        Tue, 28 Jun 2022 07:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RcJ0LvnXsRYCpaaWQCJPfDAyqL/8a86kBAToJ7vwdJU=;
        b=WQAlYrUhBD//WlreKty7MqmQg8VtvPzCPIotzVpSdo27Bvd4F/sWU6Mp1c/Vz71v8c
         wy4cBV2FBJjEk/soJ/56x041FP7KiUsR9CDJYPGAQpj7CtK++8rsq4P1P2gw1wpV6Vmb
         bhhC1BwlJos/dej4vNxEiPW8WpRl+Dm01KHRx/RNbzkcd/QE39v/U1KQZGWB46y6BzH6
         Bfp/7FbmbLLWhhAgXvZEiGM1RoxGVWVr/rVMm1oNaRcK8DinLgrrJRXphr7Z0zqMJF67
         KqXIHeSjT5yEojGDQ+PFLfqiuRfB9Zu9hM42LZmjQqSmqnFpmGW9Yys3ralF0QNrN5ry
         lLSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RcJ0LvnXsRYCpaaWQCJPfDAyqL/8a86kBAToJ7vwdJU=;
        b=18tUUAkCIyx4Ba1dJ93rLKmjEa6eYUrov3XUyOgb3tGC3vcoY68iSJpLwU5gjBHqPv
         6Y1kz8sOBO31aTFWe+xw3K7skinduG7NzWQeakJpvbFss8FB9tKY/iRyW5vjYN8trtrT
         sEfcHryllZCJqrMCC/peYrAb8pqtXeVQXd7VoAGVUaEATPqtcBVrbg3cBiNbu5msFOib
         qmtfARKV0vWr0D9DDppXly72SQqUjI++/UFgrMeMaO/U/+62rmCPvgmeE20KxH0t9j0p
         VOhdDWm+YrzvggvQP6ouN/Zj9cHPvbmhHnSClsQEsaYddEfwsQrZSlrRJ/wkN3yBuPM+
         IObQ==
X-Gm-Message-State: AJIora++U1JmAPhqdf8rk3f6zFqn0TDOI8MNX/J2aHDCMOQbzteLONkf
        5xSTg8K9K5Cgk3n0jBFMHj0=
X-Google-Smtp-Source: AGRyM1sPvQOJ0/OkTI/VuSSST+v3e7vJbLGipF63DNlCkewwutffIXDn1cfb8jo9EHcwl3AuMECgVw==
X-Received: by 2002:a17:90b:1986:b0:1ec:71f6:5fd9 with SMTP id mv6-20020a17090b198600b001ec71f65fd9mr27054263pjb.188.1656427619514;
        Tue, 28 Jun 2022 07:46:59 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:c569:fa46:5b43:1b1e? ([2600:8802:b00:4a48:c569:fa46:5b43:1b1e])
        by smtp.gmail.com with ESMTPSA id ms3-20020a17090b234300b001ead46e77e2sm9635024pjb.13.2022.06.28.07.46.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 07:46:59 -0700 (PDT)
Message-ID: <93f6d122-3b0e-5706-4c9e-b0cdc3479455@gmail.com>
Date:   Tue, 28 Jun 2022 07:46:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v2 3/4] net: dsa: microchip: add pause stats
 support
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
 <20220628085155.2591201-4-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220628085155.2591201-4-o.rempel@pengutronix.de>
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
> Add support for pause specific stats.
> 
> Tested on ksz9477.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
