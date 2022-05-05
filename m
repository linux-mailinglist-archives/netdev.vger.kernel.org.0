Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2673651BF1E
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 14:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357616AbiEEMVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 08:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355567AbiEEMVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 08:21:22 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD1E54FB5;
        Thu,  5 May 2022 05:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=aZq5jO8c2cQjpNu/6cSRu86328iJHgS0Kgbi++2VnQk=; b=t9
        rEggc8JstJI8HquYLGPX7K2BbrWG3xtlnbc5OBWAZzd6tAddeHR6S3uzlGNzNnpsgY73ujkYD4fd/
        uo1KRNTnmkYJPUMERaGHOKvsAIS299g2tf1xHtD5/TV7sqtYzry9CVbxv8trMehsTnNzawMVoo4je
        TzI5G6zMq8PYzt4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmaPw-001LnC-7I; Thu, 05 May 2022 14:17:12 +0200
Date:   Thu, 5 May 2022 14:17:12 +0200
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
Message-ID: <YnPASLy4oWJ6BJDq@lunn.ch>
References: <20220503153613.15320-1-zajec5@gmail.com>
 <235aa025-7c12-f7e1-d788-9a2ef97f664f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <235aa025-7c12-f7e1-d788-9a2ef97f664f@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 07:19:41AM +0200, Rafał Miłecki wrote:
> On 3.05.2022 17:36, Rafał Miłecki wrote:
> > From: Rafał Miłecki <rafal@milecki.pl>
> > 
> > This allows specifying multiple Ethernet speeds in a single DT uint32
> > value.
> > 
> > Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> 
> Ansuel please check if my patchset conflicts in any way with your work.
> 
> Andrew suggested to combine both but right now I don't see it as
> necessary.
> 
> I'd still appreciate your review of my work. Such binding may be
> required for some hardware controlled LEDs setup too I guess.

Please look at the LED binding. It is an LED you are trying to
control, so that is the binding you should be using.  How do you
describe this functionality using that binding. Ansuel code will give
you the framework to actually do the implementation within.

    Andrew
