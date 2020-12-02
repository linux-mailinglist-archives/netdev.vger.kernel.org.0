Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E712CC75F
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731193AbgLBUCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:02:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:58300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729165AbgLBUCL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 15:02:11 -0500
Date:   Wed, 2 Dec 2020 12:01:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606939290;
        bh=CR+EL2ZIg5zPuyiVUwgwAYmi7H5wK9yp7oqtDbYE/Ec=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=VEmjDoMlah11tBUxdG2tdsnTW/vE4/1L6aQhlJWUs5p8rplWcR6Th09MESX/fRokT
         inv2VRfXp6qeubM9mvoY2CZ8K3nXr9dBTnhtEamR5EqirUqrJ0brUgYN62gpbXiRQn
         BAdn7V3cH6seTQOaVbDWUomINbZ1gnh/fqNc0YEbJlfiWsCQZP/q+qaYssu2PbuyrF
         wL5z2Rvk4bci1BIGKUDpJBUVSsHFDoQ3gbHPz57NQD66Udy25v4MpjnbOxeC9ig+wV
         wTUYjbQ5bqgfHznWsAip+kqtnwU8cSi6P0p+Q4LR91elwLHFBlHEdUSqhvix1cVPoO
         laVSQxvmAdKbQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Netdev List <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] octeontx2-af: debugfs: delete dead code
Message-ID: <20201202120127.7cc7453f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <CA+sq2Ceo3z1KAuOfZYsmRMHw4dHcnrRLtkRmALNHvj3=tRJKtA@mail.gmail.com>
References: <X8c6vpapJDYI2eWI@mwanda>
        <CA+sq2Ceo3z1KAuOfZYsmRMHw4dHcnrRLtkRmALNHvj3=tRJKtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Dec 2020 12:33:00 +0530 Sunil Kovvuri wrote:
> On Wed, Dec 2, 2020 at 12:28 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > These debugfs never return NULL so all this code will never be run.
> >
> > In the normal case, (and in this case particularly), the debugfs
> > functions are not supposed to be checked for errors so all this error
> > checking code can be safely deleted.
> >
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Thanks for the changes.

Applied, thanks!
