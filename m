Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618EB256D01
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 11:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgH3JLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 05:11:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbgH3JLq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Aug 2020 05:11:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E151207BB;
        Sun, 30 Aug 2020 09:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598778705;
        bh=BWklOV6bppJJ3A+SKZXddiVUDib6q31F3dsVGTSMtbw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ai0UuHTnZlo4wf/I5Ov08/TrKTmcZtSZYe3sSmtFPMekal3JdcbUjzjqFbnUO+Xal
         3yu7jLxoRUMmC3+CDPYPEQ3UI5NZnEfFVp9S1Y2s6awOmfdpwE/crUJIFWSu1iADuB
         /HLt1Sk8k3z7Ye5JS2yTFeHHb/XaDjL5nXdJ7wQA=
Date:   Sun, 30 Aug 2020 11:11:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Joe Perches <joe@perches.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Alex Dewar <alex.dewar90@gmail.com>,
        York Sun <york.sun@nxp.com>, Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Douglas Miller <dougmill@linux.ibm.com>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mark Brown <broonie@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Pete Zaitcev <zaitcev@redhat.com>, linux-edac@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-i3c@lists.infradead.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: sysfs output without newlines
Message-ID: <20200830091142.GC112265@kroah.com>
References: <0f837bfb394ac632241eaac3e349b2ba806bce09.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f837bfb394ac632241eaac3e349b2ba806bce09.camel@perches.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 29, 2020 at 11:23:43AM -0700, Joe Perches wrote:
> While doing an investigation for a possible treewide conversion of
> sysfs output using sprintf/snprintf/scnprintf, I discovered
> several instances of sysfs output without terminating newlines.
> 
> It seems likely all of these should have newline terminations
> or have the \n\r termination changed to a single newline.
> 
> Anyone have any objection to patches adding newlines to these
> in their original forms using sprintf/snprintf/scnprintf?

No objection for me, patches for my subsystems will be gladly taken.

thanks,

greg k-h
