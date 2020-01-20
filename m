Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 490F114274E
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 10:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgATJcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 04:32:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55118 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgATJcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 04:32:32 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E1F91153D60C6;
        Mon, 20 Jan 2020 01:32:30 -0800 (PST)
Date:   Mon, 20 Jan 2020 10:32:28 +0100 (CET)
Message-Id: <20200120.103228.2305087164458925089.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     vivien.didelot@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Add SERDES stats
 counters to all 6390 family members
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200118184056.1153-1-andrew@lunn.ch>
References: <20200118184056.1153-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jan 2020 01:32:31 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Sat, 18 Jan 2020 19:40:56 +0100

> The SERDES statistics are valid for all members of the 6390 family,
> not just the 6390 itself. Add the needed callbacks to all members of
> the family.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks Andrew.
