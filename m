Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7CF230222
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 07:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgG1F4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 01:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726615AbgG1F4E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 01:56:04 -0400
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B3BD2065E;
        Tue, 28 Jul 2020 05:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595915764;
        bh=2ynC5UqPXs3vgS5aQmcHk+CHSXl41vdPrJl0yFslsaI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=s2Zgn4rC6PvoM5dpRMCuQp89ukBxRnsw2U5TmCwWXCfwCxXv/OD9CuehQxrNKfk/r
         0FSOK3iwdFjwOYzv+sf4cxaoAoNuH12OQrs7mjkCk+Pm4Cp3Ztjfp5VI6Ya8tq+DUp
         Kh2+FNwtiMQd4h4C2UrPrkVQ75m6wvS9LcKlV2U0=
Received: by mail-lj1-f180.google.com with SMTP id r19so19750236ljn.12;
        Mon, 27 Jul 2020 22:56:04 -0700 (PDT)
X-Gm-Message-State: AOAM5326HzhO+XLDHmzOxgM9boahSZfflBC6q/FYPP6/w9cqkJnsXwhj
        SJHcfiwSV2nE2btSsrgKvgDqWKywQYLA3hFpHXE=
X-Google-Smtp-Source: ABdhPJzyy5pWys05ij97FFdNj49iiLBbdCXvoOe0+9lXEc/tyjOmJQofnVRs7ZrT8eHV/WOvANkdul4GuWGaM2+bH6Y=
X-Received: by 2002:a2e:9996:: with SMTP id w22mr12748866lji.446.1595915762423;
 Mon, 27 Jul 2020 22:56:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-29-guro@fb.com>
In-Reply-To: <20200727184506.2279656-29-guro@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 22:55:51 -0700
X-Gmail-Original-Message-ID: <CAPhsuW51oNcT297CYWAE53TrSMPrAqY+pof8oj2ED-trXVxgZg@mail.gmail.com>
Message-ID: <CAPhsuW51oNcT297CYWAE53TrSMPrAqY+pof8oj2ED-trXVxgZg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 28/35] bpf: eliminate rlimit-based memory
 accounting for bpf progs
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

On Mon, Jul 27, 2020 at 12:21 PM Roman Gushchin <guro@fb.com> wrote:
>
> Do not use rlimit-based memory accounting for bpf progs. It has been
> replaced with memcg-based memory accounting.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
