Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE9B2241F2
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 19:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgGQRhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 13:37:14 -0400
Received: from ja.ssi.bg ([178.16.129.10]:49496 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726232AbgGQRhN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 13:37:13 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 06HHaalC011654;
        Fri, 17 Jul 2020 20:36:36 +0300
Date:   Fri, 17 Jul 2020 20:36:36 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Andrew Sy Kim <kim.andrewsy@gmail.com>
cc:     Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] ipvs: add missing struct name in ip_vs_enqueue_expire_nodest_conns
 when CONFIG_SYSCTL is disabled
In-Reply-To: <20200717162450.1049-1-kim.andrewsy@gmail.com>
Message-ID: <alpine.LFD.2.23.451.2007172032370.4536@ja.home.ssi.bg>
References: <20200717162450.1049-1-kim.andrewsy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Fri, 17 Jul 2020, Andrew Sy Kim wrote:

> Adds missing "*ipvs" to ip_vs_enqueue_expire_nodest_conns when
> CONFIG_SYSCTL is disabled
> 
> Signed-off-by: Andrew Sy Kim <kim.andrewsy@gmail.com>

Acked-by: Julian Anastasov <ja@ssi.bg>

	Pablo, please apply this too.

> ---
>  include/net/ip_vs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> index 91a9e1d590a6..9a59a33787cb 100644
> --- a/include/net/ip_vs.h
> +++ b/include/net/ip_vs.h
> @@ -1533,7 +1533,7 @@ static inline void ip_vs_enqueue_expire_nodest_conns(struct netns_ipvs *ipvs)
>  
>  void ip_vs_expire_nodest_conn_flush(struct netns_ipvs *ipvs);
>  #else
> -static inline void ip_vs_enqueue_expire_nodest_conns(struct netns_ipvs) {}
> +static inline void ip_vs_enqueue_expire_nodest_conns(struct netns_ipvs *ipvs) {}
>  #endif
>  
>  #define IP_VS_DFWD_METHOD(dest) (atomic_read(&(dest)->conn_flags) & \
> -- 
> 2.20.1

Regards

--
Julian Anastasov <ja@ssi.bg>
