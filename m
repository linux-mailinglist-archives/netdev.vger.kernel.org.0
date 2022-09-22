Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E535E620E
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 14:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbiIVMN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 08:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiIVMNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 08:13:55 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40EE52E75;
        Thu, 22 Sep 2022 05:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=aTzVrJjI9ejwxcCxS5DZxSJ5B/KvAH9Rb1NyhHF4XHw=; b=Qo1OQZ+qaf5FIk7J9JlqKwMbdD
        kIhHM6T+9AZS4bt691O5YIZmH73WgmvPKnK9UWC5qmpqXsfyaG3ORCx0ylETx/YG1D5qltrd1cbvM
        UKeZ3I9Kd5qFBZleBrxV7iEusMoWrnFxBnx7u1ChBCzG4R1221GG9qwW25XjfXflTlOs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1obL5E-00HWsr-7a; Thu, 22 Sep 2022 14:13:36 +0200
Date:   Thu, 22 Sep 2022 14:13:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        kishon@ti.com, vkoul@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        richardcochran@gmail.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, geert+renesas@glider.be,
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 4/8] dt-bindings: net: renesas: Document Renesas
 Ethernet Switch
Message-ID: <YyxRcMdJ/AG0QtGB@lunn.ch>
References: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
 <20220921084745.3355107-5-yoshihiro.shimoda.uh@renesas.com>
 <1aebd827-3ff4-8d13-ca85-acf4d3a82592@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1aebd827-3ff4-8d13-ca85-acf4d3a82592@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 09:37:28AM +0200, Krzysztof Kozlowski wrote:
> On 21/09/2022 10:47, Yoshihiro Shimoda wrote:
> > Document Renesas Etherent Switch for R-Car S4-8 (r8a779f0).
> > 
> > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > ---
> >  .../bindings/net/renesas,etherswitch.yaml     | 286 ++++++++++++++++++
> >  1 file changed, 286 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/renesas,etherswitch.yaml
> > 
> > diff --git a/Documentation/devicetree/bindings/net/renesas,etherswitch.yaml b/Documentation/devicetree/bindings/net/renesas,etherswitch.yaml
> > new file mode 100644
> > index 000000000000..988d14f5c54e
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/renesas,etherswitch.yaml
> 
> Isn't dsa directory for this?

This is not a DSA driver, but a pure switchdev driver. It is similar
to prestera, lan966x, sparx5, which put there binding in net.

   Andrew

   
