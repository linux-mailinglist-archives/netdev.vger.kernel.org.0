Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A9345FA9
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 15:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbfFNNzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 09:55:24 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42209 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727382AbfFNNzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 09:55:24 -0400
Received: by mail-pl1-f196.google.com with SMTP id go2so1050591plb.9
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 06:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oosQnLQcvYQn+KGFbSTN9je0D+j3SjuhQ7BxfiOJ7mY=;
        b=E/L8zDaoCSROPzqvW8LwBbnlIYBGxqPS66/1KD+95qyGYDBe5d535/H44FPJGfGs5g
         5USUihV6nSmiwVp4cgH0gakQJ+wOxXGh12ZFvhQVk2L/gqB1oSuoLynCs9Mtdp83NN1L
         EWCki83S1a6GqRx+ynLwVWC0YJ/aWANc01+FJSGJvjKUbIDdXjvmdQntMbwi0y5yBar2
         qVUTZCv1aXmmBqWeoGWKZv9PpxNGa/BlcKiU30d3fYWeQoRsWRFVMdstqmPgxZ3MTGHb
         4fyYUoqMe8W1SZNXwTeJjfvka9vVKk4KGt8glDSEhECFPLLx37VaKTVE+EIFL2LpeLnn
         fMeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oosQnLQcvYQn+KGFbSTN9je0D+j3SjuhQ7BxfiOJ7mY=;
        b=HEsuTUD+E2HxxvdWulnGmV6sc07qxHvY3YTroNdZJhMNZu7+I37G5RfX0UH/l/XU/a
         yNVwUELsucmtiUdLQSJ8ORXoTFVU/qXD6zbQT6elfCjqYK/mYtX1kjMZgUZwtR23R2Ds
         mfP8bZIIky4WJd4MvaJniRnXuO8fccV3kGymMkguYmnoKtZpxloIo3o3AXGUZKVCLaNg
         3n+mmdYTr0VhAvS5i4JLoaEGQflpw6kyR8uq+E5FJDACmuyMC2t3a58pYrfuIIYkeHX5
         5cTzB43Q2bR5PeUgpM1rk0U++1m18JBW1BKjjDsAUiIp0suv7oibJ47S9+63uaSlwoGb
         s17w==
X-Gm-Message-State: APjAAAWY84LVGHk3NIYWbCMQMN06qfZJFMH8vQ3yw5H82tg28/UDcCgI
        +DgXRypHe7Y/zvSD/WBhboM=
X-Google-Smtp-Source: APXvYqwzjfmS1uvA0c8JOJ8a6upa7s+D1X8zZNE8Nb552WP2Kz5iJyrsN/7ufpP6lFddb7+IuqoSHA==
X-Received: by 2002:a17:902:bc83:: with SMTP id bb3mr71864455plb.56.1560520523309;
        Fri, 14 Jun 2019 06:55:23 -0700 (PDT)
Received: from [172.27.227.167] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id t18sm4415970pgm.69.2019.06.14.06.55.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 06:55:22 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2] Makefile: use make -C to change
 directory
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
References: <3734f49cbe4b7543f09236d02cbe78b515af1e28.1560448299.git.aclaudi@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <11bd1bb3-a28d-0a73-13d2-d5df518ca3b4@gmail.com>
Date:   Fri, 14 Jun 2019 07:55:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <3734f49cbe4b7543f09236d02cbe78b515af1e28.1560448299.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/13/19 11:59 AM, Andrea Claudi wrote:
> make provides a handy -C option to change directory before reading
> the makefiles or doing anything else.
> 
> Use that instead of the "cd dir && make && cd .." pattern, thus
> simplifying sintax for some makefiles.
> 
> Changes from v1:
> - Drop an obviously wrong leftover in testsuite/iproute2/Makefile
> 
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  Makefile                    | 3 ++-
>  testsuite/Makefile          | 6 +++---
>  testsuite/iproute2/Makefile | 6 +++---
>  3 files changed, 8 insertions(+), 7 deletions(-)

Looks good.
applied to iproute2-next. Thanks
