Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4537B583
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 00:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbfG3WO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 18:14:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56178 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfG3WO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 18:14:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0150F14FD1E39;
        Tue, 30 Jul 2019 15:14:56 -0700 (PDT)
Date:   Tue, 30 Jul 2019 15:14:56 -0700 (PDT)
Message-Id: <20190730.151456.309360507478475047.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        Tristram.Ha@microchip.com, vivien.didelot@gmail.com,
        woojung.huh@microchip.com
Subject: Re: [PATCH V4 0/3] net: dsa: ksz: Add Microchip KSZ87xx support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190729174947.10103-1-marex@denx.de>
References: <20190729174947.10103-1-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jul 2019 15:14:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Mon, 29 Jul 2019 19:49:44 +0200

> This series adds support for Microchip KSZ87xx switches, which are
> slightly simpler compared to KSZ9xxx .
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Series applied to net-next, thank you.
