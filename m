Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA3B6C701B
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 19:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbjCWSTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 14:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjCWSTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 14:19:22 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CA1272C;
        Thu, 23 Mar 2023 11:19:20 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id jl13so14674393qvb.10;
        Thu, 23 Mar 2023 11:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679595560;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WAfyigCWWJOJ34y4Q8kXJB1893qBEHYU+zfH+4O1SR4=;
        b=KBd11Cxo0MrhSMbuVLrogK+5iz5oMRz+fpvQyR9OSL01Dhu7YXPkBhJGQpCxWflSOd
         EnFkE2sOh6EwxbicfPRavC4qbVxQZvsCq5BrB/E5SbvZIvVMJEVopZLLjqb636IAvVpi
         xPofl8GhZvt0b39nMnCUNO0/dnR1FDFZVTJc+VYKRz6jjK8wDZVg0psDk/ClEoj4YU/P
         meWqR3/PeIs9TNJrC+N1vMCnqflkXn+qZVDixML8RIO6VUqXJhQdGe69SZwZ2d4ju8RL
         GmyKSbO8zvJQWzjxskDBYg6X2n4SuzLwdkNdjerWAeFjXqWcAVK/cAoOUV2EUE3RMhy3
         NMUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679595560;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WAfyigCWWJOJ34y4Q8kXJB1893qBEHYU+zfH+4O1SR4=;
        b=VhtzlbZJujzuetXUXS/1Ckz/heaguu+rhcBnSZUEiWhoDnhwTpxit51RcNGbOGcwYA
         orairNNIDB9fRP67vba3FXcB1J0UMO0kfXPr+LJIQJG4tnmYp5M7eVaZzTXZXusf7ljh
         9fXC2OOj23tgk7yUihSauIk7orEJtEW6P5+A3oY8ch7D/xV+iSIXu81RHKR5lJYhdbAJ
         UHQUG8HhgDlPiG5Q3oZ7stQ5Kamfl/6w8jMog0gD0Piqx7x0DkVuDn0cTnsd18CkQAVy
         knWBVOMTH3ENs+2YPw1Ge15U9AJivQfN/I4TH7ZFZq0f7+YB4pZkAH+EM1oZSLG/TmDu
         Rzgw==
X-Gm-Message-State: AO0yUKWCiJhv0PVaDaGrH4IOOr70Q/DrRli5U0gkjXK5Dr57DYvKv3L3
        drJE8LO24/7274uevUHdzPcIDIgZO08=
X-Google-Smtp-Source: AK7set/5hSzhbznLShCN9mH4QgUT5ezCAKCkmXOabRf13w9fGSB3polcvM2IgawbjrsJnM0h5ju2Cw==
X-Received: by 2002:a05:6214:29e1:b0:5ab:3328:d6e7 with SMTP id jv1-20020a05621429e100b005ab3328d6e7mr12390959qvb.10.1679595560090;
        Thu, 23 Mar 2023 11:19:20 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id mk5-20020a056214580500b005dd8b93459csm33527qvb.52.2023.03.23.11.19.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 11:19:19 -0700 (PDT)
Message-ID: <95eb709c-a91f-4390-30b2-9e81e4534e20@gmail.com>
Date:   Thu, 23 Mar 2023 11:19:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 0/1] net: dsa: b53: mmap: add dsa switch ops
Content-Language: en-US
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        jonas.gorski@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230323170238.210687-1-noltari@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230323170238.210687-1-noltari@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/23 10:02, Álvaro Fernández Rojas wrote:
> B53 MMAP switches have a MDIO Mux bus controller which should be used instead
> of the default phy_read/phy_write ops used in the rest of the B53 controllers.
> Therefore, in order to use the proper MDIO Mux bus controller we need to
> replicate the default B53 DSA switch ops removing the phy_read/phy_write
> entries.

Did you try to implement b53_mmap_ops::phy_read16/phy_write16 and have 
them return -EIO such that you do not fallback to the else path:

                   ret = b53_read16(priv, B53_PORT_MII_PAGE(addr),
                                    reg * 2, &value);

The reason for the hang I believe is because the B53_PORT_MII_PAGE is 
simply not mapped into the switch register space, and there is no logic 
within the switch block to return an error when you read at that invalid 
location.

Re-implementing dsa_switch_ops is usually done when you have a very 
different switch integration logic, ala bcm_sf2, here it seems a bit of 
a tall order for simply not using the phy_read16/phy_write16 functions.
-- 
Florian

