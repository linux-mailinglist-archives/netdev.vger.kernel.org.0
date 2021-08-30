Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 257FA3FBB62
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 20:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238199AbhH3SFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 14:05:08 -0400
Received: from mx.ucr.edu ([138.23.62.67]:63019 "EHLO mx5.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229839AbhH3SFH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 14:05:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1630346652; x=1661882652;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EV0CA4QYVeRvWpTTWlMsAkvOjxIS6mBEFrs72ID25z8=;
  b=r1FLnH/Uz0iYITxoU2nztanCuERFyonH9kZ7alXG901aB99cF7/vXi6f
   hXaBu0sUjlaHkxLU7Tm4BrBtA9A9zXDj4VoTDPkkzbQT29xrZBYCo3d5B
   FqBnQUYGOytkxPxjGh5V9sJWyDWHJ0fGGwLPH9WVE8CRv/yQdaMOlVSx6
   jXqidhWWL0hTi7eLskT7Mi6qhhj7qxVtfaDPzDLWkjMdZT6W+tIX23XEt
   0QMYUEhDRLYhlT3D2esWBerniXGS9mavuimKPC+PEYOMoUORwQ+aLVFKE
   hENAT/gwC4pWNYSTSHYOIHxKIgRYOhBwXrRtNqC3njw+7ShvSe//w8S1v
   g==;
IronPort-SDR: j2XoPxYPI7Hzh1dRsQ3+M1OstOxZxAs9X8AYPOcZMkNbjwso1EBFP9AKe/KXvLZqvF2sDKv/4c
 ox5Wg9MDWPNcFgR9EouciEmE38lDIBOwdVVU+CHE3DZqFAaW1HHMPuyh18ObtGq8jdv+++vMdi
 8IFv+RIBedaRAW8CdMlNleeomb0yD+TI0GtWHmPz0aN2F8WFV1//04fSml7fSfmfTSkhl06OU6
 0rGuQ4HR0pFCRvcRiZ4hMOAnQeuP4ePCnW6+As8hzLQ0PZBZZh0dqVlbcAEbK7nZcwy6YMaeQg
 PB+WlMnfCS/ttK17343mXxKA
X-IPAS-Result: =?us-ascii?q?A2FpAwCHHC1hf8egVdFaHgEBCxIMQIFOC4FTgiZrhEiRD?=
 =?us-ascii?q?IQZl1+BJQNUAgkBAQENAQE/AgQBAYRuAoIyAiU2Bw4BAgQBAQEBAwIDAQEBA?=
 =?us-ascii?q?QEBAwEBBgEBAQEBAQUEAQECEAEBgSILWQtjgU+BeQYEPYI1KQGDbAEBAQEDE?=
 =?us-ascii?q?hEVQRALFQMCAiYCAjQBBQEcBgEMBgIBAR6CT4MIAQSgD4EEPYo4eoExgQGHf?=
 =?us-ascii?q?QEJDYFjCQEIfiqJfoN8J4IpgTwMgnY+h1uCZASGYIEPg3gCAZBnjg5fnR4BB?=
 =?us-ascii?q?gKDERyeRwYUKINTkXqRNJYYl0qNXgIKBwYQI4FFBmiBIDMaJYFsgUtNAQIBA?=
 =?us-ascii?q?gEMAgECAQIBAgECCQEBAp0NITM4AgYLAQEDCYVojBoBAQ?=
IronPort-PHdr: A9a23:+z8xnBNfcTGnDnXQC7Ul6naZDRdPi9zP1u491JMrhvp0f7i5+Ny6Z
 QqDv60r1QaYFtyCsbptsKn/i+jYQ2sO4JKM4jgpUadncFs7s/gQhBEqG8WfCEf2f7bAZi0+G
 9leBhc+pynoeUdaF9zjaFLMv3a88SAdGgnlNQpyO+/5BpPeg9642uys55HfeRhEiCe5bL99M
 Rm6sBvdvdQKjIV/Lao81gHHqWZSdeRMwmNoK1OTnxLi6cq14ZVu7Sdete8/+sBZSan1cLg2Q
 rJeDDQ9LmA6/9brugXZTQuO/XQTTGMbmQdVDgff7RH6WpDxsjbmtud4xSKXM9H6QawyVD+/9
 KpgVgPmhzkbOD446GHXi9J/jKRHoBK6uhdzx5fYbJyJOPZie6/Qe84RS2hcUcZLTyFPAY2yY
 IQBAOQcI+hYoYnzqFkSohWxHgSsGOHixyVUinPq06A30eIsGhzG0gw6GNIOtWzZotDrO6YST
 OC+0a7Gwi/Fb/hL3jr9643IfQonof2QQb58bNHcyVQzGAPflFmft5HqPy6M2+kLrmOU4PZuW
 /i1hG47twF+vCKvxsE0h4TXmo8YxVTJ+CRkzIs1JtC0VlJ3bN2gHZZfuSyXOYh7T8E/T2x0u
 ys217wLt5C4cSUI1ZkqyAPTZv2FfoaG7B/uUvuaLzRghH99Zr6zmxK//VKjx+D8TMW4zVdHo
 jZfntXRsn0A0wTf5taGR/dh4kus3CuD2gLP5u1YJE04i6TWJ4A8zbM1lZcfrUXOEjPzlUrrk
 KObd0Up9+2m5uj6f7rqu5qROJF1hwz9MKkjn8iyDOYmPgUMWWWQ5P6y26f5/ULjRbVHlvg2k
 q7Ev5/EPckbvau5AxNN0oYk9ha/Ey+q0NQGknkDK1JIYBeHgJLoO1HKOfz4FOu/j0m1nDdl2
 vzLOrnsDo/CLnjEl7fhcrJ95FBGxAUvytBf4opYCrAHIP3tRk/8rMLUAgM9PgCuwOvqCM9x2
 p4fVG6TGKOVLaffvFuQ6uIqOeaMZYsVuDjnK/gi4v7jlXw5mVoHcqmvwZcbdG20E+97I0qFe
 3rgmMkOHnoXvgYmVuzllEWCUSJPZ3a1R6884C80CJ67AojdWICgm6KB3CilEZ1MfGxGCU6DE
 W3ud4qaX/cAciWSItVukm9Mab/0ZpUg3lmCqQrz2bd7Zr7Z4CwT857+0dFn6vH7mhQ79DgyB
 MOYhSXFBU19gGIEDwR+muhaoEh5x03Jmfx0iuJVEPRf7u1EVwM9O4KayeFmXZS6eAvCY93Ba
 1etQ9O9AjB5GtEsydYmYEtnHdimyBfZ0Hz5LaUSkumoCY0puofV2TClJMN0zS6ejYE8hENgT
 8dSYz71zpVj/hTeUtaa236SkLynIOFFhHalyQ==
IronPort-HdrOrdr: A9a23:sLeGE6G36FAQ01y3pLqEzceALOsnbusQ8zAXPo5KOGRom7+j5q
 aTdZMgpGDJYVcqKQ0dcL+7Scu9qB/nhORICMwqTMqftWrdyQ6VxeNZnOjfKlTbckWUltK1l5
 0QCJSWYOeQMbEQt7ec3ODXKadY/DDKytHNuQ4c9RpQpMNRAZ2IIz0XNu9TKCEZeDV7
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="236182079"
Received: from mail-qt1-f199.google.com ([209.85.160.199])
  by smtpmx5.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 Aug 2021 11:04:11 -0700
Received: by mail-qt1-f199.google.com with SMTP id l24-20020ac84a98000000b00298c09593afso77080qtq.22
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 11:04:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YXra3wCUifQY4g4tI1/fSMaEAsxSkaWUwetE+GeU5Mg=;
        b=KPjhqPZlx2Zkf0wBAabdpkiuNv4Bxwwp9eKNqAks8ga+Rxdtj1krGZ83kEms2ojrhl
         Q2xzUD5yVmPfLgftCTemC7FCcFPQ0qWao8qLkocybxpCYHZW5BiZwXAcAGvSre0B3ohB
         Z1xc2R4pfRUlrmGMCUwSJtT2I4AJUohN+0lhkN8Bxl+kLwSrypJHMV50dcUQ/nGh553i
         YmGjY5wQwFSMHMzJ0WWEtzBKswIZIEYtO8iuZRsvY45B4kH4FT4qhdfya8PwSlga8vR4
         NXEJh6H2FkuKTMLJFCDh5FWWl8C1rvmMldRDAxspxtxee1Wi0RAj16U/VBS0RxoUw208
         cOqA==
X-Gm-Message-State: AOAM531XTYvDtCLqrFEYakcycyTS55fdiCEhg4nc8lfQ4Ru33l+vMCLl
        ec1sd381sE4ytb3gA8yb0QauX9daZAJLOvlPVad6E9qsqtIYkTrPnWaO+gGGrdUEkEPYP4YJONk
        jQGtJf2jUkvU3NlHF0g==
X-Received: by 2002:ac8:5c4f:: with SMTP id j15mr21819534qtj.256.1630346651581;
        Mon, 30 Aug 2021 11:04:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjoCDdueibNqXdRAy7Jc/XCV8gr4Vt46sTAO6LintuGxnbfXuS3cFVpfjU0Ny3zkHsnXjhvg==
X-Received: by 2002:ac8:5c4f:: with SMTP id j15mr21819514qtj.256.1630346651311;
        Mon, 30 Aug 2021 11:04:11 -0700 (PDT)
Received: from ?IPV6:2600:1700:232d:8060:d065:31d1:e687:9727? ([2600:1700:232d:8060:d065:31d1:e687:9727])
        by smtp.gmail.com with ESMTPSA id u22sm11810092qkj.123.2021.08.30.11.04.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Aug 2021 11:04:10 -0700 (PDT)
Message-ID: <b822a366-bb7d-4c77-7628-c773439347a2@ucr.edu>
Date:   Mon, 30 Aug 2021 11:04:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH net 0/2] inet: make exception handling less predictible
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        David Ahern <dsahern@kernel.org>
References: <20210829221615.2057201-1-eric.dumazet@gmail.com>
From:   Keyu Man <kman001@ucr.edu>
In-Reply-To: <20210829221615.2057201-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Eric and others for fixing the bug!

Keyu Man

On 8/29/2021 3:16 PM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This second round of patches is addressing Keyu Man recommendations
> to make linux hosts more robust against a class of brute force attacks.
> 
> Eric Dumazet (2):
>    ipv6: make exception cache less predictible
>    ipv4: make exception cache less predictible
> 
>   net/ipv4/route.c | 44 +++++++++++++++++++++++++++++---------------
>   net/ipv6/route.c |  5 ++++-
>   2 files changed, 33 insertions(+), 16 deletions(-)
> 

