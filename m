Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCB84722E
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 23:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfFOVEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 17:04:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39744 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfFOVEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 17:04:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3C3E714EC6995;
        Sat, 15 Jun 2019 14:04:53 -0700 (PDT)
Date:   Sat, 15 Jun 2019 14:04:52 -0700 (PDT)
Message-Id: <20190615.140452.1180359561616910750.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: improve handling of Abit Fatal1ty
 F-190HD
From:   David Miller <davem@davemloft.net>
In-Reply-To: <dd47434d-a928-6595-7be3-fd28eb3377ca@gmail.com>
References: <dd47434d-a928-6595-7be3-fd28eb3377ca@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 15 Jun 2019 14:04:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sat, 15 Jun 2019 09:58:21 +0200

> The Abit Fatal1ty F-190HD has a PCI ID quirk and the entry marks this
> board as not GBit-capable, what is wrong. According to [0] the board
> has a RTL8111B that is GBit-capable, therefore remove the
> RTL_CFG_NO_GBIT flag.
> 
> [0] https://www.centos.org/forums/viewtopic.php?t=23390
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks.
