Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5CCA42408F
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 16:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239101AbhJFO6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 10:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238205AbhJFO63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 10:58:29 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD418C061746;
        Wed,  6 Oct 2021 07:56:37 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id w10so3112573ilc.13;
        Wed, 06 Oct 2021 07:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o/Lv6+8/XuaKY9DOiYM/q6mdJTo0wU4gFvn91OldDRk=;
        b=Z6WFyKvnvp1Ud//mkJNCLH+iZHLqZOuQ/SgCLFsUtUiF4gcBfEiNrflhVq/UyRQ+FY
         3foTRseLD8XmZiCr6gGEkNr9kwDs44AFwCgX8mHFF1DvujYq38sFfEbUVjwbBOOJ0T87
         g1q/s/SLZF0c7ZNYzhM91BFqJBGHQet6nzOG67LpIBI2b5MaDjJP2lEHwvhky23/kjRu
         mUPhO6+aCruYfuRiCbGsIy6owlbpLFpsbPeMg41lfcdubWTcK85RkPmiBg4u30MVmlKO
         OEaRkl+awBymnCgTfOarrkpxvKzhpThR3hPzwP6VfYCNKFyHYg19vG1vWkL6tIP2zs1y
         PSnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o/Lv6+8/XuaKY9DOiYM/q6mdJTo0wU4gFvn91OldDRk=;
        b=sRKZfg7V1uhXYlxglZlUDtf0FynH2q9fmlK93ZA+PuFho2r9v5SQQcP1tniZGpq5E0
         3Zn/BnR97z8x/yWXGIK/kq7R25Xf/0EbjoZEiQH7wBxoPiiLVeL6F1Bd/Msshy7LpW5p
         lent2SB77jZ2XbpdhXVuwat37oeHYLwt0WLvF/7D1M8VkrnY/8gtRNv0pbv191Yqn4ZA
         NEjybkuAAUAM0MUHnHEiox53SdOQzAaOm4agdEuS6OvOP16x9uUF0hADV4KPK1vusr/V
         qfBn7bpGFfMl+GGcQPPAiJcyrbQhq+cBVqXVHw7h/ngLhGCISgPcWxa4FkBSx9oSSqm0
         wvcw==
X-Gm-Message-State: AOAM5336R4RL+2ehaFT+X4++MF5OeFaap0yBvAlp1EwIqUi14X61NIMs
        HsBv9uOZk9MmHuF69np2toeWERRihCrF9A==
X-Google-Smtp-Source: ABdhPJxBrwLjTGAPlH0nk/YlSXszmDzspjoIEQ/7Ro3GkXNNxA7yGjzSXHzPDe5+2gQhVr64RVolZQ==
X-Received: by 2002:a05:6e02:bf4:: with SMTP id d20mr7835127ilu.146.1633532197102;
        Wed, 06 Oct 2021 07:56:37 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id c15sm864809ioc.8.2021.10.06.07.56.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 07:56:36 -0700 (PDT)
Subject: Re: [PATCH 09/11] selftests: nettest: Convert timeout to miliseconds
To:     Leonard Crestez <cdleonard@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1633520807.git.cdleonard@gmail.com>
 <5a320aefed743c2a0e64c3cb30b3e258db013d1b.1633520807.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1df02de3-d990-50ff-744f-aa657f8fd39f@gmail.com>
Date:   Wed, 6 Oct 2021 08:56:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <5a320aefed743c2a0e64c3cb30b3e258db013d1b.1633520807.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/21 5:47 AM, Leonard Crestez wrote:
> This allows tests to be faster
> 
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---
>  tools/testing/selftests/net/nettest.c | 52 +++++++++++++++++++++------
>  1 file changed, 41 insertions(+), 11 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


