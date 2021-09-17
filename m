Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A8D410096
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 23:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235152AbhIQVKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 17:10:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231268AbhIQVKT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 17:10:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA83161074;
        Fri, 17 Sep 2021 21:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631912937;
        bh=D0t56trwMD2ZdvAjr2ueiL5b4vMyiepBQ/xO4U0qVKM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FDO5m22H3O8IwL6A+Fazy4juhH768103jDHHFoA35qEFzCkzAE834RbXF7DIJ8JA4
         F9s2uBC6ZJkIoi9GfHqZkl0Et/x3QtTzqImz2X7iIs6bsuzqSiYfIqTsqb84tvtgRI
         z/DVKWVGEAIQBzfdffjRvWcqQ7pI2hq0yQT2Ktc5XhQNEiw6nFl6gRGUv/TnFUItv6
         zA6WHPa7iXmHD7i/Xk8o1v9blM+IS0QNJOXNuSvaED6v3wyP0e1fst1MvHCUZv1FjV
         z2NnrAAArU+1dDORAqkUgNQrPcbVKjOnmKszDNWRhuSo7s7ht6q2/xo7PcMy5LWCY+
         8XkOxmoexFQsA==
Date:   Fri, 17 Sep 2021 14:08:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <min.li.xe@renesas.com>
Cc:     <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2 2/2] ptp: idt82p33: implement double dco time
 correction
Message-ID: <20210917140856.01a00f2e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1631911821-31142-2-git-send-email-min.li.xe@renesas.com>
References: <1631911821-31142-1-git-send-email-min.li.xe@renesas.com>
        <1631911821-31142-2-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Sep 2021 16:50:21 -0400 min.li.xe@renesas.com wrote:
> Current adjtime is not accurate when delta is smaller than 10000ns. So
> for small time correction, we will switch to DCO mode to pull phase
> more precisely in one second duration.

1. *Never* repost the patches when there is an ongoing discussion.

2. Always CC people who gave you feedback on the previous version.
