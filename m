Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC5A1143B3C
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 11:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729579AbgAUKmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 05:42:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36160 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728831AbgAUKmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 05:42:03 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4684F15BF7DCF;
        Tue, 21 Jan 2020 02:42:01 -0800 (PST)
Date:   Tue, 21 Jan 2020 11:41:59 +0100 (CET)
Message-Id: <20200121.114159.2274824592420675035.davem@davemloft.net>
To:     ms@dev.tdt.de
Cc:     kubakici@wp.pl, khc@pm.waw.pl, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] wan/hdlc_x25: fix skb handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200121060034.30554-2-ms@dev.tdt.de>
References: <20200121060034.30554-1-ms@dev.tdt.de>
        <20200121060034.30554-2-ms@dev.tdt.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jan 2020 02:42:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Schiller <ms@dev.tdt.de>
Date: Tue, 21 Jan 2020 07:00:34 +0100

>  o call skb_reset_network_header() before hdlc->xmit()
>  o change skb proto to HDLC (0x0019) before hdlc->xmit()
>  o call dev_queue_xmit_nit() before hdlc->xmit()
> 
> This changes make it possible to trace (tcpdump) outgoing layer2
> (ETH_P_HDLC) packets
> 
> Additionally call skb_reset_network_header() after each skb_push() /
> skb_pull().
> 
> Signed-off-by: Martin Schiller <ms@dev.tdt.de>

Applied to net-next
