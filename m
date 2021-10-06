Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405D642408A
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 16:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239054AbhJFO4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 10:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238205AbhJFO4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 10:56:44 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BC0C061746;
        Wed,  6 Oct 2021 07:54:52 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id r9so3158432ile.5;
        Wed, 06 Oct 2021 07:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KwYHYOuqFAsOEN4ljfi4q77Tgl6pY1vJiqgxP79RAEQ=;
        b=M+tdo9ZG5jUgwwtycOG2oql/AFGQkkXt3HIp07R3MPKzZAo/PgQX9JBjrB5DJ6pQyX
         ILlSrfPTqvdBaWMZrKUdTzSrFqDYkXs+qpoUa1QWoem3XNlRB6wZjkvvUrREYqAhzQKZ
         jRCCgy6AiJ+WUyW6TX2BAd2e5JhoL+hauZ6uKlhCr17I+wlipjOJyn+OxvLHv/d00x1Q
         uJDKXnCYaGT+RDfDUIdsd/B9wrZrcR0ae47ox+PSYXfnebO5la/U8RQP8MjTFPW4+E+I
         HkKT32+bMnLqusfQGbttAZOic7KpgnHDbB0ZhRb5REemuSTeuMo/K6o8fYPUMwToqcLQ
         hCgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KwYHYOuqFAsOEN4ljfi4q77Tgl6pY1vJiqgxP79RAEQ=;
        b=IBPVs3ulkyLRbl8726pg48YWb0L6XPmLq9HBtUbPPcOQ8l6JYi5BDr+3LAiuGktFqL
         u0L0SI7Hi82KUQkecc7reP8J6uWGQF4Khfwpf+i/Qw+zo8KqA5O3JfzL11iXVSuVHZGH
         6T86tgGnyCfF4Py5jCc0QeQEbibB3n1brYhYxSOBNevbIc8bOysxfZN+TyALhqIIuSAO
         3lduinko5s/S9jR9up+Q2tDMfiHNjzIGoHpf+BqCj3W48yLMrrjX5esaRnvefUyx0csA
         yR4DI9mlkvstH2LYzmu458Ezon0r9DKDToYuqLjaCiTeCEnNAjhTfN05l0aI4HOdaNuE
         l5Ow==
X-Gm-Message-State: AOAM532MfdbduoZ+wEymzBZ4f4ygjKWORXboJf0qHf2UcacUzhv0dtnb
        dRjbIHfqY+hL/7oXIB+cMSo5v/Rlm1vAuQ==
X-Google-Smtp-Source: ABdhPJw2K+yfK4cXBrDCD12ujVOz41XePSjB//mONzXLbUMRUw9E0PTqfjsD9LnGwSqMYwUp6ItPfQ==
X-Received: by 2002:a05:6e02:1c47:: with SMTP id d7mr1048302ilg.49.1633532091352;
        Wed, 06 Oct 2021 07:54:51 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id d8sm1358712ioh.46.2021.10.06.07.54.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 07:54:51 -0700 (PDT)
Subject: Re: [PATCH 08/11] selftests: net/fcnal: Replace sleep after server
 start with -k
To:     Leonard Crestez <cdleonard@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1633520807.git.cdleonard@gmail.com>
 <ec40bd7128a30e93b90ba888f3468f394617a010.1633520807.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <43210038-b04b-3726-1355-d5f132f6c64e@gmail.com>
Date:   Wed, 6 Oct 2021 08:54:50 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ec40bd7128a30e93b90ba888f3468f394617a010.1633520807.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/21 5:47 AM, Leonard Crestez wrote:
> The -k switch makes the server fork into the background after the listen
> call is succesful, this can be used to replace most of the `sleep 1`
> statements in this script.
> 
> Change performed with a vim command:
> 
> s/nettest \(.*-s.*\) &\n\s*sleep 1\n/nettest \1 -k\r
> 
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---
>  tools/testing/selftests/net/fcnal-test.sh | 641 ++++++++--------------
>  1 file changed, 219 insertions(+), 422 deletions(-)
> 

I have a change from January [1] that runs the tests with 1 binary -
takes both client and server side arguments, does the server setup,
switches namespaces as needed and then runs the client side. I got
bogged down validating the before and after which takes a long time
given the number of tests. The output in verbose mode is as important as
the pass / fail. Many of the tests document existing behavior as well as
intended behavior.

You used a search and replace to update the tests. Did you then do the
compare of test results - not pass / fail but output?


[1]
https://github.com/dsahern/linux/commit/8e16fbab1eb224298e3324a9ddf38e27eee439c7
