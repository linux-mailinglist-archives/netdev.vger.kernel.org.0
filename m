Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237F24A5602
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 06:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiBAFDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 00:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiBAFDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 00:03:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD49C061714;
        Mon, 31 Jan 2022 21:03:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3068B810D8;
        Tue,  1 Feb 2022 05:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707D9C340EB;
        Tue,  1 Feb 2022 05:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643691794;
        bh=DaP0XzsPDkO61Q8HSPHaMmMeBirn8zN+B48qbUj6Qbc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mwvkSUh2kGVwHxCnBuhuEPVriIipVMaed4aFY2cQqE8xm7UkPNmt/itttHskCbBqX
         Csq3tbHXGbgt+C0kiyJVjGy8akdL6QkYTX05z1n5Ecm8Rcj5+JD1ci/cRW3DSWMuCk
         m3oq2/vjmY2oCF4mQL0yK7gLmwU/+fKXDsHu0AQMqp2M4sj/Hwzb+FocZLq8ue8tMx
         LmoXzrvNWlnl/rvXkbE8rlJe1ct02Z0NVM8mWmrwddumYsEH9wONkSK3pEHlPSmdRm
         kDT+rZqJwBH8KTQirJYCpuvOQbBVthn8dvwpHahMGkZs9dmIv8zsGtoXJKgqTyJ8xn
         9+89i2WBevzbg==
Date:   Mon, 31 Jan 2022 21:03:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeffrey Ji <jeffreyjilinux@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Brian Vazquez <brianvv@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jeffreyji <jeffreyji@google.com>
Subject: Re: [PATCH v5 net-next] net-core: add InMacErrors counter
Message-ID: <20220131210313.52292cf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220131181507.3470388-1-jeffreyji@google.com>
References: <20220131181507.3470388-1-jeffreyji@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Jan 2022 18:15:07 +0000 Jeffrey Ji wrote:
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index bf11e1fbd69b..c831e3a502f2 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -320,6 +320,7 @@ enum skb_drop_reason {
>  	SKB_DROP_REASON_TCP_CSUM,
>  	SKB_DROP_REASON_TCP_FILTER,

This got renamed on Thursday, you need to rebase on latest net-next.

>  	SKB_DROP_REASON_UDP_CSUM,
> +	SKB_DROP_REASON_OTHERHOST,
>  	SKB_DROP_REASON_MAX,
>  };
