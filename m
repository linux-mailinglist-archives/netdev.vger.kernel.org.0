Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B14D28C7BC
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 06:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731413AbgJMEHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 00:07:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58662 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727016AbgJMEHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 00:07:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602562056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JirT+4vZS4Wlh/KjRG5Gnr9Co+Ss0bLSO4bv8e9Yukw=;
        b=iwWaL5X9WkuhMgMnJYHDFplAyU+m3QuxJYFvxcpkO5IVJNIGQOu7jv3bNQgzxekmG/kfai
        +0rWk0k+TacnpYpqmsw8XSIHL9NKdR3WCuOdLAt8X4OsvVwwRodfsRsBLs5ss9DCdPflQX
        a8p3OJ/QSQMWL6/1CLz2XHtvM9YfRAY=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-44m_ELsTOzKH2NjOlRXajQ-1; Tue, 13 Oct 2020 00:07:34 -0400
X-MC-Unique: 44m_ELsTOzKH2NjOlRXajQ-1
Received: by mail-qk1-f198.google.com with SMTP id w126so14174808qka.5
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 21:07:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=JirT+4vZS4Wlh/KjRG5Gnr9Co+Ss0bLSO4bv8e9Yukw=;
        b=Jg5rSTS7uP8k26BgZRW31AIw9EIlL7YumAlGStKa0djlbOsUqi0WJ3pS0UTT4ApNiG
         LDsPN2eJg8drfNhkLbzrPAqan7aDY/MFkHsRJhk6JWljxaWmDmCIt9erMkprvZAiDBju
         j2afpBQMZeLpm88tqfYmRst7MzMF1VmWo2pi+lXIIUWSVC4VPDid/wMVWOv0f/qN9b9F
         kmgLzTB18qYz0fQEVNT+yetCP7fa3EQMNRopkOagGxbaG7UMrJ7DOGO+3VVwb78FGM5t
         0mBiR7/pC5kNt6c9amefebswqauJhI4SRoapOS/5GVwuNXGiEMKwu4Id8jjR9tYi4vmq
         HBCw==
X-Gm-Message-State: AOAM533wHPHa4rFgJ1JdCD9Y+cTPjUGwpHeAWqQhbTDBTzTmS2jmzNLR
        EE+AdjHixulq8TaeAvmccygUQhEWlIjk4RynTRjkLRNNPb0DdR79QS0Jaoyg0cpG10CwJ/1+9Jb
        0sjXz+YeDOw5qcBPs
X-Received: by 2002:ac8:31b4:: with SMTP id h49mr13612802qte.258.1602562053509;
        Mon, 12 Oct 2020 21:07:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJym1jOUYWeI7Zbb7O6jtxusBRzdyOWNTK23Knln/KjzDTmGZDXeBS3EfPjk5zslnyZ6dHPQ0g==
X-Received: by 2002:ac8:31b4:: with SMTP id h49mr13612782qte.258.1602562053198;
        Mon, 12 Oct 2020 21:07:33 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id s17sm13274100qta.26.2020.10.12.21.07.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 21:07:32 -0700 (PDT)
Subject: Re: [PATCH] ptp: ptp_clockmatrix: initialize variables
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     natechancellor@gmail.com, ndesaulniers@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
References: <20201011200955.29992-1-trix@redhat.com>
 <20201012220126.GB1310@hoboy>
From:   Tom Rix <trix@redhat.com>
Message-ID: <05da63b8-f1f5-9195-d156-0f2e7f3ea116@redhat.com>
Date:   Mon, 12 Oct 2020 21:07:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20201012220126.GB1310@hoboy>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/12/20 3:01 PM, Richard Cochran wrote:
> On Sun, Oct 11, 2020 at 01:09:55PM -0700, trix@redhat.com wrote:
>> From: Tom Rix <trix@redhat.com>
>>
>> Clang static analysis reports this representative problem
>>
>> ptp_clockmatrix.c:1852:2: warning: 5th function call argument
>>   is an uninitialized value
>>         snprintf(idtcm->version, sizeof(idtcm->version), "%u.%u.%u",
>>         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>> idtcm_display_version_info() calls several idtcm_read_*'s without
>> checking a return status.
> So why not check the return status?

calling function is a print information only function that returns void.

I do think not adding error handling is worth it.

I could change the return and then the calls if if you like.

Tom

>
> Your patch papers over the issue.
>
> Thanks,
> Richard
>

