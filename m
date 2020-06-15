Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90111F949D
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 12:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbgFOK30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 06:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729436AbgFOK3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 06:29:12 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB3BC061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 03:29:09 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id x93so11104505ede.9
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 03:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EDBJtBRObvqYYs/f61xomalWJ9+yhMx1xMFegJ9eNjM=;
        b=wE48gfOLCwqOAshvmqBH/8/8y0WCvNVReqYp623yAgynOYmEdTIz6kaBELo/5EeQ1n
         vIXG6609T/L62QkUzzEwqgojwXVYJLiOhbE3rDMzZA4d21xVYnuajt1RPQUe4FYFq/F6
         3A4Mg79a9KRcPELhZBLvc7QhKMPUn+PU7gA8K/r0cm4R/uOOIMfVmrmpyJDCgpVyGdYz
         1f1jM2fyPkgwc877L4JC13sjAVyjJw+kpN0O6xlehgmFTABZutnWLM0TNfLlkK/P96US
         Vn4rGnjLlk8v0AHGserqeSsvSiPAT7GELCpo7LgRcnSNNrt5L7XmsFXNUxcj4iZndy+m
         UR+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EDBJtBRObvqYYs/f61xomalWJ9+yhMx1xMFegJ9eNjM=;
        b=s4U3H4eEFfVdJaRQGlM6na3yXL+Hb2U5ontnamge5XShrAWvwsuJIdgBw+YktvJRgb
         Aof8s5awmKC+m5+1dK+1npUaZgTr8Fwz8pg7szBeePznd+FbRySj97Ng1sVC/EDyO+2p
         0eAaHYysxpLtVaOIBM60FG2KslNMm8ufeL3RK7I/yzNj/PGXZvyN79b2mF3qajvpQNUu
         aEO1M4topQAtIxuyBGfPmdzIvyJjrmii11BNpALyuNMGP+MJSvWE9VmUZL1w4eD5Htpn
         IfB0mCReoy9qbemYEHJDakBB2/D+FAw8J2rKJCBM97YBTNHlr4fYglPL0x5C9gRuwFlH
         i+xQ==
X-Gm-Message-State: AOAM5301GKuaNQ/MvfagHkS8jeheOOI3aDZI9RnyKSBjg6gUOojxlG4n
        FJIQN/ZPxu8iy0b5SRcrSsmYMFZ8Z78=
X-Google-Smtp-Source: ABdhPJy7aATQdZ03Q4T7aEc/X/rIocX32vqMRexiuVPmN7o59z6IbFvRQdL+ytbyNTZTfNvW7IvbGA==
X-Received: by 2002:aa7:c2c4:: with SMTP id m4mr22600796edp.299.1592216947960;
        Mon, 15 Jun 2020 03:29:07 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([79.132.248.22])
        by smtp.gmail.com with ESMTPSA id y21sm8772378ejp.32.2020.06.15.03.29.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2020 03:29:07 -0700 (PDT)
Subject: Re: [PATCH net v2] mptcp: drop MPTCP_PM_MAX_ADDR
To:     Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
References: <8d8984e8f73e37c87e69459fdef12fe9bab80949.1592209282.git.geliangtang@gmail.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <dace6dec-e908-4bf8-f98e-cbec6c2a0f62@tessares.net>
Date:   Mon, 15 Jun 2020 12:29:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <8d8984e8f73e37c87e69459fdef12fe9bab80949.1592209282.git.geliangtang@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geliang,

On 15/06/2020 10:28, Geliang Tang wrote:
> We have defined MPTCP_PM_ADDR_MAX in pm_netlink.c, so drop this duplicate macro.
> 
> Fixes: 1b1c7a0ef7f3 ("mptcp: Add path manager interface")
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> ---
>   Changes in v2:
>    - change Subject from "mptcp: unify MPTCP_PM_MAX_ADDR and MPTCP_PM_ADDR_MAX"

Thank you for this v2, it looks good to me!

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
