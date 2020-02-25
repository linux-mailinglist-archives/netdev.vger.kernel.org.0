Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA89C16EBB1
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 17:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731215AbgBYQqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 11:46:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:47938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730312AbgBYQqG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 11:46:06 -0500
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A2932051A;
        Tue, 25 Feb 2020 16:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582649166;
        bh=qiJqznaWPqKEkakh/aIZGCGD4EZNREBGaBobu0Q0Sxc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VrXq7ucjz6Xx/uTQMh8WNMXlWqGTQn7VST/pCtHdXuSIa3D45bc+4xadvolpAouJ9
         nIRLaPUlRZFzwP5XR0fsqSMuNPzjpzxftLhWzbeiZpbdhWgPXsDAELF0DHYQbPDRJu
         YNXyeMnPxP4RjgjYR3MQjEsgj0MCbAYERuHC3hKA=
Received: by mail-lj1-f171.google.com with SMTP id q23so14818497ljm.4;
        Tue, 25 Feb 2020 08:46:05 -0800 (PST)
X-Gm-Message-State: APjAAAVJ7JWxwflHHJI1+doOG56ofvxXKYFwpVTfuu1vc9lX6QuG24rs
        sy35f4zxywpYY7CzE6T9VYo91u0n1ec7AElCG+A=
X-Google-Smtp-Source: APXvYqxlg46tx9KoEz24hEL0ybYK7EUkQPJWXJ9yrC3yj7Ci9naoioeUOpC41QIEcGt0wLSzjPZmZVjTgtlO3+3GbP8=
X-Received: by 2002:a05:651c:8f:: with SMTP id 15mr15132189ljq.109.1582649163803;
 Tue, 25 Feb 2020 08:46:03 -0800 (PST)
MIME-Version: 1.0
References: <20200225135636.5768-1-lmb@cloudflare.com> <20200225135636.5768-2-lmb@cloudflare.com>
In-Reply-To: <20200225135636.5768-2-lmb@cloudflare.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 25 Feb 2020 08:45:52 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4WHyBYM0kbS_CQyRTeNvgM-DULA+R7TgkTFLnPec7inQ@mail.gmail.com>
Message-ID: <CAPhsuW4WHyBYM0kbS_CQyRTeNvgM-DULA+R7TgkTFLnPec7inQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/7] bpf: sockmap: only check ULP for TCP sockets
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 5:57 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> The sock map code checks that a socket does not have an active upper
> layer protocol before inserting it into the map. This requires casting
> via inet_csk, which isn't valid for UDP sockets.
>
> Guard checks for ULP by checking inet_sk(sk)->is_icsk first.
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>

Acked-by: Song Liu <songliubraving@fb.com>
