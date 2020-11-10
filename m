Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4AAB2ACA88
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 02:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730040AbgKJBge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 20:36:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:33462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgKJBge (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 20:36:34 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA7ED2067B;
        Tue, 10 Nov 2020 01:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604972194;
        bh=0Zmk/EXN7dL1Zj0X2qA3B4HAJilTYNjtWCCsXT1YVKQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d6D8GZsJF3XvpvqdZ4yGauCVa9uQdWTgUlEs39AaxUTqE/fQTht3YrCX1MTHivu6r
         pHkP4eFWVwo6aNE5KSiiRrLk5a6W/4vC7ywZ2AQUq4y28yIpqRcxxD23+E63J7n8tn
         jiy8SgMBGG9vtG/6tz9waRw6NpPZ17LpVOKPH9Ws=
Date:   Mon, 9 Nov 2020 17:36:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, mptcp@lists.01.org
Subject: Re: [MPTCP] [PATCH net] mptcp: provide rmem[0] limit
Message-ID: <20201109173632.21c7045b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d49c966b-e2fe-e0c9-49ea-a7a2475f45cf@tessares.net>
References: <37af798bd46f402fb7c79f57ebbdd00614f5d7fa.1604861097.git.pabeni@redhat.com>
        <d49c966b-e2fe-e0c9-49ea-a7a2475f45cf@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020 18:20:50 +0100 Matthieu Baerts wrote:
> On 08/11/2020 19:49, Paolo Abeni wrote:
> > The mptcp proto struct currently does not provide the
> > required limit for forward memory scheduling. Under
> > pressure sk_rmem_schedule() will unconditionally try
> > to use such field and will oops.
> > 
> > Address the issue inheriting the tcp limit, as we already
> > do for the wmem one.
> > 
> > Fixes: ("mptcp: add missing memory scheduling in the rx path")
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>  
> 
> Good catch, thank you for this patch!
> 
> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Fixed up the tag and applied, thanks!
