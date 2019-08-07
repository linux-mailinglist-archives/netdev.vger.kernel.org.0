Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC0278536B
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 21:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388907AbfHGTHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 15:07:42 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37136 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388852AbfHGTHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 15:07:42 -0400
Received: by mail-pl1-f194.google.com with SMTP id b3so42219582plr.4;
        Wed, 07 Aug 2019 12:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vsDTBJJ0ypH9fpl/tZNLdNhg4lWZTK6zoRj1I99eK2Q=;
        b=Tahh0Xltm/LjVmnTzoUJpnXKsbWs1iOEsw8f0xkQVKf52GvlsWj8yq3pEKfgkjfFzR
         Jc1rdZg7f+J+PTt+NYQJiUljcaCPgtn1v+pfmqvLT+MbM/X/HeJcfYsOGJX2V5RbxMZ7
         uFA2PNvyYvMSjm6zRUiTyv2aUS9vqlSx7jP2TTfBzOaTGO/ejrWUTeT5ahs1QXk1OGHS
         X2s4abkjk5EPqtCLAfYDRLAuXXyQicrZGNJ0Ov5Fsprx+bEvhxLoyqfTipLju7k23KEX
         crz3VQcC7Dhvib62qfRI+T3OZfpUxK8AArRMgP7Nzu9seXwX2LdpDnr/VlXisXypinxb
         g82g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vsDTBJJ0ypH9fpl/tZNLdNhg4lWZTK6zoRj1I99eK2Q=;
        b=qCqJSQOKySmb0RYQnIP49dI+dkeLGa170h/RWIeIhLHt6oc2eOHSMEDk72Oi6HiSoC
         j05J7WV8hdg8scGn3C+svMFmuvgcDf5f7eYNmPI+FuwL+ey+qoVM7IgX7fpWpo5IuIMD
         X/X+9M3xyl7ZL7keOvl1sjuHidHKT35WIBQKDRQeaUoCByxfAGuPTLmhwKDcwD7cdvSy
         0QkQ6Km2EIbAprPYftuKUWEUJ7S48rvKj5tzmEXLswWQUoMyjzy4gdOQjlvgyKBJW1Mq
         WA8MPYMSzuMpCWLlKaPuZEeeqFKY3+drBAUo5G8fmnq9i95+LncqEuoR6HlmJYpFU4QZ
         f24g==
X-Gm-Message-State: APjAAAVYnSPBmZT9Tcyx0cAkTMznr9BYb1TVNXmh0cUmCvrZX8XZDpbP
        rultGUISlI06Es+/YGw3RcU=
X-Google-Smtp-Source: APXvYqxGZ1JrT6BNB+g/l62bZh9G2FdoYxv2xYJEQxg1B3FDHWfKwUw9uEfRFr9tl4hAp8gre2CTnw==
X-Received: by 2002:a65:6495:: with SMTP id e21mr9055614pgv.359.1565204861188;
        Wed, 07 Aug 2019 12:07:41 -0700 (PDT)
Received: from [172.27.227.247] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id r2sm113154271pfl.67.2019.08.07.12.07.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 12:07:40 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] rdma: Add driver QP type string
To:     Gal Pressman <galpress@amazon.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Leon Romanovsky <leon@kernel.org>
References: <20190804080756.58364-1-galpress@amazon.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <abdb0a98-dc7c-eea9-2382-507dea7a5391@gmail.com>
Date:   Wed, 7 Aug 2019 13:07:38 -0600
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
> 
> Signed-off-by: Gal Pressman <galpress@amazon.com>
> ---
>  rdma/res.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 

applied to iproute2-next. Thanks


