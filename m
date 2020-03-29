Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39128196FD0
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 22:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbgC2UGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 16:06:19 -0400
Received: from mail-qv1-f66.google.com ([209.85.219.66]:36197 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727933AbgC2UGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 16:06:18 -0400
Received: by mail-qv1-f66.google.com with SMTP id z13so7879818qvw.3;
        Sun, 29 Mar 2020 13:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=clV/nV6Zb0cjtGaQvCtq+1M9ztNWB5uAj2YeO5WNnhk=;
        b=J8wrY7yd6jQ93G+M0i+HSaOFCZY3yfouXmtVz0KrUKOcVMKEuLy4Gg1IXbZrKboj3I
         HZSQKmjbnXE8MIxL5bsW+6Rx6gjfm3JYPkogy+wayzV/vTv4WFhaXJ4vZl2aNP3XvSZe
         cixKPTXFajAQUW7P8d77JDRb+nE1xaue713ynPT1+9eKiyJjZazuhKeA3IfnOlkqC8LB
         9WMtUbn0RxjXxO+NpsyLVxk3r/CyXsP0e62dz6N6tMiDH68aiFRGQ5JG9Ps0SSaeGv2H
         3kKwKt14oVU/7w2j3ZO0GS6xFnS9GgBuE3Bou8KuVwOwlKRX9gu6qLstIYP42K0R4ywc
         2s/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=clV/nV6Zb0cjtGaQvCtq+1M9ztNWB5uAj2YeO5WNnhk=;
        b=KJK9RBSkA082tCnOKVbs1nqzO+nQB6pCZDeDtvZSin8t6Rud59+vqLchU5KbRDtlNa
         ZKuqYybWYXaHIWE/Z2AR5RP8loxcbArwu5Z81r6khSsVztsxEmfOYUHRcdtXVRMPYY23
         vt2V9fxEDdsKpSwbSXz3WSAsuZMHyq4JlMLVnOfVzuXyJKJ1AjE9ogwOHFpGpoivmbcG
         +HZs5+SuiTWmArXP3Uoy4RgSMwE/bu//jkx07i6V1UFZ9NvvSNswlrI6Z5ila5XH4znl
         bQReIxIGokmAg+BZw0zDU6WnA7Us+QCx7Z0oaCUFwT3CyZwbVEo3cfY2jQDRki35w6rP
         uV6A==
X-Gm-Message-State: ANhLgQ200eYyIOiPY04XcPBNz48Fz3fXuP+CU/kv8e45nH+gnElx5Nsa
        GxngMn5vC+TMLdXmClldYNt0n0bmyfgz3PdrKHyz+PU+
X-Google-Smtp-Source: ADFU+vv1hxBgjqx39VD8aj6P0TppxO180DfynVP/F+jRJ5CpLDd/BiLoxpx6gODSv/megYiGTeH9qBZv72tabitgHbw=
X-Received: by 2002:a0c:bc15:: with SMTP id j21mr8420435qvg.228.1585512375542;
 Sun, 29 Mar 2020 13:06:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200328182834.196578-1-toke@redhat.com> <20200329132253.232541-1-toke@redhat.com>
In-Reply-To: <20200329132253.232541-1-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 29 Mar 2020 13:06:04 -0700
Message-ID: <CAEf4BzZpd_SMqsJx7UjZDUZk9UY48D2RVW2ero+Rg7=HPzRo=w@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] libbpf: Add setter for initial value for internal maps
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 29, 2020 at 6:23 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> For internal maps (most notably the maps backing global variables), libbp=
f
> uses an internal mmaped area to store the data after opening the object.
> This data is subsequently copied into the kernel map when the object is
> loaded.
>
> This adds a function to set a new value for that data, which can be used =
to
> before it is loaded into the kernel. This is especially relevant for RODA=
TA
> maps, since those are frozen on load.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]
