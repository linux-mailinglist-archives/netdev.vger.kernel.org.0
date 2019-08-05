Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4181F82613
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 22:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730552AbfHEUbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 16:31:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33814 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbfHEUbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 16:31:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1E5691543276C;
        Mon,  5 Aug 2019 13:31:35 -0700 (PDT)
Date:   Mon, 05 Aug 2019 13:31:34 -0700 (PDT)
Message-Id: <20190805.133134.1233042381014184856.davem@davemloft.net>
To:     arnaud.patard@rtp-net.org
Cc:     netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [patch 1/1] drivers/net/ethernet/marvell/mvmdio.c: Fix non OF
 case
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190802083310.772136040@rtp-net.org>
References: <20190802083310.772136040@rtp-net.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 Aug 2019 13:31:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
Date: Fri, 02 Aug 2019 10:32:40 +0200

> Orion5.x systems are still using machine files and not device-tree.
> Commit 96cb4342382290c9 ("net: mvmdio: allow up to three clocks to be
> specified for orion-mdio") has replaced devm_clk_get() with of_clk_get(),
> leading to a oops at boot and not working network, as reported in 
> https://lists.debian.org/debian-arm/2019/07/msg00088.html and possibly in
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=908712.
> 
> Link: https://lists.debian.org/debian-arm/2019/07/msg00088.html
> Fixes: 96cb4342382290c9 ("net: mvmdio: allow up to three clocks to be specified for orion-mdio")
> Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>

Applied and queued up for -stable, thanks.
