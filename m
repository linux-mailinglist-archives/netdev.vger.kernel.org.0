Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BF642DB85
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 16:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbhJNOaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 10:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbhJNOaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 10:30:24 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7C5C061570;
        Thu, 14 Oct 2021 07:28:19 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id y17so3691253ilb.9;
        Thu, 14 Oct 2021 07:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3yqJazoYM4kmLQJvSLYhgrv+ART/xn7b80Tf2DaKUZE=;
        b=GcCvIJPEQ3pDL30+wH+yrRs7in7q5fCSnh+dBrL3Jxtbs/xFafNy7hUZ8STIcV95Zm
         yOzi/nPr4K5aYSTbXoBt2pZVo6MsC5GbT1m04gCG++00A21kXLtg/C5SSbnh3O8szasY
         y5LajvBdcwukNWjTGJ6tQ2vlKVJIZdFnmcywvQ7xn9cv3QZlVItg50c4Q+IwioevLVT5
         vLEieTQsj/JsZQB61/aPYHGrVaCpPHRFM+iLH3P4bHMlmdLRELy1lRw52r9ERKqHFFC5
         62JalqI7fYDCA+blNRl2B4n1ykcewl4HCddKSBBohx5m7QxR+WirxusEPQzTEz16emQq
         A4iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3yqJazoYM4kmLQJvSLYhgrv+ART/xn7b80Tf2DaKUZE=;
        b=cDnGRRzoFMl2dSJCjYqjmC4lV9nsKAnmH8lDiHl3X+tTYZ5N8rekKQPy1RMmlrhDyA
         6ccNw1HYk2Pu+wS9uNFAHl6dfFwW51/wnPJuUP4uxpHOKVdN7bY/hklbdoz1nQOSpMqx
         GvrW0aP4Lby/6AZokQCDABhAyYVAFzAi+hHaq2USGlz/6LAbX4Pk/xq16rv0blyefvet
         DDE9V6caNNMewHg0ySmY1GEFwQ8iBoLHcXe+CSG1Kx31VoHvARyohdVz809AdfeaYsMB
         vTrDLs4S4nTavMUR4Qv2uHxJkw1K8S5nrg9BW3g7PHNTB/lgHIqa4a/xzWBe0II3LUA2
         v/iQ==
X-Gm-Message-State: AOAM530UKzXW6qGH/2aF2sb6IXemzCxgiDX7n/EEVb18zFw/v+u0QmxV
        4ZReyhTAM+L2NVWylgutrqNTULvAjtfTFw==
X-Google-Smtp-Source: ABdhPJwcYhiIlEcVqT3SGlWMGwTAFiPisf+6b+JbL+OShzL5TxgrO/MfJIdjs19GStIIr5LaZ2qtqw==
X-Received: by 2002:a05:6e02:2169:: with SMTP id s9mr2765788ilv.154.1634221698843;
        Thu, 14 Oct 2021 07:28:18 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id l18sm1322377ilj.12.2021.10.14.07.28.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 07:28:18 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] selftests: net/fcnal: Test
 --{do,no}-bind-key-ifindex
To:     Leonard Crestez <cdleonard@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Yonghong Song <yhs@fb.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1634107317.git.cdleonard@gmail.com>
 <e864a790986862bb09c69627067a0349253f0fc8.1634107317.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2d00a2bf-acce-466a-8908-fbfc13c0840f@gmail.com>
Date:   Thu, 14 Oct 2021 08:28:17 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <e864a790986862bb09c69627067a0349253f0fc8.1634107317.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/21 12:50 AM, Leonard Crestez wrote:
> Test that applications binding listening sockets to VRFs without
> specifying TCP_MD5SIG_FLAG_IFINDEX will work as expected. This would
> be broken if __tcp_md5_do_lookup always made a strict comparison on
> l3index. See this email:
> 
> https://lore.kernel.org/netdev/209548b5-27d2-2059-f2e9-2148f5a0291b@gmail.com/
> 
> Applications using tcp_l3mdev_accept=1 and a single global socket (not
> bound to any interface) also should have a way to specify keys that are
> only for the default VRF, this is done by --do-bind-key-ifindex without
> otherwise binding to a device.
> 
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---
>  tools/testing/selftests/net/fcnal-test.sh | 60 +++++++++++++++++++++++
>  1 file changed, 60 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

