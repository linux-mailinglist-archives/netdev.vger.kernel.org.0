Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572A248193C
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 05:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235714AbhL3EKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 23:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235408AbhL3EKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 23:10:10 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C504BC061574;
        Wed, 29 Dec 2021 20:10:09 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id l10-20020a17090a384a00b001b22190e075so21554938pjf.3;
        Wed, 29 Dec 2021 20:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZLIxhQfqHzNnkuLNry5nbVJx3WYwLnh+KYZ/hremSLY=;
        b=B3/K+sda+rwLtfeMfE++F8BwmemdcsIc6erDJnIjfByvWQ4pue5i3SA24et0OmxEhA
         0mNQMucr/MKEW4nON6OUHd81CAPI/LJo31ITzfnZTJbY74UT2tlTenR5XRsh38yGJx2d
         IZPAEzqwbZDXfCrsKjDnCQX81Ky8jZIlGlgnNQMiZkIo0BapsgMxHRHW251+uAxWMq1f
         XaVVKzT3H2us3AARw7dE+hR5/GpKm16BBVnkgIbBddRIcv4fZsCvPjUACl7xImoMYTCW
         d9m+uQYiv5+tq+no4p6BMtJBq85MrOBTrovaXipzBmSBc63mr/6Oqd9FryltBHs0iiDQ
         IXhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZLIxhQfqHzNnkuLNry5nbVJx3WYwLnh+KYZ/hremSLY=;
        b=hI5YgPvhElKiN+GYtXpuExBZ0cndUFThRYunjjXt2aEZmKMdkgYUXgw042NcKi1Spb
         SMoYuzcb3xlJi0RtuCp8IORKDoCsHVFynOtwl3TcFGun/gfs52irT42IaS5g4CdeWSFh
         D+0m3g8xEEc+hc1rESXY47h7dx0/Ue11jnBJPEe+lsRCA5l6BLMposzSMRhFAdHFT0EN
         EKWtaQos0cgl8LQwwcPWt28AUyBkc7M7l7ioBtO8HSCo37toEhzsN7rCeacs7A9y0pgU
         Ymws+gPQmGNg7zQnSm42ZhSqGcaQ3ECH3OFxFrFHxKguLiKwfEnME+5emHnJNf+fgvf+
         2wNw==
X-Gm-Message-State: AOAM531YvLLAsuqI1W1s/3JDGlqAUy+xKzhbU1QEy4ETNvdzkeVnP/VA
        zXI6IxMyr86wbbWWHr1n8lRW2sQVXKG9wHttbNM=
X-Google-Smtp-Source: ABdhPJzQFvsAtKMsnGmAhA78hZKzB1/xwuLIOkqqGKVlQehXSLtzKa6i4MKYPfz6cPChRMtZz/oJKdcPmgkWHeX4nVc=
X-Received: by 2002:a17:902:6502:b0:149:1162:f0b5 with SMTP id
 b2-20020a170902650200b001491162f0b5mr28967222plk.126.1640837409318; Wed, 29
 Dec 2021 20:10:09 -0800 (PST)
MIME-Version: 1.0
References: <20211230012742.770642-1-kuba@kernel.org>
In-Reply-To: <20211230012742.770642-1-kuba@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 29 Dec 2021 20:09:58 -0800
Message-ID: <CAADnVQLRJQSMca_Ojc5K5vUzpJQewg_f=DgeHK5-sk1BMWuyAg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/2] lighten uapi/bpf.h rebuilds
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 29, 2021 at 5:27 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Last change in the bpf headers - disentangling BPF uapi from
> netdevice.h. Both linux/bpf.h and uapi/bpf.h changes should
> now rebuild ~1k objects down from the original ~18k. There's
> probably more that can be done but it's diminishing returns.
>
> Split into two patches for ease of review.

Applied. Thanks
