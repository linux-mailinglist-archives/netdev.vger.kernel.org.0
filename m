Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C81B9FE28
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 11:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfH1JOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 05:14:44 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:39352 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbfH1JOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 05:14:44 -0400
Received: by mail-lf1-f66.google.com with SMTP id l11so1513972lfk.6
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 02:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W/FAvQVJWH8hNDqsZxVjsvHGWQ4cwiHioyZRXaiwuH4=;
        b=PIAg8LbvLk6D0489+QlpDRqaNqGp/RCZ4+jhKkMhIiBc2/Dd3RlrzlBuLBC/HxydEC
         QowWxlIXSFCcvN/jGvd5Yg34idYzc6aCxnbN9klxRc2JGYBnbpeUz9ypAbTiLWzJQDRT
         iBK3ZNZNyvZkdpdEu8eEdu99LWq66flJeWzenx7xEGLkUp88abcmEZKA6dk+/iar2gLY
         H1vbyG5EMg0ssZr0n/1cAP/1YrdQoleL/mzP+YJhRVJIZOX1DwxNN4fN/b7cb7tU4B8r
         JOis9BEPUMSlTEBN92wV0/IvRHOioQfaupKTQCtVIOfksaLch4G9E2qhx7HKkD9eQG+S
         G+Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W/FAvQVJWH8hNDqsZxVjsvHGWQ4cwiHioyZRXaiwuH4=;
        b=SbY0BMin6arfRfWA478DL735zZXJbQFuBG6U7THktnSVV8Fzknjcs6PGJwds4uECdm
         vj/PCSQI6B92snoCloxJXk5FXIHH/Qbg1UXxhbS61g3Rw/TK0amOhfCNqg1wzmRue1S4
         nmifsFN4MH03+jeg35Hus9mkGs6rMNbIRTtqEN48esvUeAWg+c3hhhyi7ZAEK4gt66Vy
         LKPvRP57MxOKzVKkIWNO/yRFRg29fzxMKf3JRu7eJqGvYaI4dRCutIMd89IxzUozRwPc
         Dw4hVExHhWgH7H3SqYVIWHEr8/XtxTjhmxJDal5/UAk6uiYm6R7F9r7pJ5gVGr5GVlCO
         o82A==
X-Gm-Message-State: APjAAAXL2AhaU2SIkcXDQWj1mXu/9qStmaQ/ag58LhiHziPnPyDBPxuk
        NqnMsjjxeA2p8eYX5HVxS/VPZg==
X-Google-Smtp-Source: APXvYqyxt6ENbz8kd9XK40+sRsJvEZ4lHaMldtpiGWZ4JbUMbRrBUe5f2u6ARgH7OgzyukMvezH8qQ==
X-Received: by 2002:ac2:43ad:: with SMTP id t13mr2097116lfl.66.1566983681773;
        Wed, 28 Aug 2019 02:14:41 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:43c:79c5:cc63:c37e:a616:212b? ([2a00:1fa0:43c:79c5:cc63:c37e:a616:212b])
        by smtp.gmail.com with ESMTPSA id h15sm498484ljl.64.2019.08.28.02.14.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 02:14:41 -0700 (PDT)
Subject: Re: [PATCH] arcnet: capmode: remove redundant assignment to pointer
 pkt
To:     Colin King <colin.king@canonical.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190827112954.26677-1-colin.king@canonical.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <1e784ee7-c049-1155-ab7e-a90f1f20f3dd@cogentembedded.com>
Date:   Wed, 28 Aug 2019 12:14:31 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190827112954.26677-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 27.08.2019 14:29, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Pointer pkt is being initialized with a value that is never read
> and pkg is being re-assigned a little later on. The assignment is
       ^^^ pkt

> redundant and hence can be removed.
> 
> Addresses-Coverity: ("Ununsed value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
[...]

MBR, Sergei
