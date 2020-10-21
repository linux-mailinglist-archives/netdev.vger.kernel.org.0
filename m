Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6562F294F86
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 17:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2444027AbgJUPIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 11:08:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2443878AbgJUPIk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 11:08:40 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 402E720BED;
        Wed, 21 Oct 2020 15:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603292919;
        bh=CWtby+TblFCsj7hiKNeGlWF7bXc2sJ9RQ/P5oSDZnjc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CKNkJCD1mKR7Nm14SOvrvM+JzMuE/EfE5SnNQVOXWtrxuWYt+KeXHmER4vioslHRG
         boQB8/RdFtj4fL6VSAonl4UmH64kve75uGIXHCVfXsg9ljnc4PDdJsRLsDWMDtWlKK
         XZcp2B5Cwjz/HizvrkYkMbSAtqFnipv22flvruIw=
Date:   Wed, 21 Oct 2020 08:08:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] mptcp: depends on IPV6 but not as a module
Message-ID: <20201021080836.5ad77e45@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201021105154.628257-1-matthieu.baerts@tessares.net>
References: <20201021105154.628257-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Oct 2020 12:51:53 +0200 Matthieu Baerts wrote:
> Like TCP, MPTCP cannot be compiled as a module. Obviously, MPTCP IPv6'
> support also depends on CONFIG_IPV6. But not all functions from IPv6
> code are exported.
> 
> To simplify the code and reduce modifications outside MPTCP, it was
> decided from the beginning to support MPTCP with IPv6 only if
> CONFIG_IPV6 was built inlined. That's also why CONFIG_MPTCP_IPV6 was
> created. More modifications are needed to support CONFIG_IPV6=m.

Applied, thanks!
