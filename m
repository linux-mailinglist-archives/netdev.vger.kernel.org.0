Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C729B368D5
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 02:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbfFFAn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 20:43:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43412 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbfFFAn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 20:43:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4803813CD494E;
        Wed,  5 Jun 2019 17:43:56 -0700 (PDT)
Date:   Wed, 05 Jun 2019 17:43:55 -0700 (PDT)
Message-Id: <20190605.174355.1020069357083329222.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: remove state PHY_FORCING
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5c3bded5-ddcb-ffe5-5769-cf237b8352a3@gmail.com>
References: <5c3bded5-ddcb-ffe5-5769-cf237b8352a3@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 17:43:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Tue, 4 Jun 2019 23:02:34 +0200

> In the early days of phylib we had a functionality that changed to the
> next lower speed in fixed mode if no link was established after a
> certain period of time. This functionality has been removed years ago,
> and state PHY_FORCING isn't needed any longer. Instead we can go from
> UP to RUNNING or NOLINK directly (same as in autoneg mode).
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
