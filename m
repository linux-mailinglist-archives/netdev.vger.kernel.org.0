Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112B85BB41B
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 23:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiIPVsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 17:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiIPVso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 17:48:44 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF984BB684;
        Fri, 16 Sep 2022 14:48:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663364891; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=JLDt2/kFU7PEotggDN6j70oCTJcAHSNiwJtnJ1rZreVe/BBDf5r+1CV56T1eNKPU5d9NAH6+M7hl/yI+IMt3H1vlDspeZkffUpMV85tUqjpahNVK75vSlnPJPhdHEsr/CictAMNkcmgUyss2Wxodr1WwPbHNBfSjyIw2fJ3jpyw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663364891; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=4GuRfMhQm5Rn+M8LeHVMrehMbznHw6jGuLiFJ01zG90=; 
        b=dJakwSFQqzlM+viBJlYBIek0BmV9zBFURPWIoqrwq+zimAd/A4aJEQT+rrF31JZbRq3PAcQZu7TCHX7n155j3507EvDOw5lk1OaXxdAr9n348QoblStf5kS73xGOn6w4Eo8IfZ++piDDlUH7WbtmBonWuU9aRDFX6HQn7OtmlOU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663364891;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=4GuRfMhQm5Rn+M8LeHVMrehMbznHw6jGuLiFJ01zG90=;
        b=LQoYNqy7ViPr/6u6w5K5bvlvGOtK8xyG6VcNvYCqeoLe11wbFdwuCn2ZqvlHTCpn
        hRzyOKvjoj1NnsK3vwvEdPem9Z+rJvDJy86QqmUuNVswWyAZXsHxmLAwA/1D0eVChvp
        kqXB4x6YxoKx1529sEx75tRjnZJoa6M1lQO7xa6g=
Received: from [10.10.10.122] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1663364890239371.4567564648436; Fri, 16 Sep 2022 14:48:10 -0700 (PDT)
Message-ID: <bc066578-e229-7f08-d6c0-5dc2fede6be7@arinc9.com>
Date:   Sat, 17 Sep 2022 00:48:00 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 net-next 04/10] dt-bindings: memory: mt7621: add syscon
 as compatible string
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
References: <20220915065542.13150-1-arinc.unal@arinc9.com>
 <20220915065542.13150-5-arinc.unal@arinc9.com>
 <20220916194127.GA1139257-robh@kernel.org>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20220916194127.GA1139257-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.09.2022 22:41, Rob Herring wrote:
> On Thu, Sep 15, 2022 at 09:55:36AM +0300, Arınç ÜNAL wrote:
>> Add syscon as a constant string on the compatible property as it's required
>> for the SoC to work. Update the example accordingly.
> 
> I read this and start to give you the same reply as v1. Then I remember
> saying this already...
> 
> Update the commit message such that it answers my question and I don't
> think you just ignored me and have to go find v1. The fact that this
> change makes the binding match what is already in use in dts files is an
> important detail.

Sure Rob, will do.

Arınç
