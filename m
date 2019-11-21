Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 562FF105ADD
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 21:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfKUUMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 15:12:34 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:45218 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfKUUMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 15:12:33 -0500
Received: by mail-qv1-f68.google.com with SMTP id d12so3056qvv.12
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 12:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZTfkFLo5neyedyPacSJdpjeVXEUgGeg1YQNu7kYI/uY=;
        b=mffpJSqewIH3pWYkrNsaS2mNFf2GN6kGNQlSclir6Sm5gVtsKfuJgAJLKNYK2YCv/m
         c1MoozBU7Biev6V8cETEdoLkhGd3bwBMgy0R3bfUda65N5Rmeuw1lcKVUS6IGOwqLBWq
         1SE1YT+YoGZHJGbt8yvDqarfjyIvTefLWVyOsYudE4esaOVFzaOmy8HJQJE4OIqT29Jn
         iMSGUES/jj2iukNR4LBnOoFo0y0QWpNJzCdmm323hlgyh6665wXoH9H0vYfGmxt/9LFU
         ceRDhhez+EtCLJf9x3IwlEwoJGONWtBZnjRovG/kt/R4v2S2K/Bv9v9matMrMM/cHLOL
         dV+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZTfkFLo5neyedyPacSJdpjeVXEUgGeg1YQNu7kYI/uY=;
        b=pxp1CpAFpkPLzsG1R3ZFDw/31bnZqhyp6jzreJPOtGf9noDZW31SspOC17LmEzPThX
         gZMvQGzGOIXRSrM1WWYbTkvvmo8WVC55Ay60x4Naj9GP6UCfSVUbKWv2z5IVpOfN88nT
         YoK3UicXY+BKKLQjSUXxIVfFGYZcR8Z/foG6fB0pvpn2NAAHZqMVk1W3NDtYEhX5OLGu
         CcqwUQg2KcNcU6vUoB5OlBDbJ7yCMRyRb7IwS2Fw5yEnyo95uhBVkjtTQ+IiMKAd29JO
         Fhdw+moLnINrBaNo2hCCpWII8IXq05YtfKph+TCDYgi2JpVf7DMeuFJjWNgo5lpKek+a
         7hzg==
X-Gm-Message-State: APjAAAUudaZienGNu0/bl7+LBiKBGd3E9iQ27uDqeFlv77Mq/6ffWH7u
        RyYz/L8WSQTB/xWFjgSFs5o=
X-Google-Smtp-Source: APXvYqzcFnkCpC6X2SA95Ec4Agc+XvecKveFa8ZptD1uaoBvh53Zv9RBkXTRZaQBOOYpgayLPI2qcQ==
X-Received: by 2002:ad4:4c4a:: with SMTP id cs10mr10303466qvb.6.1574367152844;
        Thu, 21 Nov 2019 12:12:32 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:b9b1:601f:b338:feda])
        by smtp.googlemail.com with ESMTPSA id y24sm1899176qki.104.2019.11.21.12.12.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 12:12:32 -0800 (PST)
Subject: Re: [PATCH net-next v4 4/5] ipv4: move fib4_has_custom_rules() helper
 to public header
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <cover.1574252982.git.pabeni@redhat.com>
 <33bda5a0251f1a95a5d730b412f7f3f9fd137d03.1574252982.git.pabeni@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9817e6d4-a47f-1c24-0c5f-6e5e3ee1eb0a@gmail.com>
Date:   Thu, 21 Nov 2019 13:12:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <33bda5a0251f1a95a5d730b412f7f3f9fd137d03.1574252982.git.pabeni@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/20/19 5:47 AM, Paolo Abeni wrote:
> So that we can use it in the next patch.
> Additionally constify the helper argument.
> 
> Suggested-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  include/net/ip_fib.h    | 10 ++++++++++
>  net/ipv4/fib_frontend.c | 10 ----------
>  2 files changed, 10 insertions(+), 10 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>
