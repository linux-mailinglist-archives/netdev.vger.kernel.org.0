Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C10416085F
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 03:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgBQC5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 21:57:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48004 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgBQC5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 21:57:43 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0923D153EE2D7;
        Sun, 16 Feb 2020 18:57:43 -0800 (PST)
Date:   Sun, 16 Feb 2020 18:57:42 -0800 (PST)
Message-Id: <20200216.185742.1253688525124192173.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, petrm@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net] selftests: forwarding: vxlan_bridge_1d: fix tos
 value
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200213094054.27993-1-liuhangbin@gmail.com>
References: <20200213094054.27993-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 18:57:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Thu, 13 Feb 2020 17:40:54 +0800

> After commit 71130f29979c ("vxlan: fix tos value before xmit") we start
> strict vxlan xmit tos value by RT_TOS(), which limits the tos value less
> than 0x1E. With current value 0x40 the test will failed with "v1: Expected
> to capture 10 packets, got 0". So let's choose a smaller tos value for
> testing.
> 
> Fixes: d417ecf533fe ("selftests: forwarding: vxlan_bridge_1d: Add a TOS test")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied.
