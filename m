Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8124825E9D4
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 21:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgIETYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 15:24:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728400AbgIETY3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 15:24:29 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C26C2074D;
        Sat,  5 Sep 2020 19:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599333869;
        bh=xKpvVdosNs4RDFZVqHZRXePPNzuX/aOgjIjjBn631Wk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QGo+7qe+fu/nEGablVzLQIvt0Jb0H/C65gLkzBm2HN4ZkjYdWnvP3uk+nxz5HhWpV
         pzsFy5FBWnNd+CasnRBGKs72bATnf9xpezwjsKjUm328B1KHUp5AoN9mw8ApSvqwgA
         /WDjVgACVjUfvsnMc3K4Gv4KSZrJm/kjC9FktKiM=
Date:   Sat, 5 Sep 2020 12:24:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 0/6] sfc: TXQ refactor
Message-ID: <20200905122427.531f31bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <02b2bb5a-f360-68cb-3c13-b72ced1ecd7b@solarflare.com>
References: <02b2bb5a-f360-68cb-3c13-b72ced1ecd7b@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Sep 2020 22:30:58 +0100 Edward Cree wrote:
> Refactor and unify partner-TXQ handling in the EF100 and legacy drivers.
> 
> The main thrust of this series is to remove from the legacy (Siena/EF10)
>  driver the assumption that a netdev TX queue has precisely two hardware
>  TXQs (checksummed and unchecksummed) associated with it, so that in
>  future we can have more (e.g. for handling inner-header checksums) or
>  fewer (e.g. to free up hardware queues for XDP usage).
> 
> Changes from v1:
>  * better explain patch #1 in the commit message, and rename
>    xmit_more_available to xmit_pending
>  * add new patch #2 applying the same approach to ef100, for consistency

Applied, thanks!
