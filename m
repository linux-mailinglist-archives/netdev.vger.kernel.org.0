Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8190C37366E
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 10:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbhEEInY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 04:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbhEEInV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 04:43:21 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38448C061574;
        Wed,  5 May 2021 01:42:23 -0700 (PDT)
Received: from [192.168.0.20] (cpc89244-aztw30-2-0-cust3082.18-1.cable.virginm.net [86.31.172.11])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 19B89549;
        Wed,  5 May 2021 10:42:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1620204140;
        bh=qmu9oxq4GfKWLVnwiqcpJds5vjoid5EI4o9dBr9EVPM=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=qxh75Rjxr8ZmKGBIcckODbfKvLXdXVplxdvjE/RVGoiG0btFoH42rcMeCQCRXxRo5
         HpMWhLPXm/qvwRsx2MPtYCuBu9jxHxE49ufKELSGoZfVdSgtqWaffjEFAx7wQLafXF
         W3o2h8fje6PkcTF1O82xdCiQcIkS0CNreXrp00/Q=
Reply-To: kieran.bingham+renesas@ideasonboard.com
Subject: Re: [PATCH 2/3] Fix spelling error from "elemination" to
 "elimination"
To:     Sean Gloumeau <sajgloumeau@gmail.com>,
        Jiri Kosina <trivial@kernel.org>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        linux-mtd@lists.infradead.org, Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Gloumeau <sajgloumeau@protonmail.com>
References: <cover.1620185393.git.sajgloumeau@gmail.com>
 <f1220eaedbc71ee8d19e35b894c21c161e7a33fc.1620185393.git.sajgloumeau@gmail.com>
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Organization: Ideas on Board
Message-ID: <72b39028-f340-1cc7-40e0-0efadb57d729@ideasonboard.com>
Date:   Wed, 5 May 2021 09:42:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <f1220eaedbc71ee8d19e35b894c21c161e7a33fc.1620185393.git.sajgloumeau@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

On 05/05/2021 05:16, Sean Gloumeau wrote:
> Spelling error "elemination" amended to "elimination".
> 
> Signed-off-by: Sean Gloumeau <sajgloumeau@gmail.com>

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  fs/jffs2/debug.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/jffs2/debug.c b/fs/jffs2/debug.c
> index 9d26b1b9fc01..027e4f84df28 100644
> --- a/fs/jffs2/debug.c
> +++ b/fs/jffs2/debug.c
> @@ -354,7 +354,7 @@ __jffs2_dbg_acct_paranoia_check_nolock(struct jffs2_sb_info *c,
>  	}
>  
>  #if 0
> -	/* This should work when we implement ref->__totlen elemination */
> +	/* This should work when we implement ref->__totlen elimination */

I wonder if anyone has worked on or is working on eliminating that
ref->__totlen so that this code isn't left as dead-code.


>  	if (my_dirty_size != jeb->dirty_size + jeb->wasted_size) {
>  		JFFS2_ERROR("Calculated dirty+wasted size %#08x != stored dirty + wasted size %#08x\n",
>  			my_dirty_size, jeb->dirty_size + jeb->wasted_size);
> 

