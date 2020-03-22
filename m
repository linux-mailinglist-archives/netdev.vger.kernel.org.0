Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4198318ECBD
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 22:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgCVVnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 17:43:21 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:43225 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbgCVVnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 17:43:21 -0400
Received: by mail-il1-f194.google.com with SMTP id g15so2178601ilj.10
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 14:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1CHo0x7Wfa4qJuuhN1bUA7KIQ3CQGNq7ky+pcnD/4Uo=;
        b=CEsmlKBOQmY99DNo8MbwuwxfPrxPANZ5DyeJnrNTY6rqzRcRltn7VGm2LybgyxP9vo
         G1EoYAP1hqSmjQ7QDXoXiN/BomPjTgSpEFzTJy0NZ+bpPhDWsIpBN9Gfv94kct1k2cL/
         LiTBjvD1hrYoec1zGrPE1uyeibj2WeWxfm6czZy6wCKkUYQuqx/7CMNVswBHq30SFoSn
         Hr3bU+34lJGLF8XS5oWwX7YLmaGBtbmoeSVslC2XrB/FDZZjOpN2kBk0mjZ5Kx6O62W5
         DNIiVD4d4sVQODAFrggBupgdM076o1LaOj6YzC3wGJHMNXorzuDrGHEoniG9LSqDA03X
         xLaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1CHo0x7Wfa4qJuuhN1bUA7KIQ3CQGNq7ky+pcnD/4Uo=;
        b=VhOnLrrgq6iJ3vt0jUMc5yiWBnrxUQWSSIrNp3dDP1SecOUy5jzyIMVP2PtXM0Uxb4
         cJ8v9RqPRNnpL8/lo6sISVy3O5id4ulGz50p9tOfYYsHU2y2OkkpNL3QIsT2PJRw3OPp
         CSV7evF13Lw2a/byTDiSo+PMo6DODy+XVM0AjRH5vio7IW1A2Zok9UfNCkdhJ1bOR12w
         zfzVFso9G78gZyvbXBBsJ4OAkBJTQGhgazYd2eQE/jbltCcgPRfvBQp3zQFpTaDtty/T
         OwCJH3opOEHlRI6fxyEgdaRPdcWJ2LxCT8Oc6y6WE+S9oNrMKT6gAn4bM/obH9CgsqX3
         RCuQ==
X-Gm-Message-State: ANhLgQ16h+LGyMLLp+biUw11Mj5zHgrTTZ8xqstcXn8q1LjrzmxZ0SwS
        Y5aBooT/D3OwjImHerYhQ5w=
X-Google-Smtp-Source: ADFU+vs7h2tT00HbfKqb22pmXHjuWtkDwjK34tUHw82MfCDEz2XVI8KtTBcTRYnEgbCtPl7YUhd09Q==
X-Received: by 2002:a92:c841:: with SMTP id b1mr18140904ilq.116.1584913400625;
        Sun, 22 Mar 2020 14:43:20 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:1523:c157:28b9:614d? ([2601:282:803:7700:1523:c157:28b9:614d])
        by smtp.googlemail.com with ESMTPSA id n26sm3784794ioo.9.2020.03.22.14.43.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 14:43:19 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 2/2] tc: q_red: Support 'nodrop' flag
To:     Petr Machata <petrm@mellanox.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>
References: <cover.1584533829.git.petrm@mellanox.com>
 <bb3146bd93e4c5f089033311e8a0418f93420447.1584533829.git.petrm@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4ace5bb3-df27-44eb-dee7-6469deb0ec1b@gmail.com>
Date:   Sun, 22 Mar 2020 15:43:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <bb3146bd93e4c5f089033311e8a0418f93420447.1584533829.git.petrm@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/18/20 6:18 AM, Petr Machata wrote:
> @@ -154,6 +161,7 @@ static int red_parse_opt(struct qdisc_util *qu, int argc, char **argv,
>  	addattr_l(n, 1024, TCA_RED_STAB, sbuf, 256);
>  	max_P = probability * pow(2, 32);
>  	addattr_l(n, 1024, TCA_RED_MAX_P, &max_P, sizeof(max_P));
> +	addattr_l(n, 1024, TCA_RED_FLAGS, &flags_bf, sizeof(flags_bf));

the attr is a bitfield32 here ...

>  	addattr_nest_end(n, tail);
>  	return 0;
>  }
> @@ -183,6 +191,10 @@ static int red_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
>  	    RTA_PAYLOAD(tb[TCA_RED_MAX_P]) >= sizeof(__u32))
>  		max_P = rta_getattr_u32(tb[TCA_RED_MAX_P]);
>  
> +	if (tb[TCA_RED_FLAGS] &&
> +	    RTA_PAYLOAD(tb[TCA_RED_FLAGS]) >= sizeof(__u32))
> +		qopt->flags = rta_getattr_u32(tb[TCA_RED_FLAGS]);
> +

but a u32 here. These should be consistent.


