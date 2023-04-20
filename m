Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0036E99E0
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 18:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjDTQta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 12:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjDTQt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 12:49:29 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B25270E
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=cSyrbeMwr7Yq4c+7XhJQHf824tIRNNGnFq0zYuLbCko=; b=oh
        qVpGhbFKJOuD8IJupVyEzcjom6FNESSTmSw0DJPxPQy+id3cTMclE/efy3q4xMn+lrq5Ld8aBa+uS
        3gw6qKX/CnnfjwPZDtlQli3P5RMJ1Eq7AdZ59eW1++euc2THtSIE/vUVGY8QkVBII//i1MZx0Kwdk
        lqI6Ad5NkrsWsDE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ppXT7-00Ao8U-6U; Thu, 20 Apr 2023 18:49:13 +0200
Date:   Thu, 20 Apr 2023 18:49:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?Ram=F3n?= Nordin Rodriguez 
        <ramon.nordin.rodriguez@ferroamp.se>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v4] drivers/net/phy: add driver for Microchip LAN867x
 10BASE-T1S PHY
Message-ID: <179e7571-6cfa-4f54-b8aa-0b75600242cb@lunn.ch>
References: <ZEFqFg9RO+Vsj8Kv@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZEFqFg9RO+Vsj8Kv@debian>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 06:36:38PM +0200, Ramón Nordin Rodriguez wrote:
> This patch adds support for the Microchip LAN867x 10BASE-T1S family
> (LAN8670/1/2). The driver supports P2MP with PLCA.
> 
> Signed-off-by: Ramón Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>
> ---

Hi Ramón

So the history is in the wrong place. It should be here, under the ---
I've no idea what 'git am' will make of this patch, if it will
apply. You should try saving the email and applying the patch yourself
and see if it works.

And my Reviewed-by: has not been added.

    Andrew
