Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34EA22A24B
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 00:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729565AbgGVWTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 18:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgGVWTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 18:19:46 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC751C0619DC;
        Wed, 22 Jul 2020 15:19:45 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id u64so3575038qka.12;
        Wed, 22 Jul 2020 15:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XrjykOZMjEbhEG4xYzx5TkMq0JyZVdIE71GzGgj+ZAw=;
        b=oJvZq4zw920vtMakxOmhTZnFBQN2QldafEhIEKKnkn/XAOGY11njc1951eCgO6f4bV
         z4cGbIKqik2Gd+h9vZhGV9waHFi5xqOXsZH4ASEiBcuM8fe29vlHHiELI6S/1fXtWLUy
         ARKWNBRzYAOqoYmQMkV8FbAZ+VH2QxYLXUH6lHsi3dQB3KtWgl9YLkLjQDKVm3RLtamy
         fC7kQYIM1ncSGPZ/FgLL0x8gbQnk/UiqwSdIdCt7aTFWyvBkUJ9WJWlRh701xUZk/bno
         danH0cSZJ6tXCbsjp9TYbwWa5AZRdSYyXcnsyIrdoqMUogmA0SMgeHtwtGDT8B/9TQ1c
         bxGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XrjykOZMjEbhEG4xYzx5TkMq0JyZVdIE71GzGgj+ZAw=;
        b=IgOzcWimWNS6+UECl1hekp/dIPded6PPWe4nlrwcdtKI1wcvJkTVqqB5+34G1BJqNE
         zdDKJWjvc3N+CIwqe0IS6KkAAsMStFEAeZWkCkMDRhzdtCmSexrVvIkih97R4bal18jT
         0Y4J0any5A2Qco06DFkUcDgz4TVKtpyBzO7T6O9OfYxT5G6zBImkO1Fldfm0hDOexQrJ
         263UCjCp+F/EMwhKjFGAzzsj79Uhv6Ghz8N6sZ8TjOVmwS5+iY8w+P5aDnTYVqcraAv4
         b7IvHWXvHAwf3aUhrAZDAxMZHox+p8NzR/O+E0tVpDfaJz6Z4Z09CHx5MVw5kiQ7w+g3
         haCg==
X-Gm-Message-State: AOAM531Hw5ESh31ILO6suWFu6gyylEcxgCnChk1NjVs8TMmnrH6Fu8yK
        kgxj9HL+RPwKGjRyyXYr02o=
X-Google-Smtp-Source: ABdhPJzo4PZ4wOpwK4EPfptH0lcP6RkPlh6aS2taiOlx30gGCDmG92nQZzwYQf8t1jtnWjXdKTZgCQ==
X-Received: by 2002:a37:d83:: with SMTP id 125mr2292115qkn.430.1595456385011;
        Wed, 22 Jul 2020 15:19:45 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:5c10:aafb:1d38:5735? ([2601:282:803:7700:5c10:aafb:1d38:5735])
        by smtp.googlemail.com with ESMTPSA id n127sm1079195qke.29.2020.07.22.15.19.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2020 15:19:44 -0700 (PDT)
Subject: Re: linux-next: Tree for Jul 22 (drivers/net/vrf)
To:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        David Miller <davem@davemloft.net>
References: <20200722231640.3dae04cd@canb.auug.org.au>
 <e1fc4765-db64-2876-2f3c-857c45d4fb45@infradead.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <76e94256-ccd6-2ba5-fa85-24e643dddb84@gmail.com>
Date:   Wed, 22 Jul 2020 16:19:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e1fc4765-db64-2876-2f3c-857c45d4fb45@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/22/20 10:35 AM, Randy Dunlap wrote:
> On 7/22/20 6:16 AM, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20200721:
>>
> 
> on i386:
> when CONFIG_SYSCTL is not set/enabled:
> 
> ERROR: modpost: "sysctl_vals" [drivers/net/vrf.ko] undefined!
> 
> 

thanks for the report; I'll send a patch when I get a few minutes.
