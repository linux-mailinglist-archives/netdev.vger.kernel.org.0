Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0BE60C035
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 02:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbiJYAw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 20:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiJYAwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 20:52:39 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8DC1285DE;
        Mon, 24 Oct 2022 16:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OE9ltgQZfGJ8gIzvlomWzdYIa8zAOISdbaj6uqTUr+8=; b=20NAtAd5JfUHvZ2n/ZXDLVOV1n
        mx2o5GQAxbqXinpS0b3GrP1W6+9qSuRvPdu4+JwsYRYTdx9NueONTb+SkGKl96Yoeml5baCTYX6ow
        zb+BnJeOh5R9n5ixQaDgC+APuSamYvM8nJ5vjicVLmhKXcI0doJGxjuTyehaT279C8cw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1omw24-000NA9-1Q; Mon, 24 Oct 2022 13:54:16 +0200
Date:   Mon, 24 Oct 2022 13:54:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, lxu@maxlinear.com,
        hkallweit1@gmail.com, pabeni@redhat.com, edumazet@google.com,
        linux@armlinux.org.uk, UNGLinuxDriver@microchip.com,
        Ian.Saturley@microchip.com
Subject: Re: [PATCH net-next] net: phy: mxl-gpy: Add PHY Auto/MDI/MDI-X set
 driver for GPY211 chips
Message-ID: <Y1Z86Pj5NsJOXLEe@lunn.ch>
References: <20221021100305.6576-1-Raju.Lakkaraju@microchip.com>
 <Y1KmL7vTunvbw1/U@lunn.ch>
 <20221024072421.GB653394@raju-project-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024072421.GB653394@raju-project-pc>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Do you know why gpy_update_interface() is a void function? It is
> > called from gpy_read_status() which does return error codes. And it
> > seems like gpy_read_status() would benefit from returning -EINVAL, etc.
> 
> Do you want me to change gpy_update_interface() return type ?
> Can I do those changes as part of this commit or need to fix on "net"
> branch ?

I would say it is not a fix, so do it on net-next. But do it as a
separate patch please.

	 Andrew
