Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1FF11B542D
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 07:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgDWF0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 01:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725854AbgDWF0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 01:26:21 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05555C03C1AB;
        Wed, 22 Apr 2020 22:26:21 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id w145so3706409lff.3;
        Wed, 22 Apr 2020 22:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HZGypiAvXpwjD5Q2ojrJPyy0IB2SYyL+rQLkQrvI4+A=;
        b=Xc2bAFYwUbwnrQ/fZ6rii4SBWT8XfWCPEQJl/s1Pra2dinQ0SOnkb/S21SgZHLtofM
         SnAto8I0sCfXVggPhM7iKYWsPG7aAhAnAXL8epREPx7J42I9M7b8NxhpzetbQp/E5pgv
         lkXwFhKKb3+E9BpVb8T1X+1FTwZzTdRYqlezvyirj7xCX95zNP77PmvWlYr+cNKCrZd8
         mNLmnCSoXitJiEy8zi32b/ZcXcQs1CGffk1gi/YRLa4j5v2WRRoDf2NeE7U/uOUtWYm3
         Avm/q2Ot7dK+hVja3vZyVHgR/VGfqczp3z+vLBGesjWLTIi/FW2vZEn8QKHWTubne7gt
         FY+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HZGypiAvXpwjD5Q2ojrJPyy0IB2SYyL+rQLkQrvI4+A=;
        b=cXEYc1OM+CdtPgtGJbDP2gAiY8Wx56zk8/9Dff7KKdlMgO9AMWf+bMVKVpGC8VOn3V
         7+/6utkBX1bYZCTT07dFOMfu1snIp6ZgkXZhgZktwNmczhGJVD4nrRQlX7UPWnsr2g4T
         fRq7mbcgyNsU5CodAq1oqrqPrF2oukVUTgsM5WP33lEP+z4yfKgTudwSdaoVDMqLP3q0
         F7ZCWxn6KSRwDSM87QERttDKwC4Ha15vWsA0ezjv8zr25Jc1i5Xv70rNN221rwKjsJVP
         yEEY6oUMDwEaJqNrD/Ffajm4c2WyvKlHzff9teQs68LkjZu3ER0nPbHKh0e4uOdnxAg6
         tFYA==
X-Gm-Message-State: AGi0PuYYDJWQJUtlDxl7pZvKhcMs83PsgXPLjEW0xyEa0JhFRtUp3NM+
        7600HxiizxKct567TO9kEGUydPNJp8duw90MqPM=
X-Google-Smtp-Source: APiQypIxC18qEaY7rABIM/eFT2v85fSBW4JAKPXFjDr07ymPgmNr9CAmnccMu7zTFKXbUE63BhGb4a8v9AbhP5cGmUo=
X-Received: by 2002:ac2:5235:: with SMTP id i21mr1249346lfl.73.1587619579477;
 Wed, 22 Apr 2020 22:26:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200420174610.77494-1-sdf@google.com>
In-Reply-To: <20200420174610.77494-1-sdf@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 22 Apr 2020 22:26:08 -0700
Message-ID: <CAADnVQKWJJRs1RDmx-RCSwGVhPJTxCQvPU3U-M79wGm-q_BPFA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: enable more helpers for BPF_PROG_TYPE_CGROUP_{DEVICE,SYSCTL,SOCKOPT}
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 10:46 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Currently the following prog types don't fall back to bpf_base_func_proto()
> (instead they have cgroup_base_func_proto which has a limited set of
> helpers from bpf_base_func_proto):
> * BPF_PROG_TYPE_CGROUP_DEVICE
> * BPF_PROG_TYPE_CGROUP_SYSCTL
> * BPF_PROG_TYPE_CGROUP_SOCKOPT
>
> I don't see any specific reason why we shouldn't use bpf_base_func_proto(),
> every other type of program (except bpf-lirc and, understandably, tracing)
> use it, so let's fall back to bpf_base_func_proto for those prog types
> as well.
>
> This basically boils down to adding access to the following helpers:
> * BPF_FUNC_get_prandom_u32
> * BPF_FUNC_get_smp_processor_id
> * BPF_FUNC_get_numa_node_id
> * BPF_FUNC_tail_call
> * BPF_FUNC_ktime_get_ns
> * BPF_FUNC_spin_lock (CAP_SYS_ADMIN)
> * BPF_FUNC_spin_unlock (CAP_SYS_ADMIN)
> * BPF_FUNC_jiffies64 (CAP_SYS_ADMIN)
>
> I've also added bpf_perf_event_output() because it's really handy for
> logging and debugging.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Thanks for the cleanup. Applied.
