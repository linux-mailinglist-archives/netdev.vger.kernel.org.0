Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1491D436A85
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 20:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhJUS07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 14:26:59 -0400
Received: from ink.ssi.bg ([178.16.128.7]:60369 "EHLO ink.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231933AbhJUS06 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 14:26:58 -0400
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 5CA113C09B8;
        Thu, 21 Oct 2021 21:24:37 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.16.1/8.16.1) with ESMTP id 19LIOZ3h023797;
        Thu, 21 Oct 2021 21:24:35 +0300
Date:   Thu, 21 Oct 2021 21:24:34 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
cc:     Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: autoload ipvs on genl access
In-Reply-To: <20211021130255.4177-1-linux@weissschuh.net>
Message-ID: <c473dd-51ee-4358-4496-61c9c75f875@ssi.bg>
References: <20211021130255.4177-1-linux@weissschuh.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811672-1673610927-1634840677=:8245"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811672-1673610927-1634840677=:8245
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT


	Hello,

On Thu, 21 Oct 2021, Thomas Weißschuh wrote:

> The kernel provides the functionality to automatically load modules
> providing genl families. Use this to remove the need for users to
> manually load the module.
> 
> Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>

	Looks good to me for -next tree, thanks!

Acked-by: Julian Anastasov <ja@ssi.bg>

> ---
>  net/netfilter/ipvs/ip_vs_ctl.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index 29ec3ef63edc..0ff94c66641f 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -48,6 +48,8 @@
>  
>  #include <net/ip_vs.h>
>  
> +MODULE_ALIAS_GENL_FAMILY(IPVS_GENL_NAME);
> +
>  /* semaphore for IPVS sockopts. And, [gs]etsockopt may sleep. */
>  static DEFINE_MUTEX(__ip_vs_mutex);
>  
> 
> base-commit: d9aaaf223297f6146d9d7f36caca927c92ab855a
> -- 
> 2.33.1

Regards

--
Julian Anastasov <ja@ssi.bg>
---1463811672-1673610927-1634840677=:8245--
