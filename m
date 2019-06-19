Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B12E94C078
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 20:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbfFSSEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 14:04:23 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:36262 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfFSSEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 14:04:22 -0400
Received: by mail-io1-f68.google.com with SMTP id h6so396872ioh.3
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 11:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bY2Pdgxjl8QBtsjUINphEntPK3jfC/Ak6GNxyygmigo=;
        b=VkybdO5szSQoqsCVNU3CNvztJwBLITMX5WwtErnOYPP33xZQZA9gVzz6aeV21kCbn5
         ObwWjqDCTa2/Bb2qCTbAbK6xqxkdiHO/Mwj3z8YEH/KyXQrkohwjDJjxkKABz0ZhAhkW
         RpTbQvkIB8kS8Zn2Qbo1olUPr8yqDON/ekOis=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bY2Pdgxjl8QBtsjUINphEntPK3jfC/Ak6GNxyygmigo=;
        b=j+9YYT/PVBSzWe4OBuCJtjkiL6JpO3rVyGEdXz2K0CWDjfDhXq8LLebR9qYDrZfY1t
         neYvwjphn3E0gSJs2aPl5H4u4NoOpq+PQVz4tJfL4Wla36xqFAXIlB/xl3vGUSiirYDr
         LzOjV77JHutAjFj8ihIcjMcIJKFoKI2o3X4nObUcg8wXFpItfVqZd/oSKD9Wuh/QGAvD
         5TqaMLXFRTVX0kDyCStVokBg47kol1YlHJgvnOa/3F0g4Ly1v7/wjPK8kD1FEBm/UBTG
         Z7V5ex2GFg+6hQca0yAs2Sl9p+EX6lpwPEYt7NsCahAFGcNEN5UrzKgvmld88N4o9Jlb
         Ix0w==
X-Gm-Message-State: APjAAAUA/4dFd+VdJl8z24gAm1hFJ4pny226iHrMQ2vIbWnrBMZ5pACV
        zHH1i/ter7JpR8d2RxkJg5GcrA==
X-Google-Smtp-Source: APXvYqw4Tz4USEoEvxV705R5eyOixcvvXbf7l0fifGzCyJPxmQS1jpqwotommwl09kmMHgcdPEDAXg==
X-Received: by 2002:a6b:b40b:: with SMTP id d11mr3987486iof.122.1560967461187;
        Wed, 19 Jun 2019 11:04:21 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id y20sm17970542iol.34.2019.06.19.11.04.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 11:04:20 -0700 (PDT)
Subject: Re: [PATCH] net: fddi: skfp: Include generic PCI definitions from
 pci_regs.h
To:     Puranjay Mohan <puranjay12@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bjorn@helgaas.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20190619174556.21194-1-puranjay12@gmail.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e49daf89-1bf0-77e8-c71f-ec0802f25f6c@linuxfoundation.org>
Date:   Wed, 19 Jun 2019 12:04:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190619174556.21194-1-puranjay12@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/19/19 11:45 AM, Puranjay Mohan wrote:
> Include the generic PCI definitions from include/uapi/linux/pci_regs.h
> change PCI_REV_ID to PCI_REVISION_ID to make it compatible with the
> generic define.
> This driver uses only one generic PCI define.
> 
> Signed-off-by: Puranjay Mohan <puranjay12@gmail.com>
> ---
>   drivers/net/fddi/skfp/drvfbi.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/fddi/skfp/drvfbi.c b/drivers/net/fddi/skfp/drvfbi.c
> index bdd5700e71fa..38f6d943385d 100644
> --- a/drivers/net/fddi/skfp/drvfbi.c
> +++ b/drivers/net/fddi/skfp/drvfbi.c
> @@ -20,6 +20,7 @@
>   #include "h/supern_2.h"
>   #include "h/skfbiinc.h"
>   #include <linux/bitrev.h>
> +#include <uapi/linux/pci_regs.h>
>   
>   #ifndef	lint
>   static const char ID_sccs[] = "@(#)drvfbi.c	1.63 99/02/11 (C) SK " ;
> @@ -127,7 +128,7 @@ static void card_start(struct s_smc *smc)
>   	 *	 at very first before any other initialization functions is
>   	 *	 executed.
>   	 */
> -	rev_id = inp(PCI_C(PCI_REV_ID)) ;
> +	rev_id = inp(PCI_C(PCI_REVISION_ID)) ;
>   	if ((rev_id & 0xf0) == SK_ML_ID_1 || (rev_id & 0xf0) == SK_ML_ID_2) {
>   		smc->hw.hw_is_64bit = TRUE ;
>   	} else {
> 

Why not delete the PCI_REV_ID define in:

drivers/net/fddi/skfp/h/skfbi.h

It looks like this header has duplicate PCI config space header defines,
not just this one. Some of them are slightly different names:

e.g:

#define PCI_CACHE_LSZ   0x0c    /*  8 bit       Cache Line Size */

Looks like it defines the standard PCI config space instead of
including and using the standard defines from uapi/linux/pci_regs.h

Something to look into.

thanks,
-- Shuah





