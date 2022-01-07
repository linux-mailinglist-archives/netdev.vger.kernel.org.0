Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B9F486F38
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344173AbiAGA45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:56:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiAGA45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:56:57 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B81C061245;
        Thu,  6 Jan 2022 16:56:56 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id z30so559357pge.4;
        Thu, 06 Jan 2022 16:56:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uMXLFosFcOPnqBCXyW3ou3WsEkK2Jt5B5KOIU+ZiGjo=;
        b=HY4MDnfHnH1FSfwxEYfvyFHzygyUTcL7uLz8N+p5bzibRbSBx+GAIuZ8nd4l6mG1f+
         WAACkXbTWfBQldkidOw0KFrYGhJNninO9z5X5dGSZtU9XHp55GYmSnCLPH2G3WF8jnkq
         qQSvXUiFJdYJ0KB3RfWExyIGmKBIRVLWM+owOCNIAJneRgkO/ZU6uh/Ce0Nwmw9mBd+y
         AeKvXFZxym6e4OcgJsSslfQjGT7CDIdFPChoxVtgZRD5OSnuM9jwzDC+VsStGcFeGezU
         Uz+3SlbeMwklQerUWH2J0t6iSBMJQZr3ypkyqoFbSrkd0/PPpd9svnG6xSLngtnVSlc2
         hDww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uMXLFosFcOPnqBCXyW3ou3WsEkK2Jt5B5KOIU+ZiGjo=;
        b=H2gmqyBB9TIiqIZC4q9/KO9juDVU+nYR9e9YOepbPlB5Dl3I6GQqGR5oUOqQxg3G73
         W59WmvpYTqqQyA26FfHOeQhP4pSqaPrkfEtkLFmX0VmJ1GJomb71Wq7sw6rH58e3xDVo
         LdyDCA0BRtcqjqY3rI9WebbotD+AvMUUzlqWXk5V6mjlvpfG4H+hUwwday9KNDZrCD8o
         gZBIL/8vxs1208lmX2/Bf1E1Kpx2o6+l+LvCKgjCNylojIr0vFSwAFgTFGwXcZRImlyj
         lN7FKQFue0kkUv0usJHLb8cOtXrIU+rjtcD/cV22hRSTiCvh7BDXWolANfi/zPPsoKcr
         DQ6g==
X-Gm-Message-State: AOAM530riIZ/sMGEwXmaDbDJY1TU83NA5pTer4HiMz2FHTME1DxEtm/l
        cNjX2bhMHisRFfBcWJuLQkbtMGpuXvLZLopZzU0=
X-Google-Smtp-Source: ABdhPJyStCRrCyOg1AqLK7/yPv4PQhWye7FYWRV+XtcsXNpTI0p6T7PzG9+39q9Vk00MLMuYf0phF733PraMX/fG0Gw=
X-Received: by 2002:aa7:8c59:0:b0:4bc:9dd2:6c12 with SMTP id
 e25-20020aa78c59000000b004bc9dd26c12mr23062631pfd.59.1641517016438; Thu, 06
 Jan 2022 16:56:56 -0800 (PST)
MIME-Version: 1.0
References: <20220105030345.3255846-1-jevburton.kernel@gmail.com> <20220105030345.3255846-3-jevburton.kernel@gmail.com>
In-Reply-To: <20220105030345.3255846-3-jevburton.kernel@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 6 Jan 2022 16:56:45 -0800
Message-ID: <CAADnVQK+kB=9hdNUa_=6637ff_q46avnjoQOsUS8vRVVoUeHLQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/3] bpf: Add selftests
To:     Joe Burton <jevburton.kernel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Joe Burton <jevburton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 4, 2022 at 7:03 PM Joe Burton <jevburton.kernel@gmail.com> wrote:
> +
> +enum BoolOrErr {
> +       TRUE = 0,
> +       FALSE = 1,
> +       ERROR = 2,
> +};

No camel style in the kernel please.

> +++ b/tools/testing/selftests/bpf/progs/bpf_map_trace_common.h
> @@ -0,0 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (c) 2022 Google */
> +#pragma once

Didn't you say that pragma once was removed?

> +
> +enum MapAccessLocations {

here and other places.
