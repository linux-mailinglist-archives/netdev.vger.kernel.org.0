Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31C91BE458
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 18:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgD2QwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 12:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726481AbgD2QwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 12:52:01 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B3CC03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 09:52:00 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id o135so2686459qke.6
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 09:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZcM0xqbkWa+cj7QcDuPojFL6ag2CUmEJBATUhmc6pUQ=;
        b=UMejH44iQvsSvOsUNONle36RNHjpVatlKbS1/U0gPa256+0IRwpa3hhfycq5J7BUy2
         p6FJmbq1qdQaLCqIf9yQavWPSIYmnp7rAJ9sl2gpkR4VIahXvh94vWh7pPK7IxG6Xr2/
         HRu1ZCLYnCFUMlGPscugGs9O15HZrDjRuhdlrQvSm5Saz00HZ5zjV+ZuYvMAh2DYoYk4
         EZlJ/Pf3zL/RHwYVkx26irqhHbp1vFV9Zvl7Ska8FOjIqppQk7GTBDdWUyuVFyrqtfk7
         jsGGy5QtFAWLc7FePUwybPDcF6Mwze+QQWw3gwPMMEbpyGuscreOKJmgLnvP1xhKpdlt
         bCpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZcM0xqbkWa+cj7QcDuPojFL6ag2CUmEJBATUhmc6pUQ=;
        b=KVPF9brFbiM6wEkHv+2Rtw+Snqppb0VQqEmiXJyl0qs1lJw5YeLQM4Q5yYENQUG1Gz
         TRIkP+b+nZlzfsqnkFdHHdYdGFqVfbZnWIqnMaGbTSU9frg5ogOsihxhM1RY+xTSPPTR
         uC3v6KduHh/71JOT55clfTrEPcy4iY5mY7C2BrQjyF45SX5Gw6mSiN1jZAe5zmou40MN
         tz7lSjkz8d6UGpxHnLHvrzte9usqCpe/r/D5Vju+d6LVhC1nT4bs5xqKPSu+SvH1Ztmh
         +Rao6iv9SDcDW+7vPyqcKPAEHU6zXg0/e3WiuvkYfgrud75S4P+E3YqeGsVfoX9RGoCF
         akJQ==
X-Gm-Message-State: AGi0PuYjU7Sfwr2TfE5CsdIHYuEncsdrl32jxgidg4iUqRQEudZGuSUo
        JIYMaDDivfHfXrerFKDhqjI=
X-Google-Smtp-Source: APiQypJ+OUV4Zg4A43NX6N6kGZ9L3cgL67ZBue4LobuS8meMgy+8roek7hh0DwTBT/ngGdCyM3CEtg==
X-Received: by 2002:a37:68c5:: with SMTP id d188mr35109643qkc.85.1588179120001;
        Wed, 29 Apr 2020 09:52:00 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:3576:688b:325:4959? ([2601:282:803:7700:3576:688b:325:4959])
        by smtp.googlemail.com with ESMTPSA id b19sm16372285qkg.72.2020.04.29.09.51.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 09:51:59 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 0/4] iproute: mptcp support
To:     Paolo Abeni <pabeni@redhat.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org
Cc:     dcaratti@redhat.com
References: <cover.1587572928.git.pabeni@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2ab158b2-a0f1-1ae5-c47c-ddc0fb6afa39@gmail.com>
Date:   Wed, 29 Apr 2020 10:51:57 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <cover.1587572928.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/23/20 7:37 AM, Paolo Abeni wrote:
> This introduces support for the MPTCP PM netlink interface, allowing admins
> to configure several aspects of the MPTCP path manager. The subcommand is
> documented with a newly added man-page.
> 
> This series also includes support for MPTCP subflow diag.
> 
> Davide Caratti (1):
>   ss: allow dumping MPTCP subflow information
> 
> Paolo Abeni (3):
>   uapi: update linux/mptcp.h
>   add support for mptcp netlink interface
>   man: mptcp man page
> 


applied to iproute2-next. Thanks

please send an update for man/man8/ip.8
