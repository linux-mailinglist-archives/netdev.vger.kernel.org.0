Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA850F2737
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfKGFnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 00:43:07 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:34070 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbfKGFnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:43:07 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5C0711511FD70;
        Wed,  6 Nov 2019 21:43:07 -0800 (PST)
Date:   Wed, 06 Nov 2019 21:43:06 -0800 (PST)
Message-Id: <20191106.214306.105729259361848530.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: [PATCH net-next] net: dsa: mv8e6xxx: Fix stub function
 parameters
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191107001800.8898-1-andrew@lunn.ch>
References: <20191107001800.8898-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 21:43:07 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Thu,  7 Nov 2019 01:18:00 +0100

> mv88e6xxx_g2_atu_stats_get() takes two parameters. Make the stub
> function also take two, otherwise we get compile errors.
> 
> Fixes: c5f299d59261 ("net: dsa: mv88e6xxx: global1_atu: Add helper for get next")
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks Andrew.
