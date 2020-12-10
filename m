Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A40C2D5945
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 12:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389527AbgLJLbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 06:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389512AbgLJLaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 06:30:52 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with UTF8SMTPS id 77BE5C0613CF;
        Thu, 10 Dec 2020 03:30:37 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4CsBYJ2d3xz9shn; Thu, 10 Dec 2020 22:30:28 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Geoff Levand <geoff@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Jim Paris <jim@jtan.com>,
        Takashi Iwai <tiwai@suse.com>,
        Uwe =?ISO-8859-1?Q?=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        dri-devel@lists.freedesktop.org, linuxppc-dev@lists.ozlabs.org,
        linux-scsi@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        alsa-devel@alsa-project.org, linux-block@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <20201126165950.2554997-1-u.kleine-koenig@pengutronix.de>
References: <20201126165950.2554997-1-u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 1/2] ALSA: ppc: drop if block with always false condition
Message-Id: <160756606231.1313423.17458520968397977116.b4-ty@ellerman.id.au>
Date:   Thu, 10 Dec 2020 22:30:28 +1100 (AEDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Nov 2020 17:59:49 +0100, Uwe Kleine-König wrote:
> The remove callback is only called for devices that were probed
> successfully before. As the matching probe function cannot complete
> without error if dev->match_id != PS3_MATCH_ID_SOUND, we don't have to
> check this here.

Applied to powerpc/next.

[1/2] ALSA: ppc: drop if block with always false condition
      https://git.kernel.org/powerpc/c/7ff94669e7d8e50756cd57947283381ae9665759
[2/2] powerpc/ps3: make system bus's remove and shutdown callbacks return void
      https://git.kernel.org/powerpc/c/6d247e4d264961aa3b871290f9b11a48d5a567f2

cheers
