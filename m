Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5622126384D
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 23:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730170AbgIIVQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 17:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgIIVP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 17:15:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB302C061573;
        Wed,  9 Sep 2020 14:15:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E546312987FB5;
        Wed,  9 Sep 2020 13:59:09 -0700 (PDT)
Date:   Wed, 09 Sep 2020 14:15:55 -0700 (PDT)
Message-Id: <20200909.141555.264775437655953463.davem@davemloft.net>
To:     m.felsch@pengutronix.de
Cc:     kuba@kernel.org, robh+dt@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        zhengdejin5@gmail.com, richard.leitner@skidata.com,
        netdev@vger.kernel.org, kernel@pengutronix.de,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 0/5] SMSC: Cleanups and clock setup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200909134501.32529-1-m.felsch@pengutronix.de>
References: <20200909134501.32529-1-m.felsch@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 09 Sep 2020 13:59:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>
Date: Wed,  9 Sep 2020 15:44:56 +0200

> this small series cleans the smsc-phy code a bit and adds the support to
> specify the phy clock source. Adding the phy clock source support is
> also the main purpose of this series.
> 
> Each file has its own changelog.
> 
> Thanks a lot to Florian and Andrew for reviewing it.

Series applied to net-next, thank you.
