Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5974F61510
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 15:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbfGGNYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 09:24:43 -0400
Received: from mail-io1-f41.google.com ([209.85.166.41]:34073 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbfGGNYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 09:24:43 -0400
Received: by mail-io1-f41.google.com with SMTP id k8so28986216iot.1
        for <netdev@vger.kernel.org>; Sun, 07 Jul 2019 06:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RcHjvvcuen0s7n/2WrigMBm1Z2WTmVLfih6CssNk8Zw=;
        b=fiGr+k7BYqSUqtSGLtjgPGmNCejQxbt9iUe5URMvsQi6W9BKFs3hqlUjfOItBwHhsO
         QBAiLBppwD4X7Ro4oBcKWFYp2MM7NwQcR30+f0FP51QDFiX/t3v38DryymJwbWBj8VRb
         1k//2mPlERDdEkpNw7O1vH43II/zuSmwNstNF+FSY08iNrAYIJotEBOwxdLAGLOczrpK
         2np9GFvvREoS6CDNz5n4UE84c6AhnrPET6JgjaXdTHP3XpSfPkIC7RQ4OHcTs5/a2qxC
         Y/IzNiGuSuL9HcgGdSRHnnxeO05ZxLuwd5WE6QM+EIERWhKQO6RKGa8GRQozhr+BPjjB
         1dHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RcHjvvcuen0s7n/2WrigMBm1Z2WTmVLfih6CssNk8Zw=;
        b=rInykjD0ZRfIIobJ2m0KrkNodBKcZDZWjYBejLyEyzyBKMwCVa5zq8MEjTaibk0cYc
         eqT1jGJ6W0dmtG15xn0nO+AGEPQPikCyS9TURrm+WvrIgoGC4/oBkCxd01wdQNfCdM2D
         Mfa7WCnF1/mfLVK90+zWyLHt48Uy96F70uucOX7k3BmbsNjmeQT025JjBpChuk6aQYgG
         3GbbkoKeNiEKLtfa62lVbfS+uEqYqP0qO2V+8eqjCmfJYiqy51R5osNU5W/qCdrdXXZY
         AdAhbXGXI4m567LCzKNaGSaBxXpV9/M56Uth7+XiVCKxUQx2RlQmlyN4i0tYmlcfsjp4
         dJTQ==
X-Gm-Message-State: APjAAAUzhBuPu8Qdsxib4C37izLAQlAMvw89A/k7XYtPOZnkf5WEX+0C
        a07CMRQZudKocqN/MzFPIHcpgGMb
X-Google-Smtp-Source: APXvYqyD5RQapN2lI+CJXUx7Hwtg5YP0VovNMqeSq4YEHYcfzS/+Y1EaKtKpxFbkZDTa79V6qrP9tw==
X-Received: by 2002:a5e:8618:: with SMTP id z24mr14236604ioj.174.1562505882659;
        Sun, 07 Jul 2019 06:24:42 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:429:7ee4:c4cb:8fc5? ([2601:282:800:fd80:429:7ee4:c4cb:8fc5])
        by smtp.googlemail.com with ESMTPSA id c17sm11514834ioo.82.2019.07.07.06.24.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Jul 2019 06:24:41 -0700 (PDT)
Subject: Re: More complex PBR rules
To:     Markus Moeller <huaraz@moeller.plus.com>, netdev@vger.kernel.org
References: <AFAC77AC6F8347289E6900614A523B32@Ultrabook1>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3fe925c0-e26f-492d-2552-b13a14451e3e@gmail.com>
Date:   Sun, 7 Jul 2019 07:24:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <AFAC77AC6F8347289E6900614A523B32@Ultrabook1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/6/19 5:06 PM, Markus Moeller wrote:
> Hi Network developers
> 
> I am new to this group and wonder if you can advise how I could
> implement more complex PBR rules to achieve for example load balancing.
> The requirement I have is to route based on e.g. a hash like:
> 
>  hash(src-ip+dst-ip) mod N  routes via  gwX    0<X<=N   ( load balance
> over N gateways )

Have you tried multipath routing? Does that not work for you?

> 
>  This would help in situations where I can not use a MAC for identifying
> a gateway  ( e.g. in cloud environments) .
> 
>   Could someone point me to the kernel source code where PBR is performed ?
> 

net/core/fib_rules.c
