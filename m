Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1D67D1A17
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 22:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731792AbfJIUvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 16:51:25 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:61985 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729535AbfJIUvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 16:51:24 -0400
X-IronPort-AV: E=Sophos;i="5.67,277,1566856800"; 
   d="scan'208";a="405491272"
Received: from 81-65-53-202.rev.numericable.fr (HELO hadrien) ([81.65.53.202])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2019 22:51:23 +0200
Date:   Wed, 9 Oct 2019 22:51:22 +0200 (CEST)
From:   Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To:     Jules Irenge <jbi.octave@gmail.com>
cc:     outreachy-kernel@googlegroups.com, gregkh@linuxfoundation.org,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [Outreachy kernel] [PATCH] staging: qlge: correct misspelled
 word
In-Reply-To: <20191009194115.5513-1-jbi.octave@gmail.com>
Message-ID: <alpine.DEB.2.21.1910092249300.2570@hadrien>
References: <20191009194115.5513-1-jbi.octave@gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Wed, 9 Oct 2019, Jules Irenge wrote:

> Correct misspelled word " check

Why is there a " in the above line?

You don't need to put a newline after check.

>  issued by checkpatch.pl tool:
> "CHECK: serveral may be misspelled - perhaps several?".

It's not reall necessary to give the checkpatch message in this case,
although it is good to acknowledge checkpatch.  You could say something
like:

Fix a misspelling of "several" detected by checkpatch.

julia

> Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
> ---
>  drivers/staging/qlge/qlge_dbg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
> index 086f067fd899..097fab7b4287 100644
> --- a/drivers/staging/qlge/qlge_dbg.c
> +++ b/drivers/staging/qlge/qlge_dbg.c
> @@ -354,7 +354,7 @@ static int ql_get_xgmac_regs(struct ql_adapter *qdev, u32 *buf,
>
>  	for (i = PAUSE_SRC_LO; i < XGMAC_REGISTER_END; i += 4, buf++) {
>  		/* We're reading 400 xgmac registers, but we filter out
> -		 * serveral locations that are non-responsive to reads.
> +		 * several locations that are non-responsive to reads.
>  		 */
>  		if ((i == 0x00000114) ||
>  			(i == 0x00000118) ||
> --
> 2.21.0
>
> --
> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/20191009194115.5513-1-jbi.octave%40gmail.com.
>
