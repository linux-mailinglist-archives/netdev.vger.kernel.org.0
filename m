Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06FF214A836
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 17:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgA0QlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 11:41:25 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45136 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgA0QlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 11:41:25 -0500
Received: by mail-qk1-f194.google.com with SMTP id x1so10198790qkl.12
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 08:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GPmUTKN65M0Cc6KUBQUIPG3eLDVHEy3PY/AXWvkbCdk=;
        b=CI/So0LHJCyZ9xIoMAccvM67yk0W4a8rKAkcWaMbxojUcb98ZaFuhh1xWzh4i2Aqto
         3IKA7Hr/KF8YKZCHkvAc9v77s6aEe3lRHPh6nvfVYxNrOZgVu6sK0XJGW4lJMZna9wP3
         pBYbpqljuuzpAZcnscvjRnUBOeO0MHaGL5DJ8w9wPA+WCyUw1nlqYxFhNB+YTeRd/GBS
         Z6GVvMzCf7uBpo4P31/AGVDB46Nt+BIAADCbzYR06Hgj9XuuFmnmCT20zrlNG8RNzVL0
         LWey6GyL9LDu1GxawOiEbO4ZPSEg7cOuyXWcJLuCArrm/sZTXJzHmZQO0h1tHf60ia1K
         L0vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GPmUTKN65M0Cc6KUBQUIPG3eLDVHEy3PY/AXWvkbCdk=;
        b=ZknjIYA0fo2CCe5dUd0nwp+M1ZxiEWMqxlBrPJ+aui9onn1OILOLP8HNhcRxI66J3g
         Ze13W0Ivwlf1G8q+lBw0C5lp3GgI0XzwH6o9qG5rHtZq1skR6s5wvc7gC3fdp3yjLMkZ
         cI6NpcCKysjn6hDXPTwCuT6TEJP5k7rYNDty9kVNn9Op2TOf7jcOvpR63SHEgp3KtdlB
         amkDqITZ3G1sQJG4FlqNQxZhVq/cf049mgUit+RzzE3Pew6CiMOfV2COBFMWVmn2pW6D
         cd4MTeb8J1trgX3E7eTqNLY/0nkAxdUbRkeYAAYu7V7pVcfTFHdHKftTB3G5pF6LoD4q
         Rsqw==
X-Gm-Message-State: APjAAAUuk+NxtbnVNykkIXz5OlaHaHYz1MmTTf+eWNpH0FPqIbx3vRgo
        WXkbWWzuVlBGZjLXhU9VYWttyQLt
X-Google-Smtp-Source: APXvYqyJwIP24aJnNjibNCt0OvutAXKjZ8emU38T1KyUZw9LFuuYiZgy+mRIzEIWpzn3OKO9bINveg==
X-Received: by 2002:a37:6241:: with SMTP id w62mr17544416qkb.197.1580143284430;
        Mon, 27 Jan 2020 08:41:24 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:58fc:9ee4:d099:9314? ([2601:282:803:7700:58fc:9ee4:d099:9314])
        by smtp.googlemail.com with ESMTPSA id s22sm7372340qke.19.2020.01.27.08.41.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 08:41:23 -0800 (PST)
Subject: Re: [PATCH iproute2-next 1/2] macsec: report the offloading mode
 currently selected
To:     Antoine Tenart <antoine.tenart@bootlin.com>, dsahern@gmail.com,
        sd@queasysnail.net
Cc:     netdev@vger.kernel.org
References: <20200120201823.887937-1-antoine.tenart@bootlin.com>
 <20200120201823.887937-2-antoine.tenart@bootlin.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <69ba6f7f-9f52-a7fb-7608-955cdb200dd1@gmail.com>
Date:   Mon, 27 Jan 2020 09:41:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200120201823.887937-2-antoine.tenart@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/20/20 1:18 PM, Antoine Tenart wrote:
> @@ -997,6 +1002,19 @@ static int process(struct nlmsghdr *n, void *arg)
>  	if (attrs[MACSEC_ATTR_RXSC_LIST])
>  		print_rxsc_list(attrs[MACSEC_ATTR_RXSC_LIST]);
>  
> +	if (attrs[MACSEC_ATTR_OFFLOAD]) {
> +		struct rtattr *attrs_offload[MACSEC_OFFLOAD_ATTR_MAX + 1];
> +		__u8 offload;
> +
> +		parse_rtattr_nested(attrs_offload, MACSEC_OFFLOAD_ATTR_MAX,
> +				    attrs[MACSEC_ATTR_OFFLOAD]);
> +
> +		offload = rta_getattr_u8(attrs_offload[MACSEC_OFFLOAD_ATTR_TYPE]);
> +		print_string(PRINT_ANY, "offload",
> +			     "    offload: %s ", offload_str[offload]);

you should be an accessor around offload_str[offload] to handle a future
change adding a new type.

