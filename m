Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 553ED720F7
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 22:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389008AbfGWUi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 16:38:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36418 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbfGWUi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 16:38:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0A35E153BE24F;
        Tue, 23 Jul 2019 13:38:57 -0700 (PDT)
Date:   Tue, 23 Jul 2019 13:38:56 -0700 (PDT)
Message-Id: <20190723.133856.860402214064308020.davem@davemloft.net>
To:     nishkadg.linux@gmail.com
Cc:     olteanv@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: sja1105: sja1105_main: Add of_node_put()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190723104448.8125-1-nishkadg.linux@gmail.com>
References: <20190723104448.8125-1-nishkadg.linux@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 13:38:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nishka Dasgupta <nishkadg.linux@gmail.com>
Date: Tue, 23 Jul 2019 16:14:48 +0530

> Each iteration of for_each_child_of_node puts the previous node, but in
> the case of a return from the middle of the loop, there is no put, thus
> causing a memory leak. Hence add an of_node_put before the return.
> Issue found with Coccinelle.
> 
> Signed-off-by: Nishka Dasgupta <nishkadg.linux@gmail.com>

Applied.

Again, the semantics of these looping constructs are terrible.
