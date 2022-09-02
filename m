Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46DEA5AB840
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 20:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiIBSdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 14:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiIBSdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 14:33:37 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366FDA9C10;
        Fri,  2 Sep 2022 11:33:36 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id x5so2127658qtv.9;
        Fri, 02 Sep 2022 11:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=TEI0nxrVBWBFOQaEAjvZIRHd2jI+9SmL2JIPt5lbWq4=;
        b=X80nm1eviVwXyMpIzzgJbUrD6+9oNZTLdqZTFHEX8L0SVtdxs+VZTG1SGfUavPFOhp
         dn5zBCMfFbzBjykSnGcYOUVwbJJWzIhz6DI4BYzLd1bLxNsIzde2tlvvgZmuVdIiBKsA
         uIoFucEi3xoEMvaOIgUg30SwqAdVsWfGgbSe+6kqEfCUdcncsj31DXzEXtk6H9pRj31L
         XjdMG+nC40E7rrA1R9Hm8BpjvvuXSx24wBfYR+5gvcrJtNyBVgXie/QrnywSkE2rZY8w
         JA+bRD6PaFOgzSkI1guxdCkhz8JpA79c+zEdhWuYF16W2T0WxCvxSyAhqSPB8e+L74j0
         kkCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=TEI0nxrVBWBFOQaEAjvZIRHd2jI+9SmL2JIPt5lbWq4=;
        b=iNVGLM5tMzyhKMQ4EC+hyPR/CtAhUx1Ul6nnxTcPrD06a9O7SNizEim5TKU2oIX/4J
         fc2MPsmxD5MFeTFslvGpQKFMQKpkkvCtaFM0MNSNncaNQc/3QG7zt/f/CsRrodCM7KZx
         9rhC7akLCTCY8JIEkVJFmvWu5H2K9ntWXdn506Re3mGP0LdJnzga8rMrUgrPzhLxdpSh
         GwN5YJZTAdjDIwIQt72Lp37dFvjjoWw3Eu9FEDpPQwxmUw/++pFo/r/njnEofSLWEBjx
         ot+UErgeJKx6dznjLC7PBR26jXGLIXc9TapD0rCIs7VhhCbbrd1mrPUfhZii9F0HVL+W
         P1mQ==
X-Gm-Message-State: ACgBeo2ByvR4d7TjIPpBLHTGk7UyW7TuJKmA6E/pNgIl4D+QG0hVf/yn
        I0Op5XJDN2io2WFxtlLuQo0=
X-Google-Smtp-Source: AA6agR4vo1eWI5AoziEfKxzviQtr+1kGx4ZcHntJNdZdBYl7RW+9VSjHsfVD9Vr73ILfAsuZHKYZpA==
X-Received: by 2002:a05:622a:1ba9:b0:343:786c:3bb1 with SMTP id bp41-20020a05622a1ba900b00343786c3bb1mr28906084qtb.125.1662143615303;
        Fri, 02 Sep 2022 11:33:35 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id q29-20020a37f71d000000b006b615cd8c13sm1760638qkj.106.2022.09.02.11.33.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 11:33:34 -0700 (PDT)
Message-ID: <3da14763-b495-77eb-e059-b62e496ba7e7@gmail.com>
Date:   Fri, 2 Sep 2022 11:33:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net-next 0/9] DSA changes for multiple CPU ports (part 4)
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>
References: <20220830195932.683432-1-vladimir.oltean@nxp.com>
 <20220902103145.faccoawnaqh6cn3r@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220902103145.faccoawnaqh6cn3r@skbuf>
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



On 9/2/2022 3:31 AM, Vladimir Oltean wrote:
> On Tue, Aug 30, 2022 at 10:59:23PM +0300, Vladimir Oltean wrote:
>> This series represents the final part of that effort. We have:
>>
>> - the introduction of new UAPI in the form of IFLA_DSA_MASTER
> 
> Call for opinions: when I resend this, should I keep rtnl_link_ops,
> or should I do what Marek attempted to do, and make the existing iflink
> between a user port and its master writable from user space?
> https://lore.kernel.org/netdev/20190824024251.4542-4-marek.behun@nic.cz/
> 
> I'm not sure if we have that many more use cases for rtnl_link_ops..

It's a bit hard to see one right now, I agree.

> at some point I was thinking we could change the way in which dsa_loop
> probes, and allow dynamic creation of such interfaces using RTM_NEWLINK;
> but looking closer at that, it's a bit more complicated, since we'd need
> to attach dsa_loop user ports to a virtual switch, and probe all ports
> at the same time rather than one by one.

Yes, not sure the custom netlink operations would be the preferred way 
of doing that configuration, maybe module parameters and/or debugfs 
might just do?
-- 
Florian
