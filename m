Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6931160965
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 05:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgBQEAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 23:00:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48578 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbgBQEAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 23:00:42 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 689411584A7ED;
        Sun, 16 Feb 2020 20:00:42 -0800 (PST)
Date:   Sun, 16 Feb 2020 20:00:42 -0800 (PST)
Message-Id: <20200216.200042.628735526502750611.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: [PATCH net-next 0/3] mv88e6xxx: Add SERDES/PCS registers to
 ethtool -d
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200216175415.32505-1-andrew@lunn.ch>
References: <20200216175415.32505-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 20:00:42 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Sun, 16 Feb 2020 18:54:12 +0100

> ethtool -d will dump the registers of an interface. For mv88e6xxx
> switch ports, this dump covers the port specific registers. Extend
> this with the SERDES/PCS registers, if a port has a SERDES.

Series applied, thanks.
