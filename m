Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2A33695A
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 03:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfFFBmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 21:42:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44046 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbfFFBmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 21:42:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C4449144D4A82;
        Wed,  5 Jun 2019 18:42:54 -0700 (PDT)
Date:   Wed, 05 Jun 2019 18:42:54 -0700 (PDT)
Message-Id: <20190605.184254.1047432851767426057.davem@davemloft.net>
To:     hancock@sedsystems.ca
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH net-next] net: phy: Add detection of 1000BaseX link
 mode support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559686501-25739-1-git-send-email-hancock@sedsystems.ca>
References: <1559686501-25739-1-git-send-email-hancock@sedsystems.ca>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 18:42:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert Hancock <hancock@sedsystems.ca>
Date: Tue,  4 Jun 2019 16:15:01 -0600

> Add 1000BaseX to the link modes which are detected based on the
> MII_ESTATUS register as per 802.3 Clause 22. This allows PHYs which
> support 1000BaseX to work properly with drivers using phylink.
> 
> Previously 1000BaseX support was not detected, and if that was the only
> mode the PHY indicated support for, phylink would refuse to attach it
> due to the list of supported modes being empty.
> 
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>

Andrew/Florian/Heiner, is there a reason we left out the handling of these
ESTATUS bits?

