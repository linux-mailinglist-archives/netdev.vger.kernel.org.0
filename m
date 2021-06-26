Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFB73B4CAF
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 06:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbhFZEoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 00:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhFZEoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 00:44:05 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68897C061766
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 21:41:36 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id c19-20020a9d6c930000b0290464c2cdfe2bso363627otr.9
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 21:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G4UUguDpSSNvCnLhw6MGXcKMWm/a5SaCD02norZm3u4=;
        b=qde/w0o6ASnI62ffYLuA3DHUoZptX0M4XM41JcGPZxjaS9LBK/g9WLagQM62R4cHlO
         i+8qKFDLh8vv9MXfb48KqTB6ejT9B1LAP65+FixBcfRTxli1Lsj16Cy9XkInHCptgaut
         kYqm4aCBSDpGfiSVcvbJSd/JRJ2U1L24qCMcQZnY2Cvit6vSPXnsLEsDLFhDOQpBwevn
         eswPsVDu7fWQoJU2/OWkdUSaG1pOsskkgPMhqb7fztEByee/FI9S3FDn427Os2hjaFNd
         r9n2gcduROCwmNNW2NiKjVD4c/iHckK0RANvFwbuEbzKh9lEDrfjTX06vO0IUghSWTzY
         +GlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G4UUguDpSSNvCnLhw6MGXcKMWm/a5SaCD02norZm3u4=;
        b=aeZHFhPRKBdOcNatjgi0RBR8DoMZWsxmTu4Iupt2asRtY+bbBFIUZ8B9WoUv01oAse
         Pk5MRzfhMSBs7y1URLN2EwexsSJpvxzzv2vN/mFsJAbxiMZV15YFmH3o7LuZdwXbiUY4
         YTlfkR/tTGvTggFtvzt+0Qhjtbvrfi9lpclx9tgE1IVVNiFtH7oI5yZvlmJgchnaZV4P
         yWuKdjA9lG/vSGpwwhuxP75+mjMD7KiaoqKL/IKBFgRe0eon9fcsV0ICKZnvhIHjzgpU
         6WBq94n8K/EfGwKfA08ZByeFIoFucyDGuMybGeqbvHGxVSp/iIE+jUjCTXkAzL2I+OW+
         2Rdg==
X-Gm-Message-State: AOAM531WDzXV85+aCOh7S1Z7Y9xp8NBQIo6bWrihwIGzggRwVWguwOkm
        VlfFPC7R9vWeUuJYFux1zsM=
X-Google-Smtp-Source: ABdhPJz/P70jOM260c6ou55XeFrQ0ldY7BvBrU/GuPTM/OJxohxt43dOg3vGoWO1l9Y3bjxKE/FrPw==
X-Received: by 2002:a05:6830:1309:: with SMTP id p9mr12690604otq.209.1624682495666;
        Fri, 25 Jun 2021 21:41:35 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id b5sm224298otj.56.2021.06.25.21.41.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jun 2021 21:41:35 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2 0/2] ip: wwan links management support
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
References: <20210622235256.25499-1-ryazanov.s.a@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fb8f9f7a-a4de-e2f0-1e4c-c1976907df65@gmail.com>
Date:   Fri, 25 Jun 2021 22:41:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210622235256.25499-1-ryazanov.s.a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/21 5:52 PM, Sergey Ryazanov wrote:
> This short series introduces support for WWAN links  support.
> 
> First patch adds support for new common attributes: parent device name
> and parent device bus name. The former attribute required to create a
> new WWAN link. Finally, the second patch introduces support for a new
> 'wwan' link type.
> 
> Changelong:
>   v1 -> v2
>     * shorten the 'parentdevbus' parameter to 'parentbus', as Parav
>       suggested and Loic recalled
>   RFC -> v1
>     * drop the kernel headers update patch
>     * add a parent device bus attribute support
>     * shorten the 'parentdev-name' parameter to just 'parentdev'
> 
> Sergey Ryazanov (2):
>   iplink: add support for parent device
>   iplink: support for WWAN devices
> 
>  ip/Makefile      |  2 +-
>  ip/ipaddress.c   | 14 ++++++++++
>  ip/iplink.c      |  9 ++++--
>  ip/iplink_wwan.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 94 insertions(+), 3 deletions(-)
>  create mode 100644 ip/iplink_wwan.c
> 

applied to iproute2-next. Thanks,
