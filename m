Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529FD470504
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 16:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236854AbhLJQAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 11:00:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59462 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236700AbhLJQAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 11:00:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 250B4B828AA;
        Fri, 10 Dec 2021 15:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B21C341CA;
        Fri, 10 Dec 2021 15:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639151822;
        bh=zna+FdXtD3DNZdBDoBjRxKaQkeMOafWH2JTKGF9XsBQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lj/SfNHyPF/MWAAndG9Lz+JjRfmd6zbLChKSaoIGQBJGSaZckdRuVQJAJ27P26GOC
         OtGUz37HLzHdCUC7mPkYGgTFlJeIh+YbTOpym8nWXNGMxlVZSQvCG4AtuzP7i7O5VV
         McYROey8uC6/QZZ8e20fXJlETo77LeF7yZD3ZlvNgtTcShWC9lMgprVjVWkfF4csh+
         JvvLoR6/zo4k3AuY2rnz5Heam4iziOftTkKMDtHS28Q1azKQOA8n6fC6hGKIeGkbH5
         YxXMtxzW+nApPvuq8H/QXGbeTOUo57hpEqU+axaZSe2kQdmnWIAQQ4R0VI31DLcC7n
         8cbLqVPS4WbzQ==
Date:   Fri, 10 Dec 2021 07:57:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     cgel.zte@gmail.com, mathew.j.martineau@linux.intel.com,
        davem@davemloft.net, shuah@kernel.org, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ye Guojin <ye.guojin@zte.com.cn>,
        ZealRobot <zealci@zte.com.cn>
Subject: Re: [PATCH] selftests: mptcp: remove duplicate include in
 mptcp_inq.c
Message-ID: <20211210075701.06bfced2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b6c19c9c-de6c-225c-5899-789dfd8e7ae8@tessares.net>
References: <20211210071424.425773-1-ye.guojin@zte.com.cn>
        <ab84ca1f-0f43-d50c-c272-81f64ee31ce8@tessares.net>
        <20211210065437.27c8fe23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211210065644.192f5159@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <b6c19c9c-de6c-225c-5899-789dfd8e7ae8@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Dec 2021 16:36:06 +0100 Matthieu Baerts wrote:
> > Actually, I take that back, let's hear from Mat, he may want to take
> > the patch via his tree.  
> 
> We "rebase" our tree on top of net-next every night. I think for such
> small patches with no behaviour change and sent directly to netdev ML,
> it is probably best to apply them directly. I can check with Mat if it
> is an issue if you prefer.

Please do, I'm happy to apply the patch but Mat usually prefers to take
things thru MPTCP tree.

> I would have applied it in our MPTCP tree if we were sending PR, not to
> bother you for such patches but I guess it is best not to have us
> sending this patch a second time later :)
> 
> BTW, if you prefer us sending PR over batches of patches, please tell us!

Small preference for patches. It's good to have the code on the ML for
everyone to look at and mixed PR + patches are a tiny bit more clicking
for me.
