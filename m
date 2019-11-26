Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 257E110A702
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 00:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfKZXRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 18:17:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43836 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbfKZXRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 18:17:54 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9838414DB5953;
        Tue, 26 Nov 2019 15:17:53 -0800 (PST)
Date:   Tue, 26 Nov 2019 15:17:53 -0800 (PST)
Message-Id: <20191126.151753.744862410233394124.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     andrew@lunn.ch, olteanv@gmail.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: silence a static checker warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191126121854.6omnd7upthqsrwgj@kili.mountain>
References: <20191126121854.6omnd7upthqsrwgj@kili.mountain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 Nov 2019 15:17:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 26 Nov 2019 15:18:54 +0300

> This code is harmless but it triggers a Smatch static checker warning:
> 
>     net/dsa/tag_8021q.c:108 dsa_8021q_restore_pvid()
>     error: uninitialized symbol 'pvid'.
> 
> I believe that UBSan will complain at run time as well.  The solution is
> to just re-order the conditions.
> 
> Fixes: c80ed84e7688 ("net: dsa: tag_8021q: Fix dsa_8021q_restore_pvid for an absent pvid")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

THis doesn't apply to the current net tree.
