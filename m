Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68952C6D81
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 00:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731433AbgK0XFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 18:05:25 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:39432 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729302AbgK0XEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 18:04:33 -0500
Received: from [192.168.0.20] (cpc89244-aztw30-2-0-cust3082.18-1.cable.virginm.net [86.31.172.11])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 0001597E;
        Sat, 28 Nov 2020 00:04:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1606518252;
        bh=ZyZDfTgfTZ00cnT+cpplrgyxJT8LT1/7yN3ReJNHI4U=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=G2k+c5DiXhUx/XnmeMlGNm3cWqc5ix7Ja85ZAbEh8haviPjsnr8mVFlmU0QfbGqS4
         roy24nKYt6UZRsdJLK82OILvxoy3VX3A4eWrWgl+jeAIiRDnWLu1UH1YT5VzNrQqHt
         vtF8xwO/XoYMlI5jKToLvR/zgfyC17WvwfI/zHQM=
Reply-To: kieran.bingham+renesas@ideasonboard.com
Subject: Re: [PATCH] net: cisco: remove trailing semicolon in macro definition
To:     trix@redhat.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, bigeasy@linutronix.de, mpe@ellerman.id.au,
        lee.jones@linaro.org, dan.carpenter@oracle.com, adobriyan@gmail.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201127175821.2756988-1-trix@redhat.com>
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Organization: Ideas on Board
Message-ID: <481e5dc2-669d-451c-c405-4cd92e6f8e91@ideasonboard.com>
Date:   Fri, 27 Nov 2020 23:04:08 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201127175821.2756988-1-trix@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tom,

On 27/11/2020 17:58, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> The macro use will already have a semicolon.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Seems to be the only occurrence in this file.

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/net/wireless/cisco/airo.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
> index 74acf9af2adb..ba62bb2995d9 100644
> --- a/drivers/net/wireless/cisco/airo.c
> +++ b/drivers/net/wireless/cisco/airo.c
> @@ -5785,7 +5785,7 @@ static int airo_get_quality (StatusRid *status_rid, CapabilityRid *cap_rid)
>  }
>  
>  #define airo_get_max_quality(cap_rid) (memcmp((cap_rid)->prodName, "350", 3) ? 0x20 : 0xa0)
> -#define airo_get_avg_quality(cap_rid) (memcmp((cap_rid)->prodName, "350", 3) ? 0x10 : 0x50);
> +#define airo_get_avg_quality(cap_rid) (memcmp((cap_rid)->prodName, "350", 3) ? 0x10 : 0x50)
>  
>  /*------------------------------------------------------------------*/
>  /*
> 

