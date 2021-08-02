Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105CA3DDDCE
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 18:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhHBQhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 12:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbhHBQhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 12:37:38 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF45C061760
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 09:37:28 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id 26so6891114oiy.0
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 09:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EJ90C9kHzky9zF+K3AMyHYYG9GN+8lnAFM2ELHsgCjQ=;
        b=cw0EMwt2c9aM+FzlygnQNWR8aKSoWcpFV+WHOgl8ig0UEg1pMozKKwkWdv9S+ksWex
         qCN1yHX6dH0Ira4B/AruAIiPrChoHc+unUfcJ/QDSxNww8TaiosFVdQFnHjOQcyRpjh7
         BnArAGRNeCd5NQQq1K6uMn/AOHa6IaO/HnrD9RK2zN1QDs4DIZHRxSlBKiXPtvsiLwQX
         gtnun3Pls2peRgy4MjQNl30jjidZnqWHPhxtFhzV22QEZD6I9Yexh1nVo893N6mZmvyK
         RVbMfkGF3s87HAexpTj4jsZBVymVu0zaqyaegPRrqOyiqz9/EnX4DQ51LzhgfSbKh9e9
         PFkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EJ90C9kHzky9zF+K3AMyHYYG9GN+8lnAFM2ELHsgCjQ=;
        b=keosNrMaFUpmStQK0qAeki1X7tFsQGj1gx0WfwvFFH/pRis5lEesnpg0LQEfoaxr0b
         CwvC8wNDVwxI7nWsYem82w8NeJ+E+CxZPOouAVP54VewQrYCY329JHMl7Zsaxp4VNwnI
         nlMttjB9unq2zju9RyezjwEqRP2M7noFXbOk7I6NyYMHfby5xXqmDh/ks+S6Jah3m8Yk
         rg/8SPrzNKeEFNwQKF2GyShy61X4ZCGADm5XG/MmiMm9E4sEwGxysarcOUipy3uhmFA2
         Ciu4+HUNu4rH7A7RyIpjnh6u+TktCdSKaZYyA2SipvjbXIHvXu/EM0yAYk8RCAmNDfkH
         IhNw==
X-Gm-Message-State: AOAM531mZnD6j7/di/H1wQ5I1rEjPBJFyVvVKJBmRaboBTboIP+WQH0Y
        INPVeQjx4wdIVIoMhvC+OFM=
X-Google-Smtp-Source: ABdhPJzJbE4dPf9ABLhSf/wLFKiMPWhs110nP7ACfI5qCA0ldCnZ9NC4T6mcWIjVbyT5b2wfN2rlGw==
X-Received: by 2002:aca:aacd:: with SMTP id t196mr11015386oie.12.1627922247560;
        Mon, 02 Aug 2021 09:37:27 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id f3sm2039810otc.49.2021.08.02.09.37.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 09:37:27 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v3 1/3] Add, show, link, remove IOAM
 namespaces and schemas
To:     Justin Iurman <justin.iurman@uliege.be>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
References: <20210801124552.15728-1-justin.iurman@uliege.be>
 <20210801124552.15728-2-justin.iurman@uliege.be>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <559ce547-b07c-0ae9-c137-32b82f231b1b@gmail.com>
Date:   Mon, 2 Aug 2021 10:37:26 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210801124552.15728-2-justin.iurman@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/1/21 6:45 AM, Justin Iurman wrote:
> +/*
> + * ioam6.c "ip ioam"
> + *
> + *	  This program is free software; you can redistribute it and/or
> + *	  modify it under the terms of the GNU General Public License
> + *	  version 2 as published by the Free Software Foundation;
> + *
> + * Author: Justin Iurman <justin.iurman@uliege.be>
> + */

This boiler plate is no longer needed; just add:

// SPDX-License-Identifier: GPL-2.0

as the first line. I can do the replace before applying.
