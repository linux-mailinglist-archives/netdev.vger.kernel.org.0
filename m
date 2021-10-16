Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFB342FF5C
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 02:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236295AbhJPAJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 20:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233258AbhJPAJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 20:09:51 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051E1C061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 17:07:44 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id l24-20020a9d1c98000000b00552a5c6b23cso14957571ota.9
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 17:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HEJ7e5dBADdv/SGc4KSdp96TKTNRkK26n81WrErQLbE=;
        b=pX9XrFlp5uNj523944hXbGV4fUUzZt4Yr70PgaLZKbBY3Cjh0fJtZEq4tVhE3KPQJF
         RUfslducFbTGSsjgWZia2RgN7O0pCBtY/0r69L+PGq5rnVd2XZ86YuwcXkvdGeNz2/kJ
         /tODDWsHn1QxBPM8T2aVyfqUgvbNY+GDbbm8OFzFwJKPp2fTRfA15n1nsuqQNQYmDAm1
         grCFBxFYtHq1k+rm9rp8aN0nNeT2Bjhje/slh3jhIVbSkUWBQEMAYC6t8XSJSRWNz+pO
         N3l1V0lkkHfdWJXI7jLTABFmFy5KmtqOyTKCOYbsVB66oCKS5iMXQ8fOPvglSauymwJN
         jv2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HEJ7e5dBADdv/SGc4KSdp96TKTNRkK26n81WrErQLbE=;
        b=bQPE3x7MRDFpBSwwyuTRHDxzCKHYjyYfDL73bJuqwpT4s2Jb3S0wXaWewKhlsIBtky
         Xk4CLEnSDATuH7h2YrBP1fHm8231gTCLaslHuJz6uEjxsRgbMHPZAg1VHh/HcUBtqeVS
         kEoI8bxr/bbY2VU3Mg3eyluV6qvWPDMPXgee/qiGzBZJeWJiMt3fxXr7ms5Kurb1SK2D
         XkNxUwf3kIRl4A0TtHy/R+/L6OcLlyo84tc8q3o6kdrhV+Z/gWnXCECv+P0QLkBg22L6
         awgROq+5sYz0Eu2PSxxwGtzP1pCj5yYxSh62vYAzvqbjKzoQ95AF1Xr5pcgSGGSoHnY2
         3QoQ==
X-Gm-Message-State: AOAM530nbTB//LDcAZ7+lfvE3jytEp9763YDJuUAiWugq6VFGn+xU0oG
        srbTgYIbkXF25JsBsHcbOsvhtWmn8R2PTA==
X-Google-Smtp-Source: ABdhPJyhpMP2jRSBwtJPWICNUerqt+yFzYQXJxweVtTr25Q88WcskVND/D7NnVbBaU7VsfX7/oUlDQ==
X-Received: by 2002:a9d:8cc:: with SMTP id 70mr10623351otf.328.1634342863350;
        Fri, 15 Oct 2021 17:07:43 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id v17sm1505872otk.56.2021.10.15.17.07.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 17:07:42 -0700 (PDT)
Subject: Re: [PATCH iproute2 v2] iplink: enable to specify index when changing
 netns
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        stephen@networkplumber.org
Cc:     netdev@vger.kernel.org
References: <20211011125852.7805-1-nicolas.dichtel@6wind.com>
 <20211012093405.18302-1-nicolas.dichtel@6wind.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a9b37354-a856-516b-0f7d-c197d8c5ecf1@gmail.com>
Date:   Fri, 15 Oct 2021 18:07:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211012093405.18302-1-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/21 3:34 AM, Nicolas Dichtel wrote:
> When an interface is moved to another netns, it's possible to specify a
> new ifindex. Let's add this support.
> 
> Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=eeb85a14ee34
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
> 
> v1 -> v2:
>   reuse index option instead adding a new option
> 
>  ip/iplink.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 

applied to iproute2-next. Thanks,

