Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8EB63F3624
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 23:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbhHTVqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 17:46:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229760AbhHTVqt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 17:46:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 003E560C41;
        Fri, 20 Aug 2021 21:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629495971;
        bh=dvXYyE008dY2XVm/6wcJwDcH+fUjvkok72nH9XXHRyc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NQ+hPQHZcFnLpHQ6ENtzfrOntz0BsUdik0+iTLrLJWz8sm6eF9Y5ayKMrxqQxriz7
         PRLGPeU1DH1sH4fOGFf0rkP5o3L9QnyU1G6Q83Nt+1JVi+wr46Poc+S/wN67sm4P5z
         veqke3VjlHVcA7R/oKxAIlFLdqChXU43aGqtGoQu1mY5e6OAOk/U81hHF1kJGvKnht
         wiEpq42SrKOJkjqaAe/ezRm3j/Od5mJo8yNt0Y12UIHIjp6MypbiBJUIYTrEEw0Flm
         qf2ARu2fmvZsz0/TAOHAQMUEc57Ad0q6JlqHi2DnxVVYG2R5ZR+65I7ORAyfKmEXXD
         Rqya1PUPMyGgg==
Date:   Fri, 20 Aug 2021 14:46:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     netdev@vger.kernel.org, kernel-team@android.com,
        linux-kernel@vger.kernel.org,
        Matteo Croce <mcroce@linux.microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
Subject: Re: [PATCH net] stmmac: Revert "stmmac: align RX buffers"
Message-ID: <20210820144610.7576c36a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210820183002.457226-1-maz@kernel.org>
References: <20210820183002.457226-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Aug 2021 19:30:02 +0100 Marc Zyngier wrote:
> This reverts commit a955318fe67e ("stmmac: align RX buffers"),
> which breaks at least one platform (Nvidia Jetson-X1), causing
> packet corruption. This is 100% reproducible, and reverting
> the patch results in a working system again.
> 
> Given that it is "only" a performance optimisation, let's
> return to a known working configuration until we can have a
> good understanding of what is happening here.

Seems reasonable. Hopefully it wont discourage Matteo from revisiting
the optimization. Applied, thanks!
