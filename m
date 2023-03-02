Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 896436A7D2B
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 10:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjCBJAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 04:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjCBJAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 04:00:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF56515578;
        Thu,  2 Mar 2023 01:00:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63885B811F6;
        Thu,  2 Mar 2023 08:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C8EC433EF;
        Thu,  2 Mar 2023 08:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677747598;
        bh=7vsJJ2UWnbA5yPqyrOOw+/4k4if8YpbZ3L78wTns+mk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=djPhtteGfc7rhC+rbH7RwqdDKFvj9ACvNesN+NQ1tfpElhz51rQngnHKV8GTHU2Xw
         tGsvTNOew3QWPxpFPZgb6pNxq+wC/uuw+zKHBiO+JMJaK6n/sk/j8CWDA4w4a8oyD7
         r+xBiwYp+PeXemm7WAd7N/VgKHexP6IiUzuSurfRCEhyMKmvlFYVPqzabG9Ry/Ze75
         oqbdFD3l+nfgR8areP0z6FEKYfIEU32JzSWqHB9IHoRo64j4xNt241B67IEosR4LSL
         VMu4RWnVSlozgV0uNkWcwPvEGSPzi0r59KeVvytZJVOrtaTb8RvO7KPRckiiScuG/y
         bbIP1izBNyxXA==
Message-ID: <9a540967-c1a6-b9df-a662-b8a729d7d64b@kernel.org>
Date:   Thu, 2 Mar 2023 09:59:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 2/2] dt-bindings: net: adin: Document bindings for fast
 link down disable
Content-Language: en-US
To:     Ken Sloat <ken.s@variscite.com>
Cc:     noname.nuno@gmail.com, pabeni@redhat.com, edumazet@google.com,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230228144056.2246114-1-ken.s@variscite.com>
 <20230228184956.2309584-1-ken.s@variscite.com>
 <20230228184956.2309584-2-ken.s@variscite.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <20230228184956.2309584-2-ken.s@variscite.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/02/2023 19:49, Ken Sloat wrote:
> The ADI PHY contains a feature commonly known as "Fast Link Down" and
> called "Enhanced Link Detection" by ADI. This feature is enabled by
> default and provides earlier detection of link loss in certain
> situations.
> 

Please use scripts/get_maintainers.pl to get a list of necessary people
and lists to CC.  It might happen, that command when run on an older
kernel, gives you outdated entries.  Therefore please be sure you base
your patches on recent Linux kernel.

> Document the new optional flags "adi,disable-fast-down-1000base-t" and
> "adi,disable-fast-down-100base-tx" which disable the "Fast Link Down"
> feature in the ADI PHY.

You did not explain why do you need it.

> 
> Signed-off-by: Ken Sloat <ken.s@variscite.com>
> ---

Don't attach your new patchsets to your old threads. It buries them deep
and make usage of our tools difficult.


>  Documentation/devicetree/bindings/net/adi,adin.yaml | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
> index 64ec1ec71ccd..923baff26c3e 100644
> --- a/Documentation/devicetree/bindings/net/adi,adin.yaml
> +++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
> @@ -52,6 +52,18 @@ properties:
>      description: Enable 25MHz reference clock output on CLK25_REF pin.
>      type: boolean
>  
> +  adi,disable-fast-down-1000base-t:
> +    $ref: /schemas/types.yaml#definitions/flag
> +    description: |
> +      If set, disables any ADI fast link down ("Enhanced Link Detection")
> +      function bits for 1000base-t interfaces.

And why disabling it per board should be a property of DT?

Best regards,
Krzysztof

