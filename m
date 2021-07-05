Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068DA3BC1B1
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 18:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhGEQdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 12:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhGEQdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 12:33:08 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379E4C061574
        for <netdev@vger.kernel.org>; Mon,  5 Jul 2021 09:30:30 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id s24so6248424oiw.2
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 09:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nv6JzVM6q9E9Z/txEG3ATPD791fhy6iu1V8XPuRbTkg=;
        b=ONK3R0OSJiA6ZU8Y5p7YaY+F8m5Q73kVbyeAmdGUX6TBx6CV1bWHubrPHm252uLoUH
         f90PC1gcFw/F6UQ66/TSkzwbmsMasaGpIQKS2ODI2L1kFQaFGzzFvPB56MXnTBtrMzU9
         pq3hfWIC2/FnQ2hVV2iQUfTBdqk4zjHNVjXDI0Y1Kl4gqGzSkK32MU5pYbvt9yCJLdz+
         tb328ICZOUvcmpBoAsaXhoDWjiajzu+dY7GWxy5ywmTV85eGx116LfY7/N+SIx43h/Qo
         Hy2aBTQoMA9g0MamUa3zm+nnpxs7bsAUG9Y4Ygm5LufK4lkQeBBlkXeCB88bMb+thUAB
         zPrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nv6JzVM6q9E9Z/txEG3ATPD791fhy6iu1V8XPuRbTkg=;
        b=hBCw42UHj1qblDDHo9zO85N64u5gSnPiqYbYC9Qws0Vf3z1ACE8dQACDOr1Ygv49e0
         dufF6aeD4+FbLjidGOzJfUgf/pWrtsiktOdvdituI6EMetywBSJxVoSWMmaOmtLf+EHt
         kyEa0EhoKUBm3Cq79VLZ0smfG0H1IRGZZfjT6yAmi0G+siVdQwmhwKK9BfQF4diOnmfa
         HGwRQgJbjMJ85ILUhQUFwl3cyrejrktIpOR+++d81V830yMogkyriDpKrY/Sz52z2+Y9
         J7R0UlNp36Z7rrmsYkZbyFqA5+FVtbUkRWR09G4t3h8NDVQD94ET9cwSBQ3Yg7PKc7DH
         ex6g==
X-Gm-Message-State: AOAM532x/VybFvFsadz4FZEFYy6Mt21+HyG44Www4vzQfzVgiWhSGzAt
        avw19Z2pymh+vRzEojIXGJg=
X-Google-Smtp-Source: ABdhPJwkgEgSNwvxndNA1dXnx/xOwgC/3iwsnQtup/vjIbpvXqquULTh8TLCWtwQbmAPdXwvMjXDFg==
X-Received: by 2002:a05:6808:683:: with SMTP id k3mr10769672oig.171.1625502629655;
        Mon, 05 Jul 2021 09:30:29 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id f6sm2327444oop.31.2021.07.05.09.30.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jul 2021 09:30:29 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v4 1/1] police: Add support for json output
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Roi Dayan <roid@nvidia.com>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
References: <20210607064408.1668142-1-roid@nvidia.com>
 <20210705092817.45e225d5@hermes.local>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3678ebef-39b3-7e00-1ad1-114889aba683@gmail.com>
Date:   Mon, 5 Jul 2021 10:30:27 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210705092817.45e225d5@hermes.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/5/21 10:28 AM, Stephen Hemminger wrote:
> On Mon, 7 Jun 2021 09:44:08 +0300
> Roi Dayan <roid@nvidia.com> wrote:
> 
>> -	fprintf(f, " police 0x%x ", p->index);
>> +	print_uint(PRINT_ANY, "index", "\t index %u ", p->index);
> 
> Why did output format have to change here? Why not:
> 
> 	print_hex(PRINT_ANY, "police", " police %#x", p->index);
> 

it should not have. I caught it in the first version in a review
comment; missed it in v4 that was applied.
