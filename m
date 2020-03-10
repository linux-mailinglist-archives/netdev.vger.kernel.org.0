Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 807A317F3A8
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 10:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgCJJb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 05:31:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726202AbgCJJbZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 05:31:25 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B78D1222D9;
        Tue, 10 Mar 2020 09:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583832685;
        bh=t25UkHsdqiAmL5id5DkT/0S/zMYlUz0ykPXLC+61pg0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yUZ85uBSAFi3j5w2Rir325Zpi9SfGpmo8dWuTCosUlYzNeAclJYILqFT6xDX8OKBo
         MgUYWzmDOGAkKoqbTUdQDdLvJTMhFQROuDADvJQlpUkVdrBN+1ZYblGSwq9zAO3j6K
         AU0P3ATnHvyHOaEvOGMTC5FDQW104QiP3GL+LYk4=
Date:   Tue, 10 Mar 2020 11:31:22 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, heiko.carstens@de.ibm.com,
        raspl@linux.ibm.com, ubraun@linux.ibm.com
Subject: Re: [PATCH v2 net] net/smc: cancel event worker during device removal
Message-ID: <20200310093122.GC242734@unreal>
References: <20200310083330.90427-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310083330.90427-1-kgraul@linux.ibm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 09:33:30AM +0100, Karsten Graul wrote:
> During IB device removal, cancel the event worker before the device
> structure is freed.
>
> Fixes: a4cf0443c414 ("smc: introduce SMC as an IB-client")
> Reported-by: syzbot+b297c6825752e7a07272@syzkaller.appspotmail.com
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
> Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
> ---
>  net/smc/smc_ib.c | 1 +
>  1 file changed, 1 insertion(+)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
