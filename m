Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F5B38BB20
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 02:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235779AbhEUBAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 21:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235596AbhEUBAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 21:00:31 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F1AC061574;
        Thu, 20 May 2021 17:59:08 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id f19-20020a05600c1553b02901794fafcfefso5785933wmg.2;
        Thu, 20 May 2021 17:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=81twvJtD4IdoBkhuE/rquKU5rdFlaCgjOtn16ICABe8=;
        b=k8c0yx+hPiXp4RpSnCuJIQ0kDx9K5lKjNiQIZnPacZ9XwlVTOseeZqrX/86a+ZfT6C
         cGZOSQpl7AjaGEvDJHV17uAUprUsH670W6k6XWMHrb6AmjBGKsTbaOizTK4L7fubxPfG
         eb8+fpNh95QaL1721lcFE7FJvyR7bw4ujmvCr6GTSah7HtGNw8WQEKrk2yGDaCkoFjJz
         ZM3/axh2ZNth1ibS8meC2axCtMiWBBHkLgNitpI5FdCUBJtEWw7WaZUlyfThq3UGkQgP
         N7Ihwf9+0Hk7EJC01COYXNx1faSUDbidylqgTtPw5vS8g5rTaSmGa4heWTvFyH4izOSW
         +ryQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=81twvJtD4IdoBkhuE/rquKU5rdFlaCgjOtn16ICABe8=;
        b=S/sS4piBTsvBCRI5INChzauMMijEqBIiAt/holXZjaifZQbotI1BFYP5DSU9xrcUvZ
         f08mQO0/+PXZ/P595i5wUj401lDVkx1ImC9yPbqnJbu1pwxEeyr/Y2O5Z176Vu19lMxc
         QqUCafULcFHnOtMWvNlOqSYeY+G0Fm54bAsUGwjwZJlNGc0Td6gdic7n9BHh7tTtpurL
         FLJ6GaeUeSSuRvbjqfMiyEuMPD/CG07OkWMVZK7GLU5KAgxDQhrLa3X07qXlDyFRageW
         5xFUIvEwTjt8hKQFHsuaerxQtNd/8AZJPY4+L6+eN5exUdBk2kmwoNiVC3LFtR6ptqet
         pzzA==
X-Gm-Message-State: AOAM530n2tAF/5Stq9DGQ76ymY2QJ3GDQTSgKa+tYtFzgJk3HW1Wr7Dr
        PiLG/1VeLokQGKWLGj/mEbE=
X-Google-Smtp-Source: ABdhPJzWzmTs5nBvHSB1jgReCMUyK4MWcPlVurAyiqEDO2p1iccOK2DvcrwaVNLlyvTT2p2BWetC3A==
X-Received: by 2002:a05:600c:4f0f:: with SMTP id l15mr6253608wmq.143.1621558747505;
        Thu, 20 May 2021 17:59:07 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.236.182])
        by smtp.gmail.com with ESMTPSA id i1sm4225081wmb.46.2021.05.20.17.59.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 17:59:07 -0700 (PDT)
Subject: Re: [RFC v2 00/23] io_uring BPF requests
To:     Song Liu <songliubraving@fb.com>
Cc:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>,
        Christian Dietrich <stettberger@dokucode.de>
References: <cover.1621424513.git.asml.silence@gmail.com>
 <0A3E3601-76CC-4196-8246-CCAEB8C8AED3@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <a83f147b-ea9d-e693-a2e9-c6ce16659749@gmail.com>
Date:   Fri, 21 May 2021 01:58:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <0A3E3601-76CC-4196-8246-CCAEB8C8AED3@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/21/21 1:35 AM, Song Liu wrote:
>> On May 19, 2021, at 7:13 AM, Pavel Begunkov <asml.silence@gmail.com> wrote:
>> The main problem solved is feeding completion information of other
>> requests in a form of CQEs back into BPF. I decided to wire up support
>> for multiple completion queues (aka CQs) and give BPF programs access to
>> them, so leaving userspace in control over synchronisation that should
>> be much more flexible that the link-based approach.
>>
>> For instance, there can be a separate CQ for each BPF program, so no
>> extra sync is needed, and communication can be done by submitting a
>> request targeting a neighboring CQ or submitting a CQE there directly
>> (see test3 below). CQ is choosen by sqe->cq_idx, so everyone can
>> cross-fire if willing.
>>
> 
> [...]
> 
>>  bpf: add IOURING program type
>>  io_uring: implement bpf prog registration
>>  io_uring: add support for bpf requests
>>  io_uring: enable BPF to submit SQEs
>>  io_uring: enable bpf to submit CQEs
>>  io_uring: enable bpf to reap CQEs
>>  libbpf: support io_uring
>>  io_uring: pass user_data to bpf executor
>>  bpf: Add bpf_copy_to_user() helper
>>  io_uring: wire bpf copy to user
>>  io_uring: don't wait on CQ exclusively
>>  io_uring: enable bpf reqs to wait for CQs
> 
> Besides the a few comments, these BPF related patches look sane to me. 
> Please consider add some selftests (tools/testing/selftests/bpf). 

The comments are noted. Thanks Song

-- 
Pavel Begunkov
