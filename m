Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46AD1677227
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 20:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjAVT5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 14:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbjAVT5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 14:57:48 -0500
X-Greylist: delayed 301 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 22 Jan 2023 11:57:47 PST
Received: from ciao.gmane.io (ciao.gmane.io [116.202.254.214])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D40830CD
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 11:57:46 -0800 (PST)
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <gl-netdev-2@m.gmane-mx.org>)
        id 1pJgOQ-0001to-PJ
        for netdev@vger.kernel.org; Sun, 22 Jan 2023 20:52:42 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     netdev@vger.kernel.org
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH] net/bonding: Fix full name of the GPL
Date:   Sun, 22 Jan 2023 20:52:33 +0100
Message-ID: <6d9053c6-b56e-51f4-db47-79264f1f5672@wanadoo.fr>
References: <20230122182048.54710-1-didi.debian@cknow.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: fr
In-Reply-To: <20230122182048.54710-1-didi.debian@cknow.org>
Cc:     linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 22/01/2023 à 19:20, Diederik de Haas a écrit :
> Signed-off-by: Diederik de Haas <didi.debian@cknow.org>
> ---
>   drivers/net/bonding/bonding_priv.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/bonding/bonding_priv.h b/drivers/net/bonding/bonding_priv.h
> index 48cdf3a49a7d..353972436e5b 100644
> --- a/drivers/net/bonding/bonding_priv.h
> +++ b/drivers/net/bonding/bonding_priv.h
> @@ -8,7 +8,7 @@
>    * (c) Copyright 1999, Thomas Davis, tadavis@lbl.gov
>    *
>    *	This software may be used and distributed according to the terms
> - *	of the GNU Public License, incorporated herein by reference.
> + *	of the GNU General Public License, incorporated herein by reference.
>    *
>    */
>   

Hi,

maybe a SPDX-License-Identifier: could be added and these few lines 
removed instead?

CJ


