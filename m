Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945DA2A96FD
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 14:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbgKFN0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 08:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727214AbgKFN0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 08:26:45 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332F8C0613CF;
        Fri,  6 Nov 2020 05:26:45 -0800 (PST)
Received: from localhost.localdomain (p200300e9d7281e0351f2854eb5bb2248.dip0.t-ipconnect.de [IPv6:2003:e9:d728:1e03:51f2:854e:b5bb:2248])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id DA093C24DF;
        Fri,  6 Nov 2020 14:26:38 +0100 (CET)
Subject: Re: [PATCH] net/ieee802154: remove unused macros to tame gcc
To:     Alex Shi <alex.shi@linux.alibaba.com>, alex.aring@gmail.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1604650237-22192-1-git-send-email-alex.shi@linux.alibaba.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <b3d4a7bd-bccd-6eb0-f2b8-23f8ced67aab@datenfreihafen.org>
Date:   Fri, 6 Nov 2020 15:25:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1604650237-22192-1-git-send-email-alex.shi@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 06.11.20 09:10, Alex Shi wrote:
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Alexander Aring <alex.aring@gmail.com>
> Cc: Stefan Schmidt <stefan@datenfreihafen.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wpan@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>   net/ieee802154/nl802154.c | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> index 7c5a1aa5adb4..1cebdcedc48c 100644
> --- a/net/ieee802154/nl802154.c
> +++ b/net/ieee802154/nl802154.c
> @@ -2098,11 +2098,7 @@ static int nl802154_del_llsec_seclevel(struct sk_buff *skb,
>   #define NL802154_FLAG_NEED_NETDEV	0x02
>   #define NL802154_FLAG_NEED_RTNL		0x04
>   #define NL802154_FLAG_CHECK_NETDEV_UP	0x08
> -#define NL802154_FLAG_NEED_NETDEV_UP	(NL802154_FLAG_NEED_NETDEV |\
> -					 NL802154_FLAG_CHECK_NETDEV_UP)
>   #define NL802154_FLAG_NEED_WPAN_DEV	0x10
> -#define NL802154_FLAG_NEED_WPAN_DEV_UP	(NL802154_FLAG_NEED_WPAN_DEV |\
> -					 NL802154_FLAG_CHECK_NETDEV_UP)
>   
>   static int nl802154_pre_doit(const struct genl_ops *ops, struct sk_buff *skb,
>   			     struct genl_info *info)
> 


This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
