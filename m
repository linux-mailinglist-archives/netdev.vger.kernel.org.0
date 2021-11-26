Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6B445E7FB
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 07:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358871AbhKZGpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 01:45:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:42890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1359031AbhKZGnJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 01:43:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80B566115C;
        Fri, 26 Nov 2021 06:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637908797;
        bh=O7ZYLDzQUdSPy3GFDs+ArBrvvvqtUoLlagY/ZqJed+0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=vD4DsrxZQ+6P9k3Q+pDzD76YeNunhQFSsCgkRkWHHW++/qszLA+RkURif4YJ61K5e
         7bnIqvzCdqW/O5pTh4cjuUOMUAbMf0oNFTm7lUaJmmkFrfP6BMECO2A8AXBfSiYqaC
         gWh73aRrlDD0YoPIJ/5mUmXIO6CRR9LztK3uTpHwhg0xb+ZI0kwYUuTcq7vYG2Vebx
         xIvaJpP2BgxIUdMzZRZKiUeEYlJvu0xC5QkAlm9f7QHauPOo6BL79fmip34NVXYaab
         meuIAJE1OlQfsuABqHa4ykJS2nm8jcZaPhwVzYvfvAiHY8vZiaj6NLNfWZ40s4H0Pu
         dsdIeEDkdHNTg==
Received: by mail-yb1-f172.google.com with SMTP id v203so17602725ybe.6;
        Thu, 25 Nov 2021 22:39:57 -0800 (PST)
X-Gm-Message-State: AOAM531gusUWnJV7UV6enudOIRWHal6fn2EybgyU2gpH9jFEb3wxEgT5
        cc6J3bwH+BXrmV+4wY1WecLvUhgDk+CN9px3f4E=
X-Google-Smtp-Source: ABdhPJx3nR+Fkjbjutp04yBa9+EekoW/kqncv3wQYigrCZRa+Q562se0k9mgQdF0nvEqOcr9l+W3nJarDejeQ5Tz7DA=
X-Received: by 2002:a25:69cc:: with SMTP id e195mr13057388ybc.456.1637908796787;
 Thu, 25 Nov 2021 22:39:56 -0800 (PST)
MIME-Version: 1.0
References: <20211119163215.971383-1-hch@lst.de> <20211119163215.971383-3-hch@lst.de>
In-Reply-To: <20211119163215.971383-3-hch@lst.de>
From:   Song Liu <song@kernel.org>
Date:   Thu, 25 Nov 2021 22:39:45 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7-N3sW+erUzobP95qJ2p++=wmqZN_gSsqeK26GknFYUQ@mail.gmail.com>
Message-ID: <CAPhsuW7-N3sW+erUzobP95qJ2p++=wmqZN_gSsqeK26GknFYUQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] bpf: remove a redundant comment on bpf_prog_free
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 8:32 AM Christoph Hellwig <hch@lst.de> wrote:
>
> The comment telling that the prog_free helper is freeing the program is
> not exactly useful, so just remove it.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Song Liu <songliubraving@fb.com>
