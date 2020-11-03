Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D9A2A3A08
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 02:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgKCBsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 20:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgKCBsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 20:48:17 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70075C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 17:48:17 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id k21so16875877ioa.9
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 17:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9SfZ0Gpy3IJAx30V3lfjRSTHPYLFvQ//dYwpcGyhguk=;
        b=rgXL2ca8jCUAlm+FFHFpEs2vbO0b2PVFvD/268mwPXdpn9EeKwtSeOpunh7gwZKByS
         p+O9tf32a2+2/HJ/GEqr931Femj3PG15aWRmd2yqDH2INdpargyWicjZ83Usvfsk6B1k
         JMaV1INDN/QlbslnZHAW/w2in0JFa7YSAKNMdlZPgNdLpjW0qg661OPhFMyw7dOlCrCB
         HS2ZGe1U0fqQS03x8FdXd6dO5GSK6R3s9KZOBSA/mr1GDynMxTBhcxePMnIzUGn1SuJ+
         1ZJoVtZNSI+eM9FPedKISMW3JljBTyfHqP9yHDM0IVnevPYNQpAdsb152P2E8mcJ2mA+
         5txw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9SfZ0Gpy3IJAx30V3lfjRSTHPYLFvQ//dYwpcGyhguk=;
        b=rR90tgg2bv8qH3bbCRkBm94/r0ZvARK2Vaz8cAfWx+Mef2Su2NZfrajDLQ0yFMkbYw
         yHRRnw8WhCyyDP+UyLJIA4PgzzsapKbsuSfAxU7Up/kd3mKFeUTC/QGbAroOeqddQJ/F
         iIFZQ/u0VJ4Bacgh07rZ21IMbhSigzsWR04tNx5rtnmekPnn+2EoLfvyHsIQVLdPsa7d
         fOB55kgA1D5CEkjoXF3kN6AA//Rds6kIX7NiyaR4CSqUmfZerq79pw5Qcjy1nznhBZ4B
         2aBm1lq4dmBxaqJFEzqkxhJxPox5KCcYkb2pbNXkNgzaP4PCmtWj2teiwx7zPlt+H1zP
         EB+g==
X-Gm-Message-State: AOAM532C8nzArDYWTF3qmUKrOqvVSHyyRgymC0lszcIPGlz3GYqe82VP
        tlXoeE2qvepcGzC0ikCkppA=
X-Google-Smtp-Source: ABdhPJyzimjaFcGc8GME0Fwr9KFVZ47Jicdhu6OvOMvs0wZMjjsvj4lZNSOTz9o+cou2kOCLytT3mQ==
X-Received: by 2002:a6b:7205:: with SMTP id n5mr2114562ioc.208.1604368096812;
        Mon, 02 Nov 2020 17:48:16 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:4ca9:ddcf:e3b:9c54])
        by smtp.googlemail.com with ESMTPSA id s127sm11957130ilc.66.2020.11.02.17.48.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 17:48:15 -0800 (PST)
Subject: Re: [PATCH iproute2-next] tc: implement support for action terse dump
To:     Vlad Buslov <vlad@buslov.dev>, jhs@mojatatu.com,
        netdev@vger.kernel.org, stephen@networkplumber.org
Cc:     davem@davemloft.net, kuba@kernel.org, xiyou.wangcong@gmail.com,
        jiri@resnulli.us
References: <20201031201644.247605-1-vlad@buslov.dev>
 <20201031202522.247924-1-vlad@buslov.dev>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ddd99541-204c-1b29-266f-2d7f4489d403@gmail.com>
Date:   Mon, 2 Nov 2020 18:48:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201031202522.247924-1-vlad@buslov.dev>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/31/20 2:25 PM, Vlad Buslov wrote:
> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
> index 5ad84e663d01..b486f52900f0 100644
> --- a/include/uapi/linux/rtnetlink.h
> +++ b/include/uapi/linux/rtnetlink.h
> @@ -768,8 +768,12 @@ enum {
>   * actions in a dump. All dump responses will contain the number of actions
>   * being dumped stored in for user app's consumption in TCA_ROOT_COUNT
>   *
> + * TCA_FLAG_TERSE_DUMP user->kernel to request terse (brief) dump that only
> + * includes essential action info (kind, index, etc.)
> + *
>   */
>  #define TCA_FLAG_LARGE_DUMP_ON		(1 << 0)
> +#define TCA_FLAG_TERSE_DUMP		(1 << 1)
>  

there is an existing TCA_DUMP_FLAGS_TERSE. How does this differ and if
it really is needed please make it different enough and documented to
avoid confusion.
