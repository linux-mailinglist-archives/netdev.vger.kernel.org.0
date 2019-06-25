Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77C89522C1
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 07:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbfFYFTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 01:19:13 -0400
Received: from smtprelay0028.hostedemail.com ([216.40.44.28]:37913 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726422AbfFYFTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 01:19:12 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 694D7100E86C1;
        Tue, 25 Jun 2019 05:19:10 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 
X-HE-Tag: crown72_8991fd23cb832
X-Filterd-Recvd-Size: 2612
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf04.hostedemail.com (Postfix) with ESMTPA;
        Tue, 25 Jun 2019 05:19:05 +0000 (UTC)
Message-ID: <4ba3b835fb3675ea685390903a082bf8b7f9e955.camel@perches.com>
Subject: Re: [PATCH v4 4/7] lib/hexdump.c: Replace ascii bool in
 hex_dump_to_buffer with flags
From:   Joe Perches <joe@perches.com>
To:     Alastair D'Silva <alastair@d-silva.org>
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
Date:   Mon, 24 Jun 2019 22:19:03 -0700
In-Reply-To: <746098160c4ff6527d573d2af23c403b6d4e5b80.camel@d-silva.org>
References: <20190625031726.12173-1-alastair@au1.ibm.com>
         <20190625031726.12173-5-alastair@au1.ibm.com>
         <3340b520a57e00a483eae170be97316c8d18c22c.camel@perches.com>
         <746098160c4ff6527d573d2af23c403b6d4e5b80.camel@d-silva.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-06-25 at 15:06 +1000, Alastair D'Silva wrote:
> The change actions Jani's suggestion:
> https://lkml.org/lkml/2019/6/20/343

I suggest not changing any of the existing uses of
hex_dump_to_buffer and only use hex_dump_to_buffer_ext
when necessary for your extended use cases.



