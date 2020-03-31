Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2B4119A20C
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 00:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731476AbgCaWor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 18:44:47 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46261 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbgCaWor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 18:44:47 -0400
Received: by mail-qk1-f194.google.com with SMTP id u4so24978441qkj.13;
        Tue, 31 Mar 2020 15:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/AU0lA6PkuOvFJOWA8GHKBdsC2ZkjBjZg3pc7o84R4Q=;
        b=trRWj+ISh59YDvidnlqJY/yn2YIDW24L1vB7wSm0EfLvy7lpWrGLtsa99jG2pQvOBt
         pr/hjs/5DQhbaXbu/eI2CCIgVEwZAZcDnXyK7pa6hT1V7M9fnrTNdGd9AuEr8+JkxETT
         1eM3Y8VRpYdaD5p86bKwABu+OfqzSCha0+o7xs9XHpOdIqlr2lTrOeY9vfbCXOD4tL9k
         eOM1gZHwP3nOOt1GnPh/IuTh4sBkauF1PU2gCvkOrR4H8wXPnTo1T5QfS10bql1E/Ntt
         lWuKW4HluvGpn3ZQhkauL9ZXPFru41YBAP73Vhd4i8ppvbSZXwT0OSyOhJkUGZiQJQ52
         FB/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/AU0lA6PkuOvFJOWA8GHKBdsC2ZkjBjZg3pc7o84R4Q=;
        b=VQu3aZ3V7DHvOr1EvFJ+QkvEPmvZjNHLQRLc8WNKwSCl+IO1BK6DF+v0stqyvfzdLP
         asw0zckwnclLELkOcZoprcDsPJ9V7SmVgnhEkfFvoU4cBJoY4MkdmZalez5VVFdLjMuq
         N2THBfJy3h86+63SAyr4Pi3EVA46FG5YCxfwiuyR7uCgKHxPWyohc7M0lJIr67vdhLeb
         JcPCXlnoYoR8wT2Yc7z7vxbYLQmzmb9XBxiYCf4+XrUSEl6Td9Vtzuz0i9BcUywyLcq4
         cM+XN8IiXAf08FwMEAPgWpGPBMOCXsLFGwWrnNjnqP2bvNZtMFsd2rz9At/iQl4LGFcC
         InYg==
X-Gm-Message-State: ANhLgQ3VmzBqLzQr06QUxNg7aEmV5E2ifYoz/V6uom7WLt60OFtpS0pu
        D25UwF+XDc5RLeItBcnV65o=
X-Google-Smtp-Source: ADFU+vtwUb/xk7oS4IPL0ItYDJtc1w04KvyjY57g2ACo4GCkeIRATUQt5eIk6F2VRc7xKrQ+ha8e/w==
X-Received: by 2002:a37:6d3:: with SMTP id 202mr7291136qkg.267.1585694685906;
        Tue, 31 Mar 2020 15:44:45 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:8cf:804:d878:6008? ([2601:282:803:7700:8cf:804:d878:6008])
        by smtp.googlemail.com with ESMTPSA id f14sm203284qtp.55.2020.03.31.15.44.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2020 15:44:45 -0700 (PDT)
Subject: Re: [PATCH v3 bpf-next 0/4] Add support for cgroup bpf_link
To:     Edward Cree <ecree@solarflare.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>, Kernel Team <kernel-team@fb.com>
References: <20200330030001.2312810-1-andriin@fb.com>
 <c9f52288-5ea8-a117-8a67-84ba48374d3a@gmail.com>
 <CAEf4BzZpCOCi1QfL0peBRjAOkXRwGEi_DAW4z34Mf3Tv_sbRFw@mail.gmail.com>
 <662788f9-0a53-72d4-2675-daec893b5b81@gmail.com>
 <CAADnVQK8oMZehQVt34=5zgN12VBc2940AWJJK2Ft0cbOi1jDhQ@mail.gmail.com>
 <cdd576be-8075-13a7-98ee-9bc9355a2437@gmail.com>
 <20200331003222.gdc2qb5rmopphdxl@ast-mbp>
 <58cea4c7-e832-2632-7f69-5502b06310b2@gmail.com>
 <CAEf4BzZSCdtSRw9mj2W5Vv3C-G6iZdMJsZ8WGon11mN3oBiguQ@mail.gmail.com>
 <869adb74-5192-563d-0e8a-9cb578b2a601@solarflare.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b5526d61-9af9-1f10-bf20-38cf8a2f10fd@gmail.com>
Date:   Tue, 31 Mar 2020 16:44:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <869adb74-5192-563d-0e8a-9cb578b2a601@solarflare.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/20 3:51 PM, Edward Cree wrote:
> On 31/03/2020 04:54, Andrii Nakryiko wrote:
>> No need to kill random processes, you can kill only those that hold
>> bpf_link FD. You can find them using drgn tool with script like [0].
> For the record, I find the argument "we don't need a query feature,
>  because you can just use a kernel debugger" *utterly* *horrifying*.
> Now, it seems to be moot, because Alexei has given other, better
>  reasons why query doesn't need to land yet; but can we please not
>  ever treat debugging interfaces as a substitute for proper APIs?
> 
> </scream>
> -ed
> 

just about to send the same intent. Dev packages and processing
/proc/kcore is not a proper observability API for production systems.
