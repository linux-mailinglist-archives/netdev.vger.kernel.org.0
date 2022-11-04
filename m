Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 367D0619277
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 09:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbiKDILU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 04:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiKDILT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 04:11:19 -0400
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BA825C48;
        Fri,  4 Nov 2022 01:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1667549477; x=1699085477;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+z9ag5LPL19G0M2uEjLwzIQrVzTvZHoq4i14ZrWWfOc=;
  b=EVKJnwHXuay4bAvohwEMRIZkNdVjZuC3jVfnynW3dQbqqPGm8WyL3mw7
   4ANKCjyrjjY0uU4KwuTKKXqFJogcXcVCGliM6R8pACrNVA4rxHVIeErb3
   Fjz7NSt7RDKgbQ8iNCFYdmhFTQbbkK5H/7Hudb9/Fgs2IYKwqHRmf6HVC
   BtCSyFGxHja7fRYbXi6ty8xxYDreSPG5Kbh/dBR98NMKia3h7lYomaP8M
   s9TQ6VnqN2xuEG5mX6YyLMLi+fdd42Pe4MX+gL2DmHFxO+y2Bg2UFlhdG
   h9L4Id2vHUVo9sGtnGlYPykIBvNM38COviAuHB5jlUyHXf3On/ZpdR78v
   A==;
X-IronPort-AV: E=Sophos;i="5.96,136,1665439200"; 
   d="scan'208";a="27155345"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 04 Nov 2022 09:11:14 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Fri, 04 Nov 2022 09:11:14 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Fri, 04 Nov 2022 09:11:14 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1667549474; x=1699085474;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+z9ag5LPL19G0M2uEjLwzIQrVzTvZHoq4i14ZrWWfOc=;
  b=GzcKF6urnaZ3sYijd+TQh60n+kxTOVik1U7XXvIg1IV0LVsmsKtFcJL5
   p+K7xEs5MxrzMWmDim8I4DmMzZxpmj87SiI0MDBGK6BqgLjfZSF5auePY
   cew9ZW6wl2vnpYdnACBlldbAPRnetUcrwINIjqhkuvrpK4/w956mNDi2p
   LtSaaCo2ClPMSOsRf5F46U6tjt2UPR4RzxfXUHwa1axF6zRqzAZePI+RC
   Or8N5lQBe1dzZy8Xp2akAjba4f+cKVzT1tgT+uHKOCzr8zlhOBGW+cPU7
   jGZ3gMcgLwYx7vphMM2Zrc5bNZK9zVsOKMXKhdykjKE73KDFRezQXOYlN
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,136,1665439200"; 
   d="scan'208";a="27155337"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 04 Nov 2022 09:11:13 +0100
Received: from steina-w.localnet (unknown [10.123.53.21])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 92D67280056;
        Fri,  4 Nov 2022 09:11:12 +0100 (CET)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 1/2] dt-bindings: dp83867: define ti, ledX-active-low properties
Date:   Fri, 04 Nov 2022 09:11:11 +0100
Message-ID: <23673049.ouqheUzb2q@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <893c83e7-8b11-0439-6f38-d522f4a1a368@rasmusvillemoes.dk>
References: <20221103143118.2199316-1-linux@rasmusvillemoes.dk> <Y2Q9+qqwRqEu5btz@lunn.ch> <893c83e7-8b11-0439-6f38-d522f4a1a368@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Freitag, 4. November 2022, 08:17:44 CET schrieb Rasmus Villemoes:
> On 03/11/2022 23.17, Andrew Lunn wrote:
> > On Thu, Nov 03, 2022 at 03:31:17PM +0100, Rasmus Villemoes wrote:
> >> The dp83867 has three LED_X pins that can be used to drive LEDs. They
> >> are by default driven active high, but on some boards the reverse is
> >> needed. Add bindings to allow a board to specify that they should be
> >> active low.
> > 
> > Somebody really does need to finish the PHY LEDs via /sys/class/leds.
> > It looks like this would then be a reasonable standard property:
> > active-low, not a vendor property.
> > 
> > Please help out with the PHY LEDs patches.
> 
> So how do you imagine this to work in DT? Should the dp83867 phy node
> grow a subnode like this?
> 
>   leds {
>     #address-cells = <1>;
>     #size-cells = <0>;
> 
>     led@0 {
>       reg = <0>;
>       active-low;
>     };
>     led@2 {
>       reg = <2>;
>       active-low;
>     };
>   };
> 
> Since the phy drives the leds automatically based on (by default)
> link/activity, there's not really any need for a separate LED driver nor
> do I see what would be gained by somehow listing the LEDs in
> /sys/class/leds. Please expand.

There have been several tries to support LED support directly per DT, e.g. [1] 
& [2]. I assume Andrew is referring to [3].

Best regards,
Alexander

[1] https://lore.kernel.org/netdev/YFUVcLCzONhPmeh8@lunn.ch/T/
[2] https://www.spinics.net/lists/netdev/msg677827.html
[3] https://patches.linaro.org/project/linux-leds/cover/
20220503151633.18760-1-ansuelsmth@gmail.com/



