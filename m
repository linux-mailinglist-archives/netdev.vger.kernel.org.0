Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B10D017ED63
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 01:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbgCJAo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 20:44:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34180 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727287AbgCJAoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 20:44:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0DE4215A00545;
        Mon,  9 Mar 2020 17:44:55 -0700 (PDT)
Date:   Mon, 09 Mar 2020 17:44:52 -0700 (PDT)
Message-Id: <20200309.174452.1216342842615589776.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     linux-net-drivers@solarflare.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] sfc: detach from cb_page in efx_copy_channel()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d0c0595d-899b-0701-11cc-d9298c97df74@solarflare.com>
References: <d0c0595d-899b-0701-11cc-d9298c97df74@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 17:44:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Mon, 9 Mar 2020 18:16:24 +0000

> It's a resource, not a parameter, so we can't copy it into the new
>  channel's TX queues, otherwise aliasing will lead to resource-
>  management bugs if the channel is subsequently torn down without
>  being initialised.
> 
> Before the Fixes:-tagged commit there was a similar bug with
>  tsoh_page, but I'm not sure it's worth doing another fix for such
>  old kernels.
> 
> Fixes: e9117e5099ea ("sfc: Firmware-Assisted TSO version 2")
> Suggested-by: Derek Shute <Derek.Shute@stratus.com>
> Signed-off-by: Edward Cree <ecree@solarflare.com>
> ---
> The Fixes: is in v4.10, so this will want to go to stable for
>  4.14 and later.  Note that the recent refactoring has moved the
>  code; in the stable trees efx_copy_channel() will be in efx.c
>  rather than efx_channels.c.

Ok, applied and queued up for -stable, thanks.
