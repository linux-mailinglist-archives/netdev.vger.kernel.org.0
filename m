Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92D134B609
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 11:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbhC0KS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 06:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbhC0KSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 06:18:35 -0400
Received: from smtp.gentoo.org (mail.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6E7C0613B1;
        Sat, 27 Mar 2021 03:18:30 -0700 (PDT)
Received: by sf.home (Postfix, from userid 1000)
        id 536595A22061; Sat, 27 Mar 2021 10:18:18 +0000 (GMT)
Date:   Sat, 27 Mar 2021 10:18:18 +0000
From:   Sergei Trofimovich <slyfox@gentoo.org>
To:     linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] ia64: tools: add generic errno.h definition
Message-ID: <YF8GapSa+3zU3fqM@sf>
References: <20210312075136.2037915-1-slyfox@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312075136.2037915-1-slyfox@gentoo.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 07:51:35AM +0000, Sergei Trofimovich wrote:
> Noticed missing header when build bpfilter helper:
> 
>     CC [U]  net/bpfilter/main.o
>   In file included from /usr/include/linux/errno.h:1,
>                    from /usr/include/bits/errno.h:26,
>                    from /usr/include/errno.h:28,
>                    from net/bpfilter/main.c:4:
>   tools/include/uapi/asm/errno.h:13:10: fatal error:
>     ../../../arch/ia64/include/uapi/asm/errno.h: No such file or directory
>      13 | #include "../../../arch/ia64/include/uapi/asm/errno.h"
>         |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> CC: linux-kernel@vger.kernel.org
> CC: netdev@vger.kernel.org
> CC: bpf@vger.kernel.org
> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>

Any chance to pick it up?

Thanks!

> ---
>  tools/arch/ia64/include/uapi/asm/errno.h | 1 +
>  1 file changed, 1 insertion(+)
>  create mode 100644 tools/arch/ia64/include/uapi/asm/errno.h
> 
> diff --git a/tools/arch/ia64/include/uapi/asm/errno.h b/tools/arch/ia64/include/uapi/asm/errno.h
> new file mode 100644
> index 000000000000..4c82b503d92f
> --- /dev/null
> +++ b/tools/arch/ia64/include/uapi/asm/errno.h
> @@ -0,0 +1 @@
> +#include <asm-generic/errno.h>
> -- 
> 2.30.2
> 

-- 

  Sergei
