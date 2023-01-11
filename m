Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99B5A666664
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 23:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbjAKWsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 17:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbjAKWsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 17:48:16 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCF85F5F;
        Wed, 11 Jan 2023 14:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YOedTnXL6ljnrOqWRbkroyShXD3I/zAhcql2fABRit0=; b=qQ6hZzJHaOAbhqofs216Z6uKDd
        UL9sqOkqY0yHjRnd34Dyqly+7mpKxJlI9X13hwjlbIteSnYoUUt2Z3q6x1q9aCEmAGbkwHDe00AA9
        0cCQM8zF9pamulhb1fBrF9j511ZdaKPtAK+xhbeqbZ3c4FkaNa5q0tE/31sOF2Nvtm/4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pFjt3-001odJ-GO; Wed, 11 Jan 2023 23:48:01 +0100
Date:   Wed, 11 Jan 2023 23:48:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Rob Herring <robh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Xu Liang <lxu@maxlinear.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/4] dt-bindings: net: phy: add MaxLinear
 GPY2xx bindings
Message-ID: <Y788oSXbsqmAMVxw@lunn.ch>
References: <20230109123013.3094144-1-michael@walle.cc>
 <20230109123013.3094144-3-michael@walle.cc>
 <20230111202639.GA1236027-robh@kernel.org>
 <73f8aad30e0d5c3badbd62030e545ef6@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73f8aad30e0d5c3badbd62030e545ef6@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I know, I noticed this the first time I tested the schema. But then
> I've looked at all the other PHY binding and not one has a compatible.
> 
> I presume if there is a compatible, the devicetrees also need a
> compatible. So basically, "required: compatible" in the schema, right?
> But that is where the PHY maintainers don't agree.

It should not be required. The compatible is optional. The kernel is
happy without it. You can add a compatible to make the DT linter
happy, but you are only adding it to make the linter work. Hence it
needs to be optional. All real DT blobs are unlikely to have a
compatible, given that this PHY is known not to be broken in terms of
enumeration via its ID registers.

    Andrew

