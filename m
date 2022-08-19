Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F11859944E
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 07:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244371AbiHSFHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 01:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243534AbiHSFHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 01:07:15 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0C0CACBB
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 22:07:14 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id a9so4704531lfm.12
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 22:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=dU9JMsBDfnBhuOlEnya/WM0aYwtDu+gir+pp3+mgeWE=;
        b=FLaY4lmBfgMALh5KgTeUfUK8jhYCElNGEWj9n+ocXA7/D+NFim0Pt+3pXHwgj8g9ck
         UHxeJRPTRl11jIHy1JSQuPsQCwQj44QVmdB7aWQP7MYgvgHmHwPOOXm9pgNrknVe4KB+
         5qM31wSupLEfMZgwuBCmopJ3zcYUxO/UrGcO1oyrvaRjqR4s9A4h1oh5yZjINhxiF0W1
         Te91koGdC2L3BRlZ9RDUqny8E5DxRvaj6A53JdhE4U4aVL51/3D07UWGwPUgWqJi81L1
         at5j20ovpSffFriUCD+TG5kSgNdqOeo32L0gn99q2MtnZWCb/hR1y3HAKsFVkbltI4iy
         /jTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=dU9JMsBDfnBhuOlEnya/WM0aYwtDu+gir+pp3+mgeWE=;
        b=cjOU81r6V3gHPE9DI4n612BDWnpUGk7K4esL0arjNO5OIgocoxHvjxb7NBm6VWgYjI
         /wzb1zTVDYPIsGRD9z+uIM5joElAa9Nc9x5trlDT6iD/XoRhVq5xa6/WgEHyb1ecyCgH
         H2ve2aeNu56RBS0beYnq9EAG7tWvwY+JCW7RdppN3y1dNtWcElsq6aQ2mk68e/M/Nu/N
         H2jMi9u82Mi74UHduaESdEFbe1G8aQxClbVz981o48KOMBe26ibwgDo1+joukt1AZPWH
         GBK2T1BKQO5ax/TEdsAsQnyvAeDrNtPHiYIWJtH7aPq64JELhjdznYSV19qMZXGaWjHl
         gCWw==
X-Gm-Message-State: ACgBeo3g4equVzWN+pGjlyRSqJ38VEHszMjOc0o9CeDIMR6tjOad72U1
        bPHl58NDJYaicsIytRMw4MY=
X-Google-Smtp-Source: AA6agR7xmgNlFO+6eaj502bodg5NgPxRen7KP1GDbvs+TQnuoZ/KmwP7fBoNVYflbWZusLHynPTF1w==
X-Received: by 2002:a05:6512:36ca:b0:48b:2896:bb8c with SMTP id e10-20020a05651236ca00b0048b2896bb8cmr2087584lfs.638.1660885632462;
        Thu, 18 Aug 2022 22:07:12 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id q24-20020a2e9158000000b00261bfd3a596sm11023ljg.132.2022.08.18.22.07.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Aug 2022 22:07:11 -0700 (PDT)
Message-ID: <7c066706-708a-7cdc-2aa2-695696b55da6@gmail.com>
Date:   Fri, 19 Aug 2022 07:07:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC net-next PATCH 0/3] net: dsa: mv88e6xxx: Add RMU support
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220818102924.287719-1-mattias.forsblad@gmail.com>
 <20220818115836.dinoyfw6ukucd6d2@skbuf>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <20220818115836.dinoyfw6ukucd6d2@skbuf>
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

On 2022-08-18 13:58, Vladimir Oltean wrote:
> On Thu, Aug 18, 2022 at 12:29:21PM +0200, Mattias Forsblad wrote:
>> The Marvell SOHO switches have the ability to receive and transmit
>> Remote Management Frames (Frame2Reg) to the CPU through the
>> switch attached network interface.
>> These frames is handled by the Remote Management Unit (RMU) in
>> the switch.
>> These frames can contain different payloads:
>> single switch register read and writes, daisy chained switch
>> register read and writes, RMON/MIB dump/dump clear and ATU dump.
>> The dump functions are very costly over MDIO but it's
>> only a couple of network packets via the RMU. Handling these
>> operations via RMU instead of MDIO also relieves access
>> contention on the MDIO bus.
>>
>> This request for comment series implements RMU layer 2 and
>> layer 3 handling and also collecting RMON counters
>> through the RMU.
>>
>> Next step could be to implement single read and writes but we've
>> found that the gain to transfer this to RMU is neglible.
>>
>> Regards,
>> Mattias Forsblad
> 
> Have you seen how things work with qca8k_connect_tag_protocol()/
> qca8k_master_change()/qca8k_read_eth()/qca8k_write_eth()/
> qca8k_phy_eth_command()?

No, I have not. I'll take a look at those. Thanks.
