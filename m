Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E9C5BE424
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 13:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbiITLKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 07:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbiITLKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 07:10:16 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB7D6EF17
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 04:10:06 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id j24so2042640lja.4
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 04:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=mlr4HYAIjqLdIMpfmyesikSY6ASvfl2g+jaK7ls73IY=;
        b=HNezxQO49cnnr7ZFqbPjF98zl6YV5U2yPavhU+1HvlJ0pdBBptpKivDJ70U0RSMtP9
         CDJZnBHc3U+XLopqI0phBHXVAorLzy5qrzJyMUHfDDsvdgh/PtW/3e4EpP+jG3XaqIPx
         uBwfJaX4zqQCbLjxEmb8IcX2e1M6ZEikInyT4YW7HMSRduSmhv4n8VpYfxNQpJg8KbxB
         qC3hz/rX+0lRKVkjpTTF5PfZjnfU0CDbmOCQXBFlOrf+nWDgUxLCwTQ4EuTu+aSwUYiM
         Qbr/L6SNoz12LL1bsVCt/yzJ0ytiuX2Jy+gzNhNbPCbn85YGt5CGxvNRzAohjWob4T+1
         LTMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=mlr4HYAIjqLdIMpfmyesikSY6ASvfl2g+jaK7ls73IY=;
        b=Q4QDWKRpc/LZV7dCgstFbVAnpPwBADNWIEt0m/oLxtjXq0rlSCH/vm6qO652j3i2vk
         I6z8eRccKDMSOSziXAdJ/RnGuHYDHDdrzotIg+oidAuqNi+8F6spO335ZsiULLfv/cE4
         f0o/CqAmnM3ieRNXV8mVKSnHCkOxEdIoqhANQBAFBemH46ZV32eGokwDzgMq2zTvoU9O
         h9DnscyNRXtd1flr4JEFpey+yhyzRQuv+q+SVwiKRa/AOqpFAHsbrcu03dWt/0xXQ8gZ
         od7J1uaKXXV/QtGmvWSMvgkqSueLrpEF/qbi65GHTYGMg9Yffe/gJ/tKwc6kugVzhZ53
         o03w==
X-Gm-Message-State: ACrzQf3ejNZ4g/QYBWbe8lDhV8Lu2rB2K8rwVixo8+tstbu5UPUoHawf
        3JzWof/xglvHbSJEmGrw+1s=
X-Google-Smtp-Source: AMsMyM6ltXoL4DL1zqjcywzt+BhKE0N4+VufJbjQ6TvZI+4eL5pWxVi5QHVNbCtY3hKiKFeAtZ8TUg==
X-Received: by 2002:a05:651c:505:b0:26c:5815:5519 with SMTP id o5-20020a05651c050500b0026c58155519mr1496862ljp.316.1663672204444;
        Tue, 20 Sep 2022 04:10:04 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id k12-20020a2e888c000000b0026c18aa8587sm214849lji.75.2022.09.20.04.10.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 04:10:03 -0700 (PDT)
Message-ID: <c2937753-539c-527d-b548-d1e640e279bf@gmail.com>
Date:   Tue, 20 Sep 2022 13:10:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v14 3/7] net: dsa: Introduce dsa tagger data
 operation.
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com
References: <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-4-mattias.forsblad@gmail.com>
 <20220919110847.744712-4-mattias.forsblad@gmail.com>
 <20220919220056.dactchsdzhcb5sev@skbuf>
 <3f29e40e-1a3b-8580-3fbd-6fba8fc02f1f@gmail.com>
 <20220920103115.xoddfehdhmztr6cq@skbuf>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <20220920103115.xoddfehdhmztr6cq@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-20 12:31, Vladimir Oltean wrote:
> On Tue, Sep 20, 2022 at 08:41:30AM +0200, Mattias Forsblad wrote:
>>> Can you please also parse the sequence number here, so the
>>> decode_frame2reg() data consumer doesn't have to concern itself with the
>>> dsa_header at all?
>>
>> The sequence number is in the chip structure which isn't available here.
>> Should we really access that here in the dsa layer?
> 
> I'm talking about this sequence number:
> 
> mv88e6xxx_decode_frame2reg_handler:
> 
> 	/* Decode Frame2Reg DSA portion */
> 	dsa_header = skb->data - 2;
> 
> 	seqno = dsa_header[3];
> 
> I'm saying, if you get the seqno in net/dsa/tag_dsa.c and pass it as
> argument to mv88e6xxx_decode_frame2reg_handler(), then you should no
> longer have a reason to look at the dsa_header from drivers/net/dsa/mv88e6xxx/.

Ok, I misunderstood your intent. I'll change. Thanks.

/Mattias

