Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF8F0D9F6
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 01:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfD1Xsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Apr 2019 19:48:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44298 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbfD1Xsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Apr 2019 19:48:38 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5D253133E9740;
        Sun, 28 Apr 2019 16:48:37 -0700 (PDT)
Date:   Sun, 28 Apr 2019 19:48:36 -0400 (EDT)
Message-Id: <20190428.194836.1518261047280803384.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: avoid unneeded MDIO reads in
 genphy_read_status
From:   David Miller <davem@davemloft.net>
In-Reply-To: <92a0d681-33ea-feb7-bdf5-ff6fd9911ce1@gmail.com>
References: <92a0d681-33ea-feb7-bdf5-ff6fd9911ce1@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 28 Apr 2019 16:48:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 24 Apr 2019 21:49:30 +0200

> Considering that in polling mode each link drop will be latched,
> settings can't have changed if link was up and is up.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, let's see what happens. :-)
