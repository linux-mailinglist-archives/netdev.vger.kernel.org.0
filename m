Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852B82A7515
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 02:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731327AbgKEBuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 20:50:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbgKEBuz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 20:50:55 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FD84206FB;
        Thu,  5 Nov 2020 01:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604541054;
        bh=Ly+BsMbdK4opqzvUk2uKS4WnSU1o6e2SYIPQmW/WhRE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QIlO4e6RfzDmDLp3LQFZwgw/8vnR1yvr/RuUjQJvlhNz3ri1zSQGMtvJJrAqX8q12
         1du+aJXpqBYFT9Hroacan8svBekj1msLKMkMbzJWXShoDcNUgp9Jbq15yLMnCOpUdL
         UxBAH7Tn39tUQCTBz0njtvKP0ch51PDjYsF/2FZ4=
Date:   Wed, 4 Nov 2020 17:50:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org, davem@davemloft.net
Subject: Re: [PATCH net-next v2 0/7] mptcp: Miscellaneous MPTCP fixes
Message-ID: <20201104175053.008ee35a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201103190509.27416-1-mathew.j.martineau@linux.intel.com>
References: <20201103190509.27416-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Nov 2020 11:05:02 -0800 Mat Martineau wrote:
> This is a collection of small fixup and minor enhancement patches that
> have accumulated in the MPTCP tree while net-next was closed. These are
> prerequisites for larger changes we have queued up.
> 
> Patch 1 refines receive buffer autotuning.
> 
> Patches 2 and 4 are some minor locking and refactoring changes.
> 
> Patch 3 improves GRO and RX coalescing with MPTCP skbs.
> 
> Patches 5-7 add a sysctl for tuning ADD_ADDR retransmission timeout,
> corresponding test code, and documentation.
> 
> 
> v2: Add sysctl documentation and fix signoff tags.

Applied, thanks!
