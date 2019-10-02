Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 992AAC9332
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 23:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbfJBVAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 17:00:31 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45314 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729030AbfJBVAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 17:00:30 -0400
Received: by mail-qt1-f196.google.com with SMTP id c21so512144qtj.12;
        Wed, 02 Oct 2019 14:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8xUoba94hqt21S7poDp6aPO/G0u9HsT4zgQ8TPghFjs=;
        b=cTT625y51C5KdBmq66gcT5Bb7p9nDEZn3xjeYGYmnw0YlqIi6pL8v4gTBwrSYYHG3g
         zjZYhcoZQijyMOVQrl4LO/2bPXNWwJIefffiOlqoppEiF22JOe/KQXWTLAn5fP/ZDt6R
         /ELtSy2/tz55ePuY/d2csV60vxY7z/fCUgyMKoLamU6tKYzz2QPdamcGcqFU7IGkuazR
         gin0GD/7KW+rpSWrT8VSlpdKy576y9+E+tn+pyEbDAAGFyE9l+AaURTDJf+fYw2AhtWD
         v6ijPkFmYaGjfno945YRRIJP6ss2jsLWpJp6arg7IEJy/UafC1SgKeNM+19D9hp0aWSZ
         PCqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8xUoba94hqt21S7poDp6aPO/G0u9HsT4zgQ8TPghFjs=;
        b=uRWEMyNUl4qLQ/c9tq7VQlPmwXMlAWlw//DklBJOBbhoQof8fXtrgS5hAPS/1zY75L
         Yn8m6hbrqDs8a+EiVAczWEFPRvD3N3eCgvejir6LDnnOmAUlT5dQUMDuE5I+HdhAADVJ
         Ntt9FMS+JbgSUBbqovulhgJ6GvfQvmTpTso+JUvp1Hd9fQtwlgsyYj/GEHVS7smDSzOb
         u1DG4gJeeLavrTobpLW/YrqNLmDD4F8uZWpbX13/BI7StN4cuQ9iENKR2hUZMHvBaZSn
         Tc6gh5ZFnyLzh5iQWhLx6p3iVuehH/ZRdMLfgA5Ggkcx87FBXWq7Kt4Ze41+edt9yGz6
         aaNA==
X-Gm-Message-State: APjAAAUzdCBZgE7qB0L4toQ04twjn1dUDHCPj2Fx4vXd+R16Y7aCsmrs
        CqNsPLu4cLjmTsSzpKN1UnSFNQMFezqGcpOrVwzxIMTw
X-Google-Smtp-Source: APXvYqzyuH8ESnd6iGaROi8ICK34q9xBqydOF5gDhz2nYRgT2zwgvjWSzOkcHsvMF0kJe66mg/KF0gD9e/HMkze2QuQ=
X-Received: by 2002:ac8:1099:: with SMTP id a25mr6323923qtj.308.1570050029658;
 Wed, 02 Oct 2019 14:00:29 -0700 (PDT)
MIME-Version: 1.0
References: <20191001113307.27796-1-bjorn.topel@gmail.com> <20191001113307.27796-2-bjorn.topel@gmail.com>
In-Reply-To: <20191001113307.27796-2-bjorn.topel@gmail.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 2 Oct 2019 14:00:18 -0700
Message-ID: <CAPhsuW40mXh+fcbGZkmbFUXgKN8Qh6jQ+8Ju6yYXfnavwZxL_w@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf tools: Make usage of test_attr__* optional for perf-sys.h
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        adrian.hunter@intel.com, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 1, 2019 at 4:35 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com=
> wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> For users of perf-sys.h outside perf, e.g. samples/bpf/bpf_load.c,
> it's convenient not to depend on test_attr__*.
>
> After commit 91854f9a077e ("perf tools: Move everything related to
> sys_perf_event_open() to perf-sys.h"), all users of perf-sys.h will
> depend on test_attr__enabled and test_attr__open.
>
> This commit enables a user to define HAVE_ATTR_TEST to zero in order
> to omit the test dependency.
>
> Fixes: 91854f9a077e ("perf tools: Move everything related to sys_perf_eve=
nt_open() to perf-sys.h")
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Acked-by: Song Liu <songliubraving@fb.com>
