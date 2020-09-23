Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB785274DA8
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 02:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgIWAKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 20:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgIWAKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 20:10:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DED6C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 17:10:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2EDAE13C04A3B;
        Tue, 22 Sep 2020 16:53:23 -0700 (PDT)
Date:   Tue, 22 Sep 2020 17:10:09 -0700 (PDT)
Message-Id: <20200922.171009.152835458218973122.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, linux@armlinux.org.uk
Subject: Re: [PATCH net-next 0/3] dpaa2-mac: add PCS support through the
 Lynx module
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200921162031.12921-1-ioana.ciornei@nxp.com>
References: <20200921162031.12921-1-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 22 Sep 2020 16:53:23 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Mon, 21 Sep 2020 19:20:28 +0300

> This patch set aims to add PCS support in the dpaa2-eth driver by
> leveraging the Lynx PCS module.
> 
> The first two patches are some missing pieces: the first one adding
> support for 10GBASER in Lynx PCS while the second one adds a new
> function - of_mdio_find_device - which is helpful in retrieving the PCS
> represented as a mdio_device.  The final patch adds the glue logic
> between phylink and the Lynx PCS module: it retrieves the PCS
> represented as an mdio_device and registers it to Lynx and phylink.
> From that point on, any PCS callbacks are treated by Lynx, without
> dpaa2-eth interaction.

Please make the PCS destroy symmetric with the create as
requested by Andrew.

Thanks.
