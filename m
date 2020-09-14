Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3949E269778
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgINVNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:13:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbgINVNe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 17:13:34 -0400
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EC1E21741;
        Mon, 14 Sep 2020 21:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600118013;
        bh=u21+m9Dze8RLlKmw5vrLFG6Vqi6QZThgiavyuHPqS8E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qv4UWt6uMDTWletjKbm4McLB7jWX4k//W5/xP1nSFK/iHS9xIK/ZBcMZmg5saUuGe
         5d9UfBOhJbEovgsTMzXy6yEm+BbD42jfwKWHxYHdaM9y9cTILSTqjzRTmy0z3hnjvv
         uzqsRA1qubrBpCoP7DpF10XYOdCZOUUs6Hj30BUo=
Received: by mail-lf1-f45.google.com with SMTP id x77so842755lfa.0;
        Mon, 14 Sep 2020 14:13:33 -0700 (PDT)
X-Gm-Message-State: AOAM532LyUsyJkRGzETGgwkfZ6KIB+Tz/PolB96iWb0hOgYeKrSF6F74
        w/kl/kfHmLThcZ/BTc3shnLm9kmkvLaJdUij4+U=
X-Google-Smtp-Source: ABdhPJy44xmpggoSF9S+cT8PJibMzSTYvWxYYwfYr5zfF7XkAbFRu11eAKiH/rAcnIbqbn4f/u+/w/ssLFgcBev85Ck=
X-Received: by 2002:a19:7902:: with SMTP id u2mr5282683lfc.515.1600118011735;
 Mon, 14 Sep 2020 14:13:31 -0700 (PDT)
MIME-Version: 1.0
References: <1600095036-23868-1-git-send-email-magnus.karlsson@gmail.com>
In-Reply-To: <1600095036-23868-1-git-send-email-magnus.karlsson@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 14 Sep 2020 14:13:20 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4ktphxDkbZbvuQZUd09vBdNJbn2EfB5mDQ9-6FoXoFKQ@mail.gmail.com>
Message-ID: <CAPhsuW4ktphxDkbZbvuQZUd09vBdNJbn2EfB5mDQ9-6FoXoFKQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] xsk: fix refcount warning in xp_dma_map
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 7:52 AM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> From: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Fix a potential refcount warning that a zero value is increased to one
> in xp_dma_map, by initializing the refcount to one to start with,
> instead of zero plus a refcount_inc().
>
> Fixes: 921b68692abb ("xsk: Enable sharing of dma mappings")
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Song Liu <songliubraving@fb.com>
