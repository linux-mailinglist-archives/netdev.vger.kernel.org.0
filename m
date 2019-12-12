Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBD611CB36
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 11:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbfLLKqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 05:46:04 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:38296 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728631AbfLLKqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 05:46:04 -0500
Received: by mail-lf1-f66.google.com with SMTP id r14so1329318lfm.5
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 02:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jvqQ2LSPQakFyO6vrj7XjHi+q/qAmMP0jyqzyEsZ6cY=;
        b=fAJUxPKa6DO3DxY2/J9PLqhfYlg/da8eDTz/vxL8gOoD6z21vggxxcj96lO60KKOo8
         p0koKVNcaIOdBdVMeu+QAuEIAUfdTrzi0LWNyykx9hQxI6BmIDydNHVZ9K+Hr9crQIWx
         1WIQiO4PvtcQhtih196GjeyVAvG28GxF0e+IAs1xreoZlIl5BdfEzXCGZe6VRQK/3y32
         c4UBiESyQ5Yfo/pvMuzcBCOOk+TRBprA0w8q9ywu+MEc/jbeYhb9A6rcn2gyplg1R/4M
         BLzvWfsPEG+qXB5Gw7IibuCyqUslGbXLtumbv9KvBuFi0Mznx1tC+CuaPMKxZ2a7UZm8
         hJFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jvqQ2LSPQakFyO6vrj7XjHi+q/qAmMP0jyqzyEsZ6cY=;
        b=uCQcRSK8OERsBTDzQM3ykmEQyjBkt08ASV3uXrNVBwjH4KmLQZ5KA2xszwLCxT7a/7
         K4Tja/HZCpYXRZ8gos3/Pho0zlyh31bLIrjWwzCmhq/BXXA5fFaj73HwCE9p5PlH023I
         P5dNU5z474GNjZJ7IiaSTVGEucZCqpwswuNia1i/gYKykdT8dSMtCKLIbw+fuAcf/yX4
         DBUzlYV1fQibPV0yN1IhNvcuof0LmRCBK8hnNb1qjTLZlxgb6MqtxL+74OK3YLMeHiww
         Bku1OwnmpSS33La+9AFdoc/mNjn2uTbCHJEi7BH3I8u23pYKXwwAb1SprLrtM/EvVr8S
         lByg==
X-Gm-Message-State: APjAAAXjCiyQkFNhAWqMXCuqwdUxtQYB9Dcmyztdrp3EIRy2VGAsr3JO
        MU9SeQAQjLxKQSGVzgZRkT9WVA==
X-Google-Smtp-Source: APXvYqwP+hehehn1jHv/Es8YupV7UnCXZ6dmvNhY+VQdGf477L2UvXNh73dt+c8DyKqvqavUkp3eUA==
X-Received: by 2002:a19:f519:: with SMTP id j25mr5284968lfb.41.1576147562262;
        Thu, 12 Dec 2019 02:46:02 -0800 (PST)
Received: from ?IPv6:2a00:1fa0:2a7:d365:c8bb:a230:5f6e:8263? ([2a00:1fa0:2a7:d365:c8bb:a230:5f6e:8263])
        by smtp.gmail.com with ESMTPSA id z7sm3048827lfa.81.2019.12.12.02.46.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Dec 2019 02:46:01 -0800 (PST)
Subject: Re: [PATCH v2 20/23] staging: qlge: Fix CHECK: usleep_range is
 preferred over udelay
To:     Scott Schafer <schaferjscott@gmail.com>, gregkh@linuxfoundation.org
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
References: <cover.1576086080.git.schaferjscott@gmail.com>
 <a3f14b13d76102cd4e536152e09517a69ddbe9f9.1576086080.git.schaferjscott@gmail.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <337af773-a1da-0c04-6180-aa3597372522@cogentembedded.com>
Date:   Thu, 12 Dec 2019 13:45:57 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <a3f14b13d76102cd4e536152e09517a69ddbe9f9.1576086080.git.schaferjscott@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 11.12.2019 21:12, Scott Schafer wrote:

> chage udelay() to usleep_range()

    Change?

> Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
> ---
>   drivers/staging/qlge/qlge_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index e18aa335c899..9427386e4a1e 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -147,7 +147,7 @@ int ql_sem_spinlock(struct ql_adapter *qdev, u32 sem_mask)
>   	do {
>   		if (!ql_sem_trylock(qdev, sem_mask))
>   			return 0;
> -		udelay(100);
> +		usleep_range(100, 200);

    I hope you're not in atomic context...

>   	} while (--wait_count);
>   	return -ETIMEDOUT;
>   }

MBR, Sergei
