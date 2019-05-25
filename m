Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8FC92A3A1
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 11:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfEYJJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 05:09:19 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51579 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbfEYJJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 05:09:18 -0400
Received: by mail-wm1-f66.google.com with SMTP id f10so4124830wmb.1
        for <netdev@vger.kernel.org>; Sat, 25 May 2019 02:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=k/uq3QuHYJNZ9DfxUmqixLeELosy6Cl/suStGs9+peA=;
        b=JMZB+kZTa7DkZWF5rYFI3NSTTKsi63QvETkz2wndiIG3Cjivj4rAGQUDJuayoxYqpL
         N/Qo60TJr5Pet/fw/usNhJ/RANBWqGjFybVJtPGFIosq5KxI+syt4zErEjU8i0UrLUNl
         iHTR7kafvftMey83Cyi769OdIxwJ5RcM0AiguGoB6qy1lWGdnOiIhkQrrjpOGuB6GEYX
         jCu3ZRIzGWMjekzjt96Jpu5daOdgW40BBKLFQR96g8HmS9/fr6B8GidZ3bhTFzscth+e
         Ye94lOz0HqeF75epFlXyzKP+5dRKwopmom/xUMlNfweDSlkx+uBWdMCnGhMZFnIMpyYt
         Dnqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=k/uq3QuHYJNZ9DfxUmqixLeELosy6Cl/suStGs9+peA=;
        b=GZ5C7drA4vRCX+AbrdMtiRFoRdI82ONzfJ4EoXQ5zLpa9GzjjHddFnCLvH0h8G6mnZ
         hlTqIBjl7DxUK7rFgRKbsvClmX5ANYhxaX51ZW13gILqGTE54VzuuBod/XH8dM8UtbVc
         gXxQfBG7c27M9qHnNbZIXTtmWtu7NVmzBj6EGYGhAifGG3MlhkwXjPiPq4ML6zl9IHlp
         EhSuB3emd0XoIy2vBfbH1q9nstoWHaqJUgLjppOdWxh0uoTvJKS7+u1g3Oeu6ZQ9WIhN
         i4GY2hjJeaqRs//8qephgs/Bf3a22yK8vaJavZS7zMMS+bT77fBuGyPqCed7Dvvt+JQN
         BAzw==
X-Gm-Message-State: APjAAAVbp2mlxQRpT6D/wzkagaM6sZM1Xpo863MBM1LYeIuTv+l0ABi3
        bp6MYLZatcRwlfdDa6TgoSSN8g==
X-Google-Smtp-Source: APXvYqxpKo0suvuOJXTNl3G3D7blNjblMNcQUinzwZxqmHGf87wAUdNOQ+YNxUSVhi+FMomvjIarhg==
X-Received: by 2002:a7b:c549:: with SMTP id j9mr2726190wmk.122.1558775356841;
        Sat, 25 May 2019 02:09:16 -0700 (PDT)
Received: from LAPTOP-V3S7NLPL (cpc1-cmbg19-2-0-cust104.5-4.cable.virginm.net. [82.27.180.105])
        by smtp.gmail.com with ESMTPSA id l8sm3354097wrw.56.2019.05.25.02.09.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 25 May 2019 02:09:15 -0700 (PDT)
References: <1558736728-7229-1-git-send-email-jiong.wang@netronome.com> <20190525020736.gty5sdcu5jakffet@ast-mbp.dhcp.thefacebook.com>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Jiong Wang <jiong.wang@netronome.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiong Wang <jiong.wang@netronome.com>, daniel@iogearbox.net,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH v9 bpf-next 00/17] bpf: eliminate zero extensions for sub-register writes
In-reply-to: <20190525020736.gty5sdcu5jakffet@ast-mbp.dhcp.thefacebook.com>
Date:   Sat, 25 May 2019 10:09:13 +0100
Message-ID: <87zhnagati.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Alexei Starovoitov writes:

> On Fri, May 24, 2019 at 11:25:11PM +0100, Jiong Wang wrote:
>> v9:
>>   - Split patch 5 in v8.
>>     make bpf uapi header file sync a separate patch. (Alexei)
>
> 9th time's a charm? ;)

Yup :), it's all good things and helped us reaching a solution that fits
verifier's existing infra.

> Applied.
> Thanks a lot for all the hard work.
> It's a great milestone.

Thanks. And I guess the answer to the question:

  "Q: BPF 32-bit subregister requirements"

inside Documentation/bpf/bpf_design_QA.rst now could be updated to
mention LLVM and JIT back-ends 32-bit supports, will send out an update on
this.

> Please follow up with an optimization for bpf_patch_insn_data()
> to make it scaleable and undo that workaround in scale tests.

Sure, will do.

Regards,
Jiong

