Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDC6F3659
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 18:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389902AbfKGRzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 12:55:11 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43498 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730510AbfKGRzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 12:55:10 -0500
Received: by mail-lf1-f68.google.com with SMTP id j5so2268589lfh.10;
        Thu, 07 Nov 2019 09:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=prR1UZMSOAIrk4Kkrqgk3cxz5XFMU7J1f+HLAmadmHc=;
        b=k75OSHpXO01QPTNNrLLjcYsPg4Lq1iLJ5pUFGKwsVISN6U88T+jICyzwrViqzUD6SN
         RLUj8YwJ1vaafHNz3LLrSfZc+K9Pb39jEmAshvPYYoKGwZthzMcwUJtJloCF6qj0F6pE
         f9v2iCHusvJkCuhsLI/S1e3Pn1pFBj0uSNzCrr7XQFt88RZm51Cfq/9t2OIRtZy6aNto
         AeEhcsN2ene/7REGpIRR17I5DzWAz55YgC4aPx+1GwaCQnhcGRnkyFXJxriQn0Mz8SiQ
         G2NylxlyYe8lKFBGyh6EMfIh7GdpPqR/lbMxxc/g1A49ger/q5xZHN2GaSpJ3fYHMhRt
         +ZhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=prR1UZMSOAIrk4Kkrqgk3cxz5XFMU7J1f+HLAmadmHc=;
        b=CwOb6vSvofIw6hqN6eo41agi7xHATmhhi0E1a9xqr6fDzuaVluOy2obP88/mCgUOKo
         e48EIQ1esOwh85jP2znKZ5EokVggOXAcS3lb0t+8cj3MoXjcVPfqBEUaZHKgnAn3gtZN
         cy+Y2xqk6XZ9s1cUbiE0SHGWCCbqChqbOBgQIWYFl8HrDbar+e8DSh5OPt4m8MSrmNv6
         OFiPfRnq/ztWL/Tp4S0hPmcrN/rmUV2xmARchkUWrssTOPuwlgYdOTLQxrLa1kScyTIK
         J0bsyrEVmsFM4aEp0iA04LoGYW2oqU52lKv3qYzK8b072LGxgIO017stMI5tWfgUC0tv
         fPdA==
X-Gm-Message-State: APjAAAUf4M8EttAZHhaqiT7ArLsXaaGRGH9L+rSDjpipDHhmCAI7HiaG
        ZkFwo6nGX5mq4xFHR/YR4u5ef2J6ejSXso4FnbIbzP9x
X-Google-Smtp-Source: APXvYqygRVVB9PzC/Yvc/jx8dk3X3dFH27ADz1C3x4fCebkohaUkCT0r8xkMa+S4mRPGUaKaD+a7MrbpcQ0EU4Jkjtg=
X-Received: by 2002:ac2:5c1b:: with SMTP id r27mr3194178lfp.172.1573149308049;
 Thu, 07 Nov 2019 09:55:08 -0800 (PST)
MIME-Version: 1.0
References: <20191107125224.29616-1-anders.roxell@linaro.org>
In-Reply-To: <20191107125224.29616-1-anders.roxell@linaro.org>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Thu, 7 Nov 2019 09:54:56 -0800
Message-ID: <CAPhsuW4B_Y+xOTaSFPWm0szn1exjucwL5KBsExWxq4tn_3NSbQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] selftests: bpf: test_lwt_ip_encap: add missing object
 file to TEST_FILES
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 4:53 AM Anders Roxell <anders.roxell@linaro.org> wrote:
>
> When installing kselftests to its own directory and running the
> test_lwt_ip_encap.sh it will complain that test_lwt_ip_encap.o can't be
> find.
>
> $ ./test_lwt_ip_encap.sh
> starting egress IPv4 encap test
> Error opening object test_lwt_ip_encap.o: No such file or directory
> Object hashing failed!
> Cannot initialize ELF context!
> Failed to parse eBPF program: Invalid argument
>
> Rework to add test_lwt_ip_encap.o to TEST_FILES so the object file gets
> installed when installing kselftest.
>
> Fixes: 74b5a5968fe8 ("selftests/bpf: Replace test_progs and test_maps w/ general rule")
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>

Please highlight that this set is on top of bpf-next tree with
"[PATCH bpf-next 1/2]".

Otherwise, looks good to me.

Acked-by: Song Liu <songliubraving@fb.com>
