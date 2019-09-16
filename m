Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 973CDB3519
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 09:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbfIPHGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 03:06:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44230 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfIPHGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 03:06:31 -0400
Received: from localhost (unknown [85.119.46.8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3098D15163DCC;
        Mon, 16 Sep 2019 00:06:28 -0700 (PDT)
Date:   Mon, 16 Sep 2019 09:06:26 +0200 (CEST)
Message-Id: <20190916.090626.1576929033844726797.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, b.spranger@linutronix.de, andrew@lunn.ch,
        vivien.didelot@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: b53: Add support for
 port_egress_floods callback
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190913032841.4302-1-f.fainelli@gmail.com>
References: <20190913032841.4302-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Sep 2019 00:06:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 12 Sep 2019 20:28:39 -0700

> Add support for configuring the per-port egress flooding control for
> both Unicast and Multicast traffic.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied with comment typo fixed.
