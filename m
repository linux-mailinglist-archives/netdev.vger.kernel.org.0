Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30C32B1198
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 23:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgKLWfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 17:35:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:38012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbgKLWfA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 17:35:00 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A721020825;
        Thu, 12 Nov 2020 22:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605220500;
        bh=DPpGNEp3QpEQZKCkATmb8VY3xAAqrDgp8Q9zJEfWruE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2oldK9+N0D+CW7OimzYk1vnHC0IxhcJlwfGj5+dU+caX0Gmueaie8FIrMnafHkSP1
         ETA7Ua94EEDO9N5Za5/2/2EY1RQJd2HYPijwMB3Fb4+fi5nS21vXyysQN3kSbVuTtH
         i0uMY65GbXY1cAE/Gwby0f9mMY5b8c5DjCUpa4fA=
Date:   Thu, 12 Nov 2020 14:34:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: Re: [PATCH net-next v2 0/3] xilinx_emaclite W=1 fixes
Message-ID: <20201112143458.46e2a779@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201110024024.1479741-1-andrew@lunn.ch>
References: <20201110024024.1479741-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 03:40:21 +0100 Andrew Lunn wrote:
> kerneldoc, pointer issues, and add COMPILE_TEST support to easy
> finding future issues via build testing.
> 
> v2:
> Use uintptr_t instead of long
> Added Acked-by's.

Applied, thank you!
