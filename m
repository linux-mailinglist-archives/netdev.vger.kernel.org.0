Return-Path: <netdev+bounces-2128-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA3937006A4
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 13:23:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF3B41C211C5
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:23:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB39BD306;
	Fri, 12 May 2023 11:23:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6030EBA56;
	Fri, 12 May 2023 11:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07A0C433A8;
	Fri, 12 May 2023 11:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683890623;
	bh=LCee8NPgW5Z48oHs2X+4LDjkaisXA9d7iMkzZ/oL7EE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qawc5t5fo15Uxf3XH5wX4ydaoUgTaiH5Gxx8rNDVp/biF33zfq8hDHrcqmf5PcCRx
	 h5D6KyvrhmHBnN7SoDNKMu4CspgF+DSO0P+kgN08ypYVZZ3jPJDU6Ka94a2pzGDJPb
	 tn6BzE9cqryGUhjbkdQqBbBwgFOFgT0RJq0Y7/jo=
Date: Fri, 12 May 2023 20:23:37 +0900
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
	Manivannan Sadhasivam <mani@kernel.org>
Subject: Re: [PATCH v2 00/10] Treewide GPL SPDX conversion and cleanup (in
 response to Didi's GPL full name fixes)
Message-ID: <2023051243-bunch-goliath-7380@gregkh>
References: <20230512100620.36807-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230512100620.36807-1-bagasdotme@gmail.com>

On Fri, May 12, 2023 at 05:06:11PM +0700, Bagas Sanjaya wrote:
> I trigger this patch series as a response to Didi's GPL full name fix
> patches [1], for which all of them had been NAKed. In many cases, the
> appropriate correction is to use SPDX license identifier instead.
> 
> Often, when replacing license notice boilerplates with their equivalent
> SPDX identifier, the notice doesn't mention explicit GPL version. Greg
> [2] replied this question by falling back to GPL 1.0 (more precisely
> GPL 1.0+ in order to be compatible with GPL 2.0 used by Linux kernel),
> although there are exceptions (mostly resolved by inferring from
> older patches covering similar situation).
> 
> The series covers the same directories touched as Didi's ones, minus
> Documentation/ (as should have been inferred by SPDX tags on respective
> docs).
>

I'm glad to take these types of changes through the SPDX tree, but
please break them up into smaller changes that show the justification
for each type of change in each subsystem, so that we can evaluate them
on an individual basis.  As you did here, you are lumping things
together only by the existance of the file in the tree, not by the
logical type of change happening, which isn't ok.

Also, you can send them as subsystem-specific series, so as to not have
to cross-post all of the changes all over the place.  I doubt the drm
developers care about ethernet driver license issues :)

thanks,

greg k-h

