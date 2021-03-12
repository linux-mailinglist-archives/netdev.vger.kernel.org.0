Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B24633961E
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 19:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbhCLSTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 13:19:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:38280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232933AbhCLSSt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 13:18:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8DB764F51;
        Fri, 12 Mar 2021 18:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615573129;
        bh=el47MRlvq5YP0F+IS4GkzyIsQCa5FbOXnNo35R/Li0Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F9x4m4MK2zCqTlc689mI7iMmT0M97oOEy7FOBUYbfegj5fTKZb/vPTGokF3bvdeBy
         gv0uCbqlfTm+LM2jqfqbOCSIa97fKuYJ5YgwHMUa6Dlr819vXJezm/yAXeY+BO9WV1
         oAfpUUfbQo6h0tiDmRh8awTVq33wWVzDbZhPQILSFMVLyToAuaONXz7b7fYIRmHuVU
         oS8DJrJy7xhS2O0MAcQRbPKy85B2cH8f2Ov6G/rwnnw68PzFqBRA9ekBtMbRxMe5tU
         UYj7152MIlbIv+/bvjkohXTO3me1bb+hvdq5EznOaBw2HTvTcGQBAkJtQuF69PnbUB
         MCqGj8VZJLu/w==
Date:   Fri, 12 Mar 2021 10:18:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neil Spring <ntspring@fb.com>
Subject: Re: [PATCH net-next 0/3] tcp: better deal with delayed TX
 completions
Message-ID: <20210312101847.7391bb8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210311203506.3450792-1-eric.dumazet@gmail.com>
References: <20210311203506.3450792-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Mar 2021 12:35:03 -0800 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Jakub and Neil reported an increase of RTO timers whenever
> TX completions are delayed a bit more (by increasing
> NIC TX coalescing parameters)
> 
> While problems have been there forever, second patch might
> introduce some regressions so I prefer not backport
> them to stable releases before things settle.
> 
> Many thanks to FB team for their help and tests.
> 
> Few packetdrill tests need to be changed to reflect
> the improvements brought by this series.

FWIW I run some workloads with this for a day and looks good:

Tested-by: Jakub Kicinski <kuba@kernel.org>

Thank you!
