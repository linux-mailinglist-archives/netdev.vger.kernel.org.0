Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2C704C404
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 01:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730758AbfFSXQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 19:16:30 -0400
Received: from ushosting.nmnhosting.com ([66.55.73.32]:42028 "EHLO
        ushosting.nmnhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfFSXQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 19:16:29 -0400
Received: from mail2.nmnhosting.com (unknown [202.169.106.97])
        by ushosting.nmnhosting.com (Postfix) with ESMTPS id 5F37E2DC005B;
        Wed, 19 Jun 2019 19:16:28 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=d-silva.org;
        s=201810a; t=1560986188;
        bh=P+nFrCYIAy9nbAT3inDjyh5Nu1AGlpkuYDjYYSTo8SU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UMKHysbwL4zdfy50KqutmgBEIg3sB7A1AG+8ItwZQtNEjbw3/kefwvZoa3HJ/qPue
         FtHy3iQpmn+NaSFA3Mu2gOfCMETJuOCnHShThOrTrRi0524godGZCgjbLwEXdIrujV
         xDt+bXPG551xLU30DowKCzCX4sh2ZLCYlpwKny3nSfu6TdTO04XxEEAerz4PtGaObB
         mK5WkSsuK3ES4PAPxgZb+pSYtoFroMpH18T3PLybvLGSjfjyn/CtIMs+blM8XYmdPJ
         TvkZW6Ca8pzYT9RsBfJRAJWjf4qfNG6J0j+xJvEaD7SP/MIMGo1VZ5d/zw4b3FdeYt
         JetXAd65Zd6yavahdde3VtkKoryPECl8+glQZ+N2eRG9ycQ1RafCdpTqdv72F0hGkL
         4apz6zp0SeF0J1KA9qT4u68PJKa7dlMEnKXEomd5VE+2hLj+H2XT6HltLJdB5+pK9G
         cMe1+bLK+ayAWxIXuyZ1/r/oJ5pzAFraInvomTVKBkCfLFy8CdlSIihUmPfej/4psJ
         72/lVeYRJl+IifxxJ9hEA9A+QWlY8W986ROsAQ5xOTxmaRzXMnnZRdFLVPZt5axFGD
         EQ+IOd3b5ZUWjk3U7T3wAvcchJQaqLNw/Njxg2yMVkYsKSYnAMuX4DYn+A7LJX3oLF
         sv3nSS3HZsRxp6mS1j36fWkI=
Received: from adsilva.ozlabs.ibm.com (static-82-10.transact.net.au [122.99.82.10] (may be forged))
        (authenticated bits=0)
        by mail2.nmnhosting.com (8.15.2/8.15.2) with ESMTPSA id x5JNFxcT078663
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 20 Jun 2019 09:16:14 +1000 (AEST)
        (envelope-from alastair@d-silva.org)
Message-ID: <c68cb819257f251cbb66f8998a95c31cebe2d72e.camel@d-silva.org>
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
Date:   Thu, 20 Jun 2019 09:15:58 +1000
In-Reply-To: <9a000734375c0801fc16b71f4be1235f9b857772.camel@perches.com>
References: <20190617020430.8708-1-alastair@au1.ibm.com>
         <9a000734375c0801fc16b71f4be1235f9b857772.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail2.nmnhosting.com [10.0.1.20]); Thu, 20 Jun 2019 09:16:24 +1000 (AEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-06-19 at 09:31 -0700, Joe Perches wrote:
> On Mon, 2019-06-17 at 12:04 +1000, Alastair D'Silva wrote:
> > From: Alastair D'Silva <alastair@d-silva.org>
> > 
> > Apologies for the large CC list, it's a heads up for those
> > responsible
> > for subsystems where a prototype change in generic code causes a
> > change
> > in those subsystems.
> > 
> > This series enhances hexdump.
> 
> Still not a fan of these patches.

I'm afraid there's not too much action I can take on that, I'm happy to
address specific issues though.

> 
> > These improve the readability of the dumped data in certain
> > situations
> > (eg. wide terminals are available, many lines of empty bytes exist,
> > etc).
> 
> Changing hexdump's last argument from bool to int is odd.
> 

Think of it as replacing a single boolean with many booleans.

> Perhaps a new function should be added instead of changing
> the existing hexdump.
> 

There's only a handful of consumers, I don't think there is a value-add 
in creating more wrappers vs updating the existing callers.

-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva    
Twitter: @EvilDeece
blog: http://alastair.d-silva.org


