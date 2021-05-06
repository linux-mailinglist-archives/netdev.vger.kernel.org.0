Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371403755CF
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 16:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234868AbhEFOoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 10:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234694AbhEFOoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 10:44:30 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 241A6C061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 07:43:32 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id u16so5693949oiu.7
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 07:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f7ofW2xC9Rc1eJQ3LcUPSm1Hf7o3VqJmsXqwq/QMkwc=;
        b=PqYhngOrQIo7ZDM5J7XSVRi1llfglrPBKPb+QqHKRjVXW6tgx3zKY4CIpWXyDJRrOO
         I8W9pgjkRsUovYKcXpg0hQM8J4E3eM2ZVpJOOyYcw5saEEX4Hv3j6Pwz+m28Xdmtqziz
         1wPmVB3Zdlat7G+BoFg7JvrAiJPEi55R9KiQkqdGe+drBpH41jwiUZv/Z2VM3jxS1QUH
         ZJ4pFC7CPLTLxFi5B5Z/VR3VZ+IAFFv5arZyePlwwJzMA1Xi6wl8PvsHWB3fmJabijVQ
         MNsXzhxLozYF4WE7UJ82BrwSDsYzoLL3s0JQyJ8uyJTuU5uYrV4zQ62sNi1n9l5aoamQ
         57UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f7ofW2xC9Rc1eJQ3LcUPSm1Hf7o3VqJmsXqwq/QMkwc=;
        b=Hnt1TfO+z6JUVnsCS5KvsDWxleBkR88D1tazZ3NZCfvUj5mooSb5oY36h8AOzAIAgj
         LbTvcKnAWjMM7QVynyX1EjOFkuCAHpuxu9qEgqcAYa4MJDrX8mHKTXaFKKtk8DPV5xtv
         QjBpatK/R2BpTjVpIprZY6n8cqrKqwIgSeBn+OLa0KZFiJoqCdabPjdDTxd12m7pYOUv
         xmk+3W6N32iAPyZkCjBOy0ssqjATraNlfZ7SLIVRLFLyROwg09bL3nE04nZXp4qcvT8l
         8cmU0ldldTomCWWfYNsvRoSE/jRyyi+dokbDtwh7kOLn6DemTd72Ro2v7xDApcWwLu3T
         sYiw==
X-Gm-Message-State: AOAM533Su+hq8Tt6yCvrrxK7TDRPqbbmK03xkzadDhMOOtRa/unbImbN
        w2LCfzmWaYyoGBIQwRF1aLXobq+Ytp8=
X-Google-Smtp-Source: ABdhPJyEU5LrLBUJyVpdFrIXZSjZGHjt46/0KYTOhU3z5pIwcBv4nmTNm+Qyt7Uin0GI6Wo4HVhcJQ==
X-Received: by 2002:aca:b8d4:: with SMTP id i203mr11378511oif.61.1620312211598;
        Thu, 06 May 2021 07:43:31 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:73:7507:ad79:a013])
        by smtp.googlemail.com with ESMTPSA id w10sm536575oou.35.2021.05.06.07.43.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 07:43:31 -0700 (PDT)
Subject: Re: [PATCH iproute2] tc: q_ets: drop dead code from argument parsing
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
References: <a98f8ff492c5be9f06a6ad6522371230c5721ee7.1619887263.git.aclaudi@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <76a44538-7de0-f4d0-d541-dea7e1583bb3@gmail.com>
Date:   Thu, 6 May 2021 08:43:30 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <a98f8ff492c5be9f06a6ad6522371230c5721ee7.1619887263.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/1/21 10:44 AM, Andrea Claudi wrote:
> Checking for nbands to be at least 1 at this point is useless. Indeed:
> - ets requires "bands", "quanta" or "strict" to be specified
> - if "bands" is specified, nbands cannot be negative, see parse_nbands()
> - if "strict" is specified, nstrict cannot be negative, see
>   parse_nbands()
> - if "quantum" is specified, nquanta cannot be negative, see
>   parse_quantum()
> - if "bands" is not specified, nbands is set to nstrict+nquanta
> - the previous if statement takes care of the case when none of them are
>   specified and nbands is 0, terminating execution.
> 
> Thus nbands cannot be < 1 at this point and this code cannot be executed.
> 
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  tc/q_ets.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/tc/q_ets.c b/tc/q_ets.c
> index e7903d50..7380bb2f 100644
> --- a/tc/q_ets.c
> +++ b/tc/q_ets.c
> @@ -147,11 +147,6 @@ parse_priomap:
>  		explain();
>  		return -1;
>  	}
> -	if (nbands < 1) {
> -		fprintf(stderr, "The number of \"bands\" must be >= 1\n");
> -		explain();
> -		return -1;
> -	}
>  	if (nstrict + nquanta > nbands) {
>  		fprintf(stderr, "Not enough total bands to cover all the strict bands and quanta\n");
>  		explain();
> 

applied
