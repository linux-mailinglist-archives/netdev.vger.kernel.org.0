Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE8931C7F0
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 10:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhBPJVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 04:21:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbhBPJVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 04:21:12 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC47FC061574
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 01:20:31 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id n4so9104019wrx.1
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 01:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y41IhIT5rmyhijmxjT00xgQ2ngQOKXy/8+FZLhjS7GU=;
        b=PxauwfY1W0W8GqfSltTB89uf6BjLJooazi+FICLO0MYpouhyA0zCMNy/swKF6XKIoh
         WsaHV9J+g1NdDbZ9mwlZF+9R9q2iEAAVGQYNGmT2dM45p72c9nsJVRHRYZKPWq0G0oA+
         byAQAESeOHqZrMxjphuom8fRhS6b9fVv1OdeHUnEesoP3gb8Y7ZBO4k4N2AjsTxoocgL
         U2gSRuxYygA1CH18shWiRRHx10hdlr2tw6PZKhP3WdsEa+j0F7dT1YRG6V1q6R7QFFqy
         O3sbFg2uteZhZTzQvmOQlc9ejWpPs+SRndc/kWh0MeRlQ3iK8Sx+g/OHjazrikiPC6po
         deLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y41IhIT5rmyhijmxjT00xgQ2ngQOKXy/8+FZLhjS7GU=;
        b=R7sjy9cXvk6Y7RxUZ9r1uKoUz4H3o26azmF6VQxvw01mcm2OWfMhN8dKz7QHGzyPHL
         QtayLcjoWa4Cr9f2qTbENM5JVIBBeKqb+tW9fNEJKr8lAkNi4N56MoqAYPt7DboTPr2R
         E/jDT/TqFE7A0mmd3kVtVepw3XofZiz2cTN/RRNneT7VVpWQmlfMGERhARdlYabihTGK
         Hm+fmSXZyn6TRvz7f9xpdH63pLJt3KSxa/4NJgrsA9/pYjpS5CsDW89wq1mUgu4cbcV9
         BIsT/HTeyToSJsiGAoVqaXYU9aOa3hZxYeExqHzfn47Ftc/h3iB5v6Jjj8QrYbf7dkfY
         r2RA==
X-Gm-Message-State: AOAM532Q7EGG82nkihY27rO16Er/ZB/wdBSot+3cbbjAwgG9bcDUiIFQ
        bSpheI/S9Iwx+CTnP3Nd9D9XGVQAGCI4qA==
X-Google-Smtp-Source: ABdhPJw8rKubCzEnbeZl2jrx0DqZqg91MIvyR1rs/pdj5gKareeA2mPpfeRZmBDxtI2dC5k3rnMMiw==
X-Received: by 2002:adf:dcd2:: with SMTP id x18mr22981959wrm.355.1613467230465;
        Tue, 16 Feb 2021 01:20:30 -0800 (PST)
Received: from ?IPv6:2003:ea:8f39:5b00:ac39:e452:593c:61b5? (p200300ea8f395b00ac39e452593c61b5.dip0.t-ipconnect.de. [2003:ea:8f39:5b00:ac39:e452:593c:61b5])
        by smtp.googlemail.com with ESMTPSA id w9sm2651356wmk.16.2021.02.16.01.20.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Feb 2021 01:20:30 -0800 (PST)
Subject: Re: [PATCH v3] staging: fix coding style in
 driver/staging/qlge/qlge_main.c
To:     Du Cheng <ducheng2@gmail.com>, Manish Chopra <manishc@marvell.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, netdev@vger.kernel.org
References: <20210216085326.178912-1-ducheng2@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <f9f2ed25-8903-450b-0971-a5eb292380cf@gmail.com>
Date:   Tue, 16 Feb 2021 10:20:22 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210216085326.178912-1-ducheng2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.02.2021 09:53, Du Cheng wrote:
> align * in block comments on each line
> 
> changes v3:
> - add SUBSYSTEM in subject line
> - add explanation to past version of this patch
> 
> changes v2:
> - move closing of comment to the same line
> 
> changes v1:
> - align * in block comments
> 
> Signed-off-by: Du Cheng <ducheng2@gmail.com>
> ---
>  drivers/staging/qlge/qlge_main.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index 5516be3af898..2682a0e474bd 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -3815,8 +3815,7 @@ static int qlge_adapter_down(struct qlge_adapter *qdev)
>  
>  	qlge_tx_ring_clean(qdev);
>  
> -	/* Call netif_napi_del() from common point.
> -	*/
> +	/* Call netif_napi_del() from common point. */
>  	for (i = 0; i < qdev->rss_ring_count; i++)
>  		netif_napi_del(&qdev->rx_ring[i].napi);
>  
> 
Typically such trivial patches aren't much appreciated for staging drivers.
In the case here I have doubts that the comment as such provides any benefit.

