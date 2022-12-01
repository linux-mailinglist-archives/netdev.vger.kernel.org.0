Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D27863E7CA
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 03:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiLACXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 21:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiLACWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 21:22:51 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AF928738;
        Wed, 30 Nov 2022 18:22:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eNbTy2sBeMZqoW1g/n9wE8NZpX1k3sWmDNk3oQPmY/k=; b=EoxX6nkA/VVC2drRKJkY4RwY/x
        aWUK/YVmWguUvsQTHBWeV6pilMOOuLhEQvnHQ6jgIQl9vE1Xpl4C9thiIP2yZYusl6xF+Js6GW9nD
        CqmR4uGDOF5E/F2h4DnV5jcoNbTpljM8XlcofK3anT1wH3i3fT7Jk1uQOZmDyic7G0jI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0ZDV-0041RC-Af; Thu, 01 Dec 2022 03:22:25 +0100
Date:   Thu, 1 Dec 2022 03:22:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Laight <David.Laight@aculab.com>
Cc:     Brian Masney <bmasney@redhat.com>,
        "irusskikh@marvell.com" <irusskikh@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cth451@gmail.com" <cth451@gmail.com>
Subject: Re: [PATCH] net: atlantic: fix check for invalid ethernet addresses
Message-ID: <Y4gP4W+CBSA7qD6a@lunn.ch>
References: <20221130174259.1591567-1-bmasney@redhat.com>
 <Y4ex6WqiY8IdwfHe@lunn.ch>
 <Y4fGORYQRfYTabH1@x1>
 <Y4fMBl6sv+SUyt9Z@lunn.ch>
 <3adb7dc622a3429782ca89e83c8e020d@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3adb7dc622a3429782ca89e83c8e020d@AcuMS.aculab.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Pretty much zero chance of that board ever working well
> enough to be in a system.

IBM, for example, has at least three ranges. Maybe they could of
reached the end of one range, and simply continued shipping products
from the beginning of the next range...

aQuantia only has one range, so i would however agree for them, the
first valid MAC address is probably assigned to some internal
development device.

     Andrew
