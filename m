Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D65E07EFBB
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 11:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404548AbfHBJAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 05:00:34 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37722 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729007AbfHBJAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 05:00:31 -0400
Received: by mail-lf1-f67.google.com with SMTP id c9so52341836lfh.4
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 02:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nOfUZboLQBdefaSsqopalDUSAj0Q8TAgOh/2n7vo210=;
        b=sYNMRs1y7jnjOKwG0zRNP1K8YIFbSlBhf6eFQJQoUFdLX2BI5y27Ds6WnWgi0qyGms
         kNrqVNNfZM29KCHMMb7ui89lN5zztea5NUkgkwk6DpOgMxsswbMSDC1iaEmawklpDJRQ
         J5mVq9ranM51uW2C98xjvZfbdslylo/OjsZ1priQHrMvB+ncLViqAIO7yStBmLICDlmt
         4+8B9okpyqTizD66fvPN96bqek/5BSqiGsXfUoWdNcXst0HhQWnmNP/LrdxGupwY+9OX
         pEcIVphYhHDlTvIfYQGWq0FScSduxzYtGFCmP2pR2qSI4MhHwx2JKUnDKmXGVNhZEL4I
         1szA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nOfUZboLQBdefaSsqopalDUSAj0Q8TAgOh/2n7vo210=;
        b=K8brGr/q7CiDBYIRTcMEL1+XqyEuGHJtfc3MpIeMz6nPgBVXHK3CYORC7u2SXxdCIW
         INu/ZRZ5hG2frd/d0hM3LjGsH74g7HLh0xtA1PAFTrr3ytinaCvdPKdn5CZQRt82/08d
         xvLehCucCyawOh6AkQNake02QaZuuNs0nb/ub4YwiM7qH3EB3wBWt0OJCVxZcLqvRspI
         Fn0R20/duQ2GwkT2/xUsbghucD+aEOFBt9CSeYfnJWuukOf5jqGOfmDeLnx+UmunBWGj
         yG+lNaCUHwn4hz86l8wSyawWKHXSyLQ39bbrRd6QfHooviFgbyUVFO/qUNdePozerHxF
         FC3Q==
X-Gm-Message-State: APjAAAUvWOeSjG6/y7VrnEL3Izx0fq6PHNaWAl6+xNJ7pfXM5J5u/ohg
        YquTNFyC+fMN0hgeNZsjbAFcYA==
X-Google-Smtp-Source: APXvYqxGZgczC1eaVKSdfN3/+nRFqyz52eooZ0ry/5yt2smPrZMOndzeGHd89ilsrgEB4jlADqC5Dg==
X-Received: by 2002:a19:7006:: with SMTP id h6mr62988032lfc.5.1564736428915;
        Fri, 02 Aug 2019 02:00:28 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:461f:21d7:2c53:9256:aa0a:736? ([2a00:1fa0:461f:21d7:2c53:9256:aa0a:736])
        by smtp.gmail.com with ESMTPSA id p27sm12695592lfo.16.2019.08.02.02.00.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 02:00:28 -0700 (PDT)
Subject: Re: [PATCH net-next] net: can: Fix compiling warning
To:     Mao Wenan <maowenan@huawei.com>, socketcan@hartkopp.net,
        davem@davemloft.net, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20190802033643.84243-1-maowenan@huawei.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <133b3357-e0a4-64c8-40b7-02d386e12cef@cogentembedded.com>
Date:   Fri, 2 Aug 2019 11:59:45 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190802033643.84243-1-maowenan@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 02.08.2019 6:36, Mao Wenan wrote:

> There are two warings in net/can, fix them by setting bcm_sock_no_ioctlcmd

    Warnings. :-)

> and raw_sock_no_ioctlcmd as static.
> 
> net/can/bcm.c:1683:5: warning: symbol 'bcm_sock_no_ioctlcmd' was not declared. Should it be static?
> net/can/raw.c:840:5: warning: symbol 'raw_sock_no_ioctlcmd' was not declared. Should it be static?
> 
> Fixes: 473d924d7d46 ("can: fix ioctl function removal")
> 
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
[...]

MBR, Sergei
