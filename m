Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33A72FE8EA
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 12:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730285AbhAULfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 06:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728019AbhAULeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 06:34:37 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C34B4C061575;
        Thu, 21 Jan 2021 03:33:49 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id f6so1683034ybq.13;
        Thu, 21 Jan 2021 03:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=I+cG4Vp0KOKN+ozIhgZ8d42ujiCT1czKBVqBGfsh21E=;
        b=QjcSscZscimEm9YXE5dIYpYuqYcpiIxJB+SPAUkEjYLDPYGtuYJyR1e/+YCFiR0qlC
         pDFpMw5HFKmXcyWysd1FhVkkiwiw7v2DpYdv5H8Un0R46SL6yVpM67dXd67OIZFvtDXY
         dpW0qo3HPREc7uTvFBrV2HliAUzJOjyhbXreHkpZ5NZFYN9Csb2Q44ryDKdkBdzsyg2Q
         VoumBKLrxmHUMCdVBuY/16Za7bqRWVO3VlUPwEvpVv0UDSxxSDwErL3NRwzBqW76e0s+
         zuu9JC1a8X6Oy6MTQX4f5jonI9y7EqxIF9LQv0q6d2eNgRwvrVEBR8JqQdMw10JJcxBZ
         8o1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=I+cG4Vp0KOKN+ozIhgZ8d42ujiCT1czKBVqBGfsh21E=;
        b=gPNofxltzAEugMNKrOdXE7iawBLU6dHZdTeRcHC+88MnZXjXEmrOh2E8hlwl/fIzqr
         XUzW0qan3zp9gVtw7KyIy/iLGkX9k+eXtaHJdygoNuMo8ZN4zHA6Hm04e1WMSe0oI297
         6vlg1rQImp/mXMbxY6RewVihd+y33WAFYv6Zv0YlzaqoBaWz6uYFX5I59ToOKmesXG3W
         8PvCEQDaBZEXzrOR5SS61nbvoCBfYOe/V1KbRx9ab5HRGPM01l853ZKEZFdpvHz+AfbE
         sIlwvE2lpj6gq6Yv3i93ZkKY94oM0dC+Qcy75UAQ9rysj7uUKF+Klpehi+CJd6DRZ6U6
         Ppeg==
X-Gm-Message-State: AOAM532QcwkZXtM1C5+jou0L2SMAH0oZETSJ7ZYkLoAqlLqYmdIGfFJH
        +kwiUlUMVOqa3L7BzbNZeb9GzDx4OeKzzL43xkQ=
X-Google-Smtp-Source: ABdhPJx7CE06Ajx6zuXEJea156D0wq36xdLyL4K/2sS9pM1SZo8RtkpQgK8SOVM4JSKPoJSwnb6ypisyz8pGTv5Q+jY=
X-Received: by 2002:a25:688c:: with SMTP id d134mr20778186ybc.477.1611228829127;
 Thu, 21 Jan 2021 03:33:49 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?B?5oWV5Yas5Lqu?= <mudongliangabcd@gmail.com>
Date:   Thu, 21 Jan 2021 19:33:23 +0800
Message-ID: <CAD-N9QW6VGmAFPtJDcHahO=OQ=0Cy06-zaQf72mYL0=L_MEc_g@mail.gmail.com>
Subject: "WARNING in cgroup_finalize_control" and "WARNING in
 cgroup_apply_control_disable" should be duplicate crash reports
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, christian@brauner.io,
        Daniel Borkmann <daniel@iogearbox.net>, hannes@cmpxchg.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        linux-kernel <linux-kernel@vger.kernel.org>, lizefan@huawei.com,
        netdev@vger.kernel.org, songliubraving@fb.com, tj@kernel.org,
        yhs@fb.com
Cc:     syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear kernel developers,

I found that on the syzbot dashboard, =E2=80=9CWARNING in
cgroup_finalize_control=E2=80=9D [1] and "WARNING in
cgroup_apply_control_disable" [2] should share the same root cause.

The reasons for the above statement:
1) the stack trace is the same, and this title difference is due to
the inline property of "cgroup_apply_control_disable";
2) their PoCs are the same as each other;

If you can have any issues with this statement or our information is
useful to you, please let us know. Thanks very much.

[1] =E2=80=9CWARNING in cgroup_finalize_control=E2=80=9D -
https://syzkaller.appspot.com/bug?id=3Dfe2fee189f1f8babd95615dcbb57871d6d18=
920a

[2] =E2=80=9CWARNING in cgroup_apply_control_disable=E2=80=9D -
https://syzkaller.appspot.com/bug?id=3Dba5a3ed954137643a9337f90782c90e90ba3=
02ed

--
My best regards to you.

     No System Is Safe!
     Dongliang Mu
