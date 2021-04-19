Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D235364DCA
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 00:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhDSWqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 18:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhDSWqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 18:46:17 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A83C06174A;
        Mon, 19 Apr 2021 15:45:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 512B14F40E343;
        Mon, 19 Apr 2021 15:45:46 -0700 (PDT)
Date:   Mon, 19 Apr 2021 15:45:45 -0700 (PDT)
Message-Id: <20210419.154545.1437529237095871426.davem@davemloft.net>
To:     aford173@gmail.com
Cc:     netdev@vger.kernel.org, aford@beaconembedded.com,
        geert@linux-m68k.org, sergei.shtylyov@gmail.com, kuba@kernel.org,
        andrew@lunn.ch, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: ravb: Fix release of refclk
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210417132329.6886-1-aford173@gmail.com>
References: <20210417132329.6886-1-aford173@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 19 Apr 2021 15:45:46 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Adam Ford <aford173@gmail.com>
Date: Sat, 17 Apr 2021 08:23:29 -0500

> The call to clk_disable_unprepare() can happen before priv is
> initialized. This means moving clk_disable_unprepare out of
> out_release into a new label.
> 
> Fixes: 8ef7adc6beb2("net: ethernet: ravb: Enable optional refclk")
> Signed-off-by: Adam Ford <aford173@gmail.com>
Thjis does not apply cleanly, please rebbase and resubmit.

Please fix the formatting of your Fixes tag while you are at it, thank you.
