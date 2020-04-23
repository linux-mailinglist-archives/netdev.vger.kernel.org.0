Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93F01B647F
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 21:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbgDWTda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 15:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728308AbgDWTd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 15:33:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1D0C09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 12:33:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F366912776892;
        Thu, 23 Apr 2020 12:33:28 -0700 (PDT)
Date:   Thu, 23 Apr 2020 12:33:27 -0700 (PDT)
Message-Id: <20200423.123327.1576380761159091705.davem@davemloft.net>
To:     baruch@tkos.co.il
Cc:     linux@armlinux.org.uk, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH net] net: phy: marvell10g: limit soft reset to 88x3310
From:   David Miller <davem@davemloft.net>
In-Reply-To: <616c799433477943d782bda9d8a825d56fc70c9d.1587459886.git.baruch@tkos.co.il>
References: <616c799433477943d782bda9d8a825d56fc70c9d.1587459886.git.baruch@tkos.co.il>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Apr 2020 12:33:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>
Date: Tue, 21 Apr 2020 12:04:46 +0300

> The MV_V2_PORT_CTRL_SWRST bit in MV_V2_PORT_CTRL is reserved on 88E2110.
> Setting SWRST on 88E2110 breaks packets transfer after interface down/up
> cycle.
> 
> Fixes: 8f48c2ac85ed ("net: marvell10g: soft-reset the PHY when coming out of low power")
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Applied.
