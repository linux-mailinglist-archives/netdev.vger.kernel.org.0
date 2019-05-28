Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACDA32CC23
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 18:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfE1Qey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 12:34:54 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34326 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbfE1Qey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 12:34:54 -0400
Received: by mail-lf1-f68.google.com with SMTP id v18so15127094lfi.1;
        Tue, 28 May 2019 09:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1myZtded1RLBPOtfFMrOo9NJSxPtLPt4RXZAdQZ1vIU=;
        b=IE8ur7agfZBBCR5CIL7GjM8g8jWr7z/JqzqNUZX8/3off9XT23B7JKi8BKXausnRk+
         cBiSFCJ8giUiLxAIa49C6Oq/qSpeGkDcfxu1UR+WBzJNB6H0VrzKWOoYYp23yYJ/zG4l
         jNcHQ9LEj3lsRFnee3CIDa1fVW/lNtZi2uscScbiiVc7YuMLP/kQUuI6sNlH0NtHm2n9
         SyWAiHdIJxrmiQH3Ah7BImRFa7W1PSevo5kCSBwOfsLn3gHe2jgUISC3nudQBlILdKJY
         0v9lNBL9wgGo5UmCv7BOm2Dxev70vRHMEOIGZ2A41KLMAJWI/Vvapuz04EdXc66hQsis
         /PYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1myZtded1RLBPOtfFMrOo9NJSxPtLPt4RXZAdQZ1vIU=;
        b=DRZ8EKrw7JxuNmUKmACwrqJyqVnaZG/izC/W9fknoheMpRMDXvL0ZfQWF2YPlrncLG
         UIpB7H1A68sf7iwA0cX4HwCSmXJLLNMLF1dgbhE10097qs7/iRV4kbna4bkZQTlXIccs
         jrptisNba03l+WrdExVxDU/VEuwxRtr6bzvQSPCAQOGUmdprcCog/RHk/sIuII6aVKpv
         KmKGcgZrscfReqobumUgcl+DxenIPYiWg5sZPC6q4oBUEI2GXNF6G1fPcMC9bBh/URz4
         QJM0P31JhRp4G0u6qkhEhn8wUsAhVZzFXU1JpWnQkmP9rUQGpai33Y5kSWkn354JHGpc
         f3Ug==
X-Gm-Message-State: APjAAAVeNN8WGX3/2V73dGaBrJiG3vrgM3CIIk56e147haDUxorewkGG
        75UnWPfCbw5/9r9gIMjk7Dwawf3SFTxHSYnPxp4=
X-Google-Smtp-Source: APXvYqwgypbdahAcVJbJiaN2+ExTZHRmO5VZL7WOt6lerC+6PmktCeYjhQJxChF0TBELsaSmv3piePXZcOMTSAOs1Pg=
X-Received: by 2002:a19:d612:: with SMTP id n18mr50173592lfg.162.1559061291994;
 Tue, 28 May 2019 09:34:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190525163742.2616471-1-guro@fb.com>
In-Reply-To: <20190525163742.2616471-1-guro@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 28 May 2019 09:34:40 -0700
Message-ID: <CAADnVQJ7DpjeyAu28qtYymXxcWBa5SGxvW-JOTWyY-gJ6gmX9A@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 0/4] cgroup bpf auto-detachment
To:     Roman Gushchin <guro@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Kernel Team <kernel-team@fb.com>,
        "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Yonghong Song <yhs@fb.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 25, 2019 at 9:37 AM Roman Gushchin <guro@fb.com> wrote:
>
> This patchset implements a cgroup bpf auto-detachment functionality:
> bpf programs are detached as soon as possible after removal of the
> cgroup, without waiting for the release of all associated resources.
>
> Patches 2 and 3 are required to implement a corresponding kselftest
> in patch 4.
>
> v5:
>   1) rebase
>
> v4:
>   1) release cgroup bpf data using a workqueue
>   2) add test_cgroup_attach to .gitignore
>
> v3:
>   1) some minor changes and typo fixes
>
> v2:
>   1) removed a bogus check in patch 4
>   2) moved buf[len] = 0 in patch 2

Applied. Thanks!
