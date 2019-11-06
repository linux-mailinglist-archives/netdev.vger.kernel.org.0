Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86BEBF22B3
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 00:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732727AbfKFXew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 18:34:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57704 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbfKFXev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 18:34:51 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3345214FA6818;
        Wed,  6 Nov 2019 15:34:51 -0800 (PST)
Date:   Wed, 06 Nov 2019 15:34:50 -0800 (PST)
Message-Id: <20191106.153450.832167829030748216.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     jakub.kicinski@netronome.com, alexandre.belloni@bootlin.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: mscc: ocelot: fix __ocelot_rmw_ix
 prototype
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191105220140.15093-1-olteanv@gmail.com>
References: <20191105220140.15093-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 15:34:51 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Wed,  6 Nov 2019 00:01:40 +0200

> The "read-modify-write register index" function is declared with a
> confusing prototype: the "mask" and "reg" arguments are swapped.
> 
> Fortunately, this does not affect callers so far. Both arguments are
> u32, and the wrapper macros (ocelot_rmw_ix etc) have the arguments in
> the correct order (the one from ocelot_io.c).
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

I ended up applying this to 'net' but will not queue it up for -stable.

Thank you.
