Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D628455D27
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 03:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbfFZBC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 21:02:59 -0400
Received: from ushosting.nmnhosting.com ([66.55.73.32]:56172 "EHLO
        ushosting.nmnhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbfFZBC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 21:02:59 -0400
Received: from mail2.nmnhosting.com (unknown [202.169.106.97])
        by ushosting.nmnhosting.com (Postfix) with ESMTPS id E27A72DC0076;
        Tue, 25 Jun 2019 21:02:57 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=d-silva.org;
        s=201810a; t=1561510978;
        bh=alTGTolfSOaJib81/HV1xk13UMDoyRYklK/SpUrmd7w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NoxHUcByzLTCusX5pVe1lsXlBMGElTVDnI/XfJAy1Nl2CPCT+1tOht6i2EK/ciNkm
         K9KG5Y432fz/6LApPs3O84qtWA9SlyMmA/wuAdUcSD4rSsw1vczNmq2IadH3d8Yjjj
         5s/aRpOn+J8LZ+0EdQegjtRsGUm+NIxhK/RJ9SV1bF1UePOw1rCMB/TgxdowIewNFZ
         Ra5cgiPNVLsA+gWt+IwCMHonGdcRTTyshPS7dwjlm4RdNgxtOKDy+eQbfRQfotbzjs
         B5QQnvu0X2cSsH+yxVwnjSR18+Dt0Tt9kbJq7vhB7kczzOGw3vGeE9Nsk1oow8i/1I
         3EN2KiSeiTlphcIF4jujWhyKJYRq8hKZqgXXkbYQ8cniR0sy1e4f3msouuG7u7FAGN
         4N62OPQDxWHpA6QCR2bkcmJBVH1Jb6OE2kFfBG7EgyAY7YE5RDCG3qHf3x06F/DOxs
         QIPziAUS4TwpT/g1pYu4AH2VTerslwlrRiUj0wkS6makKQ6LJI017iD3ClsF1dCjvw
         9OKcxJoGQDOPUyeiE1V2QvnozdCZZJ0tZIwv2ngVO0Y5g38kYMSlrgiQm08cGPPyV1
         1vTrS9K7ZJD22fxteol1WonkF1zHEWTT8Eu6rNYpH6cAVTxvZ5Uw16GXOQ+goHTzVz
         m6Ftvv6Q+FYsWPnR2eqrJFq0=
Received: from adsilva.ozlabs.ibm.com (static-82-10.transact.net.au [122.99.82.10] (may be forged))
        (authenticated bits=0)
        by mail2.nmnhosting.com (8.15.2/8.15.2) with ESMTPSA id x5Q12T29029544
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 26 Jun 2019 11:02:45 +1000 (AEST)
        (envelope-from alastair@d-silva.org)
Message-ID: <e16caf5b98aafea4033bfc0e49845ef987c02678.camel@d-silva.org>
Subject: Re: [PATCH v4 0/7] Hexdump Enhancements
From:   "Alastair D'Silva" <alastair@d-silva.org>
To:     Joe Perches <joe@perches.com>
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Karsten Keil <isdn@linux-pingi.de>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Benson Leung <bleung@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Andrew Morton <akpm@linux-foundation.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fsdevel@vger.kernel.org
Date:   Wed, 26 Jun 2019 11:02:29 +1000
In-Reply-To: <3ae4c1a4a72f8ee6b75c45adfbe543fc0a7b5da1.camel@perches.com>
References: <20190625031726.12173-1-alastair@au1.ibm.com>
         <3ae4c1a4a72f8ee6b75c45adfbe543fc0a7b5da1.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail2.nmnhosting.com [10.0.1.20]); Wed, 26 Jun 2019 11:02:53 +1000 (AEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-06-24 at 22:01 -0700, Joe Perches wrote:
> On Tue, 2019-06-25 at 13:17 +1000, Alastair D'Silva wrote:
> > From: Alastair D'Silva <alastair@d-silva.org>
> > 
> > Apologies for the large CC list, it's a heads up for those
> > responsible
> > for subsystems where a prototype change in generic code causes a
> > change
> > in those subsystems.
> []
> > The default behaviour of hexdump is unchanged, however, the
> > prototype
> > for hex_dump_to_buffer() has changed, and print_hex_dump() has been
> > renamed to print_hex_dump_ext(), with a wrapper replacing it for
> > compatibility with existing code, which would have been too
> > invasive to
> > change.
> 
> I believe this cover letter is misleading.
> 
> The point of the wrapper is to avoid unnecessary changes
> in existing
> code.
> 
> 

The wrapper is for print_hex_dump(), which has many callers.

The changes to existing code are for hex_dump_to_buffer(), which is
called in relatively few places.

-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva    
Twitter: @EvilDeece
blog: http://alastair.d-silva.org


