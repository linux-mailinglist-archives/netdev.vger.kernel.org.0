Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF0A28647C
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 18:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgJGQdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 12:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgJGQd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 12:33:28 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366E2C061755;
        Wed,  7 Oct 2020 09:33:28 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a1so1313557pjd.1;
        Wed, 07 Oct 2020 09:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=neU5+rAlGsZASSKfQw8Msj4tZFoTKJRf6eBesCf7slo=;
        b=oCLbJLkoPvZKRuHhrwoQlvFapOpQthkWGLXWH6A8aLxwxAd11xlR8VbqkKL13Ne0kU
         SIcPmoUUmBzqwAdnwP8XE8u3HRTDDgkUasoRdBmVS7Rebksq7dUSlJEzUUUhH6ipSfEd
         TcHrSFRzuNlvu0p/GL2c4uQ3X+FPKf1Nh/Pbku/sRQXiWKTANMkJHHrpGReX5yk9EVVg
         fAuLuZIv7hz9S0L+DeIzBTmQdEEiZqldk9Y/AL5+NxICNql4P4HzouQ6LJw/ILrvvmSv
         /F/WqpOwV8GFafViny5wJmDbRKgz9ukOOfSSUtF/e3SVwhYVSGVNgjivgQzPqZCJfZoe
         d6tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=neU5+rAlGsZASSKfQw8Msj4tZFoTKJRf6eBesCf7slo=;
        b=hqK2jXvM0MMzR0biWA2/ZKoL0D1E7ohP2p7X4YW/bXD7qHQwHreFPF1+3YTuaVKfAu
         2CoEzkNRoy3Qa7S3/wmThcJxWBML6UMlj+Gz56cr0mh2gGNUrT9G1TW6h9sqbFLNV6IH
         7PafSBx3ssEBtMpp+KjSJz1wAnvHNHOYgynErQN4UHvjYZNJMOud5AjhCusp9mX5FJ2u
         euQxGtPzNVS0FcPxUHk+Qv9OZj80dbodkyiLNxdaGyu0b0n3lVNTaMFvdRm41hPR/tHW
         rdp12yX+efenPc1wtJCPUVZGoFh35fOjH1iO3kLx+f9LAn/6hdhtroY2nqaVXyd5AwgM
         BQgg==
X-Gm-Message-State: AOAM531rTJ+mdsQH1WCSgckDABQ72mdmUqz2N8XGPHgi8o9+h46c7Uok
        Spj8vqCZbEUuxPvrfmbz4AM=
X-Google-Smtp-Source: ABdhPJyZTFhjvoEjRRhD4UsTl8p6ocmeuNvTd86T0R0yQHgC9h9nDO/Ixdo017eaIlZn9t3He+Cqog==
X-Received: by 2002:a17:90b:23c4:: with SMTP id md4mr3589710pjb.12.1602088407840;
        Wed, 07 Oct 2020 09:33:27 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([72.164.175.30])
        by smtp.googlemail.com with ESMTPSA id m5sm4019578pgn.28.2020.10.07.09.33.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 09:33:27 -0700 (PDT)
Subject: Re: [PATCH bpf-next v7 2/2] selftests/bpf: Selftest for real time
 helper
To:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "Pujari, Bimmy" <bimmy.pujari@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "kafai@fb.com" <kafai@fb.com>,
        "Nikravesh, Ashkan" <ashkan.nikravesh@intel.com>,
        "Alvarez, Daniel A" <daniel.a.alvarez@intel.com>
References: <20201001020504.18151-1-bimmy.pujari@intel.com>
 <20201001020504.18151-2-bimmy.pujari@intel.com>
 <20201001053501.mp6uqtan2bkhdgck@ast-mbp.dhcp.thefacebook.com>
 <BY5PR11MB4354F2C9189C169C0CE40A9B86300@BY5PR11MB4354.namprd11.prod.outlook.com>
 <CAADnVQJmmY_HER23=3bxCrrsbJoNs1Ue__P24KHj3YY1EkzuKQ@mail.gmail.com>
 <CANP3RGfyG9_vj5FkgJz2HV+8voLqP3N+6Qi5hpkqJntF0YSy-A@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <59b4dd07-16c5-f831-d27f-8c5d4f50d534@gmail.com>
Date:   Wed, 7 Oct 2020 09:33:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CANP3RGfyG9_vj5FkgJz2HV+8voLqP3N+6Qi5hpkqJntF0YSy-A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/5/20 10:36 AM, Maciej Żenczykowski wrote:
>> Don't bother. This helper is no go.
> 
> I disagree on the 'no go' -- I do think we should have this helper.

+1

> 
> Lets not make bpf even harder to use then it already is...
> 

Logging is done using time of day; that is not a posix mistake but a
real need. Users do not file complaints based on a server's boot time or
some random monotonic time; they report a problem based on time-of-day.
Allowing bpf programs to timeofday makes it easier to troubleshoot and
correlate kernel side events to userspace logs.
