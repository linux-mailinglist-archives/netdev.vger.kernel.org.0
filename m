Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABEF31D7CFF
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 17:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgERPgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 11:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbgERPgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 11:36:18 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6539EC061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 08:36:18 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id 4so8422055qtb.4
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 08:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f+cowRSytC77qO03IZyReqXLFbkjI+SYF/4QoQDj+38=;
        b=johSNXu8HepGwfz5qB/FhHpkEaFnqvRtzT8ROxYEX6iGk40e+7VM4OWj3PWdJgcl/C
         mPo9lDqn3o0raR/aziSaWRP5SIr6qcIHVNx0p4Tvfg6JpDPjxUddXvjJN2/9DnQ6v8L2
         POFrS8Caju8BHP81MxPyFlKd3cn9g+P57FoUACQqgO6QPAr3yAwshLk3mnTbnfF+Qd1e
         Ac6bJtgNnqEMl/jOdOrkUwihmZfyTGkTjoMRCKByNDg2WnJKHO4hUMseMlP0p5TRMjgC
         OdA5meP4Rdvtb+hgPBDMgU37chKG2taNifFl3tebasg40SwheHCK4IcY/2AWUQP6WMXe
         jBbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f+cowRSytC77qO03IZyReqXLFbkjI+SYF/4QoQDj+38=;
        b=e1xBDTVKOved07NOulC2nkobUZnik6upnDrVMS0ySnIuWveFEinfm2kaqndznv0CHH
         4V1vL7NaVBZxb5MdRk48WcEb4Vuch38Cxvx3pQEp8GDZz18rv9oIuKq5KR4/5fpY4PHQ
         Fk0Y234ivgXuqmfWv16yFcTBlLPUPw+Xxgot6UZsDP8s1dMujhhBt35Fa2x7rgqQFlB1
         qOx2XqfEqVStUPVydo/FWfvxoIhrI2ydzJaLhwb9iYGzJRZhaNFfgpuqzU3nClQblGY4
         FWtxXDoblBmKxbJtadlIn6N6svsBLme4sLBUrFcdHEj3etKET+PARi2qfO5jZBnUMCID
         w28Q==
X-Gm-Message-State: AOAM532EEk9HbKMDfNZgJ4vC5XWLasacQqHuXBWHzOvzKmX2dYQZoa/b
        Wz1WXmLcuJsuUAHpU4SXoVScN7y9
X-Google-Smtp-Source: ABdhPJzoAujRpzxMm3559RIywflOv1uUKGz9aXLoQXHL5afyB8sioG+F3NZCkBkspIORQPE1TSunMA==
X-Received: by 2002:ac8:39a2:: with SMTP id v31mr15260296qte.33.1589816177650;
        Mon, 18 May 2020 08:36:17 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:f866:b23:9405:7c31? ([2601:282:803:7700:f866:b23:9405:7c31])
        by smtp.googlemail.com with ESMTPSA id t21sm9669327qtb.0.2020.05.18.08.36.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 08:36:17 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 1/1] tc: report time an action was first
 used
To:     Roman Mashak <mrv@mojatatu.com>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        kernel@mojatatu.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us
References: <1589722125-21710-1-git-send-email-mrv@mojatatu.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8f9898bf-3396-a8c4-b8a1-a0d72d5ebc2c@gmail.com>
Date:   Mon, 18 May 2020 09:36:15 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1589722125-21710-1-git-send-email-mrv@mojatatu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/20 7:28 AM, Roman Mashak wrote:
> Have print_tm() dump firstuse value along with install, lastuse
> and expires.
> 
> Signed-off-by: Roman Mashak <mrv@mojatatu.com>
> ---
>  tc/tc_util.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/tc/tc_util.c b/tc/tc_util.c
> index 12f865cc71bf..f6aa2ed552a9 100644
> --- a/tc/tc_util.c
> +++ b/tc/tc_util.c
> @@ -760,6 +760,11 @@ void print_tm(FILE *f, const struct tcf_t *tm)
>  		print_uint(PRINT_FP, NULL, " used %u sec",
>  			   (unsigned int)(tm->lastuse/hz));
>  	}
> +	if (tm->firstuse != 0) {
> +		print_uint(PRINT_JSON, "first_used", NULL, tm->firstuse);
> +		print_uint(PRINT_FP, NULL, " firstused %u sec",
> +			   (unsigned int)(tm->firstuse/hz));
> +	}
>  	if (tm->expires != 0) {
>  		print_uint(PRINT_JSON, "expires", NULL, tm->expires);
>  		print_uint(PRINT_FP, NULL, " expires %u sec",
> 

why does this function print different values for json and stdout?
