Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 623555ECC6F
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 20:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbiI0SxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 14:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiI0SxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 14:53:03 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FF01D1A5B;
        Tue, 27 Sep 2022 11:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PCjpbUZ+QNg2igyzFeDQgvZAR1MUdCMp61q0QjLtfQg=; b=nzX7un22W+2I2cYWxzR2Q8hKUh
        EuM3Yfvz39SLw7oosYorc+3gbY//PIu2H0BE7e/2RvE02AA0MsFYi89oVvNpSQ0sFiIT60hRr+whc
        1rtT+ChPDB1WG8wIM6pk0qcu7OfXss3OlB3WAHo+smhzoeMVljEndhl9q93LbV7W9evY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1odFhG-000R5P-SC; Tue, 27 Sep 2022 20:52:46 +0200
Date:   Tue, 27 Sep 2022 20:52:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next][PATCH v2] dt-bindings: dsa: lan9303: Add lan9303 yaml
Message-ID: <YzNGfk+tFApcszS7@lunn.ch>
References: <20220927175145.32265-1-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927175145.32265-1-jerry.ray@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +                compatible = "smsc,lan9303-mdio";
> +                dsa,member = <0 0>;
> +                reg = <0>;
> +                ethernet-ports {
> +                    #address-cells = <1>;
> +                    #size-cells = <0>;
> +                        port@0 {
> +                            reg = <0>;
> +                            phy-mode = "rmii";
> +                            ethernet = <&ethernet>;
> +                            label = "cpu";

The cpu label is never used, and i think Vladimir has been removing
them from bindings and DT blobs. So your example probably should not
have it.

     Andrew
