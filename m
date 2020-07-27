Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 317F522FC2F
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgG0WbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 18:31:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbgG0WbG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 18:31:06 -0400
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C50C20809;
        Mon, 27 Jul 2020 22:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595889066;
        bh=qMuXFcxMzvx0mR2Biber8GcV8u6iEgvTEwiheu9UbUY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=X4iRIY3OfKc7Jwfh6wmN9Yck32tyIDP+1owICcoXSqmzvU/wnmwLf80pzW1WG/ky8
         CpYd2DopQ+sh6RgwBJO4mfKGdyFjxcmLYBvybwuJV5tv4ZqocbgWgk8obrWOL39H/4
         jyjcpHLgvYSUmooeGaIR9uKc5SXOaq0D3Zy5MHIo=
Received: by mail-lf1-f44.google.com with SMTP id y18so9871447lfh.11;
        Mon, 27 Jul 2020 15:31:05 -0700 (PDT)
X-Gm-Message-State: AOAM531MyayPYARMPI0RbmA11ro8oRYCXV/sHwqHJyMI72p3ZjiW0PFn
        W6ewrATd43msSn5lZ02Gbe4CXgMhqzgu75rb5Y0=
X-Google-Smtp-Source: ABdhPJyJSqwhde6IDem+A6PjaWq4kjB6gFsq4cNlr0EjJLJzkamOrulDaGuXrU6p2F3xlha3/Xw72kZNyQiWhIvqqUI=
X-Received: by 2002:ac2:5683:: with SMTP id 3mr12510015lfr.69.1595889064422;
 Mon, 27 Jul 2020 15:31:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-4-guro@fb.com>
In-Reply-To: <20200727184506.2279656-4-guro@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 15:30:53 -0700
X-Gmail-Original-Message-ID: <CAPhsuW49Yo0WEDuNoujKtSwzKtBU3b4axuB=Z7rWTH78hrYgsQ@mail.gmail.com>
Message-ID: <CAPhsuW49Yo0WEDuNoujKtSwzKtBU3b4axuB=Z7rWTH78hrYgsQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 03/35] bpf: refine memcg-based memory
 accounting for arraymap maps
To:     Roman Gushchin <guro@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 12:23 PM Roman Gushchin <guro@fb.com> wrote:
>
> Include percpu arrays and auxiliary data into the memcg-based memory
> accounting.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
