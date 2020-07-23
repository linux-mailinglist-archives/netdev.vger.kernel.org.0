Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C714922B692
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 21:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbgGWTKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 15:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgGWTKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 15:10:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BF3C0619DC;
        Thu, 23 Jul 2020 12:10:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 100CF13B3DA0E;
        Thu, 23 Jul 2020 11:53:53 -0700 (PDT)
Date:   Thu, 23 Jul 2020 12:10:37 -0700 (PDT)
Message-Id: <20200723.121037.1733642913138811577.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     jreuter@yaina.de, yepeilin.cs@gmail.com, ralf@linux-mips.org,
        kuba@kernel.org, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, gregkh@linuxfoundation.org,
        syzkaller-bugs@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH net] AX.25: Prevent integer overflows in connect and
 sendmsg
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200723144957.GA293102@mwanda>
References: <20200722.175714.1713497446730685740.davem@davemloft.net>
        <20200723144957.GA293102@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jul 2020 11:53:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 23 Jul 2020 17:49:57 +0300

> We recently added some bounds checking in ax25_connect() and
> ax25_sendmsg() and we so we removed the AX25_MAX_DIGIS checks because
> they were no longer required.
> 
> Unfortunately, I believe they are required to prevent integer overflows
> so I have added them back.
> 
> Fixes: 8885bb0621f0 ("AX.25: Prevent out-of-bounds read in ax25_sendmsg()")
> Fixes: 2f2a7ffad5c6 ("AX.25: Fix out-of-bounds read in ax25_connect()")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thanks Dan.
