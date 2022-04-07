Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467574F8570
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 19:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345957AbiDGRDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 13:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345969AbiDGRDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 13:03:01 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9741C886C;
        Thu,  7 Apr 2022 10:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:
        From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
        :List-Post:List-Owner:List-Archive;
        bh=o3qoOir9WAPGzi1sWnNPLakfeNGwPLGP2JcLR4qBR0w=; b=MuioKSfFuI7blzwCV/6wb+YekZ
        ZxFLRKdEmgFHBL5G5EjD8gQ7NqEpdI5RH75hyyi5Lx+Qpo/ZHjbVyA8sOLM81+Cf/jnhuNTEqrUMV
        AKRzPBibxD304idWTvyCsPVM59NiEmQMfnURAJfh2CAAQpBDkCnXgKqwp0Bbiz2WY6Zs=;
Received: from p200300daa70ef2000000000000000451.dip0.t-ipconnect.de ([2003:da:a70e:f200::451] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1ncVU3-0005oz-2F; Thu, 07 Apr 2022 18:59:47 +0200
Message-ID: <15c8aab5-41b7-4d25-4b4c-98536bc197fc@nbd.name>
Date:   Thu, 7 Apr 2022 18:59:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Networking <netdev@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20220405195755.10817-1-nbd@nbd.name>
 <20220405195755.10817-5-nbd@nbd.name>
 <d0bffa9a-0ea6-0f59-06b2-7eef3c746de1@linaro.org>
 <e3ea7381-87e3-99e1-2277-80835ec42f15@nbd.name>
 <CAK8P3a1A6QYajv_HTw79HjiJ8CN6YPeKXc_X3ZFD83pdOqVTkQ@mail.gmail.com>
 <08883cf4-27b9-30bf-bd27-9391b763417c@nbd.name>
 <750c1f9e-6a53-16d5-390e-f9f81fa23afd@linaro.org>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v2 04/14] dt-bindings: arm: mediatek: document WED binding
 for MT7622
In-Reply-To: <750c1f9e-6a53-16d5-390e-f9f81fa23afd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 06.04.22 10:57, Krzysztof Kozlowski wrote:
> Thanks for clarification. I still wonder about the missing drivers as I
> responded to your second bindings:
> https://lore.kernel.org/all/20220405195755.10817-1-nbd@nbd.name/T/#m6d108c644f0c05cd12c05e56abe2ef75760c6cef
> 
> Both of these compatibles - WED and PCIe - are not actually used. Now
> everything is done inside your Ethernet driver which pokes WED and
> PCIe-mirror address space via regmap/syscon.
> 
> Separate bindings might have sense if WED/PCIe mirror were ever
> converted to real drivers.I think in terms of hardware description it makes more sense to have 
separate nodes, even if the implementation uses them in one driver at 
the moment.

- Felix
