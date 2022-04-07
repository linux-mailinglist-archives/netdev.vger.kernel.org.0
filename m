Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237154F84A1
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 18:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345625AbiDGQNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 12:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345616AbiDGQN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 12:13:29 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5009B12082;
        Thu,  7 Apr 2022 09:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8ilOzeEpMGnqmcxm5ACkIhP+cfoDdajkjlKSouIG/qg=; b=h3DD6AtKVrCXay15nFo1Hm2b9S
        1LO7hycjezhdpT3vtU9MCsyOM/K4Z1SVW+wZIuBsTllbvCmGDd9V6xrjTeHsdxOC4rFm/UQTA5p8t
        5QqDxhQWdzdeuGi5oxFQS+BwmvIHf/X11kMCr30FIazWpeX45qK+nZozHAvhmPNkJrJ4=;
Received: from p200300daa70ef20069621b7d3c575442.dip0.t-ipconnect.de ([2003:da:a70e:f200:6962:1b7d:3c57:5442] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1ncUip-0003Lb-Od; Thu, 07 Apr 2022 18:11:00 +0200
Message-ID: <7ee0b60b-a931-357e-7d88-ee2fd04f6902@nbd.name>
Date:   Thu, 7 Apr 2022 18:10:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v2 04/14] dt-bindings: arm: mediatek: document WED binding
 for MT7622
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220405195755.10817-1-nbd@nbd.name>
 <20220405195755.10817-5-nbd@nbd.name>
 <d0bffa9a-0ea6-0f59-06b2-7eef3c746de1@linaro.org>
 <e3ea7381-87e3-99e1-2277-80835ec42f15@nbd.name> <Yk8IXno6sjkHVf4g@lunn.ch>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <Yk8IXno6sjkHVf4g@lunn.ch>
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

On 07.04.22 17:50, Andrew Lunn wrote:
>> > Isn't this a network offload engine? If yes, then probably it should be
>> > in "net/".
>> It's not a network offload engine by itself. It's a SoC component that
>> connects to the offload engine and controls a MTK PCIe WLAN device,
>> intercepting interrupts and DMA rings in order to be able to inject packets
>> coming in from the offload engine.
> 
> Hi Felix
> 
> Maybe turn the question around. Can it be used for something other
> than networking? If not, then somewhere under net seems reasonable.
I'm fine with moving this to net.

- Felix
