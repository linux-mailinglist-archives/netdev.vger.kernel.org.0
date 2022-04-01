Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBC54EEECA
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346654AbiDAOHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239154AbiDAOHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:07:30 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DFA0FFF83;
        Fri,  1 Apr 2022 07:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5PTm0JMl8ZB8L2fZ+VGxDNX3rqsw2KJq19WqYqVhp7U=; b=jraTzZ0FjDbBYf66DScLypn3TN
        ar3fR9A39VnIEYQ78ThkKcF/g2JsRnqH2qgB6KQdnTDqgv3BKXmN/TfJY55QnZwnIh9vojzN6LQ/t
        2R/dEZcJoBCsqmTM+InnpYWZXS9ctxdIiEAqyur90BAHo+tDrUo6pF9MGHjpPFNohQ4U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1naHuE-00DgQl-Ik; Fri, 01 Apr 2022 16:05:38 +0200
Date:   Fri, 1 Apr 2022 16:05:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, Divya.Koppera@microchip.com,
        davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net 2/3] net: phy: micrel: Remove latency from driver
Message-ID: <YkcGsiEmnk9sKjEj@lunn.ch>
References: <20220401094805.3343464-1-horatiu.vultur@microchip.com>
 <20220401094805.3343464-3-horatiu.vultur@microchip.com>
 <Ykb0RgM+fnzOUTNx@lunn.ch>
 <20220401133454.ic6jxnripuxjhp5g@soft-dev3-1.localhost>
 <20220401135918.4tvwe6cfyku6l5wf@lx-anielsen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401135918.4tvwe6cfyku6l5wf@lx-anielsen>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I would like to keep the default values. With default values, you can
> get PTP working (accuracy is not great - but it is much better than
> if set to zero).
> 
> There is no risk of bootloaders to pre-load other values, as the kernel
> will reset the PHY, and after reset we will be back to these numbers.

O.K, that is what i wanted to know. It should be reasonable safe to
assume these values, and userspace daemons can apply whatever
correction they want, assuming this is what the hardware is doing.

       Andrew
