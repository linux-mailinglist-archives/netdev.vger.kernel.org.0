Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7141217EBD8
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 23:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbgCIWUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 18:20:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbgCIWUA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 18:20:00 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D3C624654;
        Mon,  9 Mar 2020 22:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583792399;
        bh=ZJtZiykW+wPpJkAdPJ0nRh9taSQireaiYv8qSzpmc+o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DON07o2Tif243lRX6sXp8xOD+QoHYB71pqGDVyujS+qNp5aU3nPeJUkdj4tadtNto
         5p8s8XOqtiFrq81+trfigo0twI4Y5y5RZg3dtrUb6CY380nQUjjDVmMQFuC2vSgmVK
         lq5KMDG3fJp9tCHuyauWlOJeFwTsBmoHRlKrauXU=
Date:   Mon, 9 Mar 2020 15:19:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leslie Monis <lesliemonis@gmail.com>
Cc:     Linux NetDev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        Gautam Ramakrishnan <gautamramk@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] net: sched: pie: change tc_pie_xstats->prob
Message-ID: <20200309151957.313e0428@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200309191033.2975-1-lesliemonis@gmail.com>
References: <20200309191033.2975-1-lesliemonis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Mar 2020 00:40:33 +0530 Leslie Monis wrote:
> Commit 105e808c1da2 ("pie: remove pie_vars->accu_prob_overflows")
> changes the scale of probability values in PIE from (2^64 - 1) to
> (2^56 - 1). This affects the precision of tc_pie_xstats->prob in
> user space.
> 
> This patch ensures user space is unaffected.
> 
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Leslie Monis <lesliemonis@gmail.com>

Thanks, I was looking out for user space changes during review but it
was too hard to catch this until the iproute2 patch surfaced :(

I'd be good to post the user space changes along the kernel side.
iproute2 maintainers just wait for the kernel part to land in that case.
