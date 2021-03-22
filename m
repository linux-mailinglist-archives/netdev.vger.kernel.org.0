Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F31034465B
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 14:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhCVN66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 09:58:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230192AbhCVN6f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 09:58:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AD2D61923;
        Mon, 22 Mar 2021 13:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616421514;
        bh=Fr4p/GXKjU8qqQHWq6CZhTjllnvGtGT+L9E7s6EYGjw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XNaOa2SxfVu1ATT4/CILk+jfaVpV0xXm/GXP0IJPeglUrWhcmFsXg2BJFzbk44VIh
         AB8KgDtVXU9zEGKcpviBiDN86ZIgJox2bucDo7Lss8fzb85GQOcdp2l0JhVbVE+0lL
         /GzrtwYziHhC9vQXtecE428xRNmgXlfmpqFK3VFAyxRWOGlNkpMN046wQE9ayhg7aQ
         L9uhfkH9ZC7LodAubJqoYTvR6di1JgS2I89uPauZDiurANOdu/hqS+GejlE54MUEHX
         uSfPZm2agVJTgNAUFR3CyI/8hEie94a/MpPRF9+mfr8i+I6RLfHfgdI9Ym6ktKC7Jk
         gdggr2u87NzJg==
Date:   Mon, 22 Mar 2021 15:58:30 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     netdev@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] [v2] misdn: avoid -Wempty-body warning
Message-ID: <YFiihvb1TLFaAZdH@unreal>
References: <20210322121453.653228-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322121453.653228-1-arnd@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 01:14:47PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> gcc warns about a pointless condition:
> 
> drivers/isdn/hardware/mISDN/hfcmulti.c: In function 'hfcmulti_interrupt':
> drivers/isdn/hardware/mISDN/hfcmulti.c:2752:17: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
>  2752 |                 ; /* external IRQ */
> 
> As the check has no effect, just remove it.
> 
> Suggested-by: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: remove the line instead of adding {}
> ---
>  drivers/isdn/hardware/mISDN/hfcmulti.c | 2 --
>  1 file changed, 2 deletions(-)
> 

Thanks, interesting when we will delete whole drivers/isdn :)

Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
