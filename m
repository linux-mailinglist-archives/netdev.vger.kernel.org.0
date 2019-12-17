Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8C0122BBB
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 13:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbfLQMgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 07:36:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:44612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726571AbfLQMgM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 07:36:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61696206D8;
        Tue, 17 Dec 2019 12:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576586171;
        bh=B7h76drzd6gyW48HzKwrGBmdAS3OiSGmCCDzI4QGaKI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cX82lLzPKCfZGg+79MXAntIsqijJY92TduKqfDQ0Q2kBtpEeoh31St5pPYq/uxfOp
         Sncy45woPUxOY5bQXi8jgHZJsJOyi+QDGutqsEFoVe6XNzAOrfZonrEcnQoSwMZzRH
         k3fvgAamTDQFIklI4oGO9urS09oEsPPXtYZNaZi4=
Date:   Tue, 17 Dec 2019 13:36:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Scott Schafer <schaferjscott@gmail.com>
Cc:     devel@driverdev.osuosl.org, GR-Linux-NIC-Dev@marvell.com,
        Manish Chopra <manishc@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/23] staging: qlge: Fix WARNING: Missing a blank
 line after declarations
Message-ID: <20191217123609.GA3161277@kroah.com>
References: <cover.1576086080.git.schaferjscott@gmail.com>
 <e15a6fd67d39af57fa6309037bb0c7a747c52353.1576086080.git.schaferjscott@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e15a6fd67d39af57fa6309037bb0c7a747c52353.1576086080.git.schaferjscott@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 12:12:32PM -0600, Scott Schafer wrote:
> Fix WARNING: Missing a blank line after declarations for the follig
> files:
> qlge.h
> qlge_dbg.c
> qlge_main.c
> qlge_mpi.c
> 
> Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
> ---
>  drivers/staging/qlge/qlge.h      |  1 +
>  drivers/staging/qlge/qlge_dbg.c  |  5 +++++
>  drivers/staging/qlge/qlge_main.c | 13 +++++++++++++
>  drivers/staging/qlge/qlge_mpi.c  |  6 ++++++
>  4 files changed, 25 insertions(+)
> 
> diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
> index 4bc5d5fce9bf..89502a8300f6 100644
> --- a/drivers/staging/qlge/qlge.h
> +++ b/drivers/staging/qlge/qlge.h
> @@ -2227,6 +2227,7 @@ static inline void ql_write_db_reg_relaxed(u32 val, void __iomem *addr)
>  static inline u32 ql_read_sh_reg(__le32  *addr)
>  {
>  	u32 reg;
> +	

You are adding trailing whitespace on every one of your newlines you are
adding :(

I suggest using an editor that shows this up as a bright red mark, it
makes it more obvious you are doing something wrong.

Also try running checkpatch.pl on the patches you are writing to make
sure you do not add more errors/warnings when you are trying to fix them
up.

thanks,

greg k-h
