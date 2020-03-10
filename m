Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33789180BD1
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgCJWpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:45:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43456 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgCJWpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:45:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E131014C1FBD6;
        Tue, 10 Mar 2020 15:45:12 -0700 (PDT)
Date:   Tue, 10 Mar 2020 15:45:12 -0700 (PDT)
Message-Id: <20200310.154512.295450486566087970.davem@davemloft.net>
To:     lukas@wunner.de
Cc:     kuba@kernel.org, netdev@vger.kernel.org, fw@strlen.de,
        pablo@netfilter.org, daniel@iogearbox.net, 0x7f454c46@gmail.com,
        tgraf@suug.ch, ast@kernel.org
Subject: Re: [PATCH net-next] pktgen: Allow on loopback device
From:   David Miller <davem@davemloft.net>
In-Reply-To: <077e04669829f190988f3b2018d4eee40a42a36e.1583836647.git.lukas@wunner.de>
References: <077e04669829f190988f3b2018d4eee40a42a36e.1583836647.git.lukas@wunner.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Mar 2020 15:45:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>
Date: Tue, 10 Mar 2020 11:49:46 +0100

> When pktgen is used to measure the performance of dev_queue_xmit()
> packet handling in the core, it is preferable to not hand down
> packets to a low-level Ethernet driver as it would distort the
> measurements.
> 
> Allow using pktgen on the loopback device, thus constraining
> measurements to core code.
> 
> Signed-off-by: Lukas Wunner <lukas@wunner.de>

Applied, thanks.
