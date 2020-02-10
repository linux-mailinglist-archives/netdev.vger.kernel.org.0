Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C966A1577D9
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 14:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbgBJNDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 08:03:02 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39510 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729313AbgBJNDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 08:03:00 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F21FA14DD5523;
        Mon, 10 Feb 2020 05:02:59 -0800 (PST)
Date:   Mon, 10 Feb 2020 14:02:58 +0100 (CET)
Message-Id: <20200210.140258.1121878279309233159.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, Chris.Healy@zii.aero,
        l.stach@pengutronix.de
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Prevent truncation of longer
 interrupt names
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200208155432.32680-1-andrew@lunn.ch>
References: <20200208155432.32680-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Feb 2020 05:03:00 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Sat,  8 Feb 2020 16:54:32 +0100

> When adding support for unique interrupt names, after testing on a few
> devices, it was assumed 32 characters would be sufficient. This
> assumption turned out to be incorrect, ZII RDU2 for example uses a
> device base name of mv88e6xxx-30be0000.ethernet-1:0, leaving no space
> for post fixes such as -g1-atu-prob and -watchdog. The names then
> become identical, defeating the point of the patch.
> 
> Increase the length of the string to 64 charactoes.
> 
> Reported-by: Chris Healy <Chris.Healy@zii.aero>
> Fixes: 3095383a8ab4 ("net: dsa: mv88e6xxx: Unique IRQ name")
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied.
