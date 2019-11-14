Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B719FFD15A
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 00:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfKNXLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 18:11:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55542 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbfKNXLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 18:11:31 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8591414AC47CA;
        Thu, 14 Nov 2019 15:11:30 -0800 (PST)
Date:   Thu, 14 Nov 2019 15:11:30 -0800 (PST)
Message-Id: <20191114.151130.1285429961478372878.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: sja1105: Simplify reset handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191112221641.15437-1-olteanv@gmail.com>
References: <20191112221641.15437-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 Nov 2019 15:11:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Wed, 13 Nov 2019 00:16:41 +0200

> We don't really need 10k species of reset. Remove everything except cold
> reset which is what is actually used. Too bad the hardware designers
> couldn't agree to use the same bit field for rev 1 and rev 2, so the
> (*reset_cmd) function pointer is there to stay.
> 
> However let's simplify the prototype and give it a struct dsa_switch (we
> want to avoid forward-declarations of structures, in this case struct
> sja1105_private, wherever we can).
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied, thank you.
