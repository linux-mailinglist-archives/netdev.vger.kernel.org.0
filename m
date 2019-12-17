Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98E1B121F5E
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 01:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbfLQARB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 19:17:01 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:40509 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbfLQARA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 19:17:00 -0500
Received: by mail-pj1-f68.google.com with SMTP id s35so3736708pjb.7;
        Mon, 16 Dec 2019 16:17:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1OROaEYGJ7cU9PndUkdU7ASlSknQD2Li+EEBqp17mis=;
        b=K2DrdXAgGAFjco7WkxUE9hCAVr1APCFMiBh8o7ZzruvvHrXLykJ6r9uY9wleDoCkZJ
         GUsj3lJiNDYtvhLNDr1ifkivSWMzqX9X8ku+6014LviMyW/P8YcSJbqWU/j9IZiIFyjC
         nvo5hw3AcXxkSlmm3MgyAVQkWCS9locoWAoxzCS0m65YARSbKg3bKGMdB1sbnUY/f1dX
         WPKg8V7050dPgNoOOCM/A3Vr2OCVp0Js9Rk5qNTSDGsSowTTEUpUVbGPKTy39267Zvq1
         S3t9PYVipSvKKpmWBUu+wc4TI+Qn2Oa+vueDpcjIk8wEIh9qVIL6WmnVDYaI/phCl/ve
         2B/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1OROaEYGJ7cU9PndUkdU7ASlSknQD2Li+EEBqp17mis=;
        b=LU30HSbntPHNPqHn/isOJrfiqpSx73uJDcHeFm8JVMNggH1gMNyeM09LfffwRZYGNt
         AaVezjrbtfbnjTlE1PdCVcevG576kYjOXrX+GGzlLjKObrTgQG4udcqstUvb6VYS/6kS
         L3qcUOZ4ClqibExiGrHLCRmNOZH9W2cfQT6/1YkyuMDJRGnpW2surkGLY1zaL8sTGvAT
         RlznKjIiUVL8pEE28B1TbsJFtAwah4Lbsjr/2ndQzN+xiP0i2PZj3nwio8Bbia7m22Ti
         +KddS5Lcun1yzpoyuxHSpdwHfvVRmC1jc0giVZ8aQIvZ6MLHHGDwXWHbjpdjzLXPx1oC
         mSgw==
X-Gm-Message-State: APjAAAUprOmDF/HVKgtR0PVW/Zj7q1+P++Af6D5Mkdjbkmjbesi2EBSM
        RcX3GjEdAoFJDzoq4zHf3uHUi2nQ
X-Google-Smtp-Source: APXvYqxC3G4URmrFBTRdkP1iZgsz1qAv3ai0g/6DHQuslJs48zwF2M9S7CqlRaxMN6RJxWTuqpc5lQ==
X-Received: by 2002:a17:90a:a004:: with SMTP id q4mr2608777pjp.106.1576541819819;
        Mon, 16 Dec 2019 16:16:59 -0800 (PST)
Received: from [172.20.20.156] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id p38sm660834pjp.27.2019.12.16.16.16.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 16:16:59 -0800 (PST)
Subject: Re: [PATCH bpf-next] libbpf: fix build by renaming variables
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
References: <20191216082738.28421-1-prashantbhole.linux@gmail.com>
 <20191216132512.GD14887@linux.fritz.box>
 <CAADnVQKB7hUmXBMmPfFUH4ZxSQfRtam0aEWykBNMhrKS+HjcwQ@mail.gmail.com>
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
Message-ID: <caf893fb-e574-7a67-1e4e-4ce5d7836172@gmail.com>
Date:   Tue, 17 Dec 2019 09:15:59 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQKB7hUmXBMmPfFUH4ZxSQfRtam0aEWykBNMhrKS+HjcwQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/19 11:02 PM, Alexei Starovoitov wrote:
> On Mon, Dec 16, 2019 at 5:25 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
>> On Mon, Dec 16, 2019 at 05:27:38PM +0900, Prashant Bhole wrote:
>>> In btf__align_of() variable name 't' is shadowed by inner block
>>> declaration of another variable with same name. Patch renames
>>> variables in order to fix it.
>>>
>>>    CC       sharedobjs/btf.o
>>> btf.c: In function ‘btf__align_of’:
>>> btf.c:303:21: error: declaration of ‘t’ shadows a previous local [-Werror=shadow]
>>>    303 |   int i, align = 1, t;
>>>        |                     ^
>>> btf.c:283:25: note: shadowed declaration is here
>>>    283 |  const struct btf_type *t = btf__type_by_id(btf, id);
>>>        |
>>>
>>> Fixes: 3d208f4ca111 ("libbpf: Expose btf__align_of() API")
>>> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
>>
>> Applied, thanks!
> 
> Prashant,
> Thanks for the fixes.
> Which compiler do use?

gcc (GCC) 9.1.1 20190503 (Red Hat 9.1.1-1)

> Sadly I didn't see any of those with my gcc 6.3.0
> Going to upgrade it. Need to decide which one.
> 
