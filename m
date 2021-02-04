Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9B230E88C
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbhBDAdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:33:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:35692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233331AbhBDAdo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 19:33:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DF3464F4C;
        Thu,  4 Feb 2021 00:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612398783;
        bh=XlrQNpV7bf/3l1Dc4RbXW1wet5dcOjy37FCiV/h0PSg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T4Ndx8xUN8vZienx46n/fUHVxfS1WxWtiS0G9Cz8IIjGiG1keVcRVBZVJF5AVVPXp
         83/pDIQuzS4Qles8yy5jIpCyWORtGIlqcSFaSfmbEwhXvp7kUsR+FMMeSLlfB4ADxh
         RO4h+GuKBkSOm4VRgiHnHtY1KyJT3BSlVHIDUYSI0gHFgcYxRphdHo58nSIgg9Fe4b
         Qnw0SsOW9DreAy7znkQFWDLkFKAVFH39zw+yxEzzpq8C7uPMvOFfdstn8XykDH5EVc
         GurwFeEOoh2RCC98cljRhHKMxmIvyyHdeNMsiLnyy0wzUAIobQnexZ+6LWh3k6uHaI
         k1PglnT+ikhxg==
Date:   Wed, 3 Feb 2021 16:33:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 1/4] batman-adv: Start new development cycle
Message-ID: <20210203163302.13e8a2a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210202174037.7081-2-sw@simonwunderlich.de>
References: <20210202174037.7081-1-sw@simonwunderlich.de>
        <20210202174037.7081-2-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Feb 2021 18:40:33 +0100 Simon Wunderlich wrote:
> Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
> ---
>  net/batman-adv/main.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/batman-adv/main.h b/net/batman-adv/main.h
> index 288201630ceb..2486efe4ffa6 100644
> --- a/net/batman-adv/main.h
> +++ b/net/batman-adv/main.h
> @@ -13,7 +13,7 @@
>  #define BATADV_DRIVER_DEVICE "batman-adv"
>  
>  #ifndef BATADV_SOURCE_VERSION
> -#define BATADV_SOURCE_VERSION "2021.0"
> +#define BATADV_SOURCE_VERSION "2021.1"
>  #endif
>  
>  /* B.A.T.M.A.N. parameters */

For just comment adjustments and the sizeof() change?
