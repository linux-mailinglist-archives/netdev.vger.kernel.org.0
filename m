Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 387E6B782B
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 13:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388902AbfISLHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 07:07:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53636 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388719AbfISLHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 07:07:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1568891252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=akH4tA+8boh2Z3ENSsOS4nb9YnmpMGx/umkuL11b15A=;
        b=NxT3PXb7lvloacQa57fkf70iDgJmxYlRKHytbqtWpqp6mhYcBOeHX8bzJVbv8De28zGkm0
        Frp7QzVCVkxlgdWv8fHmCHEiTT2srjV0ScJLvDl0ClaHBS5R/R9LYEjFxAHVhq4beWRff+
        RMmoystyb0Gi8OxfKss/zi7Pliw0zHg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-xIsprDIyNaCK7eM6U7N4Cg-1; Thu, 19 Sep 2019 07:07:29 -0400
Received: by mail-wm1-f70.google.com with SMTP id r187so2695455wme.0
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 04:07:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MrXngNBkRSb78QhU35+OjWCZncslayQbSrEJYxPwRu8=;
        b=iNuXD0rqfBzufgsRtJK6QfHUyMB3+SMuxNwDy1xprIGTVZWH0nL8vPfWh9lJAYAfIR
         b4uSfGZaCW+KRzEL95UTmi4ne3x0xGyaiW58eMj55GE8f9ooBknZLOR92sTYzBqv9WeJ
         oPzTalIimy/YmT7UJNE2sm9dFo19nzoBG4ndjWIb6sCY/jKybq+ReefVXkEzo0uAyVBG
         cNWRd9ArYnV6FVyzCBB/LblSj4SF5vT4S2YeSnzdNyyxq4MY5lk+Wt/+/EH+wB9TgHg2
         0/vxIdewZRLfXmh1sV7jGvgUFRHoXxGMdndjU3Ke9twaHRLu9JZ1yreLFpM+MAmbjQmT
         d4GA==
X-Gm-Message-State: APjAAAWwxX6iNLEXMwsPSK3tOXyOXhHNt3jz8qaNeMQ9YNmbPoGAR6yG
        Y03fcT9tarheN7OIgWvbGsY2hNIysksBvaNXns9FIAsFbpuXnPDAlGYaPUYnu6g4QFRrQ96mM8e
        XEPwPvEYb+9lHIlV9
X-Received: by 2002:a5d:40d2:: with SMTP id b18mr6966171wrq.4.1568891247740;
        Thu, 19 Sep 2019 04:07:27 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwckM+/LSaoom2PwxEmBix+GsMstuwLeTRInJeFdhoBW3jpxwLH/cidatmfnMnCjGzYBzirCw==
X-Received: by 2002:a5d:40d2:: with SMTP id b18mr6966141wrq.4.1568891247420;
        Thu, 19 Sep 2019 04:07:27 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c46c:2acb:d8d2:21d8? ([2001:b07:6468:f312:c46c:2acb:d8d2:21d8])
        by smtp.gmail.com with ESMTPSA id b16sm14179405wrh.5.2019.09.19.04.07.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Sep 2019 04:07:26 -0700 (PDT)
Subject: Re: [RFC PATCH v3 4/6] psci: Add hvc call service for ptp_kvm.
To:     "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "Kaly Xin (Arm Technology China)" <Kaly.Xin@arm.com>,
        "Justin He (Arm Technology China)" <Justin.He@arm.com>,
        nd <nd@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <20190918080716.64242-1-jianyong.wu@arm.com>
 <20190918080716.64242-5-jianyong.wu@arm.com>
 <83ed7fac-277f-a31e-af37-8ec134f39d26@redhat.com>
 <HE1PR0801MB1676F57B317AE85E3B934B32F48E0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <629538ea-13fb-e666-8df6-8ad23f114755@redhat.com>
 <HE1PR0801MB167639E2F025998058A77F86F4890@HE1PR0801MB1676.eurprd08.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ef6ab8bd-41ad-88f8-9cfd-dc749ca65310@redhat.com>
