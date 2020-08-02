Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614B42354FD
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 05:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgHBDdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 23:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbgHBDdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 23:33:14 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F2FC06174A;
        Sat,  1 Aug 2020 20:33:12 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id t23so12747910ljc.3;
        Sat, 01 Aug 2020 20:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CjD8DUMldZakNB+ym7yoPKLUoI9L5qD3Uy2+cTz530Q=;
        b=KqZhQVO+V34CwUal27ZS0t6cVCK5yS7Jw6yd+BGD20zl9DmuH1BaP816xB0zkSHSAq
         2AdtSWWTddpgDcw/42hJW6qQJmz6JUeMaa3lGsaHSGygqICYcE7M7eN0/Onswuncqn6Q
         0X5Y6ztfGuiBLnFAxGccBGLYdInIq/u8j1PmgIVV5t1La8o4zcE5yJU3mTxaWunIAva6
         qgaPlc/YR5vofzGy94/HHo4oAimpKcu3lNEUYMjNOau0gRQSZaQ5uC3ua58IgqJGmMPJ
         lViDQlQ2Xc6gEeqkAZ5C3efg1+tLgsq0a2CS4Zyi34DB8WYhk+QDqAfegsPOLr+t4RuZ
         rgsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CjD8DUMldZakNB+ym7yoPKLUoI9L5qD3Uy2+cTz530Q=;
        b=j28UD4F3qVvv0IJXXxf0Kb6O7g6mk4bRSv1+zdZkgglypxvkw+/I7e+ckHcgC7t19Z
         jttdipJWe/+JtC2yFIvC6jA6OFbgM9rUKzgaWEZueElasHLuYghnRZicHqIOJrQMLCCY
         Xf1giDhvF2N4DPUzVKCyYqJmefBKGox2t9hBDKULu96YE73VFIx80MU9t1Y1+YN/IKXP
         LUTTFgGMUy8fFkYKiedJuS5Cwuacj/kvl4xZcB4ShVhoeNNOaDjcfN+RoQastoVQd+1u
         fZqJkZLri2N7kWOSvHm6UjUyIviX0QkfkpUx5OilMTqUiZo5j/WSzXO1+yJR1eXONEL7
         +NPQ==
X-Gm-Message-State: AOAM530eEWo5nq+Ld0Vaq1T8q1xueKFkRCsvNMWxz0J45+Yidx7kVKxT
        ronl4uKRXFYLYBk0vXUEXXTJVcofDetmzKGqFww=
X-Google-Smtp-Source: ABdhPJwB72qZJoVHcxalvxFvrJTIV7kB0QZycMu++RaCM0x4BPzJHtCDxP90mGGfUPLsqTtdMbdCqFzqQFZZnGQPQBY=
X-Received: by 2002:a2e:8e28:: with SMTP id r8mr953652ljk.290.1596339191388;
 Sat, 01 Aug 2020 20:33:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200731024244.872574-1-andriin@fb.com>
In-Reply-To: <20200731024244.872574-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 1 Aug 2020 20:33:00 -0700
Message-ID: <CAADnVQ+0ESD3t1YhQ3rzOwV07JKKc9oK+_0Eenj8+k2c+WHM+g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] tools build: propagate build failures from tools/build/Makefile.build
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 7:44 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> The '&&' command seems to have a bad effect when $(cmd_$(1)) exits with
> non-zero effect: the command failure is masked (despite `set -e`) and all but
> the first command of $(dep-cmd) is executed (successfully, as they are mostly
> printfs), thus overall returning 0 in the end.
>
> This means in practice that despite compilation errors, tools's build Makefile
> will return success. We see this very reliably with libbpf's Makefile, which
> doesn't get compilation error propagated properly. This in turns causes issues
> with selftests build, as well as bpftool and other projects that rely on
> building libbpf.
>
> The fix is simple: don't use &&. Given `set -e`, we don't need to chain
> commands with &&. The shell will exit on first failure, giving desired
> behavior and propagating error properly.
>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Fixes: 275e2d95591e ("tools build: Move dependency copy into function")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Jiri, Arnaldo,
could you please review and ack?
