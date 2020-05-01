Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0DF1C0B5B
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 02:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgEAAtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 20:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726384AbgEAAtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 20:49:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96053C035494;
        Thu, 30 Apr 2020 17:49:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5309712741D71;
        Thu, 30 Apr 2020 17:49:20 -0700 (PDT)
Date:   Thu, 30 Apr 2020 17:49:19 -0700 (PDT)
Message-Id: <20200430.174919.939495831904691325.davem@davemloft.net>
To:     Julia.Lawall@inria.fr
Cc:     richardcochran@gmail.com, kernel-janitors@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, eugene.volanschi@inria.fr
Subject: Re: [PATCH] dp83640: reverse arguments to list_add_tail
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1588276292-19166-1-git-send-email-Julia.Lawall@inria.fr>
References: <1588276292-19166-1-git-send-email-Julia.Lawall@inria.fr>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 17:49:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julia Lawall <Julia.Lawall@inria.fr>
Date: Thu, 30 Apr 2020 21:51:32 +0200

> In this code, it appears that phyter_clocks is a list head, based on
> the previous list_for_each, and that clock->list is intended to be a
> list element, given that it has just been initialized in
> dp83640_clock_init.  Accordingly, switch the arguments to
> list_add_tail, which takes the list head as the second argument.
> 
> Fixes: cb646e2b02b27 ("ptp: Added a clock driver for the National Semiconductor PHYTER.")
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

This looks correct to me too.

Applied and queued up for -stable, thanks.
