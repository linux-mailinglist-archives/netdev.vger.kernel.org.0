Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DB61F7C81
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 19:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgFLRdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 13:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgFLRdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 13:33:16 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E21BC03E96F
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 10:33:15 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id l12so10841782ejn.10
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 10:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=riq8oZ0YmVJgRL3JUnUAQs/ESUHxcGfiGOYYzkUX5O8=;
        b=AYxlnsBvg3ciNGR1E/ZV3+KKfCnlMH/SzgcuP04PaGpjjC6k52kZtVZkh4m/ITJ+Zf
         Rm8zrZcN01Yzw92PPCjDeufQhBsWDUG+qngwqFdb+FooHy2xtPkOFHFmeGqlPuN9izF5
         5IKB2yEOjJM1kQrVRATM4tUuUgronSgbACTU26MbD4xozOPZKvbY08dkkUDMJ/DqdufL
         5j0ZL2vBpCUGmN3BcnK1nTqlSJJxFc+jClRVuqYZMjJw3Z4yA7jwPDDgXMTE19fIYlFu
         jwo9Lyc0ki8dV7R54SNKnlVUXdFhwrnXc7lg1O6IiaRpTtDyDuL+lMqK5gTocKmr5fZK
         x1TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=riq8oZ0YmVJgRL3JUnUAQs/ESUHxcGfiGOYYzkUX5O8=;
        b=MX4EKm72h94gcaXJk22mY5J791gT6yUlufUrd9NxCxcTYPEvQo4nttLgE4Bjxz4msd
         KdiAWSy+FA61xR9qLvHWLi9g+kXLADlvjhhlrWbfNWTGpI2+E3M52vg9H1AtPRYq2yT0
         gHMgd/XG8UZ3YxN6kNRQEBhN/JGpVg0RVnlWlgvOQTfe21X6B4wLH8I53L9MUNZOHNO8
         USRrsY6hHwXBFcH8dfJ/jRvWPNLVP3cJHP6rOHYw+VixQBGhMV8nPqVQTNHjPobCkiTd
         KIxzVTMCc54PlDMQ2y0JENoQ9zoY+OHQxhazxO8qZJB67/QsyKWQuIVDbG5XqZJurgU+
         +VGA==
X-Gm-Message-State: AOAM5337ddZj0+xYPuLpAiHX+tRUjAlTfkMQsOOTSKu30nks15VjfyXd
        79okQFa5/b80qEIeeqLsENC9Rw==
X-Google-Smtp-Source: ABdhPJwlDJSLLm1eei1ZYYEczfbr65LnrIffTlsF8XlpG70TYl2jz2JOc++y8M2MsKVxGcGc4UAqUA==
X-Received: by 2002:a17:906:5283:: with SMTP id c3mr13395606ejm.22.1591983194136;
        Fri, 12 Jun 2020 10:33:14 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([79.132.248.22])
        by smtp.gmail.com with ESMTPSA id us3sm3962154ejb.31.2020.06.12.10.33.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2020 10:33:13 -0700 (PDT)
Subject: Re: [PATCH] mptcp: unify MPTCP_PM_MAX_ADDR and MPTCP_PM_ADDR_MAX
To:     Geliang Tang <geliangtang@gmail.com>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
References: <463f48a4f92aa403453d30a801259c68fda15387.1591939496.git.geliangtang@gmail.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <2638593d-82bd-73be-8ff1-3a4a7d4d5968@tessares.net>
Date:   Fri, 12 Jun 2020 19:33:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <463f48a4f92aa403453d30a801259c68fda15387.1591939496.git.geliangtang@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geliang,

On 12/06/2020 07:27, Geliang Tang wrote:
> Unify these two duplicate macros into 8.

Thank you for this new patch!

(...)

> diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
> index 809687d3f410..86d265500cf6 100644
> --- a/net/mptcp/protocol.h
> +++ b/net/mptcp/protocol.h
> @@ -135,7 +135,7 @@ static inline __be32 mptcp_option(u8 subopt, u8 len, u8 nib, u8 field)
>   		     ((nib & 0xF) << 8) | field);
>   }
>   
> -#define MPTCP_PM_MAX_ADDR	4
> +#define MPTCP_PM_ADDR_MAX	8

I think it would be better to drop MPTCP_PM_MAX_ADDR and keep 
MPTCP_PM_ADDR_MAX in pm_netlink.c where it is used. Each PM can decide 
what's the maximum number of addresses it can support.

MPTCP_PM_MAX_ADDR seems to be a left over from a previous implementation 
of a PM that has not been upstreamed but replaced by the Netlink PM later.

Also, please always add "net" or "net-next" prefix in the subject of 
your email to help -net maintainers. Do not hesitate to look at the 
netdev FAQ for more details.

Here this patch looks like a fix so you should have [PATCH net] and a 
"Fixes" tag. I guess for this patch you can use:

   Fixes: 1b1c7a0ef7f3 ("mptcp: Add path manager interface")

That's where MPTCP_PM_MAX_ADDR has been introduced. It was already not 
used and never used later.

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
