Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC591FFF5D
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 02:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729302AbgFSAji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 20:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgFSAjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 20:39:37 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262AAC06174E;
        Thu, 18 Jun 2020 17:39:37 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id d6so3533044pjs.3;
        Thu, 18 Jun 2020 17:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=fZlmdJTpTq8ttVb43et8N11XjADL4BqC+tm43TzmjMQ=;
        b=kmOLWUVeEyMsyUISxAXCpaJq8/tgaaZ1xRuyZ+gI3fUohVJuKu46yJtnpN783MwXyI
         1lnAMtFlRuxdTndjcFLrY9dAh40qDhImqx46ppNH0zw9m+LDciS660zwYf/o3kryNUcL
         5VwZ35nf9u67xN5SJ1rB2ao2kO8lQN/im4cQNptH7jZ0e+NOaSRCPPlOieDE2ZxQ6bED
         AyUPxufdryvrQoTwtm4Lv9qjLP7b/o6pFih6bgIQf3dj8HYG7ZtQiYXNODWCEHyroVm1
         wSNU8AT9EbtbswQsQ7i7yAX4XWkot1y+b1CAVzlaQIx0OYdCdxBKyliaG/8ubZ/lsScS
         sZsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=fZlmdJTpTq8ttVb43et8N11XjADL4BqC+tm43TzmjMQ=;
        b=ehj1w2NvjpCkxlFWSVgOX4VQkXHdccTcaBOjNfhuGtdQqqv+Bi/LOZZ/qWGx2OsQFi
         +zXSaUvhLBEcuklcifkVeM262zDEa17O6S0TqZtnzb0HyunGyWkq9IV9ENeN4XFy6KLm
         jPcaoOTSvx6AhjaLjo7bbjbEE3GGU4Ycp8tvlyBgySfHq4EUZs2iBOBbkPoWERhdr9mq
         8T169U5lfm8SAKZL3EkHDX1++ABPSk8QSFeZ79DIz2d7jVk8WSaoRQY6ZM7ukeXap4EM
         etgUAYsI6gL/EePC4to1AbXmOdIIP8u73cEzQrbf9TzFcZoWGijbsWSJXUST0rQ5+03F
         P/1Q==
X-Gm-Message-State: AOAM532ZkUlSV0BgkMzr48pZ+gqDgXlDp4l0/Abnx9KiY+FhMTI9ZhKc
        JQ5EyyMFCmXcReCrWhCx/hY=
X-Google-Smtp-Source: ABdhPJydIvWYJUXpO3LHj0hrcRnS1dNaJHEBglW+AU9dMiSMfOZTyI2nzjpG1j5euEwf1x6FnFtGPg==
X-Received: by 2002:a17:90a:9d82:: with SMTP id k2mr943366pjp.224.1592527176724;
        Thu, 18 Jun 2020 17:39:36 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id e5sm3387685pjv.18.2020.06.18.17.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 17:39:36 -0700 (PDT)
Date:   Thu, 18 Jun 2020 17:39:29 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Message-ID: <5eec09418954e_27ce2adb0816a5b8f7@john-XPS-13-9370.notmuch>
In-Reply-To: <5eebf9321e11a_519a2abc9795c5bc21@john-XPS-13-9370.notmuch>
References: <20200617202112.2438062-1-andriin@fb.com>
 <5eeb0e5dcb010_8712abba49be5bc91@john-XPS-13-9370.notmuch>
 <CAEf4BzZi5pMTC9Fq53Mi_mXUm-EQZDyqS_pxEYuGoc0J1ETGUA@mail.gmail.com>
 <5eebb95299a20_6d292ad5e7a285b835@john-XPS-13-9370.notmuch>
 <CAEf4BzZmWO=hO0kmtwkACEfHZm+H7+FZ+5moaLie2=13U3xU=g@mail.gmail.com>
 <5eebf9321e11a_519a2abc9795c5bc21@john-XPS-13-9370.notmuch>
Subject: Re: [PATCH bpf-next 1/2] bpf: switch most helper return values from
 32-bit int to 64-bit long
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> Andrii Nakryiko wrote:
> > On Thu, Jun 18, 2020 at 11:58 AM John Fastabend
> > <john.fastabend@gmail.com> wrote:

[...]

> > That would be great. Self-tests do work, but having more testing with
> > real-world application would certainly help as well.
> 
> Thanks for all the follow up.
> 
> I ran the change through some CI on my side and it passed so I can
> complain about a few shifts here and there or just update my code or
> just not change the return types on my side but I'm convinced its OK
> in most cases and helps in some so...
> 
> Acked-by: John Fastabend <john.fastabend@gmail.com>

I'll follow this up with a few more selftests to capture a couple of our
patterns. These changes are subtle and I worry a bit that additional
<<,s>> pattern could have the potential to break something.

Another one we didn't discuss that I found in our code base is feeding
the output of a probe_* helper back into the size field (after some
alu ops) of subsequent probe_* call. Unfortunately, the tests I ran
today didn't cover that case.

I'll put it on the list tomorrow and encode these in selftests. I'll
let the mainainers decide if they want to wait for those or not.
