Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962412EB699
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbhAEX6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbhAEX6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 18:58:48 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ABE6C061793;
        Tue,  5 Jan 2021 15:58:08 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id D5CF64CE685B7;
        Tue,  5 Jan 2021 15:58:06 -0800 (PST)
Date:   Tue, 05 Jan 2021 15:58:06 -0800 (PST)
Message-Id: <20210105.155806.1768484944984996325.davem@davemloft.net>
To:     abaci-bugfix@linux.alibaba.com
Cc:     kuba@kernel.org, dchickles@marvell.com, sburla@marvell.com,
        fmanlunas@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] liquidio: style: Identical condition and return
 expression 'retval', return value is always 0.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1609308450-50695-1-git-send-email-abaci-bugfix@linux.alibaba.com>
References: <1609308450-50695-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 05 Jan 2021 15:58:07 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YANG LI <abaci-bugfix@linux.alibaba.com>
Date: Wed, 30 Dec 2020 14:07:30 +0800

> The warning was because of the following line in function
> liquidio_set_fec():
> 
> retval = wait_for_sc_completion_timeout(oct, sc, 0);
>     if (retval)
> 	return (-EIO);
> 
> If this statement is not true, retval must be 0 and not updated
> later. So, It is better to return 0 directly.
> 
> Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
> Reported-by: Abaci <abaci@linux.alibaba.com>

Maybe you can remove the rest of the 'retval' usage in this function
and even the variable itself?

Thanks.
