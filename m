Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB1B8D9CB
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730699AbfHNRMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:12:16 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32853 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730687AbfHNRMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:12:14 -0400
Received: by mail-wr1-f65.google.com with SMTP id u16so791776wrr.0
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 10:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H/7OTBw8lTwy+HIM6EDci779JsAp+znpSI/Ol/n6Ldw=;
        b=1ac/G3pFcjTSbRZhXklSnossjnkouLlX+R6jl2IOyCpbtQkWYFuhsoDPZ79BNLhLoy
         BOaWrrECjscnt4WGUqZ+osS+AzmDKdMhCY/tTFDToUulG5jEMSOKbfpD+zG8E0Tvy6GA
         4u1bQIqiK4DIBLBTBKOlAeryeqKnUpBOPPdyYxk43US3kC/j9bjP0Rmcv7RluldriiJD
         fy2aw+Ou2oNgVVBf/VbYjJxcFkebSQcPOn9OOH659QioEjOQ7Lnhibn3+v6bUoQqKDv5
         TyuPO72qmyrw6BwqB+7ba4YjfhkWA1ZpzAkBo3VZnoAHJEQp6moei2QtijjMjcAgxeu1
         paMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=H/7OTBw8lTwy+HIM6EDci779JsAp+znpSI/Ol/n6Ldw=;
        b=OGqDg6UKwXTM9V2gPe55j/qcnPY0hqBwUa2mM3/sAO5nOQy5VAYMvT0lsuJ3d0iVS3
         mMlLVCynXwHm0/pbOuqulD0Goy7QhTWgWQwCiHEhSeblfH6QOgK3GafzJGL2ISZjXjJU
         +/+d021nCkJypNAr3RijeWbnfdRXuU1M2AMQYCyHY+2sCDfQ1pT/j2hCdItGMJy/Bglg
         kb1CJ1YiLC7QRJBuenLcFih4OtuVz2GKmFotJ+pt2DBDHLm7zoEKoVRsF5nAn5FWEw1C
         0BKcWrd1uq4tI5LOjnD1pV/lxQf05x2yZ1puj7BCetut3IdjSwrzMkjwIeS83rnd6qFB
         MGnA==
X-Gm-Message-State: APjAAAVizSNxq//863+elTo9EuinmBbPJ0hEjhLQhp8OPXJuGxg1fDa4
        BHw2f+Xz5/cG/f2nholzcm7ATg==
X-Google-Smtp-Source: APXvYqwEFjPlrxYI+r8fxW7h1gA/0RqfETVM1m7b5FwNGF18U/0ucUpUMmJBYhrEBgJ+YfHGcjVBvQ==
X-Received: by 2002:adf:efd2:: with SMTP id i18mr794306wrp.145.1565802732448;
        Wed, 14 Aug 2019 10:12:12 -0700 (PDT)
Received: from [172.20.1.254] ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id q3sm210670wma.48.2019.08.14.10.12.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 10:12:11 -0700 (PDT)
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Edward Cree <ecree@solarflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
References: <20190813130921.10704-1-quentin.monnet@netronome.com>
 <20190814015149.b4pmubo3s4ou5yek@ast-mbp>
 <ab11a9f2-0fbd-d35f-fee1-784554a2705a@netronome.com>
 <bdb4b47b-25fa-eb96-aa8d-dd4f4b012277@solarflare.com>
 <CAADnVQJE2DCU0J2_d4Z-1cmXZsb_q2FODcbC1S24C0f=_b2ffg@mail.gmail.com>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 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
 RHhSHGnKaQ6MfrTge5Q0h5A=
Subject: Re: [RFC bpf-next 0/3] tools: bpftool: add subcommand to count map
 entries
Message-ID: <bec14521-dec1-5e1b-2f29-5c0492500272@netronome.com>
Date:   Wed, 14 Aug 2019 18:12:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQJE2DCU0J2_d4Z-1cmXZsb_q2FODcbC1S24C0f=_b2ffg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-08-14 09:58 UTC-0700 ~ Alexei Starovoitov
<alexei.starovoitov@gmail.com>
> On Wed, Aug 14, 2019 at 9:45 AM Edward Cree <ecree@solarflare.com> wrote:
>>
>> On 14/08/2019 10:42, Quentin Monnet wrote:
>>> 2019-08-13 18:51 UTC-0700 ~ Alexei Starovoitov
>>> <alexei.starovoitov@gmail.com>
>>>> The same can be achieved by 'bpftool map dump|grep key|wc -l', no?
>>> To some extent (with subtleties for some other map types); and we use a
>>> similar command line as a workaround for now. But because of the rate of
>>> inserts/deletes in the map, the process often reports a number higher
>>> than the max number of entries (we observed up to ~750k when max_entries
>>> is 500k), even is the map is only half-full on average during the count.
>>> On the worst case (though not frequent), an entry is deleted just before
>>> we get the next key from it, and iteration starts all over again. This
>>> is not reliable to determine how much space is left in the map.
>>>
>>> I cannot see a solution that would provide a more accurate count from
>>> user space, when the map is under pressure?
>> This might be a really dumb suggestion, but: you're wanting to collect a
>>  summary statistic over an in-kernel data structure in a single syscall,
>>  because making a series of syscalls to examine every entry is slow and
>>  racy.  Isn't that exactly a job for an in-kernel virtual machine, and
>>  could you not supply an eBPF program which the kernel runs on each entry
>>  in the map, thus supporting people who want to calculate something else
>>  (mean, min and max, whatever) instead of count?
> 
> Pretty much my suggestion as well :)
> 
> It seems the better fix for your nat threshold is to keep count of
> elements in the map in a separate global variable that
> bpf program manually increments and decrements.
> bpftool will dump it just as regular map of single element.
> (I believe it doesn't recognize global variables properly yet)
> and BTF will be there to pick exactly that 'count' variable.
> 

It would be with an offloaded map, but yes, I suppose we could keep
track of the numbers in a separate map. We'll have a look into this.

Thanks to both of you for the suggestions.
Quentin
