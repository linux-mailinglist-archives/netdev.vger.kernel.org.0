Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 175ACD7E39
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 19:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388904AbfJORzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 13:55:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37662 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731694AbfJORzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 13:55:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C82EC1504B49C;
        Tue, 15 Oct 2019 10:55:51 -0700 (PDT)
Date:   Tue, 15 Oct 2019 10:55:51 -0700 (PDT)
Message-Id: <20191015.105551.1592575105039759451.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, phil@raspberrypi.org,
        jonathan@raspberrypi.org, matthias.bgg@kernel.org,
        linux-rpi-kernel@lists.infradead.org, wahrenst@gmx.net,
        nsaenzjulienne@suse.de, opendmb@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: bcmgenet: Set phydev->dev_flags only for
 internal PHYs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191011195349.9661-1-f.fainelli@gmail.com>
References: <20191011195349.9661-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 10:55:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Fri, 11 Oct 2019 12:53:49 -0700

> phydev->dev_flags is entirely dependent on the PHY device driver which
> is going to be used, setting the internal GENET PHY revision in those
> bits only makes sense when drivers/net/phy/bcm7xxx.c is the PHY driver
> being used.
> 
> Fixes: 487320c54143 ("net: bcmgenet: communicate integrated PHY revision to PHY driver")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied and queued up for -stable, thanks Florian.
