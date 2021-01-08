Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8282EEB72
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 03:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbhAHCnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 21:43:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:44592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726566AbhAHCnU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 21:43:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77D3D23603;
        Fri,  8 Jan 2021 02:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610073759;
        bh=mAzFsBnALbRAw8MytA8IqEYz8JwOkyAkdFv/I7JONzE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A7EMmbKmC826NcUu3pME4GN8RmQ0wH2YssQfkcBt0Z6xrDC7E2JGmqjVNOAqKzt8B
         cXe0KdWlOgcBYe9pNIrJcolVu0w5hSV6JSfXKQeJxL6WV1OpL4PsHOISXBExVIS8/k
         RWWUzHRZnVTEWLcjIznyPAl5raOMWWDtYDjFTiz5IuAOCvk66iwXj+PonU2ahL8SQn
         9TM9GMQhWJgtN2vb/zMQOUU9YEmZXVHMoGUHvTxPXAdRRc+EZRKtD+nJPIi8je1OTb
         6gBMTyRIStB9cIY5BnySOsL21ZhIkoPkNfE7kYVD0BuJPknrcnI3LXdivTJ9GAdtTO
         lI8IQF9GxDSLw==
Date:   Thu, 7 Jan 2021 18:42:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Colin King <colin.king@canonical.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Nithya Mani <nmani@marvell.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] octeontx2-af: fix memory leak of lmac and lmac->name
Message-ID: <20210107184238.36841971@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CA+sq2CcPRuQijfOFA74KrNF9E5tj-QqH_0nNC21fT=rqkuuCcw@mail.gmail.com>
References: <20210107123916.189748-1-colin.king@canonical.com>
        <CA+sq2CcPRuQijfOFA74KrNF9E5tj-QqH_0nNC21fT=rqkuuCcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jan 2021 22:31:30 +0530 Sunil Kovvuri wrote:
> On Thu, Jan 7, 2021 at 6:11 PM Colin King <colin.king@canonical.com> wrote:
> >
> > From: Colin Ian King <colin.king@canonical.com>
> >
> > Currently the error return paths don't kfree lmac and lmac->name
> > leading to some memory leaks.  Fix this by adding two error return
> > paths that kfree these objects
> >
> > Addresses-Coverity: ("Resource leak")
> > Fixes: 1463f382f58d ("octeontx2-af: Add support for CGX link management")
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> Thanks for the fix, looks good to me.

Consider venturing an Acked-by tag in the future so it can be recorded 
in git.

Applied, thanks!
