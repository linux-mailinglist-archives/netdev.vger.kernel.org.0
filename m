Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 618B76AFFE
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 21:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388753AbfGPTjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 15:39:18 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46400 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388736AbfGPTjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 15:39:18 -0400
Received: by mail-wr1-f67.google.com with SMTP id z1so22166294wru.13
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 12:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=JHtxnd2ZQ2lAM7CnK9XNjS6v40V+5VTZiu9B1CLj1tA=;
        b=NVvHJoi1C9uJRcGmD4UqeWkCV6DJTrAzosFvpyWt/gV4Um0uIIOrVqOxH8S7ksO0dj
         PSF9yV8Wx0weepHVA/zjwEAGGjXeiNQULJSvQUP+Lw5rpwlLke7jTS7F9U56IiSjh9dC
         Xr6K1StUMs1HpWHcDjmuLcG90Y4/hugS+NSjnsVRr5+SvyfVU+o7HmOAr0tGIHiQMkga
         OFTl0Xp37AgptL4k4d1BoIEFhD4x7CKBF9zR0c88ZbLqpq4jgoGIAQNLfbPTvZuVr+l5
         Qfln76ptJa6o/8hluZTr3fIANPoouMmjAJm7k2y3xIamK3WJuU9bZANNv2fpTwB7/Af1
         ZHfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=JHtxnd2ZQ2lAM7CnK9XNjS6v40V+5VTZiu9B1CLj1tA=;
        b=Gyehlra1Gg/0oBri4uES3nglZk8NWz9jaIFedR8O73C/372TxqK1Tl1+d1usUwhLEq
         ChoW2cgIWaPLfxSYkeEEQZBu335yIEjwMXKtwyK6k5GhvvJsB522LdqF3bkZzJtICW6Y
         4hdOBcHDn87C9JAPMxflVvQHUsugg/ryTKBEzUiZnMooNZjJtUo7Rd+1ohsiD5zzUS3J
         5LLzPoOG23l8W4I2RbRyCwWrMvVk8k1/3pKCg3jTl4ieKUmwy8P8k2k6tKw44O7CPk+9
         gRh5i9UImiPwI1Y6fIs2zn5iWQ/f4/3O96nf59UVNwMCvPej5RpgI91CHJIWI8Fy/4DJ
         D73w==
X-Gm-Message-State: APjAAAU+pNFnKqrWe1Fiw4GGerLIDUAgalvWFRWNbb0mYrknOTksLfC0
        Y1zqUJAuA6qIS4lwhzTHOl2zWA==
X-Google-Smtp-Source: APXvYqwIJLpj3UhsiDrDdZsgIlTEC3VxF2dRe3d4BQnbnZcUc2bPEBgKHCtfZ0ZbfiZtJRWTgyApzw==
X-Received: by 2002:adf:b64b:: with SMTP id i11mr37324159wre.205.1563305956022;
        Tue, 16 Jul 2019 12:39:16 -0700 (PDT)
Received: from LAPTOP-V3S7NLPL (cpc1-cmbg19-2-0-cust104.5-4.cable.virginm.net. [82.27.180.105])
        by smtp.gmail.com with ESMTPSA id t3sm14150205wmi.6.2019.07.16.12.39.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Jul 2019 12:39:14 -0700 (PDT)
References: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com> <CAEf4BzavePpW-C+zORN1kwSUJAWuJ3LxZ6QGxqaE9msxCq8ZLA@mail.gmail.com> <87r26w24v4.fsf@netronome.com> <CAEf4BzaPFbYKUQzu7VoRd7idrqPDMEFF=UEmT2pGf+Lxz06+sA@mail.gmail.com> <87k1cj3b69.fsf@netronome.com> <CAEf4BzYDAVUgajz4=dRTu5xQDddp5pi2s=T1BdFmRLZjOwGypQ@mail.gmail.com> <87wogitlbi.fsf@netronome.com> <20190716161701.mk5ye47aj2slkdjp@ast-mbp.dhcp.thefacebook.com>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Jiong Wang <jiong.wang@netronome.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiong Wang <jiong.wang@netronome.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Edward Cree <ecree@solarflare.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        oss-drivers@netronome.com, Yonghong Song <yhs@fb.com>
Subject: Re: [RFC bpf-next 0/8] bpf: accelerate insn patching speed
In-reply-to: <20190716161701.mk5ye47aj2slkdjp@ast-mbp.dhcp.thefacebook.com>
Date:   Tue, 16 Jul 2019 20:39:11 +0100
Message-ID: <871rypdb1c.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Alexei Starovoitov writes:

> On Tue, Jul 16, 2019 at 09:50:25AM +0100, Jiong Wang wrote:
>> 
>> Let me digest a little bit and do some coding, then I will come back. Some
>> issues can only shown up during in-depth coding. I kind of feel handling
>> aux reference in verifier layer is the part that will still introduce some
>> un-clean code.
>
> I'm still internalizing this discussion. Only want to point out
> that I think it's better to have simpler algorithm that consumes more
> memory and slower than more complex algorithm that is more cpu/memory efficient.
> Here we're aiming at 10x improvement anyway, so extra cpu and memory
> here and there are good trade-off to make.
>
>> >> If there is no dead insn elimination opt, then we could just adjust
>> >> offsets. When there is insn deleting, I feel the logic becomes more
>> >> complex. One subprog could be completely deleted or partially deleted, so
>> >> I feel just recalculate the whole subprog info as a side-product is
>> >> much simpler.
>> >
>> > What's the situation where entirety of subprog can be deleted?
>> 
>> Suppose you have conditional jmp_imm, true path calls one subprog, false
>> path calls the other. If insn walker later found it is also true, then the
>> subprog at false path won't be marked as "seen", so it is entirely deleted.
>> 
>> I actually thought it is in theory one subprog could be deleted entirely,
>> so if we support insn deletion inside verifier, then range info like
>> line_info/subprog_info needs to consider one range is deleted.
>
> I don't think dead code elim can remove subprogs.
> cfg check rejects code with dead progs.

cfg check rejects unreachable code based on static analysis while one
subprog passed cfg check could be identified as dead later after runtime
value tracking, after check_cond_jmp_op pruning subprog call in false
path and making the subprog dead?

For example:

  static subprog1()
  static subprog2()
  
  foo(int mask)
  {
    if (mask & 0x1)
      subprog1();
    else
      subprog2();
    ...
  }

foo's incoming arg is a mask, and depending on whether the LSB is set, it
calls different init functions, subprog1 or subprog2.

foo might be called with a constant as mask, for example 0x8000. Then if
foo is not called by someone else, subprog1 is dead if there is no other
caller of it.

LLVM is smart enough to optimize out such dead functions if they are only
visible in the same compilation unit, and people might only write code in
such shape when they are encapsulated in a lib. but if case like above is
true, I think it is possible one subprog could be deleted by verifier
entirely.

> I don't think we have a test for such 'dead prog only due to verifier walk'
> situation. I wonder what happens :)

