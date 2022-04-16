Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C2750347A
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 08:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiDPGgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 02:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiDPGgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 02:36:22 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4E9FCBDF;
        Fri, 15 Apr 2022 23:33:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1650090811; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=PRTj/8X5oT9ghucpa9TjEtg1cHLA5CGkoLFMilBXYpLb8aes+SKJKQMIvfiqk4a5RM2AEMlMgqQ8tRwVn/tlYgRoqsfhmjU9UvVjR042lYGR27Rf84F6VLDe1LwgQZzjDjbBLcsqmU4QgepmdnOynPRACNOSbIEe+KOwUQm7HF4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1650090811; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=5eFjRektgYNgCLk42++Y+sC5sKU1miyrndgi5UTjNys=; 
        b=ghDFT4u6cSiMID29YiOIK9qypI8UgPrJ7tOBeGjzbTJVfz4TYhEIrQZepA8zT0FowvNkmi9xX/suEkz1O6GeCRBl6LZ1/E6LzAz9fyeo+QYnkeQd4UlYUyFtNCXCshAxw0nMg13uA5UjlUJQmuvnwrLfStPBXMdOZQBMnKW4b58=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1650090811;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=5eFjRektgYNgCLk42++Y+sC5sKU1miyrndgi5UTjNys=;
        b=NmyvQpyIPVKnZUsT2Urqf8dAeGi6xQwW5eGG6Ht3cY/NU5aeKV0a/wcnOYgb7SLM
        xgwj9JQNNgurzqDyNxVVA+U8XXlOKxNRwyyodEM6Qu2gT4bKOqIN/Auh6c0hIxplUW/
        64Cu4GW3uEOzwVWQyNT92/x6aIO2LhrcJ5FuIcio=
Received: from [10.10.10.3] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1650090809904755.2901823257303; Fri, 15 Apr 2022 23:33:29 -0700 (PDT)
Message-ID: <d2287e43-9794-c46a-e924-6f5b50e21c16@arinc9.com>
Date:   Sat, 16 Apr 2022 09:33:20 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net 1/2] dt-bindings: net: dsa: realtek: cleanup
 compatible strings
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org, devicetree@vger.kernel.org
References: <20220416062504.19005-1-luizluca@gmail.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20220416062504.19005-1-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/04/2022 09:25, Luiz Angelo Daros de Luca wrote:
> Compatible strings are used to help the driver find the chip ID/version
> register for each chip family. After that, the driver can setup the
> switch accordingly. Keep only the first supported model for each family
> as a compatible string and reference other chip models in the
> description.
> 
> CC: devicetree@vger.kernel.org
> Link: https://lore.kernel.org/netdev/20220414014055.m4wbmr7tdz6hsa3m@bang-olufsen.dk/
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---
>   .../devicetree/bindings/net/dsa/realtek.yaml  | 33 +++++++------------
>   1 file changed, 12 insertions(+), 21 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/realtek.yaml b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
> index 8756060895a8..9bf862abb496 100644
> --- a/Documentation/devicetree/bindings/net/dsa/realtek.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
> @@ -27,32 +27,23 @@ description:
>     The realtek-mdio driver is an MDIO driver and it must be inserted inside
>     an MDIO node.
>   
> +  The compatibility string is used only to find an identification register,
> +  (chip ID and version) which is at a different MDIO base address in different
> +  switch families. The driver then uses the chip ID/version to device how to
> +  drive the switch.

I think you meant to say "decide how to drive the switch"?

> +
>   properties:
>     compatible:
>       enum:
>         - realtek,rtl8365mb
> -      - realtek,rtl8366
>         - realtek,rtl8366rb
> -      - realtek,rtl8366s
> -      - realtek,rtl8367
> -      - realtek,rtl8367b
> -      - realtek,rtl8367rb
> -      - realtek,rtl8367s
> -      - realtek,rtl8368s
> -      - realtek,rtl8369
> -      - realtek,rtl8370
>       description: |
> -      realtek,rtl8365mb: 4+1 ports
> -      realtek,rtl8366: 5+1 ports
> -      realtek,rtl8366rb: 5+1 ports
> -      realtek,rtl8366s: 5+1 ports
> -      realtek,rtl8367:
> -      realtek,rtl8367b:
> -      realtek,rtl8367rb: 5+2 ports
> -      realtek,rtl8367s: 5+2 ports
> -      realtek,rtl8368s: 8 ports
> -      realtek,rtl8369: 8+1 ports
> -      realtek,rtl8370: 8+2 ports
> +      realtek,rtl8365mb:
> +        Use with models RTL8363NB, RTL8363NB-VB, RTL8363SC, RTL8363SC-VB,
> +        RTL8364NB, RTL8364NB-VB, RTL8365MB, RTL8366SC, RTL8367RB-VB, RTL8367S,
> +        RTL8367SB, RTL8370MB, RTL8310SR
> +      realtek,rtl8367rb:
> +        Use with models RTL8366RB, RTL8366S

You kept rtl8366rb string but defined description for rtl8367rb.

Arınç
