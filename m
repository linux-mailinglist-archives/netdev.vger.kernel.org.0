Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E79E5F9739
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 05:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiJJDpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 23:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiJJDpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 23:45:45 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518003A49E
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 20:45:44 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id r18so9281627pgr.12
        for <netdev@vger.kernel.org>; Sun, 09 Oct 2022 20:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gPbK7t2wYBd6+4gCzos9wZj6XiiOFZnoiVmrg6V+/4Y=;
        b=ZDUglpzj2A00wAAmTAe2YfVdA+Yh32ACD64pJ8gdoLpoNEnu5Nhn6Fp2F1QJEb4Sa1
         u0n5HeaHXVarTBMLEoTTsVEtuctoNpd/LRbBirgqWt0y6zUts+y5ivF5ipqAxFNcXLOQ
         TVsGgliYfPvvKiO9VNVjPKCjRPLvBYDA0f+mcFcmTNY03tOa6W2zcN6VAPynEcasNqu0
         VRAkLDdtypaxTbNvHgcKRQGLi6ZBQeUMDEKWtaTv8SoGdRYTDvgrwHgg+xhbuzF6tI0h
         +/AolTYyDTHFmr9CnMHKGCamr9WJVIXUfxVJhYyV9cxf5THbyZaZJlk/Msa86RHAe2cK
         hemA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gPbK7t2wYBd6+4gCzos9wZj6XiiOFZnoiVmrg6V+/4Y=;
        b=2kfeof7qQVt6+lLwJomPtyQz8ILFDZza+5vB73FBaVXJPF26FisrpM6jvfu3AlFLil
         elno7+nJNV6sbIxMtcx0iD4JnrzM5/UTUmaChFJkjg1H260DlB1K7w4j6h4vbX8dNVW1
         kkgApWENJAxRCCDZjguPsYuT4/Q/AE4p8f3JvVWDUrKkInjNcTSzvh/u39VA6LPaNK5I
         BzwegigUeqXxQ8tpyJ5kMLeEbL4/16t5R8ygHptIgVtW6ZARIylJSKGkMcARy0kiCSVz
         inJSWTjmeYL5ckomf9IFe/rRZezHQwzVpPRUSBXoKCuW/GbR7Orj6RQvrQko85q9bPwS
         t5SA==
X-Gm-Message-State: ACrzQf0KZJKWgEtR8DnRMZQUqmTHiQ/sVy2hjCXVYKCA6kA/2I7tO78s
        lQwQenspy1Nk4JJnrWWAwU0=
X-Google-Smtp-Source: AMsMyM4j/kOkWmAh5vKtOtpqXl2pI58L08qZer8yI7mgoD0UHCI8tw2zMbcK0yiH1MmfdozxhGfo7A==
X-Received: by 2002:a63:1d1:0:b0:43a:348b:63fd with SMTP id 200-20020a6301d1000000b0043a348b63fdmr15572392pgb.52.1665373543745;
        Sun, 09 Oct 2022 20:45:43 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:2103:475:ef07:bb37:8b7b? ([2620:10d:c090:400::5:641])
        by smtp.gmail.com with ESMTPSA id x66-20020a623145000000b005360da6b26bsm5661040pfx.159.2022.10.09.20.45.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Oct 2022 20:45:43 -0700 (PDT)
Message-ID: <5da0d110-73f2-3210-dc0c-ee024267c4ad@gmail.com>
Date:   Sun, 9 Oct 2022 20:45:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Subject: Re: [[PATCH net]] ptp: ocp: remove symlink for second GNSS
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>
References: <20221010012934.25639-1-vfedorenko@novek.ru>
Content-Language: en-US
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
In-Reply-To: <20221010012934.25639-1-vfedorenko@novek.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/9/22 6:29 PM, Vadim Fedorenko wrote:
> Destroy code doesn't remove symlink for ttyGNSS2 device introduced
> earlier. Add cleanup code.
> 
> Fixes: 71d7e0850476 ("ptp: ocp: Add second GNSS device")
> Signed-off-by: Vadim Fedorenko <vadfed@fb.com>

Thanks, Vadim!

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>

> ---
>   drivers/ptp/ptp_ocp.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
> index d36c3f597f77..a48d9b7d2921 100644
> --- a/drivers/ptp/ptp_ocp.c
> +++ b/drivers/ptp/ptp_ocp.c
> @@ -3657,6 +3657,7 @@ ptp_ocp_detach_sysfs(struct ptp_ocp *bp)
>   	struct device *dev = &bp->dev;
>   
>   	sysfs_remove_link(&dev->kobj, "ttyGNSS");
> +	sysfs_remove_link(&dev->kobj, "ttyGNSS2");
>   	sysfs_remove_link(&dev->kobj, "ttyMAC");
>   	sysfs_remove_link(&dev->kobj, "ptp");
>   	sysfs_remove_link(&dev->kobj, "pps");

