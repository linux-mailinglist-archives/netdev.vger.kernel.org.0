Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD7641BBC7
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 02:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243447AbhI2Amq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 20:42:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242626AbhI2Amp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 20:42:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26D9260FBF;
        Wed, 29 Sep 2021 00:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632876065;
        bh=sy0qq7KHfQdVKkeOQD717wVZX8eSF8cMH0D/jJJxS5w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nSpkZYhYFkFJdBR4deD1skf88vM4/7/2tyoxsIyOJz85joRrE+AnAb/JGx+2j2Tn4
         BigCk0DgyKOupOS712czoPiPxs6V88JLbSusBZ5HewXGm0E6dOC1jaQsEYA4ouban5
         +BHQ+KoLsqVxdRCD6XJNAXii2mZPISoDru7j2ekrXgae8PMhzmv3sOGKpgA0WP4Hk1
         kaM6BVRtjhjjZIV+pUJnwFxbcpZLpNuwFGs9XMJ14LaLA88q7I6MV7CRSkBZnVVa3O
         CiskHX7nQ6fWG1EvZ67oIo7vDvhwaTRHaaTZfgXmY/d2qaz1KTNjObR35CtOD/7KRv
         X5pbaXULMpAEQ==
Date:   Tue, 28 Sep 2021 17:41:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mianhan Liu <liumh1@shanghaitech.edu.cn>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] net/ipv4/datagram.c: remove superfluous header
 files from datagram.c
Message-ID: <20210928174104.4c05448e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210928174943.8148-1-liumh1@shanghaitech.edu.cn>
References: <20210928174943.8148-1-liumh1@shanghaitech.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Sep 2021 01:49:43 +0800 Mianhan Liu wrote:
> datagram.c hasn't use any macro or function declared in linux/ip.h,
> and linux/module.h.
> Thus, these files can be removed from datagram.c safely without
> affecting the compilation of the net/ipv4 module
> 
> Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>
> 
> ---
>  net/ipv4/datagram.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
> index 4a8550c49..2dc5f1890 100644
> --- a/net/ipv4/datagram.c
> +++ b/net/ipv4/datagram.c
> @@ -8,8 +8,6 @@
>   */
>  
>  #include <linux/types.h>
> -#include <linux/module.h>

If we remove this one we need to add an include for linux/export.h

> -#include <linux/ip.h>

This indeed looks unnecessary.

>  #include <linux/in.h>
>  #include <net/ip.h>
>  #include <net/sock.h>

