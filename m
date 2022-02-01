Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDBBA4A581E
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 08:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbiBAHxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 02:53:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49032 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234313AbiBAHxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 02:53:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42542B82C0A
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 07:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62281C340EB;
        Tue,  1 Feb 2022 07:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643701992;
        bh=uaW9qAVFxjBGB8/pAocH71Fvm7l2OtnUkktpxgYo+hE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Iv5KI8hs96hlVGXpoFAqdbGgw3DKyqP5SjN4RT8hwGHQsgIP1aLHU3wDRtchHThan
         I1zl1JAc4/D5XyGz3B55Iv4qJRpCVV1+OontWP2xWhr2mjK+3yEJ/rMenO48LCcJHe
         hwZVlf55NavzKUinsAFMIJ9a8Oyilx4fEGOzvPmwRxm/sXLl3UymFVYm53mKBgXlY5
         Q0aBx6Cr3pRvhzVwSrzjIoFsqOtZI1HtOz96V0Tfp2VRSCQMTyaywrfXjoMLTSgQri
         xgsf1VazhF85usPVnjIq/ip0Tw+QAaa0qu4FF1n1SeacEvaED6/ZlfUX/wy956V333
         rqo6tBuQjMyrw==
Date:   Tue, 1 Feb 2022 09:53:08 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org
Subject: Re: [PATCH ipsec-next] xfrm: delete not-used XFRM_OFFLOAD_IPV6 define
Message-ID: <Yfjm5FKAc65whUAc@unreal>
References: <31811e3cf276ae2af01574f4fbcb127b88d9c6b5.1643307803.git.leonro@nvidia.com>
 <20220201065836.GT1223722@gauss3.secunet.de>
 <YfjfqWRVr4KpkQC8@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfjfqWRVr4KpkQC8@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 09:22:17AM +0200, Leon Romanovsky wrote:
> On Tue, Feb 01, 2022 at 07:58:36AM +0100, Steffen Klassert wrote:
> > On Thu, Jan 27, 2022 at 08:24:58PM +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > XFRM_OFFLOAD_IPV6 define was exposed in the commit mentioned in the
> > > fixes line, but it is never been used both in the kernel and in the
> > > user space. So delete it.
> > 
> > How can you be sure that is is not used in userspace? At least some
> > versions of strongswan set that flag. So even if it is meaningless
> > in the kernel, we can't remove it.
> 
> I looked over all net/* and include/uapi/* code with "git log -p" and didn't
> see any use of this flag ever. 

And in my search on github, I didn't see anyone except strongswan who
used this flag.

Thanks
