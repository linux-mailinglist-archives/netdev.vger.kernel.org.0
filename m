Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE06133583
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 23:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbgAGWKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 17:10:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38696 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgAGWKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 17:10:11 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7EBC815A17A14;
        Tue,  7 Jan 2020 14:10:10 -0800 (PST)
Date:   Tue, 07 Jan 2020 14:10:09 -0800 (PST)
Message-Id: <20200107.141009.2200317425968518411.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, pfrenard@gmail.com,
        stefan.wahren@i2se.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net] net: usb: lan78xx: fix possible skb leak
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200107185701.137063-1-edumazet@google.com>
References: <20200107185701.137063-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jan 2020 14:10:10 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue,  7 Jan 2020 10:57:01 -0800

> If skb_linearize() fails, we need to free the skb.
> 
> TSO makes skb bigger, and this bug might be the reason
> Raspberry Pi 3B+ users had to disable TSO.
> 
> Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: RENARD Pierre-Francois <pfrenard@gmail.com>

Applied and queued up for -stable, thanks.
