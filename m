Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E02B269B51
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 03:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgIOBlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 21:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgIOBlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 21:41:03 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835DAC06174A;
        Mon, 14 Sep 2020 18:41:01 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id z17so1300928lfi.12;
        Mon, 14 Sep 2020 18:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0P9Hh8b6A3uQAMa1CjhoAwCfuRMTfsPjp/wKwAiv9FA=;
        b=OrJUPbbbjcbay3kyLroo5DazvijKb1FcvbKrNsRhzP4VQcoqFbNtKtBzT+cWB3dk9q
         NsW5xtV29NImOzT5D6jUbNSgf0NbL9OMinGHqcpBBB8TZzbdRdJftzYYscd1Ts6t1pVF
         TMkTtLK7OVrrRup0ctIaCpGO+B6dg98UWf0mot5WGaRhsmO3W6HMigNuheFfzweOT2r4
         Zpr/S004WbUs2fT9CJY6Al1adwcg3ZwzMNjwhe1afcMyuy38FajBSp1FdQFbrgQn4Cch
         93nm0Oo1irLfJ7nWuwpzT6vgc6noUDlmOBPd+eqPtFOuaMlJVE41wZ+JCOdt5qRhqHLh
         nTbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0P9Hh8b6A3uQAMa1CjhoAwCfuRMTfsPjp/wKwAiv9FA=;
        b=jc7EfuyY/kdF1CG2CNzoo2QE+AYn+PfkRfuBOwMsctIWjcsaYQfx09V0uy+akVe2YA
         +55N580shHNsbpsuqU7dKXi2nsEJzKJY0DAQuO2hL9PdaLpE/RiIJhKCDqv0SY3Q/iDF
         1EPGqrMt7dtCU78zyyXNaV8iXiZv/yD20tTjbtQ2PC4t9F5pyert2xvPdhCcJxH9aNqz
         PPTKKCO0Aa2JQ7cuBJd+5w/D+KsdwmgYS8WtVOhcmMXkQveqBuuz+Os1Am8UMMs0mA7F
         poHQpKD+gC7e9DAqlaBQ83hXel+rYR2ZnAuSjATXdqWCgk1/VVlCaievdyE41I0xU823
         ctJA==
X-Gm-Message-State: AOAM530Q8p23ANss05Zciw75vKZXgkCufws9qrEGKp+Y5AxjLU743CS7
        MGJaU2gIdZGH2HwUc+FSncIcc63xhDNbZg6xKOg=
X-Google-Smtp-Source: ABdhPJxGV5Vm4+5vhjj1JCrFbbSvjpFMbFaww1l2mrbKd5XRfS+tzhaVc4eDqdSYpIJT+1PDMfIKzTeNz0hE1KUZXEw=
X-Received: by 2002:a19:df53:: with SMTP id q19mr5324242lfj.119.1600134059894;
 Mon, 14 Sep 2020 18:40:59 -0700 (PDT)
MIME-Version: 1.0
References: <1599726666-8431-1-git-send-email-magnus.karlsson@gmail.com>
In-Reply-To: <1599726666-8431-1-git-send-email-magnus.karlsson@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 14 Sep 2020 18:40:48 -0700
Message-ID: <CAADnVQJ_ReAbcifq+QEdAJataJj3DV9P4SRqcMQXwHVC0ZUH6g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] samples/bpf: improve xdpsock application
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 1:31 AM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> This small series improves/fixes three things in the xdpsock sample
> application. Details can be found in the individual commit messages,
> but a brief summary follows:
>
> Patch 1: fix one packet sending in xdpsock
> Patch 2: fix possible deadlock in xdpsock
> Patch 3: add quiet option to xdpsock
>
> This patch has been applied against commit 8081ede1f731 ("perf: Stop using deprecated bpf_program__title()")
>
> Thanks: Magnus

Applied. Thanks
