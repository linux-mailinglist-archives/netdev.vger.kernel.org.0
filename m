Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092E955242B
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 20:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245309AbiFTSpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 14:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238101AbiFTSpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 14:45:11 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804E5101E8;
        Mon, 20 Jun 2022 11:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qnQUCsEXT9Glp8UWEloOX+Drt3ezCDD2lXajWbA84j8=; b=3L2ymfx+Ja5ziQKxMzCIzNJwxF
        v/NgaJIJnk7Wn3M7/QUZy9kMXCsaagHo/cRvFyc0aa5ic2J4tn3J8dH26K8Lis+eDlfSK2Os2BCSr
        VaKoQ50VOX5QlPLTbwy6jobSpQgtJ3fzr6TstL2cmHeQxvkai2iSXLtDO4EU5RoST84A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o3MOX-007dpk-Pz; Mon, 20 Jun 2022 20:45:05 +0200
Date:   Mon, 20 Jun 2022 20:45:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Marcin Wojtas <mw@semihalf.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        rafael@kernel.org, lenb@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, hkallweit1@gmail.com, gjb@semihalf.com,
        jaz@semihalf.com, tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com,
        upstream@semihalf.com
Subject: Re: [net-next: PATCH 00/12] ACPI support for DSA
Message-ID: <YrDAMcGg1uF9m/L+@lunn.ch>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <YrC0oKdDSjQTgUtM@lunn.ch>
 <YrC3ZKsMQK3PYKkR@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrC3ZKsMQK3PYKkR@smile.fi.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> You beat me up to this. I also was about to mention that the problem with such
> conversions (like this series does) is not in the code. It's simplest part. The
> problem is bindings and how you get them to be a standard (at least de facto).

De facto is easy. Get it merged. After that, i will simply refuse
anything else, the same way i and other Maintainers would refuse a
different DT binding.

If the ACPI committee approve and publish a binding, we will naturally
accept that as well. So in the end we might have two bindings. But so
far in this whole ACPI for networking story, i've not heard anybody
say they are going to submit anything for standardisation. So this
might be a mute point.

    Andrew
