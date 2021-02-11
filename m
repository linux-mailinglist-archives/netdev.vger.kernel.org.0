Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B86E318822
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 11:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhBKK2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 05:28:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhBKK0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 05:26:01 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564A6C0613D6
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 02:25:21 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id m1so5189845wml.2
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 02:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bOALI3AfEhN0OdnOwb9mqvaoG4hH1rxWibCocU9mbUo=;
        b=bLHJPK44nV6T79NQt72EBQkPXFXXBXBQ5dW8yPcyPca10peOzQwktl+a3cGT/p8wEv
         rVYjC4Yd41V31QonCMdPGFQGZf6UMYaGG9O0pbJJrzALAxd+PEV/ZkykeXo/KaeC4oYn
         mwGDDVyq841S52uCnbs/pGM4qrnj9rMfOhUtLSKopNZLntvHDVzmHSfZVR6y31DDHOkc
         Dd+gF5toznfKWrOpVLYYKC7UhgAm8y+O5tuDbM6S5AphJHGtpzhlJCB8EYtklhmLSMi7
         9eVYrap13RHJZoi16NkhkvBA6b5V6mrm8Gm0ZoI1Om3tN9vpu6M8VLzX5TJziQt6c4cS
         zHoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=bOALI3AfEhN0OdnOwb9mqvaoG4hH1rxWibCocU9mbUo=;
        b=gn2GmWNh8RD9urNnvawA5Jddtoqfd3xkKJnsyhfpO/RYGG7tk+itJNtbgqXYj/NaHs
         5rPsdBqv8/NVOFwSlMgFOs46yi8NCGdx/UiDbvQJ4yJphgpHaXd1yhbIvXW3ED8RJQIa
         Q2It1mVP/SVeHiU6guGKwGdVcuH8byUCaNFnXr5QB6AVV41ZjhOE8HUq62qIxSs+QgIC
         piev+RYcO8APKdqL+WdYuSDgnMhJS+x6kAcipEfjv9ma5zQU5ackNqdwDdJtmiJfYAml
         S+mQ3e+z9IiN469eM0xs1ya09S8RjRSg3atfhzY71I4//kgcM7Pde/x695E8dtPHwsKB
         taOQ==
X-Gm-Message-State: AOAM533XGgMbhU8LFUYJaYALEfU2ifBmhY8cmQOxVmzvCobZ5WGgp5TW
        96dSgLjaUPMNC5zxb9gm2r7X1A==
X-Google-Smtp-Source: ABdhPJy76vVe/k0BOSe3/IU7XWa6ypcZ5ufkwCji+VreSgsDeXcc7UrCjkoULoIlY+GOsbLjDqCoJw==
X-Received: by 2002:a1c:e905:: with SMTP id q5mr4388977wmc.84.1613039120051;
        Thu, 11 Feb 2021 02:25:20 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:64f8:1d8e:bcd3:9707? ([2a01:e0a:410:bb00:64f8:1d8e:bcd3:9707])
        by smtp.gmail.com with ESMTPSA id o13sm9649050wmh.2.2021.02.11.02.25.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Feb 2021 02:25:19 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v2 0/3] bonding: 3ad: support for 200G/400G ports
 and more verbose warning
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, andy@greyhouse.net, j.vosburgh@gmail.com,
        vfalico@gmail.com, kuba@kernel.org, davem@davemloft.net,
        alexander.duyck@gmail.com, idosch@nvidia.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
References: <20210210204333.729603-1-razor@blackwall.org>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <c86ba0ea-23b5-2aaf-6f1a-c25b2b2488ac@6wind.com>
Date:   Thu, 11 Feb 2021 11:25:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210210204333.729603-1-razor@blackwall.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 10/02/2021 à 21:43, Nikolay Aleksandrov a écrit :
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Hi,
> We'd like to have proper 200G and 400G support with 3ad bond mode, so we
> need to add new definitions for them in order to have separate oper keys,
> aggregated bandwidth and proper operation (patches 01 and 02). In
> patch 03 Ido changes the code to use pr_err_once instead of
> pr_warn_once which would help future detection of unsupported speeds.
> 
> v2: patch 03: use pr_err_once instead of WARN_ONCE
> 
> Thanks,
>  Nik
> 
> Ido Schimmel (1):
>   bonding: 3ad: Print an error for unknown speeds
> 
> Nikolay Aleksandrov (2):
>   bonding: 3ad: add support for 200G speed
>   bonding: 3ad: add support for 400G speed
> 
>  drivers/net/bonding/bond_3ad.c | 26 ++++++++++++++++++++++----
>  1 file changed, 22 insertions(+), 4 deletions(-)
> 
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
