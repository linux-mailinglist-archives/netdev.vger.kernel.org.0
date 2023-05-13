Return-Path: <netdev+bounces-2345-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8EF47015E0
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 11:48:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB0B51C20941
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 09:48:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22A7E184C;
	Sat, 13 May 2023 09:48:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5F61846;
	Sat, 13 May 2023 09:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC4DC433EF;
	Sat, 13 May 2023 09:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683971334;
	bh=iuYMi2gjfYb+IRWU1fcP0fhm1yRE7Y7rTFV0Kcq9Po0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cqVMkhU2Vlu2aIkzA0B3BBAPxer/sw2uHOQgfaBoQX5cWieq28w+CJnfz1nD0uwPK
	 KzaLhiK7IW3qfQWePhC8l8/f2niN/MLo9LKhftYQ6m9PA433oT4Hf97QS6upliyh8B
	 +omhYPuYTmSDW3T8ss//v/muXhg8KmpiSgHrHMpGpX7rEsLcKAWmXpeyJJooS3SDQX
	 WzEkH9ulEUfW8Exss0nq5HviYQycqLM+YYWBgFn4zdeAqSL5cJs7hZHNdx++AkqidH
	 KOkMfkmZLzd+Apr5pVbG2TjCc0IuPkrQc8dGyUPJwZn9ZtIgBtfkkiQukzD/YokkLJ
	 pyCGbTtprTrFg==
Received: by pali.im (Postfix)
	id 79E187F9; Sat, 13 May 2023 11:48:51 +0200 (CEST)
Date: Sat, 13 May 2023 11:48:51 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
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
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Guenter Roeck <linux@roeck-us.net>, Jan Kara <jack@suse.com>,
	Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH v2 09/10] udf: Replace license notice with SPDX identifier
Message-ID: <20230513094851.d3qdlfbvfc67vpdl@pali>
References: <20230512100620.36807-1-bagasdotme@gmail.com>
 <20230512100620.36807-10-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230512100620.36807-10-bagasdotme@gmail.com>
User-Agent: NeoMutt/20180716

On Friday 12 May 2023 17:06:20 Bagas Sanjaya wrote:
> diff --git a/fs/udf/udftime.c b/fs/udf/udftime.c
> index fce4ad976c8c29..d0fce5348fd3f3 100644
> --- a/fs/udf/udftime.c
> +++ b/fs/udf/udftime.c
> @@ -1,21 +1,4 @@
> -/* Copyright (C) 1993, 1994, 1995, 1996, 1997 Free Software Foundation, Inc.
> -   This file is part of the GNU C Library.
> -   Contributed by Paul Eggert (eggert@twinsun.com).
> -
> -   The GNU C Library is free software; you can redistribute it and/or
> -   modify it under the terms of the GNU Library General Public License as
> -   published by the Free Software Foundation; either version 2 of the
> -   License, or (at your option) any later version.
> -
> -   The GNU C Library is distributed in the hope that it will be useful,
> -   but WITHOUT ANY WARRANTY; without even the implied warranty of
> -   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> -   Library General Public License for more details.
> -
> -   You should have received a copy of the GNU Library General Public
> -   License along with the GNU C Library; see the file COPYING.LIB.  If not,
> -   write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> -   Boston, MA 02111-1307, USA.  */
> +// SPDX-License-Identifier: GPL-2.0-only
>  
>  /*
>   * dgb 10/02/98: ripped this from glibc source to help convert timestamps

Please, dot not do this. It is really rude to people who worked on it in
past (even if they do not care about this particular file anymore) as
technically they still have ownership of this code / file. And such
change never remove their ownership or copyright in most countries.

