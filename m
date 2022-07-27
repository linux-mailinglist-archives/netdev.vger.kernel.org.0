Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45DAD58203B
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiG0GmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiG0GmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:42:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C995357EB;
        Tue, 26 Jul 2022 23:42:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C21BDB818C8;
        Wed, 27 Jul 2022 06:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3686EC433C1;
        Wed, 27 Jul 2022 06:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658904123;
        bh=tlum5LNcuhwwd32TYWPk3TbzbdBIf8mN1z5mBa/svUo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0ETe66NHSeZjjb+Nlny2gEHZOnDqGlGjk2vwFgbdwwaGJsQcixQwDbZlJO9LpnRRi
         ZgGZKSkeOhFKhTHIF6jRLUStg2qM+OlfiVLsIQV28HYBs35YxKUHxuSLVEswjKfTJc
         d9cznoWRW3YPxVrKwl8dGHOVyt5MPlr+GqQ2lQ0Y=
Date:   Wed, 27 Jul 2022 08:42:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Louis Goyard <louis.goyard@hashi.re>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: fix indentation
Message-ID: <YuDeOFTWAxWsYvYa@kroah.com>
References: <0e60fe4b-5bc6-19bb-a061-23acbfa606c4@hashi.re>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e60fe4b-5bc6-19bb-a061-23acbfa606c4@hashi.re>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 04:30:37PM +0200, Louis Goyard wrote:
> From: Louis Goyard <louis.goyard@hashi.re>
> 
> Adhere to linux coding style. Reported by checkpatch:
> WARNING: suspect code indent for conditional statements (16, 32)
> 
> Signed-off-by: Louis Goyard <louis.goyard@hashi.re>
> ---
>  drivers/staging/qlge/qlge_main.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/qlge/qlge_main.c
> b/drivers/staging/qlge/qlge_main.c
> index 1a378330d775..8eb0048c596d 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -3008,9 +3008,9 @@ static int qlge_start_rx_ring(struct qlge_adapter
> *qdev, struct rx_ring *rx_ring
>  		base_indirect_ptr = rx_ring->lbq.base_indirect;
> 
>  		for (page_entries = 0; page_entries <
> -			MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++)
> -				base_indirect_ptr[page_entries] =
> -					cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
> +				MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++)
> +			base_indirect_ptr[page_entries] =
> +				cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
>  		cqicb->lbq_addr = cpu_to_le64(rx_ring->lbq.base_indirect_dma);
>  		cqicb->lbq_buf_size =
>  			cpu_to_le16(QLGE_FIT16(qdev->lbq_buf_size));
> @@ -3023,9 +3023,9 @@ static int qlge_start_rx_ring(struct qlge_adapter
> *qdev, struct rx_ring *rx_ring
>  		base_indirect_ptr = rx_ring->sbq.base_indirect;
> 
>  		for (page_entries = 0; page_entries <
> -			MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++)
> -				base_indirect_ptr[page_entries] =
> -					cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
> +				MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++)
> +			base_indirect_ptr[page_entries] =
> +				cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
>  		cqicb->sbq_addr =
>  			cpu_to_le64(rx_ring->sbq.base_indirect_dma);
>  		cqicb->sbq_buf_size = cpu_to_le16(SMALL_BUFFER_SIZE);
> -- 
> 2.37.1

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- Your patch is malformed (tabs converted to spaces, linewrapped, etc.)
  and can not be applied.  Please read the file,
  Documentation/email-clients.txt in order to fix this.


If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
