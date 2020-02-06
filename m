Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9A401544E8
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 14:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgBFN36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 08:29:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59564 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgBFN35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 08:29:57 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AA9A914CCC98E;
        Thu,  6 Feb 2020 05:29:56 -0800 (PST)
Date:   Thu, 06 Feb 2020 14:29:54 +0100 (CET)
Message-Id: <20200206.142954.1457791883934476387.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: systemport: Avoid RBUF stuck in Wake-on-LAN
 mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200205203204.14511-1-f.fainelli@gmail.com>
References: <20200205203204.14511-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Feb 2020 05:29:57 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Wed,  5 Feb 2020 12:32:04 -0800

> After a number of suspend and resume cycles, it is possible for the RBUF
> to be stuck in Wake-on-LAN mode, despite the MPD enable bit being
> cleared which instructed the RBUF to exit that mode.

Must be some weird state latching or something like that...

> Avoid creating that problematic condition by clearing the RX_EN and
> TX_EN bits in the UniMAC prior to disable the Magic Packet Detector
> logic which is guaranteed to make the RBUF exit Wake-on-LAN mode.
> 
> Fixes: 83e82f4c706b ("net: systemport: add Wake-on-LAN support")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied and queued up for -stable, thanks.
