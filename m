Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3302534BE51
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 20:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhC1Spx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 14:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbhC1Sph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 14:45:37 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A54C061756;
        Sun, 28 Mar 2021 11:45:36 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id b83so15079746lfd.11;
        Sun, 28 Mar 2021 11:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i9QQ/MF1ty4petQ8Mzj557Qsdpc6PlWXTrpnIGrdc1I=;
        b=NhDB0IlKoU2Ml/a3sPvGp0Crpjjt4RD9fT0DwDDIJKKOepL2o5xMWdUpfhNZ4Aq+SS
         K7O9hNMGydC+rV9vzUWi+axUDaAk1ZrgJDS+0y4L3W4XClEo+MONdjHATrtATDM/Zd9h
         0xYYlT+FeERDFVCz+0MNJs/61116YwEesWgJxy2xcQKP1xMxpnwgoFABGU1Dayv8z2S9
         mig5YXw8vTj5kQHzIfufWUWuXpd1AbZdqyg/+qNr7VhD8AOHDVkyqVotn/G1h/Iz1l47
         5DGq7njoI2tQpA1svaDArh5sGNsIkeZdQgRWG2TJXy5WoXqFnPzErBXxt79Yw9CBAziG
         yAcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i9QQ/MF1ty4petQ8Mzj557Qsdpc6PlWXTrpnIGrdc1I=;
        b=HetvonwF5qqhoGQKf1q6Gf5XTOpYrfgkuwdkSfcCo5iIUqIO7xkV30bFYCboYjWrHg
         QhEysuPJSj6roNxLnOdInu028UzEx8c+WVeMsWdvlnTF3H9nCTazOe9Z+Z5yquamvIMU
         URmWN+GuX6JZR5XFuMGqLUDuR4RSpS9DLmJttVdlybom5Bpchr551lbQJu7lPEHUaYiy
         pQqMw1KV9etN3QsYx267AkUs6yXse1GcOVV6btzBOzbC2tu6phuU8FUNDyNWHWonGPgM
         4X9DhYjxtEZlWFlBAxqEB/XoDKn4PRawSmNJSImD/chMYJQikwxcu0m9nOKHioVNd8p3
         hczw==
X-Gm-Message-State: AOAM532ymdW8t+aXK/gRju8WfBDw1g4AP1ys3AHqyeITunSja9j+6cIX
        d+MKj02S9iuyApjj6z59bmBMYThnTXdwmxCJz6Y=
X-Google-Smtp-Source: ABdhPJwJKTWAyIuYhPL+xFHJMLhxdvP7TB/oMboiFVneYtgMXKcAJH+0IEE+Xk2Bc6I0f7ozJxROKatMYfKDfZINmyQ=
X-Received: by 2002:a19:ee0d:: with SMTP id g13mr14677327lfb.38.1616957134452;
 Sun, 28 Mar 2021 11:45:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210328120515.113895-1-atulgopinathan@gmail.com>
In-Reply-To: <20210328120515.113895-1-atulgopinathan@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 28 Mar 2021 11:45:23 -0700
Message-ID: <CAADnVQ+PyPtcNagDDFE8cOOZCg9cAv_xJerBSY9BPziKEpai0g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: tcp: Remove comma which is causing build error
To:     Atul Gopinathan <atulgopinathan@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+0b74d8ec3bf0cc4e4209@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 28, 2021 at 5:05 AM Atul Gopinathan
<atulgopinathan@gmail.com> wrote:
>
> Currently, building the bpf-next source with the CONFIG_BPF_SYSCALL
> enabled is causing a compilation error:
>
> "net/ipv4/bpf_tcp_ca.c:209:28: error: expected identifier or '(' before
> ',' token"
>
> Fix this by removing an unnecessary comma.
>
> Reported-by: syzbot+0b74d8ec3bf0cc4e4209@syzkaller.appspotmail.com
> Fixes: e78aea8b2170 ("bpf: tcp: Put some tcp cong functions in allowlist for bpf-tcp-cc")
> Signed-off-by: Atul Gopinathan <atulgopinathan@gmail.com>

Thanks for the quick fix. Applied.
