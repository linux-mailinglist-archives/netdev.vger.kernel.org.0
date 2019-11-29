Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAEE10D1B5
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 08:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfK2HGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 02:06:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53738 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfK2HGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 02:06:18 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 56D1A146A7863;
        Thu, 28 Nov 2019 23:06:17 -0800 (PST)
Date:   Thu, 28 Nov 2019 23:06:16 -0800 (PST)
Message-Id: <20191128.230616.2298780502442519078.davem@davemloft.net>
To:     hslester96@gmail.com
Cc:     nicolas.ferre@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v4] net: macb: add missed tasklet_kill
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191128020021.23761-1-hslester96@gmail.com>
References: <20191128020021.23761-1-hslester96@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 28 Nov 2019 23:06:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>
Date: Thu, 28 Nov 2019 10:00:21 +0800

> This driver forgets to kill tasklet in remove.
> Add the call to fix it.
> 
> Fixes: 032dc41ba6e2 ("net: macb: Handle HRESP error")
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> ---
> Changes in v4:
>   - Put tasklet_kill after unregister_netdev to ensure
>     IRQs are disabled when killing tasklet.

Applied and queued up for -stable, thanks.
