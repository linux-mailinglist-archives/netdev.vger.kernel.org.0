Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20182F02F7
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 19:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbhAIS4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 13:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbhAIS4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 13:56:22 -0500
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4136C061786
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 10:55:41 -0800 (PST)
Received: by mail-oo1-xc2c.google.com with SMTP id o5so3196884oop.12
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 10:55:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vkDtvUfju3z553HfBVaCtW0xqrwm7BBcHA45ufSZi94=;
        b=SsJnrZSW4biJQVakOe2JprLvU4tDQ3xBWLMesM3n14MN6IHG/lVa+eGHLe9iTrFFPa
         ZfGNxMmOBpNswudF7UH/sMKcfIPBHbi4Mv24gDutlqLMa40lq7MNqomseOgufktzubUJ
         qj9xYxSM3YhrGjLVlLreeYxffyfvl8GTYYQoyyCGWamr5+Bk3HPlMBF335HRT6tblo8C
         GyIWeFm0de+29XC1IDsA1I4RGJYkcuLx4xw4F/VK6Opgr17GrnD0xL0Tl7KW2bt6orGW
         z//t12UQFD2NPAAK5e9xgmhFPnkvsDFBz9G1xjGfdjO1mryQv0kce369OtSlK3ayNB42
         Hx0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vkDtvUfju3z553HfBVaCtW0xqrwm7BBcHA45ufSZi94=;
        b=Aro4sQqJF9ODlTjxQOzHvYU90tVfPbHZlPzb66AmTvfYeeQP7Ws/9U1ntmj7Vcpwst
         fsTZdDamn2XJW31oh2S7ZlvV5uzIvtDXvX96SS431su2B/fUOQ5XkOnopjrRpHGjI5ak
         h4gBik1zX3ILWNAaGzQmstRH5DTXp0brERNHOU9cXdHuJ5J4I+eJV05tcvjMOqr3MbL3
         pw1r7bfONOxhHbShen0t/Acoz+v9vq/HdDUNpAvP+5RRsief8FHm4ixTO9r8QSkTpLl4
         FVouTUaNfmqNnoh6fXd5zZALqO+6AD5u581FlSjeZ9fyhr0i/2aSEohYIoDvyNg7o6YZ
         AshA==
X-Gm-Message-State: AOAM532p/KlRLSLv93UDXCIcew6q9Os14zTEXJnKyc68v2UZsiDEj9Mu
        g5zJLTjkTz9dubJqQ73+zPl3hsnUZCM=
X-Google-Smtp-Source: ABdhPJy9/oNUBPlj0yoFACVZpUkJcbEan7v7lZgvN2+EF9t8RwbN3Xsc6qwWzLkYQOfkxbHmhb9ekg==
X-Received: by 2002:a4a:d628:: with SMTP id n8mr6956919oon.79.1610218541135;
        Sat, 09 Jan 2021 10:55:41 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id x130sm2787120oif.3.2021.01.09.10.55.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Jan 2021 10:55:40 -0800 (PST)
Subject: Re: [PATCH 00/11] selftests: Updates to allow single instance of
 nettest for client and server
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     schoen@loyalty.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210109185358.34616-1-dsahern@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <036b819f-57ad-972e-6728-b1ef87a31efe@gmail.com>
Date:   Sat, 9 Jan 2021 11:55:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210109185358.34616-1-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/9/21 11:53 AM, David Ahern wrote:
> Update nettest to handle namespace change internally to allow a
> single instance to run both client and server modes. Device validation
> needs to be moved after the namespace change and a few run time
> options need to be split to allow values for client and server.
> 
> David Ahern (11):
>   selftests: Move device validation in nettest
>   selftests: Move convert_addr up in nettest
>   selftests: Move address validation in nettest
>   selftests: Add options to set network namespace to nettest
>   selftests: Add support to nettest to run both client and server
>   selftests: Use separate stdout and stderr buffers in nettest
>   selftests: Add missing newline in nettest error messages
>   selftests: Make address validation apply only to client mode
>   selftests: Consistently specify address for MD5 protection
>   selftests: Add new option for client-side passwords
>   selftests: Add separate options for server device bindings
> 
>  tools/testing/selftests/net/fcnal-test.sh | 398 +++++++--------
>  tools/testing/selftests/net/nettest.c     | 576 +++++++++++++++-------
>  2 files changed, 595 insertions(+), 379 deletions(-)
> 

Ugh, I forgot to add net-next to the subject line. Let me know if I
should re-send.
