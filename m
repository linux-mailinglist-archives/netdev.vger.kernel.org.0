Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8619A8254F
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 21:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730326AbfHETIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 15:08:05 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45615 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbfHETIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 15:08:05 -0400
Received: by mail-pg1-f193.google.com with SMTP id o13so40193246pgp.12;
        Mon, 05 Aug 2019 12:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=idFG2mTEpSbw73WHSjePYJvH/E+3K7M4GqzEgN2zlLY=;
        b=ZayV7+qrst7eyG8CshixkEtbJEa0x/8jVG45IgTW3ZXhLUvOl4ptoJHoQAy1b6zOK3
         WRmrrB8k4j08mO0fqBF+llGfj8N05RBvJTbVq16Z2I0uBVrW4H9y12yHxE0EvLAe0B3t
         T8O7qgQvAmw2WWULTwaM/xa7nUGqWr7GoxbiVtH8n8y4CX6Q2EYM2c4QzWrA3TY+hcJs
         6n9BqjG7ZaAwGHK6qEXsitI172QtFXfl8RLE0Md+Ld87Jx+5WaY5TSQqfboyN4ctn+z8
         Bo8iI+7oYvnW9k3XvMdrY71NXZf7aVD8ExNcxRg3XfOVggPLoUvTFuXqTJINDGG0fTL3
         OJTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=idFG2mTEpSbw73WHSjePYJvH/E+3K7M4GqzEgN2zlLY=;
        b=OG4buZ5hEKuGB2X23XVWvwa7utrgZr6SGYdgr4t1/gwuvt+i6gTYoS3latdrWk1xEk
         D5OsKw54XExkXkWK6NeyQ+VvggIY4WXFMwpHfyvNaPGlj4q2oajKmNWdx96fIeVptr1n
         UVjoxuDbN5O9/I5jSL0vgeCigrDThLuFPS1nMOsDX9jj6tjyHYfN9aqcnbtZ2u4zygNO
         tqNn2pzBVhXGJLJRLFJA57882NwwE8z1KX3Pf1fnesVzk2gYlIGwdPz1WwvMXUXexakp
         6YucycgHhw+myFY9c7hyYIcqPJ+9Evls9irsJcgTigu2/8o6qcsakzxeJWtc2c5DUTKW
         0PKQ==
X-Gm-Message-State: APjAAAUCufqhCGRY0KmFarTg7D5w923AuM11stAFeO2xyUJxPzuuq1Jp
        2qRpRhjxU6fqM+k8zK/SYe/DFxx+RsQ=
X-Google-Smtp-Source: APXvYqyc7o+C/Qk7w77byYcljAodqdjEYcOgFI6vqLs/YZEsnATcqCv1Ru0jxpEpj1fWOqE03zFqZQ==
X-Received: by 2002:a65:4304:: with SMTP id j4mr141221056pgq.419.1565032084722;
        Mon, 05 Aug 2019 12:08:04 -0700 (PDT)
Received: from [172.27.227.246] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id z63sm59188703pfb.98.2019.08.05.12.08.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 12:08:03 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] rdma: Add driver QP type string
To:     Gal Pressman <galpress@amazon.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Leon Romanovsky <leon@kernel.org>
References: <20190804080756.58364-1-galpress@amazon.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fd623a4e-d076-3eea-2d1e-7702812b0dfc@gmail.com>
Date:   Mon, 5 Aug 2019 13:08:02 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190804080756.58364-1-galpress@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/4/19 2:07 AM, Gal Pressman wrote:
> RDMA resource tracker now tracks driver QPs as well, add driver QP type
> string to qp_types_to_str function.

"now" means which kernel release? Leon: should this be in master or -next?

> 
> Signed-off-by: Gal Pressman <galpress@amazon.com>
> ---
>  rdma/res.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/rdma/res.c b/rdma/res.c
> index ef863f142eca..97a7b9640185 100644
> --- a/rdma/res.c
> +++ b/rdma/res.c
> @@ -148,9 +148,11 @@ const char *qp_types_to_str(uint8_t idx)
>  						     "UC", "UD", "RAW_IPV6",
>  						     "RAW_ETHERTYPE",
>  						     "UNKNOWN", "RAW_PACKET",
> -						     "XRC_INI", "XRC_TGT" };
> +						     "XRC_INI", "XRC_TGT",
> +						     [0xFF] = "DRIVER",
> +	};
>  
> -	if (idx < ARRAY_SIZE(qp_types_str))
> +	if (idx < ARRAY_SIZE(qp_types_str) && qp_types_str[idx])
>  		return qp_types_str[idx];
>  	return "UNKNOWN";
>  }
> 

