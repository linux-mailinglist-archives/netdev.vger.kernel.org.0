Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01FDB618B3F
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 23:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbiKCWRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 18:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbiKCWRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 18:17:49 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448BD2125F;
        Thu,  3 Nov 2022 15:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Qdq9ylbUbhEutSgPDvpC0GfZinhuqtjurQSscowS5Bc=; b=w5sKC2qoOjyCL8D4cbFzt8ibOV
        ujWMBDpSWoSqpUHTQKcaZDqhUtm07xeYj5Oq98xEiyzyh2elI44Re7Gs+MQbgE9eWlg3a6L1Dl5GG
        PQsLIYRmcMcC2XHSecdjpc5a781axBHqmup7Y/CF7rF7SUPDKR2es1WSYgw2y4Xh/4gQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oqiWh-001M4o-0W; Thu, 03 Nov 2022 23:17:31 +0100
Date:   Thu, 3 Nov 2022 23:17:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 1/2] dt-bindings: dp83867: define ti,ledX-active-low
 properties
Message-ID: <Y2Q9+qqwRqEu5btz@lunn.ch>
References: <20221103143118.2199316-1-linux@rasmusvillemoes.dk>
 <20221103143118.2199316-2-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103143118.2199316-2-linux@rasmusvillemoes.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 03, 2022 at 03:31:17PM +0100, Rasmus Villemoes wrote:
> The dp83867 has three LED_X pins that can be used to drive LEDs. They
> are by default driven active high, but on some boards the reverse is
> needed. Add bindings to allow a board to specify that they should be
> active low.

Somebody really does need to finish the PHY LEDs via /sys/class/leds.
It looks like this would then be a reasonable standard property:
active-low, not a vendor property.

Please help out with the PHY LEDs patches.

       Andrew
