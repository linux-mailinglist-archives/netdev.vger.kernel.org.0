Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A87EA16F2DA
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 00:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgBYXBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 18:01:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:41008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726827AbgBYXBS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 18:01:18 -0500
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FE44222C2;
        Tue, 25 Feb 2020 23:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582671677;
        bh=dX3IH9+5MjEzzkpanrcFRcHLXK3db4PSfS7mYxOwq5I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dK7Qh1V+/6N9Ri6cBZVJJAyuxHrt62nYmzLwNHeF5eLsgRwAg0AlLDfRuabi5Ael2
         lBw+YxKraYNgvJxltcWbxv30vto+EjhtGNF4YMhD/g598FAdKSWrYxUJsFPlYiCqHe
         HvQXtPDf6n6Nws2JRCGkXUxKanHv1tM1potbJUio=
Received: by mail-lj1-f173.google.com with SMTP id o15so756414ljg.6;
        Tue, 25 Feb 2020 15:01:17 -0800 (PST)
X-Gm-Message-State: APjAAAUAV/x1lOByHgfTvDol0laWvUaJ9Pwoi8K+zaWivxP9OY3JPCe0
        zvHLa95BTm3Y2xVh7BA4xKJfI5zF7Uv8VDNtqA8=
X-Google-Smtp-Source: APXvYqyWPLHEoDNa6vGMqUhEnWzOeu73cs3upPf8yYw4aW/Tm/zxrPw4BfXF/A8nCsyx+Fa3/MbFo/fS+xU0rdej0KY=
X-Received: by 2002:a05:651c:239:: with SMTP id z25mr778144ljn.48.1582671675745;
 Tue, 25 Feb 2020 15:01:15 -0800 (PST)
MIME-Version: 1.0
References: <20200225205426.6975-1-scott.branden@broadcom.com>
In-Reply-To: <20200225205426.6975-1-scott.branden@broadcom.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 25 Feb 2020 15:01:04 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5h9FoYxzMFmKwMOKktn_a0uej2tmmGoXXfq2RtThAF8A@mail.gmail.com>
Message-ID: <CAPhsuW5h9FoYxzMFmKwMOKktn_a0uej2tmmGoXXfq2RtThAF8A@mail.gmail.com>
Subject: Re: [PATCH] scripts/bpf: switch to more portable python3 shebang
To:     Scott Branden <scott.branden@broadcom.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 12:55 PM Scott Branden
<scott.branden@broadcom.com> wrote:
>
> Change "/usr/bin/python3" to "/usr/bin/env python3" for
> more portable solution in bpf_helpers_doc.py.
>
> Signed-off-by: Scott Branden <scott.branden@broadcom.com>

Acked-by: Song Liu <songliubraving@fb.com>
