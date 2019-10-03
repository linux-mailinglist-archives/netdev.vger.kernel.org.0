Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15F0ACA15F
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 17:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730004AbfJCPvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 11:51:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45244 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbfJCPvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 11:51:12 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:b5c5:ae11:3e54:6a07])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8A3261434B962;
        Thu,  3 Oct 2019 08:51:11 -0700 (PDT)
Date:   Thu, 03 Oct 2019 11:51:11 -0400 (EDT)
Message-Id: <20191003.115111.1102308654924030394.davem@davemloft.net>
To:     pmalani@chromium.org
Cc:     hayeswang@realtek.com, grundler@chromium.org,
        netdev@vger.kernel.org, nic_swsd@realtek.com
Subject: Re: [PATCH net-next] r8152: Add identifier names for function
 pointers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191002210933.122122-1-pmalani@chromium.org>
References: <20191002210933.122122-1-pmalani@chromium.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 03 Oct 2019 08:51:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prashant Malani <pmalani@chromium.org>
Date: Wed,  2 Oct 2019 14:09:33 -0700

> Checkpatch throws warnings for function pointer declarations which lack
> identifier names.
> 
> An example of such a warning is:
> 
> WARNING: function definition argument 'struct r8152 *' should
> also have an identifier name
> 739: FILE: drivers/net/usb/r8152.c:739:
> +               void (*init)(struct r8152 *);
> 
> So, fix those warnings by adding the identifier names.
> 
> While we are at it, also fix a character limit violation which was
> causing another checkpatch warning.
> 
> Change-Id: Idec857ce2dc9592caf3173188be1660052c052ce
> Signed-off-by: Prashant Malani <pmalani@chromium.org>
> Reviewed-by: Grant Grundler <grundler@chromium.org>

Applied.
