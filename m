Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C062AC832
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 23:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730294AbgKIWUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 17:20:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:53956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgKIWUx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 17:20:53 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBEEC206BE;
        Mon,  9 Nov 2020 22:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604960453;
        bh=5o++kBGtqvY/cH2LHogRFoYRDW40+gdKIWMOuMRsIbU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zychZuSRf00MA36kGvBXdeaA1NUgl93Q8/VASMJYNy0Xl0VZXbSYAuuD/P4vcrWTQ
         L1wYwfJybykYv6WM5/5XVWZXtKsH1r103Mi2fFwVe3N2Bpe7OwVqbMrHIZ8areEtJq
         kd5GAcq4vfgvXgjunvIXqRbV3/fLo+s/cVIc8C4A=
Date:   Mon, 9 Nov 2020 14:20:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [MPTCP][PATCH net 1/2] mptcp: fix static checker warnings in
 mptcp_pm_add_timer
Message-ID: <20201109142051.39f1cfaa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <62ab8297-41fc-446b-a09e-0b93118a478c@tessares.net>
References: <cover.1604930005.git.geliangtang@gmail.com>
        <ccf004469e02fb5bd7ec822414b9a98b0015f4a3.1604930005.git.geliangtang@gmail.com>
        <009ea5da-8a44-3ea2-1b9f-a658a09f3396@tessares.net>
        <20201109125703.7d82a34a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <62ab8297-41fc-446b-a09e-0b93118a478c@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020 21:23:33 +0000 (UTC) Matthieu Baerts wrote:
> 09 Nov 2020 21:57:05 Jakub Kicinski <kuba@kernel.org>:
> > On Mon, 9 Nov 2020 17:28:54 +0100 Matthieu Baerts wrote:  
> >> A small detail (I think): the Signed-off-by of the sender (Geliang)
> >> should be the last one in the list if I am not mistaken.
> >> But I guess this is not blocking.
> >>
> >> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>  
> >
> > I take it you'd like me to apply patch 1 directly to net?  
> 
> Sorry, I didn't know it was OK to apply only one patch of the series.
> Then yes, if you don't mind, please apply this patch :)

Not really, I was just establishing ownership ;)

Geliang Tang, please rebase on net and repost just the first patch.
It does not apply to net as is.
