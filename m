Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8928269B91
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 03:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgIOBrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 21:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbgIOBrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 21:47:41 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C17BC06174A;
        Mon, 14 Sep 2020 18:47:41 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id n25so1359982ljj.4;
        Mon, 14 Sep 2020 18:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sZyRAw+PCqw3SZzVchUUN5uoKmttjiq3XVaU/7TyVn4=;
        b=ctAXwrcD7xp3MxN7BozSCC6KJsX3yS+qpIN8FfUFCYgHI16+76d9Ubv5HVEwgoi23r
         A6sm87ohiJjOWb1EJMY/PhupuRvgmc/q9xyg3UKDmfKV0DJDmmz8kdormpAYylbSHn7i
         uzIrUB5GiAB0Fx6nF9J6rXE8Zs1/STbtVTjhS70Ahk8mRq27RkcMfh6oLJQOiIinM2V5
         LSnjiACEH8xm2dAPfIpwYjGY0gV5cfT3Rd5egMvWz1N7jiJmpFlnnY0/Q+4E1JlnqcaL
         W1a3ZYd/kfAJfCzxJ+d8jFJIfmYJ0YmKxrvJ5BnS+lYE76V5m6QU3TWh3AugQyS+2qmR
         6lPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sZyRAw+PCqw3SZzVchUUN5uoKmttjiq3XVaU/7TyVn4=;
        b=bpBUwPXL57Z01OIe0QfzN4hKCA1toTLERexrdSYyCEef75jLk2iDbq6Ykvbfq592bw
         fZViRwj68Yt5gpNwStHQhohUFDFCl2aZW6NO+zv/lfzLo3fsPjwcPpFWI771w9N7G4uE
         I9PKkQbCmN/BPSJMcjKPlI/4D/CygF0dL4AQTkR1HGYqhE34+KlGFE2/9Plaxdk+Vf4a
         nQ21yhwdS76sh3+ZNird4pPgvx2ejnp/zKDTxzYrQZft64rrXr+BR6j1dlo0GwvB7TlT
         CmvfnRdNW/5Hay8yo64UFiqlhctSE67XQorOHjzD9DGFH7ZvK+03lzog/c+zNOkDaCur
         Axzg==
X-Gm-Message-State: AOAM530hwjBlCElgF2kl3IPhTDXIx2nCpIiBmHDgmvZqyCDfrcS/ZQ6j
        i6DlsaO8FjZoiMI1/rZEAaZDV2icCrcZVif8sxY=
X-Google-Smtp-Source: ABdhPJyLmobL/WZmytLwx9lr9gtw8eGbpQiIaBom5Rr5AWCUo5HVPxcsKhtGAERxRX0TJ4iyZgoTlpKv36DLBBBcOK8=
X-Received: by 2002:a2e:9dcb:: with SMTP id x11mr6273419ljj.450.1600134459697;
 Mon, 14 Sep 2020 18:47:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200915005031.2748397-1-andriin@fb.com>
In-Reply-To: <20200915005031.2748397-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 14 Sep 2020 18:47:28 -0700
Message-ID: <CAADnVQ+2RgENK6nohNRsOG5tqmGsMyzUyXt5mySFnXSAwXcbuw@mail.gmail.com>
Subject: Re: [PATCH bpf] docs/bpf: remove source code links
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 5:51 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Make path to bench_ringbufs.c just a text, not a special link.
>
> Reported-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> Fixes: 97abb2b39682 ("docs/bpf: Add BPF ring buffer design notes")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
