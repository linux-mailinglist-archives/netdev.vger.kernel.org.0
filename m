Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEAFCC249D
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 17:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732137AbfI3Ppi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 11:45:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:34810 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731865AbfI3Ppi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 11:45:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4B75DAFE4;
        Mon, 30 Sep 2019 15:45:36 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id D0417E0083; Mon, 30 Sep 2019 17:45:35 +0200 (CEST)
Date:   Mon, 30 Sep 2019 17:45:35 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: ERROR: "__umoddi3"
 [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!
Message-ID: <20190930154535.GC22120@unicorn.suse.cz>
References: <20190930141316.GG29694@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930141316.GG29694@zn.tnic>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 04:13:17PM +0200, Borislav Petkov wrote:
> I'm seeing this on i386 allyesconfig builds of current Linus master:
> 
> ERROR: "__umoddi3" [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2

This is usually result of dividing (or modulo) by a 64-bit integer. Can
you identify where (file and line number) is the __umoddi3() call
generated?

Michal
