Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C595C51C201
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 16:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380445AbiEEOPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 10:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377567AbiEEOP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 10:15:29 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACA7580E6;
        Thu,  5 May 2022 07:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=E4jsY0uAPE+nMpUAcq/anRC7ZLLjgF7r9Wt9SH2W6Kc=; b=iDdeA7mkqnPRQQVropF3wQJL+9
        xeru26CIl+pG4mE0r5Z7fWhw/pEUF6P+Ej7QHkDQx58x4gRG3t2Ygh8eipwf+9jkflXPlWKnHa9rr
        yki6b4vbe8f/MNVzcP5/OJOTUQ0dNoEcN/vlZ5TECO1sqIkXDsU8la4BiuStgEvdi38I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmcCQ-001N5Y-D5; Thu, 05 May 2022 16:11:22 +0200
Date:   Thu, 5 May 2022 16:11:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Pavel Machek <pavel@ucw.cz>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        John Crispin <john@phrozen.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/4] dt-bindings: net: add bitfield defines for Ethernet
 speeds
Message-ID: <YnPbCor/hObN0zuT@lunn.ch>
References: <20220503153613.15320-1-zajec5@gmail.com>
 <235aa025-7c12-f7e1-d788-9a2ef97f664f@gmail.com>
 <YnPASLy4oWJ6BJDq@lunn.ch>
 <47bafeae-34fb-fc55-3758-d248bd9706af@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47bafeae-34fb-fc55-3758-d248bd9706af@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Please look at the LED binding.
> 
> My binding or Ansuel's binding?

Ansuels binding is using the LED binding.

> I was planning to base my work on top of Ansuel's one. I'll send proof
> on concept meanwhile without asking for it to be applied.

Great. The more testing Ansuel work gets the better.

	Thanks
		Andrew
