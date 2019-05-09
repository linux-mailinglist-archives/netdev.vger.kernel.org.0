Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFEAF18F2B
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 19:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfEIRbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 13:31:09 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52801 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbfEIRbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 13:31:09 -0400
Received: by mail-wm1-f68.google.com with SMTP id g26so2358603wmh.2
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 10:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=Crhk9lcEiYLiah6PZ+aUx1I7QMePtrTkjU5HwUJdRe4=;
        b=RbLgxNTndfEdtJq/JKfG3xLgs38HGCAyqU3PSwyz+oOwdAAcySUrCSOaARtpMylKT2
         JIEWcHLpwJ7bFDruKE9WaKHnRsa7O2hhmtHc5ICxd0igomPgSB7StLYT4L7tZtvZnl5o
         PCmR9INEeCXN3+flYzjsJAXXY0kQbISUKR6XSm6rPwnb68w5cbQVNR+PBl1di1dlF8KK
         EzwbppKgkGwcisOb+lw/6hbr49kNtQafEpOs6fy+m+JbQo8Owvl4ZSMpQBvWSOCkVWy1
         wNY+fzQXZ4ZMdSXLrBKw+t3KrPO8wh+bIJH35QzyBmTHRuMjW3AeCXUh/0OYKTdX3NwP
         SWKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=Crhk9lcEiYLiah6PZ+aUx1I7QMePtrTkjU5HwUJdRe4=;
        b=gt4a2anuEYS40Wsg0SrDqwjk4+yNxL1dZoK/HC0MT6pqazcPF3C6oNsIF2FseAggpI
         iAnQpEMn0qTj4x7RQgFx6BeaSPdMaFN8ZcLQ2ImAWv/ze2CqHr+dzImyve/0Fqgp+8ft
         C9GRGOGXg4BwXOFt8qkc4gqxElKIMKLrucmWVGALnJAdlT1bOHzhAz0jfuKOVexMMHO/
         OCC5jtPca9vl1LtdQrU9EcUPGPPPXOAa+qD6OkFc/IcTSBSqPsrtFfLdOZHdixXJ7KQW
         7ZT6PZ4CLk6kxebGaZuxqu6+OL0MzWVOTeAn7Olx/rjMrl8dbR/6KkewLy4eO1Iftsfc
         P2Hg==
X-Gm-Message-State: APjAAAVQ/wSHVj5vN7bU4/+js//JnXbCs40Zwmi7Rn/CKaqy9kZOcVp7
        V95hqdQ4xphtvKMv3usmv8Pvqg==
X-Google-Smtp-Source: APXvYqwk6LbYk2adh0taZ4rOV2wKkSH1dyL+zGYUThe1eOD7Wggnz8ZSDdldWIfkbJxVLEyxcH4jpg==
X-Received: by 2002:a1c:ef0c:: with SMTP id n12mr445593wmh.110.1557423067566;
        Thu, 09 May 2019 10:31:07 -0700 (PDT)
Received: from LAPTOP-V3S7NLPL (cpc1-cmbg19-2-0-cust104.5-4.cable.virginm.net. [82.27.180.105])
        by smtp.gmail.com with ESMTPSA id w7sm3696145wmm.16.2019.05.09.10.31.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 09 May 2019 10:31:06 -0700 (PDT)
References: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com> <1556880164-10689-2-git-send-email-jiong.wang@netronome.com> <20190506155041.ofxsvozqza6xrjep@ast-mbp> <87mujx6m4n.fsf@netronome.com> <20190508175111.hcbufw22mbksbpca@ast-mbp> <87ef5795b5.fsf@netronome.com>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Jiong Wang <jiong.wang@netronome.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     daniel@iogearbox.net, bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com
Subject: Re: [PATCH v6 bpf-next 01/17] bpf: verifier: offer more accurate helper function arg and return type
In-reply-to: <87ef5795b5.fsf@netronome.com>
Date:   Thu, 09 May 2019 18:31:04 +0100
Message-ID: <87v9yjk013.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jiong Wang writes:

<snip>

> At the moment we have single backend hook "bpf_jit_hardware_zext", once a
> backend enable it, verifier just insert zero extension for all identified
> alu32 and narrow loads.
>
> Given verifier analysis info is not pushed down to JIT back-ends, verifier
> needs more back-end info pushed up from back-ends. Do you think make sense
> to introduce another hook "bpf_jit_hardware_zext_narrow_load"

Maybe just keep the current "bpf_jit_hardware_zext", but let it return
int/enum instead of bool. Then verifier could know hardware ability through
the enum value?


> to at least
> prevent unnecessary zext inserted for narrowed loads for arches like
> PowerPC, SPARC?
>
> The hooks to control verifier zext insertion then becomes two:
>
>   bpf_jit_hardware_zext_alu32
>   bpf_jit_hardware_zext_narrow_load
>
>>> And that why I introduce these new argument types, without them, there
>>> could be more than 10% extra zext inserted on benchmarks like bpf_lxc.
>>
>> 10% extra ? so be it.
>> We're talking past each other here.
>> I agree with your optimization goal, but I think you're missing
>> the safety concerns I'm trying to explain.
>>> But for helper functions, they are done by native code which may not follow
>>> this convention. For example, on arm32, calling helper functions are just
>>> jump to and execute native code. And if the helper returns u32, it just set
>>> r0, no clearing of r1 which is the high 32-bit in the register pair
>>> modeling eBPF R0.
>>
>> it's arm32 bug then. All helpers _must_ return 64-bit back to bpf prog
>> and _must_ accept 64-bit from bpf prog.

