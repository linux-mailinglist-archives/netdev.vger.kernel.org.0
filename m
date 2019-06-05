Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 096BF35EC4
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 16:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbfFEOK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 10:10:58 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42754 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbfFEOK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 10:10:58 -0400
Received: by mail-pl1-f193.google.com with SMTP id go2so9725743plb.9
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 07:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7nUEBhoC6lebMxYlG9Hvw2pJUq2/0V68ilRhseiWM6Q=;
        b=oJEcOverBWrq1WAQJ0RY8O/qYPa0Lb+5NHn1oQztfLSRrfm/VTq2gnTd+1Z9FaTSUP
         FkJdhneNIqthcP4Jui6TBopRR3IL1tqVmoFof4kw+w4osrRBEzZDsCFgQoMK2luk8/ld
         1s25tIVl2pemUOxmSJIlHnY9mQE/EO7mu/jQl+8II3MVpbUn3UuOnepCAQFX3Qy0MBY5
         HJCHXfiGOcs74ijBBOvHmddfjCpGzF8rile7KXJ+6UWDeVLIGnSQdM5P5HdR91vn1jXR
         cWAtbzFC7T187iv0MmJDO06QpCyccl0Bqx5Lk4I0xxsp+anDFgnQtGBcQNKxK+mzOes3
         9Veg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7nUEBhoC6lebMxYlG9Hvw2pJUq2/0V68ilRhseiWM6Q=;
        b=G3JKgvkm9cSSC5ia/iYxt5nTiZOP4bY+VKouyXuL7llXqqUi1sljw6ZDUoSbxik8us
         lVOSZXuJLHn3XrsXPqgwnJh0TQr4K0Uak3isTc7ZbxVIJ4edE482zIT32W6rEhILQUkr
         lpAxnffsA4y4Y74bAdeszlMqwqxx/yFZ4hyLev65eoikK+WpwApq4K/eAsbyd0cuHdNU
         /QaYeTAsKs1THyg1BeDE3NOFyd/j8QMFVVcNmkG0vlxz9LJHjiaJkdGfzuFZ8lGPWqau
         sCQ7ZvkEav8npOHOYugZIarZsvTADvi5BewYy19oVQSWSSyYectw5yqaDZPpdjvpWl1z
         jHdg==
X-Gm-Message-State: APjAAAVBbEvlVGmODjYghrONX1rQdfR+WnohqELevDEunUy1MXN+Ywi7
        tfSIYW8m9HLbfiMk1PCWckY=
X-Google-Smtp-Source: APXvYqzcgkUef5Kb/ggUcpuDwDF9v9+IfYT480gUxpEb1Gdjcj+uUH/GZGYYkym0sxW0urZfT/f7+A==
X-Received: by 2002:a17:902:9a9:: with SMTP id 38mr45288094pln.10.1559743857607;
        Wed, 05 Jun 2019 07:10:57 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id l63sm22220565pfl.181.2019.06.05.07.10.55
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 07:10:56 -0700 (PDT)
Subject: Re: [PATCH net] inet_connection_sock: remove unused parameter of
 reqsk_queue_unlink func
To:     Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Mingfangsen <mingfangsen@huawei.com>,
        "Zhoukang (A)" <zhoukang7@huawei.com>,
        "wangxiaogang (F)" <wangxiaogang3@huawei.com>
References: <20190604145543.61624-1-maowenan@huawei.com>
 <CANn89iK+4QC7bbku5MUczzKnWgL6HG9JAT6+03Q2paxBKhC4Xw@mail.gmail.com>
 <40f32663-f100-169c-4d1b-79d64d68a5f9@huawei.com>
 <546c6d2f-39ca-521d-7009-d80df735bd9e@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c3a0c655-38b7-91d1-d1da-74d0f73cbad1@gmail.com>
Date:   Wed, 5 Jun 2019 07:10:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <546c6d2f-39ca-521d-7009-d80df735bd9e@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/5/19 3:49 AM, Zhiqiang Liu wrote:
> small cleanup: "struct request_sock_queue *queue" parameter of reqsk_queue_unlink
> func is never used in the func, so we can remove it.
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> ---

SGTM

Reviewed-by: Eric Dumazet <edumazet@google.com>

