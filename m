Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED5D4C4CB
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 03:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731103AbfFTBOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 21:14:40 -0400
Received: from ushosting.nmnhosting.com ([66.55.73.32]:42702 "EHLO
        ushosting.nmnhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730815AbfFTBOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 21:14:40 -0400
Received: from mail2.nmnhosting.com (unknown [202.169.106.97])
        by ushosting.nmnhosting.com (Postfix) with ESMTPS id 69B9C2DC005B;
        Wed, 19 Jun 2019 21:14:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=d-silva.org;
        s=201810a; t=1560993276;
        bh=BpBuDfxeeGKTRli558OgjbbAAYwjKMdDNWO/akOC738=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RF6v98lSsz7mEeMkL6nYM26bVYiaYsE5nhDTdpSgsSqeX/3zMCjAr4TqNQp9WIfv/
         86CC6Ye1PnKU2tVcKzoHi6p0ci6zxBOVgFO9n72C5iQz9+SB6K7/0nVDP/VyFCPlaY
         FLUcpUGGdTZdApXoRPpCqgMDcOcjY474Zn0XLgaGITdvorfwpUXmZDgQ6EAv2KEeeH
         hsDlwa55rOWcmyBEG1gJiqQFoKwd4vtesVH2ev+sFIs/P0K4fN8rAnPULx/aKlaW55
         Xog4yR0aT8p5wNoiqCRJwH2iN+YfSZ4AvcdM+Q0rEd7JLhL6sB0ezZLT7TOwH1n+XN
         ppi/I6nDq4fWTCfaHlyIa6RXgMwHcCEeDMWqSuoySrahrXRNJvfvsk6ZLNMGqTQCf6
         /Gw1UfiMqZwrY6h2/n+W7N7emw8D5oHjLS525cWVe0UaUk81hSiabY8yyHmHomHnoM
         AUP20jID/hZwCVjTNxW4G4AF+ve+rXXutokOzrxmk8TxeEt2H6fZk0j+hMnp6xmgCo
         ztA+5Y0Fln5ESkL9ZxaDLBIEGtIwITdDACn777F9Dh8IZerMjjbxrfAodkiKBcMQdq
         w+lJnV2rMVuDBufsyxzwpAWwXFQZuqAV7brmmdY/sAB+Gtg/np4gGpFCjb5kY2UnjQ
         glkSIphnG+gk/TjO0eDg5rys=
Received: from adsilva.ozlabs.ibm.com (static-82-10.transact.net.au [122.99.82.10] (may be forged))
        (authenticated bits=0)
        by mail2.nmnhosting.com (8.15.2/8.15.2) with ESMTPSA id x5K1E6f4079317
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 20 Jun 2019 11:14:22 +1000 (AEST)
        (envelope-from alastair@d-silva.org)
Message-ID: <9456ca2a4ae827635bb6d864e5095a9e51f2ac45.camel@d-silva.org>
Subject: Re: [PATCH v3 0/7] Hexdump Enhancements
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
Date:   Thu, 20 Jun 2019 11:14:06 +1000
In-Reply-To: <d8316be322f33ea67640ff83f2248fe433078407.camel@perches.com>
References: <20190617020430.8708-1-alastair@au1.ibm.com>
         <9a000734375c0801fc16b71f4be1235f9b857772.camel@perches.com>
         <c68cb819257f251cbb66f8998a95c31cebe2d72e.camel@d-silva.org>
         <d8316be322f33ea67640ff83f2248fe433078407.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail2.nmnhosting.com [10.0.1.20]); Thu, 20 Jun 2019 11:14:32 +1000 (AEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-06-19 at 17:35 -0700, Joe Perches wrote:
> On Thu, 2019-06-20 at 09:15 +1000, Alastair D'Silva wrote:
> > On Wed, 2019-06-19 at 09:31 -0700, Joe Perches wrote:
> > > On Mon, 2019-06-17 at 12:04 +1000, Alastair D'Silva wrote:
> > > > From: Alastair D'Silva <alastair@d-silva.org>
> > > > 
> > > > Apologies for the large CC list, it's a heads up for those
> > > > responsible
> > > > for subsystems where a prototype change in generic code causes
> > > > a
> > > > change
> > > > in those subsystems.
> > > > 
> > > > This series enhances hexdump.
> > > 
> > > Still not a fan of these patches.
> > 
> > I'm afraid there's not too much action I can take on that, I'm
> > happy to
> > address specific issues though.
> > 
> > > > These improve the readability of the dumped data in certain
> > > > situations
> > > > (eg. wide terminals are available, many lines of empty bytes
> > > > exist,
> > > > etc).
> 
> I think it's generally overkill for the desired uses.

I understand where you're coming from, however, these patches make it a
lot easier to work with large chucks of binary data. I think it makes
more sense to have these patches upstream, even though committed code
may not necessarily have all the features enabled, as it means that
devs won't have to apply out-of-tree patches during development to make
larger dumps manageable.

> 
> > > Changing hexdump's last argument from bool to int is odd.
> > > 
> > 
> > Think of it as replacing a single boolean with many booleans.
> 
> I understand it.  It's odd.
> 
> I would rather not have a mixture of true, false, and apparently
> random collections of bitfields like 0xd or 0b1011 or their
> equivalent or'd defines.
> 

Where's the mixture? What would you propose instead?

-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva    
Twitter: @EvilDeece
blog: http://alastair.d-silva.org


