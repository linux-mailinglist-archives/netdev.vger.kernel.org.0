Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37644750FE
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 03:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhLOCfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 21:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhLOCfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 21:35:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6220C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 18:35:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 667B8B81D2F
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 02:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E8BC34600;
        Wed, 15 Dec 2021 02:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639535709;
        bh=oWVcVy1VF8zZFOeSoKg7KznKLliCnaZhdoa0MaiS/gI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aBynIXxOwkSbVdZz6oHkTdnD+8eh/YPPHxF8O260iKeYH5j8DJrsRnERO7o9vc3yl
         wb8rIh19GsqaH6b2v2cE72lNJpPiZlm73efYfET0/gDIXqZBdUjg67rLJ3m8pdykRb
         fnZPml/QSk6FPKkpIEqaugwicQ30VA5EjeKy7eR7SRLZFeohE9FaBiCYqpcJYRPy1q
         /B1kHfYZgYnlhodd+Hh9PT487+VqbUeYr+CAryG6J8ji7Cvp56qFa5wwPGtJL43IQG
         CNFfbMQfgfEk9+uoYvxqTrUQj3Y4jvlDK49OvEQIpQF2kiDHk5eugU6l/ZIcw+zbSB
         XjYgJY37Z+x1Q==
Date:   Tue, 14 Dec 2021 18:35:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marcin Wojtas <mw@semihalf.com>, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH net-next 1/7] net: phylink: add mac_select_pcs() method
 to phylink_mac_ops
Message-ID: <20211214183507.736f8fdc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <E1mx965-00GCd9-Ao@rmk-PC.armlinux.org.uk>
References: <Ybiue1TPCwsdHmV4@shell.armlinux.org.uk>
        <E1mx965-00GCd9-Ao@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Dec 2021 14:48:05 +0000 Russell King (Oracle) wrote:
> +/**
> + * @mac_select_pcs: Select a PCS for the interface mode.

nit: no '@' in front of the function name

> + * @config: a pointer to a &struct phylink_config.
> + * @interface: PHY interface mode for PCS
> + *
> + * Return the &struct phylink_pcs for the specified interface mode, or
> + * NULL if none is required, or an error pointer on error.
> + *
> + * This must not modify any state. It is used to query which PCS should
> + * be used. Phylink will use this during validation to ensure that the
> + * configuration is valid, and when setting a configuration to internally
> + * set the PCS that will be used.
> + */
> +struct phylink_pcs *mac_select_pcs(struct phylink_config *config,
> +				   phy_interface_t interface);
