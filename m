Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 435EF6D882
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 03:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfGSBm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 21:42:56 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46291 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfGSBm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 21:42:56 -0400
Received: by mail-wr1-f67.google.com with SMTP id z1so30550507wru.13;
        Thu, 18 Jul 2019 18:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ahdHibGHy9qahFvO4H+ZrJxqOuoRka1XVbwU+ThPrP0=;
        b=l88tQwrwYYL1zDLla+GgAth84oKoQ6mAldxMgDaFKag7GTh5WpqCfOFH6+Iw1rtGKn
         eNSaaR/R3z4nnWOPv34tr6NeFurgqp4w/wX8xONOjW8jZEh2kthtP1hj+SJgn7xk15DD
         Q/Rk/niXgHssCEQ9KCCuOP7em9JEmNgUkFkwThc0ia8R5NzCmcARIWi+Ndd+BauyXVnb
         1+s03c500bInQiVtZPi4HbTPXVMusgJcD1+/WckD2LeEBvWsvOgW3RqrcvNGMvw5BZZX
         8w44sUQCz7U9IBVGvVaNqdi2dpXNdAdWMPpvKk5JUhWajpo8aSYSCIeMtd6kMh8kWkli
         /VXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ahdHibGHy9qahFvO4H+ZrJxqOuoRka1XVbwU+ThPrP0=;
        b=BENFysB/4OGkw+L/jUcDqsw6zPer8FYtv9iGTo6w+kI48m+PRFbfR7eod0gEaVtxPD
         bOzLLEUjcGVASknjWtqE+gNzbkxrWVi+W3iagJdXQNdmWe06FvhS9CfUnmU4qXKzNshJ
         YGVJxS0X0IkKcTensD9ygFALbXdAFjVHh+eZXnSju6Be4o7W2kqv628BFsudeKAmr6TL
         5Z7CQlshcRv9KbYA7COyEc5yqjyQIOQSRLS8fKpQwu5Y4FLrGT1rfrEVyyFY8Q0wh8of
         LQ0brWTz3iFc8LbOZ6DNcel3f4wSExyGGgW1QuOm2X95ceSikrueSdKl73QGxXr7SkXq
         Pw2g==
X-Gm-Message-State: APjAAAX501pr8eTJ82BCS5GDP9m9i7OsLeRpwtBe29Gv0C01K5QxlY+s
        1iYQjgxF23pGKlEOl6n7LSsYAzdN
X-Google-Smtp-Source: APXvYqw/1Dw+nt9l5hs2rHp1pnUlgEgKHH0Aw10om65f7H+8pRyubOuadfFPiwjo6JjwpYpa8z9MdQ==
X-Received: by 2002:a5d:468a:: with SMTP id u10mr700283wrq.177.1563500574829;
        Thu, 18 Jul 2019 18:42:54 -0700 (PDT)
Received: from [192.168.8.147] (104.160.185.81.rev.sfr.net. [81.185.160.104])
        by smtp.gmail.com with ESMTPSA id g10sm20968878wrw.60.2019.07.18.18.42.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 18:42:53 -0700 (PDT)
Subject: Re: [PATCH] sch_gred: kzalloc needs null check
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190719013026.24297-1-navid.emamdoost@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c557b5be-202e-d0d5-5c28-5abe138ab81c@gmail.com>
Date:   Fri, 19 Jul 2019 03:42:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190719013026.24297-1-navid.emamdoost@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/19/19 3:30 AM, Navid Emamdoost wrote:
> call to kzalloc may fail and return null. So the result should be checked
> against null. Added the check to cover kzalloc failure case.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> ---
>  net/sched/sch_gred.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
> index 8599c6f31b05..5cd0859f0274 100644
> --- a/net/sched/sch_gred.c
> +++ b/net/sched/sch_gred.c
> @@ -697,6 +697,9 @@ static int gred_change(struct Qdisc *sch, struct nlattr *opt,
>  	}
>  
>  	prealloc = kzalloc(sizeof(*prealloc), GFP_KERNEL);
> +	if (!prealloc)
> +		return -ENOMEM;
> +
>  	sch_tree_lock(sch);
>  
>  	err = gred_change_vq(sch, ctl->DP, ctl, prio, stab, max_P, &prealloc,
> 

This seems not needed.

The case is handled later in gred_change_vq()

