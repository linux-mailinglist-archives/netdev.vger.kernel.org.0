Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F347E206DD2
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 09:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389695AbgFXHdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 03:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387871AbgFXHdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 03:33:47 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A1CC061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 00:33:46 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id o8so1331642wmh.4
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 00:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KP04hHKJxj++Af7LDnpBlZtxcM5bSpRC0i4e+5DsQMk=;
        b=SCLIZQVGWBvmM73pUCYbK7GVgRKm2EpN+0Pglu5ink8fTxpqFq04OCrm4rL5jzWR8v
         n9eS7JmMnG9V0bByXMa2mEx1VUNXFeGJFk4ZSXKXkQgH9FbbewlDsuJGR1mj5DZR1PFX
         CdcJQg6h2+6XHEn0blSmFU33mZ49umwkR0MbT6gp4OGI4EbKCMl1Dj7pQzRt0zL4CTHi
         ioeCC3YHHzUpVDPDcoCHumYCME1OnbvxeryGd1WfGFA4NW4fzgcVhR9NfbdNhHlvh5tK
         TBJGJfoMAlGVlEgJ2Ix9sqe0NKwACoT24JD508vDUWegW6DiT9Dps0ufx9LMjT79DKan
         ctCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KP04hHKJxj++Af7LDnpBlZtxcM5bSpRC0i4e+5DsQMk=;
        b=F005OvH4MmanIWzWuGEB1tWhGfZNsAM1ImK+efqaTzG+BW/O2cAO7hh5QiROnWv77+
         ek6XmugzyUYA7Ny/Vi47Q9vauD78QR36cz63e/Apqspa3mF7+f3QuJUdi79SCKaPOhMs
         SAU2m8LkhgQU7idDB2m8Os/4qe/ZW2OOXAEZ+trsdFGuOfHm3+JiOoHCaSZwZ9lEGkXb
         2fPw7tLqTuQQGxY9LfDNCxuzoaRjTATFcoT5WSfAr2Uq7/jpzmoIafk9kPFem6ZhHG+Y
         g5GKDEKh+XtBGJAQA3G88jPChqX5NXnwRoo4tQztx1PCjaAS0U2SEJ+IE5ZBJUu7XH27
         Luqw==
X-Gm-Message-State: AOAM532cOTM+YFDXHrVdGRCgxLGPelaGro0uzrXVHAv+wEcMFy8qZQGL
        Gh3dh4fd1D2xARmDpz83ShWOwccT94as7g==
X-Google-Smtp-Source: ABdhPJzFGoXUSW/x8T7T82pthX70aVL9NLyYE3uOEVxcDYmvfUzgp5xGcDO3W4QInlLR1ZNr7rhJ7Q==
X-Received: by 2002:a7b:cb18:: with SMTP id u24mr28878791wmj.67.1592984022834;
        Wed, 24 Jun 2020 00:33:42 -0700 (PDT)
Received: from [192.168.1.12] ([194.53.184.63])
        by smtp.gmail.com with ESMTPSA id 67sm26841371wrk.49.2020.06.24.00.33.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2020 00:33:42 -0700 (PDT)
Subject: Re: [PATCH bpf] bpf: fix formatting in documentation for BPF helpers
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
References: <20200623153935.6215-1-quentin@isovalent.com>
 <CAADnVQJwtac0C+DgAhQbVrofSwV7BeG7RoEdQAj5sQZGvxNeLA@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <c3819c00-23f2-a3c4-35ae-3de9b1d469ec@isovalent.com>
Date:   Wed, 24 Jun 2020 08:33:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQJwtac0C+DgAhQbVrofSwV7BeG7RoEdQAj5sQZGvxNeLA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-06-23 18:02 UTC-0700 ~ Alexei Starovoitov
<alexei.starovoitov@gmail.com>
> On Tue, Jun 23, 2020 at 8:39 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> When producing the bpf-helpers.7 man page from the documentation from
>> the BPF user space header file, rst2man complains:
>>
>>     <stdin>:2636: (ERROR/3) Unexpected indentation.
>>     <stdin>:2640: (WARNING/2) Block quote ends without a blank line; unexpected unindent.
>>
>> Let's fix formatting for the relevant chunk (item list in
>> bpf_ringbuf_query()'s description), and for a couple other functions.
>>
>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>> ---
>>  include/uapi/linux/bpf.h | 41 ++++++++++++++++++++--------------------
>>  1 file changed, 21 insertions(+), 20 deletions(-)
> 
> Applied to bpf tree and added similar fix to tools/include/.../bpf.h
> Please don't forget it next time.
> 

Right, sorry. Thank you for fixing it this time.
Quentin
