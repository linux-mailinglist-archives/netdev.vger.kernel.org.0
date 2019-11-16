Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B62AFF569
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 21:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbfKPURM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 15:17:12 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53226 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfKPURL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 15:17:11 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3CA4815172091;
        Sat, 16 Nov 2019 12:17:11 -0800 (PST)
Date:   Sat, 16 Nov 2019 12:17:10 -0800 (PST)
Message-Id: <20191116.121710.1143094650284471912.davem@davemloft.net>
To:     hslester96@gmail.com
Cc:     nicolas.ferre@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: macb: add missed tasklet_kill
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191116142310.13770-1-hslester96@gmail.com>
References: <20191116142310.13770-1-hslester96@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Nov 2019 12:17:11 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>
Date: Sat, 16 Nov 2019 22:23:10 +0800

> This driver forgets to kill tasklet in remove.
> Add the call to fix it.
> 
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> ---
> Changes in v2:
>   - Rebase on net-next.

Does this bug exist in mainline?  Then this bug fix should target 'net'.

You must also provide an appropriate Fixes: tag which indicates the commit
which introduced this bug.

Thank you.