Date:   Thu, 19 Sep 2019 13:07:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <HE1PR0801MB167639E2F025998058A77F86F4890@HE1PR0801MB1676.eurprd08.prod.outlook.com>
Content-Language: en-US
X-MC-Unique: xIsprDIyNaCK7eM6U7N4Cg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/09/19 11:46, Jianyong Wu (Arm Technology China) wrote:
>> On 18/09/19 11:57, Jianyong Wu (Arm Technology China) wrote:
>>> Paolo Bonzini wrote:
>>>> This is not Y2038-safe.  Please use ktime_get_real_ts64 instead, and
>>>> split the 64-bit seconds value between val[0] and val[1].
>
> Val[] should be long not u32 I think, so in arm64 I can avoid that Y2038_=
safe, but
> also need rewrite for arm32.

I don't think there's anything inherently wrong with u32 val[], and as
you notice it lets you reuse code between arm and arm64.  It's up to you
and Marc to decide.

>>>> However, it seems to me that the new function is not needed and you
>>>> can just use ktime_get_snapshot.  You'll get the time in
>>>> systime_snapshot->real and the cycles value in systime_snapshot->cycle=
s.
>>>
>>> See patch 5/6, I need both counter cycle and clocksource,
>> ktime_get_snapshot seems only offer cycles.
>>
>> No, patch 5/6 only needs the current clock (ptp_sc.cycles is never acces=
sed).
>> So you could just use READ_ONCE(tk->tkr_mono.clock).
>>
> Yeah, patch 5/6 just need clocksource, but I think tk->tkr_mono.clock can=
't read in external like module,
> So I need an API to expose clocksource.
> =20
>> However, even then I don't think it is correct to use ptp_sc.cs blindly =
in patch
>> 5.  I think there is a misunderstanding on the meaning of
>> system_counterval.cs as passed to get_device_system_crosststamp.
>> system_counterval.cs is not the active clocksource; it's the clocksource=
 on
>> which system_counterval.cycles is based.
>>
>=20
> I think we can use system_counterval_t as pass current clocksource to sys=
tem_counterval_t.cs and its
> corresponding cycles to system_counterval_t.cycles. is it a big problem?

Yes, it is.  Because...

>> Hypothetically, the clocksource could be one for which ptp_sc.cycles is =
_not_
>> a cycle value.  If you set system_counterval.cs to the system clocksourc=
e,
>> get_device_system_crosststamp will return a bogus value.
>=20
> Yeah, but in patch 3/6, we have a corresponding pair of clock source and =
cycle value. So I think there will be no
> that problem in this patch set.
> In the implementation of get_device_system_crosststamp:
> "
> ...
> if (tk->tkr_mono.clock !=3D system_counterval.cs)
>                         return -ENODEV;
> ...
> "
> We need tk->tkr_mono.clock passed to get_device_system_crosststamp, just =
like patch 3/6 do, otherwise will return error.

... if the hypercall returns an architectural timer value, you must not
pass tk->tkr.mono.clock to get_device_system_crosststamp: you must pass
&clocksource_counter.  This way, PTP is disabled when using any other
clocksource.

>> So system_counterval.cs should be set to something like
>> &clocksource_counter (from drivers/clocksource/arm_arch_timer.c).
>> Perhaps the right place to define kvm_arch_ptp_get_clock_fn is in that f=
ile?
>>
> I have checked that ptp_sc.cs is arch_sys_counter.
> Also move the module API to arm_arch_timer.c will looks a little
> ugly and it's not easy to be accept by arm side I think.

I don't think it's ugly but more important, using tk->tkr_mono.clock is
incorrect.  See how the x86 code hardcodes &kvm_clock, it's the same for
ARM.

>> You also have to check here that the clocksource is based on the ARM
>> architectural timer.  Again, maybe you could place the implementation in
>> drivers/clocksource/arm_arch_timer.c, and make it return -ENODEV if the
>> active clocksource is not clocksource_counter.  Then KVM can look for er=
rors
>> and return SMCCC_RET_NOT_SUPPORTED in that case.
>=20
> I have checked it. The clock source is arch_sys_counter which is arm arch=
 timer.
> I can try to do that but I'm not sure arm side will be happy for that cha=
nge.

Just try.  For my taste, it's nice to include both sides of the
hypercall in drivers/clocksource/arm_arch_timer.c, possibly
conditionalizing them on #ifdef CONFIG_KVM and #ifdef
CONFIG_PTP_1588_CLOCK_KVM.  But there is an alternative which is simply
to export the clocksource struct.  Both choices are easy to implement so
you can just ask the ARM people what they prefer and they can judge from
the code.

Paolo

