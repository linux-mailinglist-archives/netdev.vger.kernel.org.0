Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB212EEB39
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 03:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbhAHCTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 21:19:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:42754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbhAHCTq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 21:19:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 130E323601;
        Fri,  8 Jan 2021 02:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610072345;
        bh=yfghZdWtmDJlHXNcRP9Jz8r5JaDrPx3UsFfMlc1kpt0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AoI0iZz43CfAorelfgaTFZc6tFh59M3LxL1W3+5VpORI4Vb5wGtAonMr3megFuYaO
         44jrXbNZ9EG5RDsF4YWbjeWkKEuFzaWcGes2v+91K4hxmMOn2y7mgLngQXCmGSrxK+
         AyjA4kquWzfq5uEHq7zN/RtsXxQorqF5doZ0GEiy4a0OIxo/O9doQfVB1KXyC3nPJb
         D1k6hbnzXdAo7IyeNiO/eaXfdzQsrd1jgV7anYllgo94TZIZ3zmSA5eH4vrnpFf65Z
         CA37UfyR8CxcrNTwtPIPuHym2WAlPfS6iZe0ogVSWnzcDf83DoJiqvDp9Hh6p2YbmE
         5mrrHuleYRJbQ==
Date:   Thu, 7 Jan 2021 18:19:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <edumazet@google.com>,
        <dsahern@gmail.com>, <kernel-team@fb.com>
Subject: Re: [RESEND PATCH net-next v1 00/13] Generic zcopy_* functions
Message-ID: <20210107181904.74efb053@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210106221841.1880536-1-jonathan.lemon@gmail.com>
References: <20210106221841.1880536-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Jan 2021 14:18:28 -0800 Jonathan Lemon wrote:
> This is set of cleanup patches for zerocopy which are intended
> to allow a introduction of a different zerocopy implementation.
> 
> The top level API will use the skb_zcopy_*() functions, while
> the current TCP specific zerocopy ends up using msg_zerocopy_*()
> calls.
> 
> There should be no functional changes from these patches.

I realigned some lines to make checkpatch happy.

Applied, thanks!
