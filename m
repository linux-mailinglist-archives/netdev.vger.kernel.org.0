Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 838FB62E81
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 05:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbfGIDLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 23:11:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34284 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfGIDLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 23:11:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3FF91133F9EC7;
        Mon,  8 Jul 2019 20:11:03 -0700 (PDT)
Date:   Mon, 08 Jul 2019 20:11:02 -0700 (PDT)
Message-Id: <20190708.201102.1931743973646074575.davem@davemloft.net>
To:     huangfq.daxian@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/14] net: phy: Make use of linkmode_mod_bit helper
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190708123417.12265-1-huangfq.daxian@gmail.com>
References: <20190708123417.12265-1-huangfq.daxian@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 20:11:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fuqian Huang <huangfq.daxian@gmail.com>
Date: Mon,  8 Jul 2019 20:34:17 +0800

> linkmode_mod_bit is introduced as a helper function to set/clear
> bits in a linkmode.
> Replace the if else code structure with a call to the helper
> linkmode_mod_bit.
> 
> Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>

Applied to net-next, thanks.
