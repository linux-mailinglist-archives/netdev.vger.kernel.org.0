Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219D31E5746
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 08:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgE1GIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 02:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbgE1GIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 02:08:37 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB15C05BD1E;
        Wed, 27 May 2020 23:08:36 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id k22so6585152qtm.6;
        Wed, 27 May 2020 23:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E3nnwRQVmPx0RnVlPvOQUeyhAGklO+sO+VnesiuX/yY=;
        b=ehN1cA5CXzDuLWvcTY/AxbJ6iAOMW29Ib02oHaEAuMU4dWWdolHD95EjfcYSqF8prQ
         7Zk6fqp4bdUBYaYSr7rF8wPiut3+oi018XGym6GswrKlTpJJdldE4uGXBtlvQUodMsfU
         6JSwYL20KixReKr31eLdXTLLI5ld3a/oyfwSi2vJPqTJzZBz6NtnmAmgtMCA7d7GR3+l
         VDRDIyKG+BQp9IRwhrK3gkJgZW+bfsEqtVYfytr18ePy3ACxNKMsLk/IybbDAZZZxIwi
         qYEpWe3N46BzcfMWGsrUJFTjvwm4iOCxGFtLZsp1PDfFnVfltp4GPu7kIXh+PZW8sp5C
         ZYRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E3nnwRQVmPx0RnVlPvOQUeyhAGklO+sO+VnesiuX/yY=;
        b=fuCipaOuyT7UmRqcmgFDW4qt7YsO3ApodtG2zbCHZAhOjBNKPuEu/gP2jjQ1ZXKw30
         SMuJdK8IbfzOdoUN1PGrRB5Hf6iIu6x3Y58FtGTgYdrT0OrcoK5kHC2M69KZcP3f5Jjo
         c7y5xC49tx8rQjIA8vwQpa3i0DXFIBn+34CPcVtMDYg/66CEJ/4FnBCWIZPjPmyHiqmX
         4gdMwvItk0xK8ujVvbPUNylqdgV5El4/q/9edfK6x1MLpC67Fj6LYpqjHjW6dfzXAL90
         g5luBmwan8hunUU0WeHX88Jdf5CvtAUD5LENgVAqrI0TXZFMVlUzTZJqqth5+lkDOD+H
         e1kg==
X-Gm-Message-State: AOAM5309dml0xQaNHwg56nX/y/S7fo5xsDpFT0HQY/+bgnDBQ9G6TU/8
        zeFHXrzPA3yHrshnjI9ETqe5crVaXdoZR2vOwz0=
X-Google-Smtp-Source: ABdhPJzz3xU5n2qpLAOibXZAZbCTz0i+IvOfTNgATlTLwz42ikWywTzqgzucc5MtT5Ezvl45thcblGWmI605Fct7YWE=
X-Received: by 2002:ac8:2dc3:: with SMTP id q3mr1436840qta.141.1590646115344;
 Wed, 27 May 2020 23:08:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200527170840.1768178-1-jakub@cloudflare.com> <20200527170840.1768178-9-jakub@cloudflare.com>
In-Reply-To: <20200527170840.1768178-9-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 May 2020 23:08:24 -0700
Message-ID: <CAEf4BzZEDArh8kL-mredwYb=GAOXEue=rGAjOaM0qGjj5RG6RA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 8/8] selftests/bpf: Add tests for attaching
 bpf_link to netns
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 12:16 PM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Extend the existing test case for flow dissector attaching to cover:
>
>  - link creation,
>  - link updates,
>  - link info querying,
>  - mixing links with direct prog attachment.
>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

You are not using bpf_program__attach_netns() at all. Would be nice to
actually use higher-level API here...

Also... what's up with people using CHECK_FAIL + perror instead of
CHECK? Is CHECK being avoided for some reason or people are just not
aware of it (which is strange, because CHECK was there before
CHECK_FAIL)?

>  .../bpf/prog_tests/flow_dissector_reattach.c  | 500 +++++++++++++++++-
>  1 file changed, 471 insertions(+), 29 deletions(-)
>

[...]
