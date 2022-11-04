Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A681361A234
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 21:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbiKDUhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 16:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKDUhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 16:37:32 -0400
X-Greylist: delayed 3281 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 04 Nov 2022 13:37:30 PDT
Received: from mx03lb.world4you.com (mx03lb.world4you.com [81.19.149.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682FE45A19;
        Fri,  4 Nov 2022 13:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=P5uGlo43cj8nsSwAyRcZaNwzn4e2re4qXj0MTElEhVI=; b=bfoWpaXhROdINQC/V6vctnqkjS
        keuejXK5VmvXQWHMX8DiCWjc5HQkoOw/DAUXgOHyc1rwlPnuEnuSX4+z63MYMx7VQtqRRbqVrPruD
        70bgcY4HW+R+HfmUWtWY+mY6q8w/cL2G7UnW9oqRScVnpacjSsdB42Q40Gz4byGcbj/Y=;
Received: from [88.117.56.108] (helo=[10.0.0.160])
        by mx03lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1or2aI-0005aX-V8; Fri, 04 Nov 2022 20:42:35 +0100
Message-ID: <3f531da8-8735-4dfb-5a2d-09e3fa30ade3@engleder-embedded.com>
Date:   Fri, 4 Nov 2022 20:42:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next] dt-bindings: net: tsnep: Fix typo on generic
 nvmem property
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org
References: <20221104162147.1288230-1-miquel.raynal@bootlin.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <20221104162147.1288230-1-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> While working on the nvmem description I figured out this file had the
> "nvmem-cell-names" property name misspelled. Fix the typo, as
> "nvmem-cells-names" has never existed.
> 
> Fixes: 603094b2cdb7 ("dt-bindings: net: Add tsnep Ethernet controller")
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>   Documentation/devicetree/bindings/net/engleder,tsnep.yaml | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/engleder,tsnep.yaml b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
> index 5bd964a46a9d..a6921e805e37 100644
> --- a/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
> +++ b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
> @@ -47,7 +47,7 @@ properties:
>   
>     nvmem-cells: true
>   
> -  nvmem-cells-names: true
> +  nvmem-cell-names: true
>   
>     phy-connection-type:
>       enum:

Thanks for fixing my typo!

Reviewed-by: Gerhard Engleder <gerhard@engleder-embedded.com>
