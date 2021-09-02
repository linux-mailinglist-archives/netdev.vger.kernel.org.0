Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E693FF782
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 00:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347912AbhIBW7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 18:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347813AbhIBW7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 18:59:35 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208E8C061575;
        Thu,  2 Sep 2021 15:58:36 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id c11so1567408ybn.5;
        Thu, 02 Sep 2021 15:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AyGGknhvkgNtNvMdUjTmJ2dDGbFKfZvEY2DbDsh57t0=;
        b=WMuzBHg/3xw/HEna+SB+AnTobrdXxb9/VWjRWZQpb6CprRtT6FKaYH3KXhyQPMmxnk
         TIRv8Dv98kLmWE9lK7qUH8cy999yDjF+v9Mhm+psrbujgGSM4nyRmlv52HyPxTx/magH
         7oHmGuLZZuvnaChDEH64u0xdzzpzIIPoet5PVzFPy1HrEwhkG2GaA7EaGpmEWlCaRD57
         P10ibJ4+pJO2ei3gecdJfvY2hgOYM2UeIW4AgfIzKU4B6ll5yIGtB849fpMJ97h4N26I
         JVBws6cGkUcFDMO46b16b5eEbU+pYzw4wTL2wKXugbO814rqULBWOviXt78qPb0DHlkX
         dhkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AyGGknhvkgNtNvMdUjTmJ2dDGbFKfZvEY2DbDsh57t0=;
        b=p8eYNU5CABMdAGhQK/oqx8H3SLWwXbWMgWHR+H5Lw94qwMEOwh8U6iUhO0sFfq6ct6
         abEY7ukdwbvL6iidt0C5oJIEb04wJ6nbxWNyZ24WKLJixUaZBJm5c2nbBxxnoA6ajKrA
         snL6tvRe4wFyb7Z4uh2nNLaL66VnubBgx2C5YdgYNV7Q/4XtePYn9CxTs4KhrE/MnheR
         kBXwkFRotRwGjJCeyQiZEmlEPBKfShPU25xSsjpSePmw+XaynDTqKNDdGFBRgpCZOnKP
         gVXBxUFjeSqpSDnP3VTuh0McKsuQoNd7xH55TwS+gj4Uqp77J2uyM2dgozCnLU3i+4Ro
         tGAA==
X-Gm-Message-State: AOAM532aoSl9YZmzGV1wkoKRFK80nqKu1/34LwVbcEEDddNHNP+czNat
        1XxRA5agR1no9/WyZuYNM/81KujrNvUiFfmU0S7I723bUPw=
X-Google-Smtp-Source: ABdhPJwqlfzJs562LRaqbo5k9T8TKcpnG75bOVOZZdSvpVIxe53iINEtYkeFmkDRdgsSln2+CMG4lD2iwXHbrrDzp0o=
X-Received: by 2002:a5b:142:: with SMTP id c2mr902806ybp.425.1630623515484;
 Thu, 02 Sep 2021 15:58:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210902171929.3922667-1-davemarchevsky@fb.com> <20210902171929.3922667-3-davemarchevsky@fb.com>
In-Reply-To: <20210902171929.3922667-3-davemarchevsky@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 2 Sep 2021 15:58:24 -0700
Message-ID: <CAEf4BzY_WtmNoJ1BGnVOGGeR1BKcqtL9n5rBxxRBurBjQNj0HQ@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 2/9] selftests/bpf: stop using bpf_program__load
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 2, 2021 at 10:20 AM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>
> bpf_program__load is not supposed to be used directly. Replace it with
> bpf_object__ APIs for the reference_tracking prog_test, which is the
> last offender in bpf selftests.
>
> Some additional complexity is added for this test, namely the use of one
> bpf_object to iterate through progs, while a second bpf_object is
> created and opened/closed to test actual loading of progs. This is
> because the test was doing bpf_program__load then __unload to test
> loading of individual progs and same semantics with
> bpf_object__load/__unload result in failure to load an __unload-ed obj.
>
> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  .../bpf/prog_tests/reference_tracking.c       | 39 +++++++++++++++----
>  1 file changed, 31 insertions(+), 8 deletions(-)
>

[...]
