Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575DD231114
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 19:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732073AbgG1Rok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 13:44:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728163AbgG1Roj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 13:44:39 -0400
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CC3D21D95;
        Tue, 28 Jul 2020 17:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595958279;
        bh=sEmZiUgz/iXoEnUd+OL8Zyq392/Uwqkmz/LeFx/nF0E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ragbW06wdO0H0YeYjmG61axhlSPOYdhsgaS0ckbJg9Q+53Ijvb4MYB80L3v0PkijA
         GkAheJNfHCT/klAA8PNHg9D559372mBd7TiaVh4JooqVXxi/2i/ddZvPRnF7WKSXVK
         C5ka185UXBgiK3Y40XOn2r1NdU5FU5kmvxx6ton8=
Received: by mail-lj1-f174.google.com with SMTP id g6so9466163ljn.11;
        Tue, 28 Jul 2020 10:44:39 -0700 (PDT)
X-Gm-Message-State: AOAM531tzWw96qyo6ExtOL6XXqfXhGfjPGjvzOoIACPAMqvEbH9awQZd
        akpQs6LQDUYtZwZi+od40Hx1MIkvkHxz9s9oR/Y=
X-Google-Smtp-Source: ABdhPJxQ0qMoKzoL82JrsSyDjP/n2jChYdu2Z01ygtw6diN2oWroKRybrSKO8JuPwEU3ckOLBrugersjiwD0G08+IAs=
X-Received: by 2002:a05:651c:1349:: with SMTP id j9mr5882341ljb.392.1595958277527;
 Tue, 28 Jul 2020 10:44:37 -0700 (PDT)
MIME-Version: 1.0
References: <159594714197.21431.10113693935099326445.stgit@john-Precision-5820-Tower>
In-Reply-To: <159594714197.21431.10113693935099326445.stgit@john-Precision-5820-Tower>
From:   Song Liu <song@kernel.org>
Date:   Tue, 28 Jul 2020 10:44:26 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5nXGDLRg0AV7_YpMHxp9DAFfT6trP1fobuc6ZjdQcXng@mail.gmail.com>
Message-ID: <CAPhsuW5nXGDLRg0AV7_YpMHxp9DAFfT6trP1fobuc6ZjdQcXng@mail.gmail.com>
Subject: Re: [bpf-next PATCH] bpf, selftests: use ::1 for localhost in tcp_server.py
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Roman Gushchin <guro@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 7:40 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Using localhost requires the host to have a /etc/hosts file with that
> specific line in it. By default my dev box did not, they used
> ip6-localhost, so the test was failing. To fix remove the need for any
> /etc/hosts and use ::1.
>
> I could just add the line, but this seems easier.
>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Acked-by: Song Liu <songliubraving@fb.com>
