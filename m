Return-Path: <netdev+bounces-2127-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D34A700690
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 13:21:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68CB5281B21
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:21:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3CFBD507;
	Fri, 12 May 2023 11:21:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA00763AF;
	Fri, 12 May 2023 11:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BAFDC4339C;
	Fri, 12 May 2023 11:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683890482;
	bh=iWf2+ctagbyxUJDf+uXJKZH3IsmKptDDA43LqE8XhlM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qLJYR024ZODCYOIVYMBlBnFZwAYsInhdb5q77puh/dedefB3jaUxD0n1Gw6Jo19NR
	 2+bM4PZ/7XPv0DYBdM5jPr1oBUSWlbM/b9uyM/hCEHLvQnb7PCPqjPfYEJw3p7R23G
	 OCQAKnTy0UL9jyZo9VQ3GjmrD6X5nKQYbL3vCGn8=
Date: Fri, 12 May 2023 20:21:15 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux SPDX Licenses <linux-spdx@vger.kernel.org>,
	Linux DRI Development <dri-devel@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Networking <netdev@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Staging Drivers <linux-staging@lists.linux.dev>,
	Linux Watchdog Devices <linux-watchdog@vger.kernel.org>,
	Linux Kernel Actions <linux-actions@lists.infradead.org>,
	Diederik de Haas <didi.debian@cknow.org>,
	Kate Stewart <kstewart@linuxfoundation.org>,
	Philippe Ombredanne <pombredanne@nexb.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Airlie <airlied@redhat.com>,
	Karsten Keil <isdn@linux-pingi.de>,
	Jay Vosburgh <j.vosburgh@gmail.com>,
	Andy Gospodarek <andy@greyhouse.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sam Creasey <sammy@sammy.net>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Daniel Mack <daniel@zonque.org>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Guenter Roeck <linux@roeck-us.net>, Jan Kara <jack@suse.com>,
	Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Donald Becker <becker@scyld.com>,
	Michael Hipp <hippm@informatik.uni-tuebingen.de>,
	Richard Hirst <richard@sleepie.demon.co.uk>,
	Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH v2 05/10] net: ethernet: i825xx: Replace GPL boilerplate
 with SPDX identifier
Message-ID: <2023051205-shrouded-cymbal-7b9c@gregkh>
References: <20230512100620.36807-1-bagasdotme@gmail.com>
 <20230512100620.36807-6-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230512100620.36807-6-bagasdotme@gmail.com>

On Fri, May 12, 2023 at 05:06:16PM +0700, Bagas Sanjaya wrote:
> Replace unversioned GPL boilerplate notice on remaining i825xx files
> with appropriate SPDX identifier. For files that contains "extension to
> Linux kernel", use GPL 2.0, otherwise GPL 1.0+.
> 
> Cc: Donald Becker <becker@scyld.com>
> Cc: Michael Hipp <hippm@informatik.uni-tuebingen.de>
> Cc: Richard Hirst <richard@sleepie.demon.co.uk>
> Cc: Sam Creasey <sammy@sammy.net>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  drivers/net/ethernet/i825xx/82596.c      | 5 ++---
>  drivers/net/ethernet/i825xx/lasi_82596.c | 5 ++---
>  drivers/net/ethernet/i825xx/lib82596.c   | 5 ++---
>  drivers/net/ethernet/i825xx/sun3_82586.c | 4 +---
>  drivers/net/ethernet/i825xx/sun3_82586.h | 4 +---
>  5 files changed, 8 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/ethernet/i825xx/82596.c b/drivers/net/ethernet/i825xx/82596.c
> index 3ee89ae496d0ca..773d7aa29ef5fc 100644
> --- a/drivers/net/ethernet/i825xx/82596.c
> +++ b/drivers/net/ethernet/i825xx/82596.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-1.0+
>  /* 82596.c: A generic 82596 ethernet driver for linux. */
>  /*
>     Based on Apricot.c
> @@ -31,9 +32,7 @@
>     Driver skeleton
>     Written 1993 by Donald Becker.
>     Copyright 1993 United States Government as represented by the Director,
> -   National Security Agency. This software may only be used and distributed
> -   according to the terms of the GNU General Public License as modified by SRC,
> -   incorporated herein by reference.
> +   National Security Agency.
>  
>     The author may be reached as becker@scyld.com, or C/O
>     Scyld Computing Corporation, 410 Severn Ave., Suite 210, Annapolis MD 21403
> diff --git a/drivers/net/ethernet/i825xx/lasi_82596.c b/drivers/net/ethernet/i825xx/lasi_82596.c
> index 0af70094aba341..3e53e0c243ba04 100644
> --- a/drivers/net/ethernet/i825xx/lasi_82596.c
> +++ b/drivers/net/ethernet/i825xx/lasi_82596.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-1.0+
>  /* lasi_82596.c -- driver for the intel 82596 ethernet controller, as
>     munged into HPPA boxen .
>  
> @@ -59,9 +60,7 @@
>     Driver skeleton
>     Written 1993 by Donald Becker.
>     Copyright 1993 United States Government as represented by the Director,
> -   National Security Agency. This software may only be used and distributed
> -   according to the terms of the GNU General Public License as modified by SRC,
> -   incorporated herein by reference.
> +   National Security Agency.
>  
>     The author may be reached as becker@scyld.com, or C/O
>     Scyld Computing Corporation, 410 Severn Ave., Suite 210, Annapolis MD 21403
> diff --git a/drivers/net/ethernet/i825xx/lib82596.c b/drivers/net/ethernet/i825xx/lib82596.c
> index ca2fb303fcc6f6..67d248a7a6f49e 100644
> --- a/drivers/net/ethernet/i825xx/lib82596.c
> +++ b/drivers/net/ethernet/i825xx/lib82596.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-1.0+
>  /* lasi_82596.c -- driver for the intel 82596 ethernet controller, as
>     munged into HPPA boxen .
>  
> @@ -59,9 +60,7 @@
>     Driver skeleton
>     Written 1993 by Donald Becker.
>     Copyright 1993 United States Government as represented by the Director,
> -   National Security Agency. This software may only be used and distributed
> -   according to the terms of the GNU General Public License as modified by SRC,
> -   incorporated herein by reference.
> +   National Security Agency.
>  
>     The author may be reached as becker@scyld.com, or C/O
>     Scyld Computing Corporation, 410 Severn Ave., Suite 210, Annapolis MD 21403
> diff --git a/drivers/net/ethernet/i825xx/sun3_82586.c b/drivers/net/ethernet/i825xx/sun3_82586.c
> index 3909c6a0af89f9..f05f016cb3b0ea 100644
> --- a/drivers/net/ethernet/i825xx/sun3_82586.c
> +++ b/drivers/net/ethernet/i825xx/sun3_82586.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0-only

As you are mixing GPL-1.0 and GPL-2.0 conversions in the same patch, you
need to break this up and provide the justification for why you choose
the specific license for each one, as you can't just lump them all
together and expect us to understand the reasoning when you didn't
provide any.

thanks,

greg k-h

