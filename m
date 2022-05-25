Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A65AF5337DD
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 09:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbiEYH5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 03:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233794AbiEYH5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 03:57:38 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F287CDC4
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 00:57:37 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id y24so4220524wmq.5
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 00:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7/n2rpbeqJlIklC2fIxXMA/rV6mHKXGQbAPiEq5BLsM=;
        b=mlQa19aK81m43lYo0SMSdV1JuMB3iAcGjS0kCYSlwY4Owl10NE/fMJcXACc/rOrt38
         CswENuk2mEk4I+53JvksmltRMaPncPj0spLwH62zJatFkIPtEHoLLH8pX1WaYBpVNiAY
         EIYuMUPv5YMmuRFp550wpzzXx1jr8CcPaBPhdyFxvq/qYxhTyW1hXuW6zEwcvDSMWOUu
         T2LXFnFzHFSzUDR4ILkT7vlD6xbBKdeXJMDS8tUIvDVGEIW+Yzrh6p8RdIdtsLCuedP4
         soaO8Z6Z1lAgZeD0adQQpgEVDzs94XQld2Oj2Sx0txyIC/b/Ew5LhCsnPBQlysD+8nvw
         wucw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7/n2rpbeqJlIklC2fIxXMA/rV6mHKXGQbAPiEq5BLsM=;
        b=uddXLusD6nyPT2nV9z5EnCo5XpFZXNRS+1AY6eCintVvtt9rKc3lSG5Im9Rlf448GX
         hHf+2wsdc6ClqkxPsXQrLwDncak4JxPhohk3jAGQaXHhvO6/dEYIIchgeeMN0KtnqQoM
         FEGBLImHSaFFTk6mTj72Rl+/ea0pZSlyyFSQHxcKKrumzGaAbpTb3qT7TtdQ0kQbA7Y4
         b3o3Xix8F9B+l6YXyYNxPzd+s3oWZ8ByM0J24CxM+Fq9NeSOtaZmEdMnz5y/db3ZnK+x
         qi/kvOhbnbjbwO8FetpFvS0EZGdn1FiSq33r5JWtJeqhELFEdrIzuE62LNAcKe+9GEDo
         iTFA==
X-Gm-Message-State: AOAM531FlyFR5IRe8ZgPxfDGdRISeOEtsSuSjBpcfhl5NhKSI0Cxl4et
        wC/qRaFfQ9b7DxACqEHvfYQg+g==
X-Google-Smtp-Source: ABdhPJwU3tiCSWEc5k6/hdVsuGs3QgovfC4cfBeEzTT2vPIRaFjiEuTCQ1BJa9/qqQpUuRwQG1bHvQ==
X-Received: by 2002:a7b:c5cd:0:b0:38c:8b1b:d220 with SMTP id n13-20020a7bc5cd000000b0038c8b1bd220mr6862787wmk.118.1653465455410;
        Wed, 25 May 2022 00:57:35 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id j11-20020a5d564b000000b0020e68dd2598sm1307846wrw.97.2022.05.25.00.57.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 00:57:34 -0700 (PDT)
Message-ID: <979fb547-41d8-e346-74f1-ba723b932e7a@blackwall.org>
Date:   Wed, 25 May 2022 10:57:33 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] net, neigh: Set lower cap for neigh_managed_work
 rearming
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>, kuba@kernel.org
Cc:     wangyuweihx@gmail.com, pabeni@redhat.com, netdev@vger.kernel.org
References: <3b8c5aa906c52c3a8c995d1b2e8ccf650ea7c716.1653432794.git.daniel@iogearbox.net>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <3b8c5aa906c52c3a8c995d1b2e8ccf650ea7c716.1653432794.git.daniel@iogearbox.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/05/2022 01:56, Daniel Borkmann wrote:
> Yuwei reported that plain reuse of DELAY_PROBE_TIME to rearm work queue
> in neigh_managed_work is problematic if user explicitly configures the
> DELAY_PROBE_TIME to 0 for a neighbor table. Such misconfig can then hog
> CPU to 100% processing the system work queue. Instead, set lower interval
> bound to HZ which is totally sufficient. Yuwei is additionally looking
> into making the interval separately configurable from DELAY_PROBE_TIME.
> 
> Reported-by: Yuwei Wang <wangyuweihx@gmail.com>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Nikolay Aleksandrov <razor@blackwall.org>
> Link: https://lore.kernel.org/netdev/797c3c53-ce1b-9f60-e253-cda615788f4a@iogearbox.net
> ---
>  net/core/neighbour.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index f64ebd050f6..fd69133dc7c 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -1579,7 +1579,7 @@ static void neigh_managed_work(struct work_struct *work)
>  	list_for_each_entry(neigh, &tbl->managed_list, managed_list)
>  		neigh_event_send_probe(neigh, NULL, false);
>  	queue_delayed_work(system_power_efficient_wq, &tbl->managed_work,
> -			   NEIGH_VAR(&tbl->parms, DELAY_PROBE_TIME));
> +			   max(NEIGH_VAR(&tbl->parms, DELAY_PROBE_TIME), HZ));
>  	write_unlock_bh(&tbl->lock);
>  }
>  

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

