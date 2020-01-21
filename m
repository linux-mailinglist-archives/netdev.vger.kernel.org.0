Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D510B1439C8
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 10:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbgAUJrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 04:47:46 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35876 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729037AbgAUJrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 04:47:45 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2D26B15BCB7A8;
        Tue, 21 Jan 2020 01:47:44 -0800 (PST)
Date:   Tue, 21 Jan 2020 10:47:42 +0100 (CET)
Message-Id: <20200121.104742.248406818935135423.davem@davemloft.net>
To:     james.hughes@raspberrypi.org
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH] net: usb: lan78xx: Add .ndo_features_check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200120111240.9690-1-james.hughes@raspberrypi.org>
References: <20200120111240.9690-1-james.hughes@raspberrypi.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jan 2020 01:47:45 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: James Hughes <james.hughes@raspberrypi.org>
Date: Mon, 20 Jan 2020 11:12:40 +0000

> As reported by Eric Dumazet, there are still some outstanding
> cases where the driver does not handle TSO correctly when skb's
> are over a certain size. Most cases have been fixed, this patch
> should ensure that forwarded SKB's that are greater than
> MAX_SINGLE_PACKET_SIZE - TX_OVERHEAD are software segmented
> and handled correctly.
> 
> Signed-off-by: James Hughes <james.hughes@raspberrypi.org>

Applied and queued up for -stable, thanks.
