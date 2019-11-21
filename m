Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBF01105A8A
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 20:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfKUTmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 14:42:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52328 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUTmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 14:42:33 -0500
Received: from localhost (unknown [IPv6:2001:558:600a:cc:f9f3:9371:b0b8:cb13])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6F6AD1503D3D2;
        Thu, 21 Nov 2019 11:42:32 -0800 (PST)
Date:   Thu, 21 Nov 2019 11:42:31 -0800 (PST)
Message-Id: <20191121.114231.144140953957043920.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] octeontx2-af: Fix uninitialized variable in
 debugfs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191121092146.hnvdwnzpirskw3wr@kili.mountain>
References: <20191121092146.hnvdwnzpirskw3wr@kili.mountain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Nov 2019 11:42:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 21 Nov 2019 12:21:46 +0300

> If rvu_get_blkaddr() fails, then this rvu_cgx_nix_cuml_stats() returns
> zero and we write some uninitialized data into the debugfs output.
> 
> On the error paths, the use of the uninitialized "*stat" is harmless,
> but it will lead to a Smatch warning (static analysis) and a UBSan
> warning (runtime analysis) so we should prevent that as well.
> 
> Fixes: f967488d095e ("octeontx2-af: Add per CGX port level NIX Rx/Tx counters")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
