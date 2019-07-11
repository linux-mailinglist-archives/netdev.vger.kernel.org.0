Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7D165AFF
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 17:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbfGKPyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 11:54:47 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:38147 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbfGKPyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 11:54:47 -0400
Received: by mail-lf1-f68.google.com with SMTP id h28so4412109lfj.5
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 08:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:organization:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VuLRQPIPYru5e49vQnd6z9oqDTPUlyTTwykrBgQw35U=;
        b=LMXQ+ET9fJBRnE0SBpu+3wlEDYPFp4dm4xJcgzGGfxzILS3Asf0Ae0uXmwP6F1rfZw
         xZ73jWpn1WK/o1Hr7C5DvdDv/wcABkUmcgf6E2EOcMTgSt9NOb8ZBabRZwA8I0Q05lOd
         lsYhzLfMdnxFq3R6Oxk+AO8TLo0eaSax+vXtqqmdd6WVxtR4wsBGJAFI6IjO8jubDO/7
         /hw0i9YnNyTTh+XIwaHDYxV3vkAI8LrYNUhdGiBpMTzotK82Pyl5ssDasFGfOBQ2ANJl
         +EBT16xu7BG3MO13MUmqJ+j2LDZeXmjsKAkVtPhpkLHYXFnNFdEN1zPQsKiKlXBc1ryR
         GPuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=VuLRQPIPYru5e49vQnd6z9oqDTPUlyTTwykrBgQw35U=;
        b=r2y00oZC8KobR/wgEd8XnIYkuumcPCo/7ridsn9/+/2s9TdmCrO9JK1dkENfZEfjpt
         Krvm/AuDj9DlMaHkaEWvL+LOikgZDm9oVSV8iajtgdUa5775AAeuYl8kuuj05Arwq/0F
         lzNAXrXyI0TqYCjeBEBrq/xsvebETmUbkLEKJZcj7JvP/9AWPYLt7nhp/a2ISw2Qb5vl
         GVyAUUdB/KSUQ8dv6JcJDP4jzNs0yD2WhKzKKIy5EPrhprPT+tvE7XlIU4bUVroRTJBV
         kbtyo0a5gA8WcsaeQoGmHzdCDRFO8G88wWc5G/MYNqcoSulJV1NIu8xuhK2Ti6GydlH6
         ti/Q==
X-Gm-Message-State: APjAAAUNtZqrGCeDXFXcIQlJNSP33GrMvvznwfvf7fC1JzHs8Pc9GW+w
        3/WSvy/WWnZ1uzh8/4jewwryGMcYL7p8AA==
X-Google-Smtp-Source: APXvYqykapWZFBUmZNV7N8XBwcaQr7fa/08Cu67m42e4o/qXCSDFAslew9WSikjh8DCHDrVT5PNEdQ==
X-Received: by 2002:a19:c6d4:: with SMTP id w203mr2274734lff.135.1562860484680;
        Thu, 11 Jul 2019 08:54:44 -0700 (PDT)
Received: from wasted.cogentembedded.com ([2a00:1fa0:6a9:2c74:93e5:edca:9c98:290d])
        by smtp.gmail.com with ESMTPSA id m28sm1034469ljb.68.2019.07.11.08.54.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 08:54:44 -0700 (PDT)
Subject: Re: [PATCH] libertas: add terminating entry to fw_table
To:     Oliver Neukum <oneukum@suse.com>, davem@davemloft.net,
        netdev@vger.kernel.org
References: <20190711142744.31956-1-oneukum@suse.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <dc2f79c8-a6fa-2d7d-df2d-dbbd5326305e@cogentembedded.com>
Date:   Thu, 11 Jul 2019 18:54:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190711142744.31956-1-oneukum@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 07/11/2019 05:27 PM, Oliver Neukum wrote:

> In case no firmware was found, the system would happily read
> and try to load garbage. Terminate the table properly.
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> Fixes: ce84bb69f50e6 ("libertas USB: convert to asynchronous firmware loading")

   The Fixed: tag should precede the sign-offs, according to DaveM...

> Reported-by: syzbot+8a8f48672560c8ca59dd@syzkaller.appspotmail.com

   That should be the 1st tag, I think...

> ---
>  drivers/net/wireless/marvell/libertas/if_usb.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net/wireless/marvell/libertas/if_usb.c
> index f1622f0ff8c9..b79c65547f4c 100644
> --- a/drivers/net/wireless/marvell/libertas/if_usb.c
> +++ b/drivers/net/wireless/marvell/libertas/if_usb.c
> @@ -50,7 +50,10 @@ static const struct lbs_fw_table fw_table[] = {
>  	{ MODEL_8388, "libertas/usb8388_v5.bin", NULL },
>  	{ MODEL_8388, "libertas/usb8388.bin", NULL },
>  	{ MODEL_8388, "usb8388.bin", NULL },
> -	{ MODEL_8682, "libertas/usb8682.bin", NULL }
> +	{ MODEL_8682, "libertas/usb8682.bin", NULL },
> +
> +	/*terminating entry - keep at end */

   Why no space after /* ?

> +	{ MODEL_8388, NULL, NULL }
>  };
>  
>  static const struct usb_device_id if_usb_table[] = {

MBR, Sergei
