Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE7836286AF
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 18:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238194AbiKNRI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 12:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238094AbiKNRI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 12:08:59 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ADA2B1D9;
        Mon, 14 Nov 2022 09:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XroYG9yTOXYHb7bcF/mMm5A/bLzXHHg/N2Mkhl+FaJo=; b=lhZTc7UGYrOr/VUoAbMuT+9ZvS
        eP6B99gz9fslJu6u2CSDNhQwZoKfEVINcVf+909s0CsIi6OQpW4Ua7D5wyoxcWocRomsC5FAQgVcO
        NUuNT+ADjPWhRD3nrLb1iQUZb4D1lcRPWjbM1ktX7sSUhP+ArIv4JPa6TTnXcAlXeZms=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oucwp-002Mbo-Fm; Mon, 14 Nov 2022 18:08:39 +0100
Date:   Mon, 14 Nov 2022 18:08:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 0/3] can: etas_es58x: report firmware, bootloader and
 hardware version
Message-ID: <Y3J2FwamFZbdsu2h@lunn.ch>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221113040108.68249-1-mailhol.vincent@wanadoo.fr>
 <Y3Ef4K5lbilY3EQT@lunn.ch>
 <CAMZ6RqLjcxDG_yCK3dfYr2dWb7sddRPMDGwXRy62c6WHDH5=Gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZ6RqLjcxDG_yCK3dfYr2dWb7sddRPMDGwXRy62c6WHDH5=Gw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Do you have any reference of how to dump the other registers?

Have a look at drivers/net/dsa/mv88e6xxx/devlink.c, all the code with
mv88e6xxx_region_. This ethernet switch chip has multiple banks of
registers, one per port of the switch, and two global. It also has a
few other tables which can be interesting to dump in their raw format.
There is also a user space tool to pritty print them.

    Andrew
