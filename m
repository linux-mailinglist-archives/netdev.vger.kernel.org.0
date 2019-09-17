Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55FEDB563C
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 21:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfIQTf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 15:35:56 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42223 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727459AbfIQTf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 15:35:56 -0400
Received: by mail-qt1-f195.google.com with SMTP id g16so5870916qto.9;
        Tue, 17 Sep 2019 12:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+9uabsN39tgCQlv8HKCGkfQaRq1Aq9okGyjh2Symb3U=;
        b=CAwWRABGG1+3MQrHmuOROEX8Y4ZevX2ZLOhMplfpbpD7AMHZMNhfZIllL7fFaKNgU+
         BOjt2oS4NUVjkEKqUUKQ98Ve+AwjR4dO0kGPIYuZ+TxjD+QWQ2ykfb3UCQAfvV9ISHCt
         ENX+J3shg22kmroK4fOHQs0XEi+bMsfVWOHoVz2dFd+OtKe/SfAj2+Hgmt7TnrfD5XQd
         ED6mXepV7RqSj9sx0+on8v5u0y/GrURIXCRXi+cYjyZvbMTeNs4aQh+ywGMfEnbMisn4
         qFo7hk0Jg/0p2op2oQIxz87ROyaJc0nVlE7QOTjn0aQ8lpRufGq6rVm6scHQatUcAMIt
         TPFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+9uabsN39tgCQlv8HKCGkfQaRq1Aq9okGyjh2Symb3U=;
        b=PCvKyEw5uQ7JW5uoZSgf6uRX0nUvwBxNYJWTQgsyuiQAq7EwvFbUDfglGyXs07RAaI
         T/jso7jtl+/Zeymg9HM8RumLPXVbaQ+cE0DwGX+Sfbm2grRdn3LPv+iaVxFa9OFwgdIJ
         12grgLnTX4xxMRaiFSsQknNavqzJBsSun8I4KxbzgFZL0aArUHAp7lBkfXC41DPCmC33
         3sYBgCN4244e10RVFgSDujdWk5pdgJwDkTHccu97pkl/FKPpuW+JKjPa0Nrn76f6PTnF
         nG20SBCilmMKdboj5Hg6BiF/9VQeM1jJHRSoWSzmqZJm6i+rqJa3XOJY0Mquyz0LFlgH
         lgcg==
X-Gm-Message-State: APjAAAWrptbqYsi0w4BNoS0PfMWFKxGpzE/61KyHcYrgLhWGJYeVeE1y
        Nlrp+gDQDd2AA9JPwEcWWewr/TEeD4OyOPR4KZM=
X-Google-Smtp-Source: APXvYqzGx1aRpoOnf+87U43ghlwCnLzwOfUiVtvB4duW4BHsAPbX7+fRif2o2jCuGueONyoIViOSu7QwaWSoUtvfWQw=
X-Received: by 2002:ac8:5147:: with SMTP id h7mr488749qtn.117.1568748955260;
 Tue, 17 Sep 2019 12:35:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190917174538.1295523-1-ast@kernel.org>
In-Reply-To: <20190917174538.1295523-1-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Sep 2019 12:35:43 -0700
Message-ID: <CAEf4BzajByePHPbVMz4t9Aexwumee3f9Y0=VegDd-6smYheBjQ@mail.gmail.com>
Subject: Re: [PATCH bpf 0/2] bpf: BTF fixes
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 17, 2019 at 12:27 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Two trivial BTF fixes.
>
> Alexei Starovoitov (2):
>   bpf: fix BTF verification of enums
>   bpf: fix BTF limits
>
>  include/uapi/linux/btf.h | 4 ++--
>  kernel/bpf/btf.c         | 5 ++---
>  2 files changed, 4 insertions(+), 5 deletions(-)
>
> --
> 2.20.0
>

For the series:

Acked-by: Andrii Nakryiko <andriin@fb.com>
