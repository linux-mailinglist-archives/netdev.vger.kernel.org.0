Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 198A3FA79F
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 04:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfKMDxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 22:53:20 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54532 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbfKMDxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 22:53:19 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 79CAF155004EE;
        Tue, 12 Nov 2019 19:53:19 -0800 (PST)
Date:   Tue, 12 Nov 2019 19:53:19 -0800 (PST)
Message-Id: <20191112.195319.928477486408098214.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: sja1105: Print the reset reason
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191112212200.5572-1-olteanv@gmail.com>
References: <20191112212200.5572-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 19:53:19 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue, 12 Nov 2019 23:22:00 +0200

> Sometimes it can be quite opaque even for me why the driver decided to
> reset the switch. So instead of adding dump_stack() calls each time for
> debugging, just add a reset reason to sja1105_static_config_reload
> calls which gets printed to the console.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied.
