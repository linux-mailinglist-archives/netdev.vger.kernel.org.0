Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553DA2632D8
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730734AbgIIQw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731136AbgIIQvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:51:33 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BEFC061755
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 09:51:33 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z4so3744193wrr.4
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 09:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=boivrIm6XLTnEn5eNCEDkvkxwNtfR6jDbwNyy8jPdmE=;
        b=VldR9po461+TYgauCcqCfiTaaggzunJLKwo2r8r4Dvf5Efls/zVpW9FW53Jq4zHyge
         6nTzBLsTFBOVj5zyAijL882AtUfh92sSqDq6OlYALcDu4oVc2yELCtDQPQUl6XTjAljR
         0dElEqoWYFI+mBobUqCsod348iZIYWRwrUd/n61nCLpH4vIGgxyQLVknYFWMLLiRgviR
         O37UkD5eyDUaY5glBdo8bKJbCdwZudXrvLS3o2E4nboUmM5Z5E3aKeOUGDZT7cvQDDL3
         WM9X24EBz39upL8xv6+1XsFNp2rWaRzr6Kr/H6ZgAxUOeC+ZW07YsTcqtyDgXSOGwvuL
         AvwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=boivrIm6XLTnEn5eNCEDkvkxwNtfR6jDbwNyy8jPdmE=;
        b=BF2UL5IIwAv0Wx+14lHTWmLk8yBiAmIIQ45kSsnWQEB+6tZFMscYQD+r7yuXQFYEG7
         hvq9hnPSJoSVh6TdQtD9L1VU/BmjRmO5u2TDD25BUJQdxxZ1fxYk8hv1JFz7synefDIc
         Hy6hLBadeu2Moo0Rt1lF25JDARsg0JIXupV8HkrYlMm2kpkqj1iWNJXj7Sb/HTwC9gt9
         4l8QG7lw7Src9IAXRDl30SnXeY5bHGivfbcnbaRqewE2T40mNzh88Uas9ZB2VqyZhSQt
         xZ1834zlq/bQAzBEPvamaOJVekFNNCjFTQ7NvwAHA2/2UuSq2ZTgft/VNOERdS835mEo
         Z+dA==
X-Gm-Message-State: AOAM5332beQT1VpSQa+qz1XgdBLsR5WWUwDzWY9DMcuTMto9lnPAsHnh
        tuJzXoz0wtz6AnF/58E/Lr8NqbBjPYOfYr7och0=
X-Google-Smtp-Source: ABdhPJzn9vZUbbD/dlQf5hBUye24ua87RlalRciD8ioxxEqTDCZZNaLE+GsN0sM7wheRHuOvhaTs4A==
X-Received: by 2002:adf:dcd1:: with SMTP id x17mr5276210wrm.150.1599670291709;
        Wed, 09 Sep 2020 09:51:31 -0700 (PDT)
Received: from [192.168.1.12] ([194.35.119.78])
        by smtp.gmail.com with ESMTPSA id h5sm4809005wrt.31.2020.09.09.09.51.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 09:51:31 -0700 (PDT)
Subject: Re: [PATCH bpf-next v2 2/2] selftests, bpftool: add bpftool (and eBPF
 helpers) documentation build
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
References: <20200909162251.15498-1-quentin@isovalent.com>
 <20200909162251.15498-3-quentin@isovalent.com>
 <CAEf4BzYaXsGFtX2K9pQF7U-e5ZcHFxMYanvjKanLORk6iF1+Xw@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <9574095f-f354-2f52-a476-8b832ffb1a7b@isovalent.com>
Date:   Wed, 9 Sep 2020 17:51:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYaXsGFtX2K9pQF7U-e5ZcHFxMYanvjKanLORk6iF1+Xw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/09/2020 17:45, Andrii Nakryiko wrote:
> On Wed, Sep 9, 2020 at 9:22 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> eBPF selftests include a script to check that bpftool builds correctly
>> with different command lines. Let's add one build for bpftool's
>> documentation so as to detect errors or warning reported by rst2man when
>> compiling the man pages. Also add a build to the selftests Makefile to
>> make sure we build bpftool documentation along with bpftool when
>> building the selftests.
>>
>> This also builds and checks warnings for the man page for eBPF helpers,
>> which is built along bpftool's documentation.
>>
>> This change adds rst2man as a dependency for selftests (it comes with
>> Python's "docutils").
>>
>> v2:
>> - Use "--exit-status=1" option for rst2man instead of counting lines
>>   from stderr.
> 
> It's a sane default to have non-zero exit code on error/warning, so
> why not specifying it all the time?

I hesitated to do so. I held off because a non-zero exit stops man pages
generation (rst2man does pursue the creation of the current man page
unless the error level is too high, but the Makefile will exit and not
produce the following man pages). This sounds desirable for developers,
but if distributions automatically build the doc to package it, I
thought it would be better to carry on and build the other man pages
rather than stopping the whole process.

But I can change it as a follow-up if you think it would be best.

Quentin
