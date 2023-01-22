Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8381677220
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 20:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbjAVTwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 14:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjAVTwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 14:52:40 -0500
Received: from smtp.smtpout.orange.fr (smtp-20.smtpout.orange.fr [80.12.242.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7169F1BEF
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 11:52:39 -0800 (PST)
Received: from [192.168.1.18] ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id JgOKpmcwBobXwJgOKp81Ee; Sun, 22 Jan 2023 20:52:37 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 22 Jan 2023 20:52:37 +0100
X-ME-IP: 86.243.2.178
Message-ID: <6d9053c6-b56e-51f4-db47-79264f1f5672@wanadoo.fr>
Date:   Sun, 22 Jan 2023 20:52:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] net/bonding: Fix full name of the GPL
Content-Language: fr
To:     Diederik de Haas <didi.debian@cknow.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:BONDING DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Newsgroups: gmane.linux.network,gmane.linux.kernel
References: <20230122182048.54710-1-didi.debian@cknow.org>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20230122182048.54710-1-didi.debian@cknow.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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

