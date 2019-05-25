Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C21752A274
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 04:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfEYC7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 22:59:02 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38917 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbfEYC7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 22:59:01 -0400
Received: by mail-lf1-f65.google.com with SMTP id f1so8429613lfl.6;
        Fri, 24 May 2019 19:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I42CaPGNEMCFp3CHpIjUQ2oZUjvywz2zdl78AKj9zEo=;
        b=Npl7JritObxy1JJtlBqRQBvGcd9kLRUokl3Hh45MqZDJO+4MrshCR34M05VrIvOl5Y
         7f9W+Y1KJ86KiuCVz9dvL0lNdu9ZB0+6wfr1n4Ik1zPE/CqBALBGRxFt9/0+iL3+vlLV
         +l4y/No601fB74ol5PrSq7LUUCjkSanJhME/4DlQgANAb0rAnO/AczsBVXIhfAu4iq86
         OiVQZctd9z6t9w6I32409WzNDlo+fNLX7t/y8in8Kvqq1sJp8BYRt/xSrZmNwXZFm1Gt
         +bFok46TVwxJQKsLBcMyCBz3IRZK709ykkEj1oG3cA+YFod+3jEhl1X9VeJCalvWbnOQ
         uoZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I42CaPGNEMCFp3CHpIjUQ2oZUjvywz2zdl78AKj9zEo=;
        b=uIbf4Lv2zMdso44WPiDq8Nz/90msMFojMHBcbEi9Lw/UxCNGCgXngPcexWu4uZq6Uj
         bdCiYmlGJmqpk92POJhRBfzzsGLgLEF+KA1LA0mzx38u6woZy7o9Kv2Enml3VuyT2zJv
         3vpAUv4jEWltjFbxhwFUtXlpjVERxAsaKNShurzCZIMyYmtgq9ZtzqM9zVMZ/QwwjxmZ
         8gw79dAhBWLu73O1t+/acJtamJbiSzP7rYlZlKWPgvEjbzwxtmlBuoLFXZ07tf47pmmH
         21CfwEpaGXykK1tRkykD/W6eI56Val2O9QVG2NSsFaWfKYWRRKvMBmrfITC4xdnJu74V
         zzOA==
X-Gm-Message-State: APjAAAVfGWqJIIfAoZDtAAi2+YpXeVP39x5P/97pGjYa5ZBbMqG8pKnl
        i4gKeYltN9nUfY47EnmbBMmWCtP3AsFvyKh+87Q=
X-Google-Smtp-Source: APXvYqynMZ4i/b/sNcnC/qUMa8ryVMxbvDaU/zePZGwG5YMv1GIvEFr8MFNfQCSXwi4k+SgGsgWFtuR4Yx6yDk7DpWA=
X-Received: by 2002:ac2:4252:: with SMTP id m18mr19148041lfl.100.1558753139417;
 Fri, 24 May 2019 19:58:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190524195912.4966-1-mcroce@redhat.com>
In-Reply-To: <20190524195912.4966-1-mcroce@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 24 May 2019 19:58:47 -0700
Message-ID: <CAADnVQJzb7ruKZu1Wr8=S6J4Yp9tw_kX0tKEL1FrZroUwy4j7Q@mail.gmail.com>
Subject: Re: [PATCH bpf] samples: bpf: add ibumad sample to .gitignore
To:     Matteo Croce <mcroce@redhat.com>
Cc:     Xdp <xdp-newbies@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 12:59 PM Matteo Croce <mcroce@redhat.com> wrote:
>
> This commit adds ibumad to .gitignore which is
> currently ommited from the ignore file.
>
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Applied. Thanks
