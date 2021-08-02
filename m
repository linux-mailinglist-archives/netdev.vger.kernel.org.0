Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF223DDD59
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 18:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbhHBQQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 12:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhHBQQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 12:16:26 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82559C06175F
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 09:16:15 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id 21so24685027oin.8
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 09:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=D3PTrulmKIKSF+t8dYKOxuaOLjT8bPwtJ1mtyXiq9ks=;
        b=Fm/e+3cuGPpjAr2pGEzBf9yU0YmpCXw2S/0XhU+0Xj/SDZPuePUIcSy3lHX32QCw4P
         qA8n0wWEeEFO1AUQ6OGL8X3f6iF8fxglUcWGf6hqTYlJ1zuNxFTbJqwIu386huRHb01q
         RU2qL5yrt15f1eXPpVJxWGHHe+lh01i0Jvi+mprmFzqEeZvlb6zikh7BTAX20tZsBqTN
         /0m1PCD41AgNFehUkuxISjWowWrOgujGwI4qmF3JQVaRHNl3g6qRPoKkdYlu7lz44MhI
         gdTMM5L6MKaCvQnwjxCdZLmabtKNRhbZOl60G78L0zQwQsLP5sEX6EJv3cUzFteHQlTc
         K3Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D3PTrulmKIKSF+t8dYKOxuaOLjT8bPwtJ1mtyXiq9ks=;
        b=PwVDzN4TOGuW4p/ttQTHfwiGV3HNSCyUXwnKR8AjY21QRK/CLkaR/xaZa6C3i4PJK+
         HnzklkpGDI0rAHnGAE4CJ1isC7zrATHXyi2zQdXjgnz6ySCLtpbkor11k/s+G2YF5UcP
         o4TJ/P5lmgmeL+u8bGPTlLv79WFNlpnM8izu74Uf/urGuN4NpA+XE3vvILYVENmy6JOH
         SYmz3iTqvslH3ZIt1h7U5nhrX2zZOjH6nj2GKAoqMwXbRktJib+5IlJvoHLlsjzZ81cH
         4r6l7/bknI9F3Zlzmc5g19twWYF3Op5BLt44EQvK8/y5Vir1DXfnXOW577NMn5y023wP
         U7cA==
X-Gm-Message-State: AOAM531LEr2eupl0F6fnFDm9D1kSmsFCA5bLpml/fI6Sq6yuAtYeHuI5
        y0+idcROSDz4vNOcCiGXFhA=
X-Google-Smtp-Source: ABdhPJwDneJPRZYB7BNmz3hoWbbNVxROVUvIE8/E4ULrpxbOo50hQGzcY3Rl2DwxsVAoDsjuWJ826w==
X-Received: by 2002:aca:5b83:: with SMTP id p125mr11262320oib.87.1627920974910;
        Mon, 02 Aug 2021 09:16:14 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id a24sm1986470otq.72.2021.08.02.09.16.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 09:16:14 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2] ipneigh: add support to print brief
 output of neigh cache in tabular format
To:     Gokul Sivakumar <gokulkumar792@gmail.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
References: <20210727164628.2005805-1-gokulkumar792@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8656e8f0-70bd-6076-ea07-4bd53bd1a203@gmail.com>
Date:   Mon, 2 Aug 2021 10:16:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210727164628.2005805-1-gokulkumar792@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/21 10:46 AM, Gokul Sivakumar wrote:
> Make use of the already available brief flag and print the basic details of
> the IPv4 or IPv6 neighbour cache in a tabular format for better readability
> when the brief output is expected.
> 
> $ ip -br neigh
> 172.16.12.100                           bridge0          b0:fc:36:2f:07:43
> 172.16.12.174                           bridge0          8c:16:45:2f:bc:1c
> 172.16.12.250                           bridge0          04:d9:f5:c1:0c:74
> fe80::267b:9f70:745e:d54d               bridge0          b0:fc:36:2f:07:43
> fd16:a115:6a62:0:8744:efa1:9933:2c4c    bridge0          8c:16:45:2f:bc:1c
> fe80::6d9:f5ff:fec1:c74                 bridge0          04:d9:f5:c1:0c:74
> 
> And add "ip neigh show" to the list of ip sub commands mentioned in the man
> page that support the brief output in tabular format.
> 
> Signed-off-by: Gokul Sivakumar <gokulkumar792@gmail.com>
> ---
> 
> Notes:
>     Changes in v2:
>     - Reordered the columns in the brief output to be consistent with the order of the
>       fields in the non-brief output.
>     - changed the format specifier width of dst field from "%-40s" to "%-39s " to be
>       consistent with the way width of dev field is specified.
> 
>  ip/ipneigh.c  | 50 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  man/man8/ip.8 |  2 +-
>  2 files changed, 50 insertions(+), 2 deletions(-)
> 

applied to iproute2-next

