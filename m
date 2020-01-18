Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA39B1419F7
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 23:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgARWBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 17:01:41 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:34018 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbgARWBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 17:01:40 -0500
Received: by mail-qv1-f67.google.com with SMTP id o18so12380602qvf.1
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 14:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Eh0e7OZNob2D0Zc1ly478io5jyDjroSxiXTuS7EnmfM=;
        b=rpBD3gIZhW9F8QQqc8P+itvkRQsDCE/jtfU8SZ/Lz0p/hc32fEvPx4gq/chcNVoual
         vbedEoA6zCM5YnpPF8Q/lntgDeXfv2NkVAYayg0/JsYnXeT4cam243JPuGa6UGGeK7Lr
         D5jeAM18RhmSQum704H4cAzy4mq3ACq1zEVcy1Vb3dVZ5ugO9rIhqs5UqT8++PMAa0Je
         a6cm3IQehKkFo9oBd2+tx2vlKdeqOwbkgqP5pHL5Q8SBNR5qCIcHwVWZ9QhNHnJ0kv5l
         Z5079f9XyggftNeuQNCLOA0zGv3yChaiJSiRP5JlibbvYjtR8LaKQgBhHrWQS84Y9OQB
         xXvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Eh0e7OZNob2D0Zc1ly478io5jyDjroSxiXTuS7EnmfM=;
        b=JU3gDWHmHihmnLaHL9z1KU9w5n+Hk9doA9+fcZjr3yJtlWB+mGt1Kp7oX06HYQjjxk
         tcigDNWlf2WeCNpaP7PtvxYPLLYiMpNJfppzoZPkHg6Z6ymQ19hmy/x/w7FGcyQTfwKd
         Yl3TK46FSC7E1h7MZ2DSiGiujJGTsR8XU2ECvDy7aYquIxoVwaJUJgjkn2UF8jSnDMuW
         v8vY80Wfh5qtcgmJ2Dimn7WhkLgg+sLhAqem5RAjxPC+ozFaNQNwTFzZm9bWA/m2VII1
         gnj7TlfsUJWeG7NEAdTpJ+7OZaVDKG2NBWoPLy3p/MHuNMWlFq9i/7TXQG8uLCKWjoAX
         rK/w==
X-Gm-Message-State: APjAAAV9GFj9SciRo9tkyMUDJvVgshKJ1Lw0BT8JZGmt7bE0cBLVkyLW
        w7rtDOpy50PyGMZqkBdHq41xXX0w
X-Google-Smtp-Source: APXvYqy/z2N37+292nhbsVZbjskRiCHfY4//1Ct4R5SqfOgIDv5vKBVb9AfqkxTR6GvyZT5bxJBpbg==
X-Received: by 2002:ad4:45ae:: with SMTP id y14mr14060868qvu.158.1579384899947;
        Sat, 18 Jan 2020 14:01:39 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:61e3:b62a:f6cf:af56? ([2601:282:803:7700:61e3:b62a:f6cf:af56])
        by smtp.googlemail.com with ESMTPSA id s20sm13642601qkj.100.2020.01.18.14.01.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2020 14:01:39 -0800 (PST)
Subject: Re: [PATCH] tc: parse attributes with NLA_F_NESTED flag
To:     Leslie Monis <lesliemonis@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20200116155701.6636-1-lesliemonis@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <263a272f-770e-6757-916b-49f1036a8954@gmail.com>
Date:   Sat, 18 Jan 2020 15:01:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200116155701.6636-1-lesliemonis@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/16/20 8:57 AM, Leslie Monis wrote:

> diff --git a/tc/tc_class.c b/tc/tc_class.c
> index c7e3cfdf..39bea971 100644
> --- a/tc/tc_class.c
> +++ b/tc/tc_class.c
> @@ -246,8 +246,8 @@ static void graph_cls_show(FILE *fp, char *buf, struct hlist_head *root_list,
>  			 "+---(%s)", cls_id_str);
>  		strcat(buf, str);
>  
> -		parse_rtattr(tb, TCA_MAX, (struct rtattr *)cls->data,
> -				cls->data_len);
> +		parse_rtattr_flags(tb, TCA_MAX, (struct rtattr *)cls->data,
> +				   cls->data_len, NLA_F_NESTED);

Petr recently sent a patch to update parse_rtattr_nested to add the
NESTED flag. Can you update this patch to use parse_rtattr_nested?
