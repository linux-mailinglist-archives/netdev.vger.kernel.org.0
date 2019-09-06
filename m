Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E04CAC322
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 01:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405574AbfIFXee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 19:34:34 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41373 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732131AbfIFXed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 19:34:33 -0400
Received: by mail-pl1-f193.google.com with SMTP id m9so3903101pls.8;
        Fri, 06 Sep 2019 16:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PQUdTfmTeC9Eu7doYDquPbP6FsNUDihOtUoLPN2jFQs=;
        b=Jxbb5ZVG7jP+a/W/8elEjctYdBRym3CI0km54IzX4iNoSTW8R0gajhivVCAA2h/W4C
         +nNDOBL8J0WRZUAVDKW6wbkPZc5cMNdIdaB8hcbLPlqGsRNWY/2ph/SdLMZVyrzkTqmV
         MMcjsfmCI8mCjP2XPA4hssvcL9CtonsjXftQPKSh1KODs2H2yZ0loftjvjgv2T97rjzy
         FyaxmxFLm2VhCF1cx0MZbTON6yRUcIw9lvq1MdNAZcri5xzuAvhu1PWTtiKnOVm2FwTr
         XSbJQ2s0idVaqRdytSzSvVQX55B+bQ5rtmnswZEbZ2snTiuY9Fawe+I/UHsgb/BGOEAZ
         e/TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PQUdTfmTeC9Eu7doYDquPbP6FsNUDihOtUoLPN2jFQs=;
        b=o3aTAg5x8NUmVbiQdKP5DUp+2BpJRqBK8KfSoO7+RxID61QI4RmOfXYKq2XVI/p4E3
         AMW2NtnvKGq2BRX34k46MK6xhVsPeXifvOuBni/eXSdSiKB/2RjgiZPm94bi4GZBXb4y
         XplIkeMIHCynog0M2IF8lCUGOLJ32Ykpk6oyqkSolfrC+vUwsWMdGos5r0YqPNG1fAQ2
         jSidH/nNuIQSPkZqN2uHJ5DQYHKo/aA8I7Ue/MX8r5Kmz9pWDBh9/yTPC2XvWSZwqwFx
         UhgQQwu38iTCpYmdrS3Xh5PA2zyki9C4O2kiV/R+Sf8pxy/d2Zv12gu9LXZc5oTWB6lI
         bcuA==
X-Gm-Message-State: APjAAAW4JxbSMWscR5BSzBdCOqo9P0X5yWX7vwzuBPREOwyvMaSY0ezj
        w3Rgkci09bpeTMvghr5hGdk=
X-Google-Smtp-Source: APXvYqxcrUHaLye4oY121rlnSfsMiKK0a+zcamioe5WufmKggdtyjpal0qn6qBkvcwYJ7kQ+H9vC6A==
X-Received: by 2002:a17:902:d702:: with SMTP id w2mr6804221ply.321.1567812872968;
        Fri, 06 Sep 2019 16:34:32 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::3:46a4])
        by smtp.gmail.com with ESMTPSA id o67sm6610359pfb.39.2019.09.06.16.34.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 16:34:32 -0700 (PDT)
Date:   Fri, 6 Sep 2019 16:34:31 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH bpf-next 8/8] samples: bpf: Makefile: base progs build on
 Makefile.progs
Message-ID: <20190906233429.6ass5x5inaypvbpr@ast-mbp.dhcp.thefacebook.com>
References: <20190904212212.13052-1-ivan.khoronzhuk@linaro.org>
 <20190904212212.13052-9-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904212212.13052-9-ivan.khoronzhuk@linaro.org>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 05, 2019 at 12:22:12AM +0300, Ivan Khoronzhuk wrote:
> +
> +If need to use environment of target board, the SYSROOT also can be set,
> +pointing on FS of target board:
> +
> +make samples/bpf/ LLC=~/git/llvm/build/bin/llc \
> +     CLANG=~/git/llvm/build/bin/clang \
> +     SYSROOT=~/some_sdk/linux-devkit/sysroots/aarch64-linux-gnu

Patches 7 and 8 look quite heavy. I don't have a way to test them
which makes me a bit uneasy to accept them as-is.
Would be great if somebody could give Tested-by.

