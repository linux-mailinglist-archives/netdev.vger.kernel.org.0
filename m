Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC973664B2
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 07:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235126AbhDUFLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 01:11:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:54504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230440AbhDUFLC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 01:11:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4049D6105A;
        Wed, 21 Apr 2021 05:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618981830;
        bh=gDTv6Ws3dmiAvi6sW15n2JiYhMOJzINkMNlGAdGchIE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NMxNzSRnAAGnNumW9gSrxiCWk3sJBxRFXy+AOmTUBr4BNVY8gd+WVCqDapgGFwLmt
         NwSm+rO0py+PkwjfQhaRZ4Gw2XAk2ombhiKsAXwiS06GLwP8kXpWPvPIHdT8U7CGVL
         jbfNlAjMmaoWu6EETQ5Dat7jn1guk47kwOKRVGtwXPSJXYuM3dPmtPxHsycUf1544S
         Jj+Q5MRKWqrx9vYj111SkvVE78KVv2llcQNbVVI51ZsLiFLPDsJy39KQmcK1fcC7AR
         On4NjLtWK5qWryVFk9uIp9q2F9SL/4/Ux5FknOXDi317F1DSGyi2HP99puFc4GrRoi
         OkVsDhQ1wmAMg==
Date:   Wed, 21 Apr 2021 08:10:25 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "J. Bruce Fields" <bfields@fieldses.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Aditya Pakki <pakki001@umn.edu>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dave Wysochanski <dwysocha@redhat.com>,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
Message-ID: <YH+zwQgBBGUJdiVK@unreal>
References: <20210407001658.2208535-1-pakki001@umn.edu>
 <YH5/i7OvsjSmqADv@kroah.com>
 <20210420171008.GB4017@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420171008.GB4017@fieldses.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 01:10:08PM -0400, J. Bruce Fields wrote:
> On Tue, Apr 20, 2021 at 09:15:23AM +0200, Greg KH wrote:
> > If you look at the code, this is impossible to have happen.
> > 
> > Please stop submitting known-invalid patches.  Your professor is playing
> > around with the review process in order to achieve a paper in some
> > strange and bizarre way.
> > 
> > This is not ok, it is wasting our time, and we will have to report this,
> > AGAIN, to your university...
> 
> What's the story here?

Those commits are part of the following research:
https://github.com/QiushiWu/QiushiWu.github.io/blob/main/papers/OpenSourceInsecurity.pdf

They introduce kernel bugs on purpose. Yesterday, I took a look on 4
accepted patches from Aditya and 3 of them added various severity security
"holes".

Thanks

> 
> --b.
