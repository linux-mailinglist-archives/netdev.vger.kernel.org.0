Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F35C60FD14
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 18:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234879AbiJ0Qao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 12:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234377AbiJ0Qan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 12:30:43 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D025F12D
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 09:30:41 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id bj12so6120801ejb.13
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 09:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GsC2tH5FCWQwUdSW7q7v2Ia+8daeT+SmW6K0U7QxsOI=;
        b=LcvLf/4whQLduA9IPP5YPNz8gfL9OwFDaOK7Waj5nQ21tuhl9l7+128uOcyJJiy9GS
         7lZv7CrAe/VmZs2bLHdgh8dqGB1INbJ18lSCtIudig0U3gxOwKoR7DLO/1dw99nuq8c4
         ie8+xZi+8pqPKIfXrV3nMARud2RBlXiFC13Oqf2pLRKxbHGbLQkIF/l3Lm6EvCGyoSxi
         KuHzqSmuS0dNOKr+bCBjeL9x4sUJC+Is5H1a2i7J5GsYu08PCovLyDdMJS8a1JMYU3J0
         jD/uahxTnvvvAaf1i5wMCVP1eO7f0hYrP7UFFgCbpAhYlYjDPR6XZPI+xw9C0BZrFEUF
         R08w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GsC2tH5FCWQwUdSW7q7v2Ia+8daeT+SmW6K0U7QxsOI=;
        b=mLq2KXRd1q/k8FfvASFYjWS3sdfQ1eye04EzzrZIZ4ROMcNVV2P3SrsAB4FtAl6ep+
         CdCYh+Q/kvwjy1gjUa8bfiS1G/4jeSYwmQxUZf6VwYltJQBCXFMIeALUOVot3UNrtjTo
         q4d/+K/aNcbc5pzRQHH7G21cx+qD+jCCZF/Ah2DLvyFx9e4X1PIe7ri6ozeGfGZYFe9t
         UWEvKNxedurUzDUjhQVhApBbjcGV6UujAMX0m0Pcgxx6bcmZewzCU4aoPX/zaIzk3koo
         ftkM53Ij3ok5aVz5f4w2zlMUgjwgKRjzS2Vtxl8YGw/9PutQoPafLEVbhaaZvQHMbqpv
         A+cQ==
X-Gm-Message-State: ACrzQf15LsVq+s6+N+rfYHf1YrUETkXKJ7o4vXoqIXLFNU+qNfCwgW6m
        4Di8HY16MnXgpnf2N5K7WlUV0BgJcuc=
X-Google-Smtp-Source: AMsMyM571HFVL6cybX3qAczdpd3SSf8HkDdmUfdm3TCo+Ojx9Y49nqyAvemPi0Z21WBN67EObXXH7A==
X-Received: by 2002:a05:6512:3402:b0:49f:e6a:3cc8 with SMTP id i2-20020a056512340200b0049f0e6a3cc8mr20924648lfr.457.1666888229234;
        Thu, 27 Oct 2022 09:30:29 -0700 (PDT)
Received: from [192.168.26.149] (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id r4-20020ac25f84000000b004a1e7216131sm238493lfe.116.2022.10.27.09.30.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 09:30:28 -0700 (PDT)
Message-ID: <cf8c3805-4688-bacc-bdc5-76ea990e7928@gmail.com>
Date:   Thu, 27 Oct 2022 18:30:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [PATCH] net: broadcom: bcm4908_enet: update TX stats after actual
 transmission
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20221027112430.8696-1-zajec5@gmail.com>
 <087ad3a4-2be4-64ad-b5df-d0e31899ed1d@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
In-Reply-To: <087ad3a4-2be4-64ad-b5df-d0e31899ed1d@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.10.2022 18:12, Florian Fainelli wrote:
> On 10/27/2022 4:24 AM, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>>
>> Queueing packets doesn't guarantee their transmission. Update TX stats
>> after hardware confirms consuming submitted data.
>>
>> This also fixes a possible race and NULL dereference.
>> bcm4908_enet_start_xmit() could try to access skb after freeing it in
>> the bcm4908_enet_poll_tx().
>>
>> Reported-by: Florian Fainelli <f.fainelli@gmail.com>
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> To me this is 'net' material since it fixes a potential issue, but let's see what the netdev maintainers prefer.

Thanks. In that case it may be also worth adding:

Fixes: 4feffeadbcb2e ("net: broadcom: bcm4908enet: add BCM4908 controller driver")
