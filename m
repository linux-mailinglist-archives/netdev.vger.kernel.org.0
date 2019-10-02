Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33B34C94AB
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbfJBXO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:14:56 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42864 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728461AbfJBXO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 19:14:56 -0400
Received: by mail-lj1-f195.google.com with SMTP id y23so580011lje.9
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 16:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=UgTt1s2t3sg0v6y3jPFKSo9NyBXHyysWlJIqH2+dS84=;
        b=qIcbNjpyVugWAKSNEz7Wb9fwaJn3yg3SKOMtpqYfKJBhxgMwLVl9KEhHvdMkMeTmoJ
         1oj63lrsvx88r7gusVdZs7zew6pUlHiDnoiV5ZMtRHoFC42fLgnIkU/oBWFulZ7q2agY
         4ceFiAPT2DPx981o/3pRdKiiF0L0sLU9fSAcdOdjY4+/KevJD/U8P21l7CSITAXb3I9x
         bzwlyo3BK+83/xDj7wdmLs04qzAUxisYTDtyrXwJVjOTVlkGn5CfX3F0RktGq7cR+5zy
         mH1urqt4dFX2YP2RbXaZcBLi19tnunwMzOkoqijq4UHuohCAGe8UGoAxug1SSTpERcFO
         0jlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=UgTt1s2t3sg0v6y3jPFKSo9NyBXHyysWlJIqH2+dS84=;
        b=EFND5aJlpu8U51ms0z+YJSAu1Uk0bhZKFSTOzjUjw9Y1UAdF1qmzW4Xr07uQE2Lh86
         aDoex4+22gxLel1oISp8q7xyXOkpProX1Mgcolpi88ErhM7tw0cJi8PY6wUMueYizgG6
         kCcdEj24ge3KAV9hZ77rbgBFdKHSLzxkDzl7XROMuQG1RmK/MZuoc+ZvQQdQZJdssir/
         qDabgh0JbaCJMW4JDucnzqKU5GRo2bj0YdEgwVOPToGnGEf5x7y5jcagY7vy2ipBRmU5
         WaIKMebgKr6XJgq8d3KL3RMqAxDad4XXr8YTseUSEW++Uib1WwLK6A1DdxLvT8lFSt6/
         lJpQ==
X-Gm-Message-State: APjAAAXkuHu0Oj+yNk8c0aSZQHhyvZcIWOxpeI10ZRH+pAX0DNtQgMMQ
        2WYQ/7FNWgvjxlA0ScLbvNetOA==
X-Google-Smtp-Source: APXvYqwrl1jb/dLjiJDvGTME5xFbdtNf2mo7y+7nzW/o8zCYP9/fQoQMwGsu/qM3/g7GeDw7w6EAVQ==
X-Received: by 2002:a2e:4296:: with SMTP id h22mr4098307ljf.208.1570058093003;
        Wed, 02 Oct 2019 16:14:53 -0700 (PDT)
Received: from khorivan (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id z18sm165026ljh.17.2019.10.02.16.14.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 02 Oct 2019 16:14:52 -0700 (PDT)
Date:   Thu, 3 Oct 2019 02:14:50 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf] samples/bpf: kbuild: add CONFIG_SAMPLE_BPF Kconfig
Message-ID: <20191002231448.GA10649@khorivan>
References: <20191001101429.24965-1-bjorn.topel@gmail.com>
 <CAK7LNATNw4Qysj1Q2dXd4PALfbtgMXPwgvmW=g0dRcrczGW-Fg@mail.gmail.com>
 <CAJ+HfNgvxornSfqnbAthNy6u6=-enGCdA8K1e6rLXhCzGgmONQ@mail.gmail.com>
 <CAK7LNATD4vCQnNsHXP8A2cyWDkCNX=LGh0ej-dkDajm-+Lfw8Q@mail.gmail.com>
 <CAJ+HfNgem7ijzQkz7BU-Z_A-CqWXY_uMF6_p0tGZ6eUMx_N3QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ+HfNgem7ijzQkz7BU-Z_A-CqWXY_uMF6_p0tGZ6eUMx_N3QQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 09:41:15AM +0200, Björn Töpel wrote:
>On Wed, 2 Oct 2019 at 03:49, Masahiro Yamada
><yamada.masahiro@socionext.com> wrote:
>>
>[...]
>> > Yes, the BPF samples require clang/LLVM with BPF support to build. Any
>> > suggestion on a good way to address this (missing tools), better than
>> > the warning above? After the commit 394053f4a4b3 ("kbuild: make single
>> > targets work more correctly"), it's no longer possible to build
>> > samples/bpf without support in the samples/Makefile.
>>
>>
>> You can with
>>
>> "make M=samples/bpf"
>>
>
>Oh, I didn't know that. Does M= support "output" builds (O=)?
>
>I usually just build samples/bpf/ with:
>
>  $ make V=1 O=/home/foo/build/bleh samples/bpf/
>
>
>Björn

Shouldn't README be updated?

-- 
Regards,
Ivan Khoronzhuk
