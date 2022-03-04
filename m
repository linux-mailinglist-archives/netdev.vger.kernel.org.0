Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7194CCCD9
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 06:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237988AbiCDFOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 00:14:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiCDFOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 00:14:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65B812AE2;
        Thu,  3 Mar 2022 21:13:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19D1C61B5F;
        Fri,  4 Mar 2022 05:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1B5C340E9;
        Fri,  4 Mar 2022 05:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646370795;
        bh=2bhvpvpoLPvxmKnAKxFj4gIe5IH9iLL1LzWAgEeBE7o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eYDFilSdHcoNTBWO0w35CE3rDMUpyT2OLsbTh+s8eS55M/e45lsZ3MBggxciQ8Ooc
         UBMHyOg7+cVsVXLm6QeU3xS9P74I8mQeEyv5Uwjo2FQmbyb9bwFi+BnEdnM5Bl0I+q
         ChJTKLxEZO66YIWiR0HHzfkz0kt8VTrjxjn9VsTxit4gp5/16CX/cZBeR3WDrtRxbL
         wFXSxXRJiOwZtE9ZvnmwM8fwULMGuzWhpYDlx5rqz7gJv6NdxSvRbPz4rul4/bj03E
         EaGGfKATUfFh1XWAb5r6PHKrRIEE3rL9Eo2Kq/jhK+JNLSfKrN4ykTjy6+YCRgC1s8
         3HLaYq6BsZa6Q==
Date:   Thu, 3 Mar 2022 21:13:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        devicetree@vger.kernel.org, robh+dt@kernel.org
Subject: Re: [PATCH net-next v5 1/3] dt-bindings: net: dsa: add rtl8_4 and
 rtl8_4t tag formats
Message-ID: <20220303211313.2c5ee295@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220303015235.18907-2-luizluca@gmail.com>
References: <20220303015235.18907-1-luizluca@gmail.com>
        <20220303015235.18907-2-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Mar 2022 22:52:33 -0300 Luiz Angelo Daros de Luca wrote:
> Realtek rtl8365mb DSA driver can use these two tag formats.
> 
> Cc: devicetree@vger.kernel.org

I think you have to CC robh+dt@kernel.org specifically, no?
Otherwise it may not get to Rob's checker.

> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/dsa-port.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> index 702df848a71d..e60867c7c571 100644
> --- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> @@ -51,6 +51,8 @@ properties:
>        - edsa
>        - ocelot
>        - ocelot-8021q
> +      - rtl8_4
> +      - rtl8_4t
>        - seville
>  
>    phy-handle: true

