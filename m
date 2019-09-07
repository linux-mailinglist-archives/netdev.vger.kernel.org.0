Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82B2EAC3DE
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 03:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406389AbfIGBYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 21:24:54 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43543 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405727AbfIGBYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 21:24:54 -0400
Received: by mail-lf1-f66.google.com with SMTP id q27so6453752lfo.10
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 18:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dEvfAeH1+QnRAS4bDZMCk0ZaJEhgzrd8FSpH8DNHr7E=;
        b=MPK8QXdTbmrBAjjf4ZxHzTHJNgns7GcUfyegDYCbyS6B8ThW2aVAkjLsLqoekGwCfA
         t+El/gWbEAPSx6CSSJ1brYPYAkrMoZgSzRCNqNZ6/jqzB5wtRDBiPOionCSBEg6dctHd
         DDX+Ia1Yazqrmzzaqy2ga8rYTrZKuYL9HROFN4FyP0emw4Lm7auvAqaqdivR3L/EHKRb
         yFr5GR8n/OdRDI+O6zBNpqXY96PQ+datAOuOAbZ6bu/nwFgDRipzEIbkowPnF+5EgKgT
         oID6Gxzqn5PZ/igaUV4yPnQ6LTloxPsEZBtbbld7MhwoalwsuF3IEPBu97VQBGmQ/HKM
         Ztog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=dEvfAeH1+QnRAS4bDZMCk0ZaJEhgzrd8FSpH8DNHr7E=;
        b=NTXIBw+Iu3DjriOotq2KchCC+mcdhX3TUPnrK4P8gOk0kiEc+cYSn87e+fSAMMZE0g
         ckQjKD/HQpeiZKpBH4EWZ+nAnsCsE+P9EzfiG0+KW2Pf9+qIy+1P495SadP+G+o4GMNi
         MPifVgDTi7VagW87L4r1X5yl+Z33UYXwF9RdycrBGPCJS//NrvlSlc8WMy66WvEKLqPJ
         Y0pkFOgv7w7Z4wUphijJVfz/a5dfR071cZmaKm/nAgx8l6SeHmUwBXs9P3MUNmxKKxjK
         fBGVWF1PYTLwgUtIgVVrq9W0RnB0EB/46lgzRAcOieVwfApU6NPxFqQvRPz2b1rGGmQK
         tEzw==
X-Gm-Message-State: APjAAAW9y+5XDtOvz7LpXK5WFyu9lMqOEpZe1XCpuhozP+HoYKa5sp0p
        cyhQ7z2qamejBWVi3rSwhBDAIQ==
X-Google-Smtp-Source: APXvYqxT2w9ujZ8nGy5dRXmD7sSvF34/U5b1u0zKlWMwjYrokQ4iRkdVNJJanv4Wj23s/ql1fMVGNg==
X-Received: by 2002:ac2:5451:: with SMTP id d17mr8094711lfn.77.1567819491989;
        Fri, 06 Sep 2019 18:24:51 -0700 (PDT)
Received: from khorivan (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id e21sm1413684lfj.10.2019.09.06.18.24.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 06 Sep 2019 18:24:51 -0700 (PDT)
Date:   Sat, 7 Sep 2019 04:24:49 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH bpf-next 8/8] samples: bpf: Makefile: base progs build on
 Makefile.progs
Message-ID: <20190907012448.GC3053@khorivan>
Mail-Followup-To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com
References: <20190904212212.13052-1-ivan.khoronzhuk@linaro.org>
 <20190904212212.13052-9-ivan.khoronzhuk@linaro.org>
 <20190906233429.6ass5x5inaypvbpr@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190906233429.6ass5x5inaypvbpr@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 06, 2019 at 04:34:31PM -0700, Alexei Starovoitov wrote:
>On Thu, Sep 05, 2019 at 12:22:12AM +0300, Ivan Khoronzhuk wrote:
>> +
>> +If need to use environment of target board, the SYSROOT also can be set,
>> +pointing on FS of target board:
>> +
>> +make samples/bpf/ LLC=~/git/llvm/build/bin/llc \
>> +     CLANG=~/git/llvm/build/bin/clang \
>> +     SYSROOT=~/some_sdk/linux-devkit/sysroots/aarch64-linux-gnu
>
>Patches 7 and 8 look quite heavy. I don't have a way to test them
>which makes me a bit uneasy to accept them as-is.
>Would be great if somebody could give Tested-by.
>
I can try to split patch 8 in v2, but not significantly.

-- 
Regards,
Ivan Khoronzhuk
