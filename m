Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A238C398CBD
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 16:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhFBObr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 10:31:47 -0400
Received: from mail-ot1-f48.google.com ([209.85.210.48]:42959 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbhFBObq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 10:31:46 -0400
Received: by mail-ot1-f48.google.com with SMTP id x41-20020a05683040a9b02903b37841177eso2559661ott.9
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 07:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IiLMmHcn5KulfjfwqwMQzlST/9AG6iSzvPD7mycOf14=;
        b=rV59shqZ/SKAlVQIduPtUpQdiB55dP6o4hIJqbJ8GGn/pBK60TVDxlLkqq6XUIdQ8L
         V5xS1k9eAzJsK46lSKLodBsEkhClgcBVWnozs3uWzAWK+mc+viw5mpo0e5NqKRHfdVfK
         e77nD+ijsRA/6flLWcXh/ga8keDtpE24T61apsUkgtMYv0fD1Ag6Q/ORYOPU8t1yoUOi
         dZNHga5N2GOca5A+abZ57zmV4Oxt57mU6LBrHYco6rz48xJVdvMpaX1dllmbtteO1Hb5
         EhGxjDMjvdPcyHwd0mKxJWEBFGK3GvI5Cug+iPtq2RFIVM/Qw3gxTbrWmA6ykeWLJYOS
         ZjBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IiLMmHcn5KulfjfwqwMQzlST/9AG6iSzvPD7mycOf14=;
        b=GUa4fVS+o6tgnMVNGF/XMCV3PeCTR7j6TVNssJCLibEZ/7f0tvNGG8d+1hJuaoiEa4
         oZTpEPacEP1LGV9cr3NyQjCKqp05y8sbW7IUvIGeY7BQLH7hlCIOkN15Gye4i2hzGWiw
         z326tDKF/n7M0YeAKzCYwbuqd4lHlmTN2IX1J/znM8muH/fXzmiVc13hzXRNgXhRsKj8
         xWMeh8BERTg+QgsKaMemhqZc+XZGZw0qgBphFxye7Ff9ROAwvjp3SfcWGxD0rY6A868N
         nyxBDPSBWOTEd7wdgBeV54dAfuJ2xWLgOVil3CY2x08afTYWXILv8OuzYCH1TxD2gyja
         g0Tg==
X-Gm-Message-State: AOAM531ebIpIz9NOdh7Lwklyf/YbKR0OqrrCmnhIxWrwPvE+4MVwcynH
        Sex+7ER07EadywDmcw0uKvU9dGDEZAI=
X-Google-Smtp-Source: ABdhPJx1xphed5OX+yvFVJtCOpln15kJsePOukVR1PJmeFuW0ttdep/s22TkI393sDAONfhzEeF9qQ==
X-Received: by 2002:a9d:4911:: with SMTP id e17mr26637043otf.38.1622644143527;
        Wed, 02 Jun 2021 07:29:03 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id n186sm12904oia.1.2021.06.02.07.29.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jun 2021 07:29:03 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] police: Add support for json output
To:     Roi Dayan <roid@nvidia.com>, netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Paul Blakey <paulb@nvidia.com>
References: <20210527130742.1070668-1-roid@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e107ce61-58bf-d106-3891-46c83e3bfe8f@gmail.com>
Date:   Wed, 2 Jun 2021 08:29:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210527130742.1070668-1-roid@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/21 7:07 AM, Roi Dayan wrote:
> @@ -300,13 +300,13 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
>  	    RTA_PAYLOAD(tb[TCA_POLICE_RATE64]) >= sizeof(rate64))
>  		rate64 = rta_getattr_u64(tb[TCA_POLICE_RATE64]);
>  
> -	fprintf(f, " police 0x%x ", p->index);
> +	print_int(PRINT_ANY, "police", "police %d ", p->index);

this changes the output format from hex to decimal.


>  	tc_print_rate(PRINT_FP, NULL, "rate %s ", rate64);
>  	buffer = tc_calc_xmitsize(rate64, p->burst);
>  	print_size(PRINT_FP, NULL, "burst %s ", buffer);
>  	print_size(PRINT_FP, NULL, "mtu %s ", p->mtu);
>  	if (show_raw)
> -		fprintf(f, "[%08x] ", p->burst);
> +		print_hex(PRINT_FP, NULL, "[%08x] ", p->burst);
>  
>  	prate64 = p->peakrate.rate;
>  	if (tb[TCA_POLICE_PEAKRATE64] &&


