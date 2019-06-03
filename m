Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD67E33624
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 19:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbfFCRJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 13:09:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60442 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728189AbfFCRJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 13:09:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A671C14B905AE;
        Mon,  3 Jun 2019 10:09:01 -0700 (PDT)
Date:   Mon, 03 Jun 2019 10:09:01 -0700 (PDT)
Message-Id: <20190603.100901.283313877265435660.davem@davemloft.net>
To:     rasmus.villemoes@prevas.dk
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        Rasmus.Villemoes@prevas.se, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: make mv88e6xxx_g1_stats_wait
 static
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190603080353.18957-1-rasmus.villemoes@prevas.dk>
References: <20190603080353.18957-1-rasmus.villemoes@prevas.dk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Jun 2019 10:09:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Date: Mon, 3 Jun 2019 08:04:09 +0000

> mv88e6xxx_g1_stats_wait has no users outside global1.c, so make it
> static.
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Applied to net-next.
