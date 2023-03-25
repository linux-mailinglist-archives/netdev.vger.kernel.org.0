Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C236C8D56
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 12:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbjCYLPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 07:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCYLPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 07:15:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADD81980;
        Sat, 25 Mar 2023 04:15:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 526E9B8069C;
        Sat, 25 Mar 2023 11:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3050C433EF;
        Sat, 25 Mar 2023 11:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679742936;
        bh=sSM/z8rp4uf+Mhk7rsk5vXq0jFtNdgxn4U9sLXMVH7U=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=O8fIjPWBFN9kUhR4+iQ/xX9TAW4a/ieFOj/eFJk58sgyOlkkQyztoW5HmA5Auyijg
         3AED1G8yLRI9gU253jl3QqzKT7woaWswU12PZDHg3mt+g802B01pQq0fXJe1gMXEwe
         Wih9KfldOYbhD1qoVCkWc1YNmEifa3GgrB1EU/TogacLCgJhBgJ2NO3NDZB2iEIW+F
         CofHV+RoYrraNwYMGvKBQJSPfGI2CrZwtUa3NLIsfRROcw8MKyXTRY9/eBKT5Q7kRZ
         LZzY4eC+AmkoqdekN2SQcX3Ab1MNoRmbZJfIvgxHKcVuxrCKQtnC6Mz2TNhMr3c+Cj
         uUNFyEpmF8PBg==
Message-ID: <e17e6abf-4b04-4968-d757-d5a7530357e2@kernel.org>
Date:   Sat, 25 Mar 2023 12:15:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 1/2] dt-bindings: net: dsa: b53: add BCM53134 support
Content-Language: en-US
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        paul.geurts@prodrive-technologies.com, f.fainelli@gmail.com,
        jonas.gorski@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230323121804.2249605-1-noltari@gmail.com>
 <20230323121804.2249605-2-noltari@gmail.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <20230323121804.2249605-2-noltari@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/03/2023 13:18, Álvaro Fernández Rojas wrote:
> BCM53134 are B53 switches connected by MDIO.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml | 1 +
>  1 file changed, 1 insertion(+)


Acked-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof

