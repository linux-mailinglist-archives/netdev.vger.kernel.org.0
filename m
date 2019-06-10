Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 468973AD69
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 05:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730372AbfFJDFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 23:05:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49076 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFJDFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 23:05:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5E9E514EAF656;
        Sun,  9 Jun 2019 20:05:34 -0700 (PDT)
Date:   Sun, 09 Jun 2019 20:05:33 -0700 (PDT)
Message-Id: <20190609.200533.1251345152032433142.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     hkallweit1@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/1] net: phy: broadcom: Add genphy_suspend
 and genphy_resume for BCM5464
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190608135356.29898-1-olteanv@gmail.com>
References: <20190608135356.29898-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 20:05:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sat,  8 Jun 2019 16:53:56 +0300

> This puts the quad PHY ports in power-down mode when the PHY transitions
> to the PHY_HALTED state.  It is likely that all the other PHYs support
> the BMCR_PDOWN bit, but I only have the BCM5464R to test.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied.
