Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C61D04BE41
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 18:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbfFSQbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 12:31:34 -0400
Received: from smtprelay0234.hostedemail.com ([216.40.44.234]:46325 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725899AbfFSQbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 12:31:34 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id D3FFA1801A0B4;
        Wed, 19 Jun 2019 16:31:31 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 
X-HE-Tag: cakes27_80e37c98d9d58
X-Filterd-Recvd-Size: 3106
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Wed, 19 Jun 2019 16:31:25 +0000 (UTC)
Message-ID: <9a000734375c0801fc16b71f4be1235f9b857772.camel@perches.com>
Subject: Re: [PATCH v3 0/7] Hexdump Enhancements
From:   Joe Perches <joe@perches.com>
To:     Alastair D'Silva <alastair@au1.ibm.com>, alastair@d-silva.org
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
Date:   Wed, 19 Jun 2019 09:31:24 -0700
In-Reply-To: <20190617020430.8708-1-alastair@au1.ibm.com>
References: <20190617020430.8708-1-alastair@au1.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-06-17 at 12:04 +1000, Alastair D'Silva wrote:
> From: Alastair D'Silva <alastair@d-silva.org>
> 
> Apologies for the large CC list, it's a heads up for those responsible
> for subsystems where a prototype change in generic code causes a change
> in those subsystems.
> 
> This series enhances hexdump.

Still not a fan of these patches.

> These improve the readability of the dumped data in certain situations
> (eg. wide terminals are available, many lines of empty bytes exist, etc).

Changing hexdump's last argument from bool to int is odd.

Perhaps a new function should be added instead of changing
the existing hexdump.

> The default behaviour of hexdump is unchanged, however, the prototype
> for hex_dump_to_buffer() has changed, and print_hex_dump() has been
> renamed to print_hex_dump_ext(), with a wrapper replacing it for
> compatibility with existing code, which would have been too invasive to
> change.
> 
> Hexdump selftests have be run & confirmed passed.


