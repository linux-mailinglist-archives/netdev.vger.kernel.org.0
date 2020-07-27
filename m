Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15CFD22F6B3
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 19:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731222AbgG0Rcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 13:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgG0Rcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 13:32:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76076C061794;
        Mon, 27 Jul 2020 10:32:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 60921128719F1;
        Mon, 27 Jul 2020 10:15:49 -0700 (PDT)
Date:   Mon, 27 Jul 2020 10:32:33 -0700 (PDT)
Message-Id: <20200727.103233.2024296985848607297.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     ilial@codeaurora.org, kuba@kernel.org, jiri@mellanox.com,
        edumazet@google.com, ap420073@gmail.com, xiyou.wangcong@gmail.com,
        maximmi@mellanox.com, ilia.lin@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dev: Add API to check net_dev readiness
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200726194528.GC1661457@lunn.ch>
References: <1595792274-28580-1-git-send-email-ilial@codeaurora.org>
        <20200726194528.GC1661457@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jul 2020 10:15:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Sun, 26 Jul 2020 21:45:28 +0200

> I also have to wonder why a network device driver is being probed the
> subsys_initcall.

This makes me wonder how this interface could even be useful.  The
only way to fix the problem is to change when the device is probed,
which would mean changing which initcall it uses.  So at run time,
this information can't do much.
