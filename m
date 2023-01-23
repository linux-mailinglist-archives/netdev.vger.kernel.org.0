Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B19677FE4
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 16:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbjAWPfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 10:35:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbjAWPfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 10:35:22 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB672915F;
        Mon, 23 Jan 2023 07:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=JrhTRbohZcUiOX4gCm++sE97rp1uhTr0oB7m4yP4me4=; b=3oUeEY2ty5whZuMqQUPxkHEyHZ
        bOUDe6+IrWc7XvHm8nCTgIP1VKgSkpK9c0I1U8YD2RIRGb/BR9r0uw2pSUVGssbsTeUgv8EqN1PRX
        eKvw5xM/YkkXZiMD8Fm8X98brdJl4SuiXjjNxgtio+j6FMRwrlmnnS7yQ6TsZGJNLR/A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pJyqY-002v7S-Ez; Mon, 23 Jan 2023 16:34:58 +0100
Date:   Mon, 23 Jan 2023 16:34:58 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Xu Liang <lxu@maxlinear.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] net: phy: add error checks in
 mmd_phy_indirect() and export it
Message-ID: <Y86pItVLKwbRYX7e@lunn.ch>
References: <20230120224011.796097-1-michael@walle.cc>
 <20230120224011.796097-2-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230120224011.796097-2-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 11:40:07PM +0100, Michael Walle wrote:
> Add missing error checks in mmd_phy_indirect(). The error checks need to
> be disabled to retain the current behavior in phy_read_mmd() and
> phy_write_mmd(). Therefore, add a new parameter to enable the error
> checks. Add a thin wrapper __phy_mmd_indirect() which is then exported.

Do we need to retain the current behavior? Is there a good reason to
silently ignore errors? If there is, it would be good to state it here
in the commit message.

   Andrew
