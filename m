Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D852CDAFD
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 17:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389358AbgLCQRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 11:17:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389290AbgLCQRR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 11:17:17 -0500
Date:   Thu, 3 Dec 2020 08:16:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607012196;
        bh=QJmUDO6xhsojn4u+7OnFYC2Zb/LB/D8bhycoXV7Ge5o=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=iy8pqoJRWtKYNDvEMxxQEsj0DT5h6dYrsNGDxF+h61FtYpzek0h5SQhb8KaD+w6xf
         rbI/DpAjnKQu1TYyDs6dXMJfGZbP6nIiTImsM8reRnh3MDaPs2LF+Dm2q7I4PA764e
         VOXeY+y27e6TszTrQ2S9iZrsR/cBjeBGydV/53rHohws8kDdWeCyrT+ChKEwd0CFDu
         RgObSJ5Xh7JI86z47n5s746duEcZXfDjIdl+NWYuHrKx5tFvLZvt8LOPdCmraPVEum
         X9FOMgj/PiBSwI2SkuJsGoSWtlFgXE/Jwmky1FmSSn70KSoQSVQ9Ia+R5mVcqkmBmN
         8WjYR1JcnyESw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>
Subject: Re: [PATCH net-next v2 1/1] ibmvnic: add some debugs
Message-ID: <20201203081634.346d0c24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201203033319.GA2305828@us.ibm.com>
References: <20201124043407.2127285-1-sukadev@linux.ibm.com>
        <20201124095949.1828b419@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201203033319.GA2305828@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Dec 2020 19:33:19 -0800 Sukadev Bhattiprolu wrote:
> Jakub Kicinski [kuba@kernel.org] wrote:
> > On Mon, 23 Nov 2020 20:34:07 -0800 Sukadev Bhattiprolu wrote:  
> > > We sometimes run into situations where a soft/hard reset of the adapter
> > > takes a long time or fails to complete. Having additional messages that
> > > include important adapter state info will hopefully help understand what
> > > is happening, reduce the guess work and minimize requests to reproduce
> > > problems with debug patches.
> > > 
> > > Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> > > ---
> > > 
> > > Changelog[v2]
> > > 	[Jakub Kacinski] Change an netdev_err() to netdev_info()? Changed
> > > 	to netdev_dbg() instead. Also sending to net rather than net-next.
> > > 
> > > 	Note: this debug patch is based on following bug fixes and a feature
> > > 	from Dany Madden and Lijun Pan:  
> > 
> > In which case you need to wait for these prerequisites to be in net-next
> > and then repost.  
> 
> Jakub,
> 
> A process question that I could not find an answer to on the netdev FAQ.
> 
> With commit 98c41f04a67a ("ibmvnic: reduce wait for completion time")
> the pre-requisites for the above patch are in the net tree but not yet
> in net-next.
> 
> When net-next is open, does it get periodically rebased to net tree or
> does the rebase happen only when net-next closes?

net is merged into net-next after each PR with fixes we send to Linus,
so they are merged periodically.

There is no schedule for it but I usually send a PR on Thu and merge
things late in the day on Thu or early Fri PST.

> If latter, should I resend above patch based on net-next and handle a
> manual merge during the rebase? (There is no functional dependence on
> the pre-reqs - just needs a manual merge).
