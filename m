Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5445B8BA6
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbiINPTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiINPTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:19:53 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68EE61056E;
        Wed, 14 Sep 2022 08:19:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663168748; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=d18h0VCuUcQlrCNVzd8EEARixB3LaiEII5NJ/cAhdM+pS/xi7tIBSgiQy3ka5+ZSrVuT4UyAe/KNYmZjtCurviNkdscz28ErI9nIFS1dr/FB1R3XMNkdVh++Ieu/ny1Osr06f01k4/FbH+EeNTBJB8u5xHLmj13skdfm1vUxM2I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663168748; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=wloC/J0F6yZhG8fSrhhIFOYeY4PZYcuw8/qw0WLhmts=; 
        b=Kc35hLPDHHRFNBPdLXsB7ca2ooQ2Qh4pt8u+B4zDSzcdOFr2dO98x1/5wnc/95ocK86DfkAWYueARithEsUoJw8419JkhhCX9bQxYfLk36pGSZDkvMOAsdRZCvWV0U2f63wA7zsEE7dzvCoT2tS/EVy+MCqMnKwxabPm3g6Tuus=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663168748;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=wloC/J0F6yZhG8fSrhhIFOYeY4PZYcuw8/qw0WLhmts=;
        b=HYRqQgZnOA5dUMeMQZnjRkWq2q5fiZVvdxsATLGvgufw/k6xNHAFIdJOJyDF3HvH
        sMLAyZz5GVqPkarxZt/Kxxx3lH1axtLnS5Xo3Yi6tN0WmasIP1k7FsR6aW5C9AWvtzB
        SPqc6KtvrFFWWLMhVRRmgRphHUwJ60k8lxnGDHvI=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1663168746065958.7172933428667; Wed, 14 Sep 2022 08:19:06 -0700 (PDT)
Message-ID: <44045164-692d-c8f5-3216-b043fb821634@arinc9.com>
Date:   Wed, 14 Sep 2022 18:18:58 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 04/10] dt-bindings: memory: mt7621: add syscon as
 compatible string
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
References: <20220914085451.11723-1-arinc.unal@arinc9.com>
 <20220914085451.11723-5-arinc.unal@arinc9.com>
 <20220914151414.GA2233841-robh@kernel.org>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20220914151414.GA2233841-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14.09.2022 18:14, Rob Herring wrote:
> On Wed, Sep 14, 2022 at 11:54:45AM +0300, Arınç ÜNAL wrote:
>> Add syscon as a constant string on the compatible property as it's required
>> for the SoC to work. Update the example accordingly.
> 
> It's not required. It's required to automagically create a regmap. That
> can be done yourself as well. The downside to adding 'syscon' is it
> requires a DT update. Maybe that's fine for this platform? I don't know.

My GB-PC2 won't boot without syscon on mt7621.dtsi. This string was 
always there on the memory controller node on mt7621.dtsi.

Arınç
