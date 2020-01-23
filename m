Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24E52146F99
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 18:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgAWR01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 12:26:27 -0500
Received: from mail-lj1-f174.google.com ([209.85.208.174]:33957 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbgAWR01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 12:26:27 -0500
Received: by mail-lj1-f174.google.com with SMTP id z22so4456075ljg.1;
        Thu, 23 Jan 2020 09:26:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5whUSi8KAmuIHHfju4XzyJjxS2rFkZ3eJlyu7GpHMr4=;
        b=E7b5XB+XY77kZYppGQ5V7DLnxV/rwhgC5pOQXNyZa3BEzjeFs8nTllQs9gGpmqiGwb
         MA7Uirc0LDcTM+DWVF2WR1KEgNliWRxPAOmwRjiHL4OnkdDcKEBwYRYdA2LOtbNyvu15
         nCN8MQXzXHjRdjQAuPzJCwBGFIcrXBTbmvsDfXJSmktiPJdds2laQSTqxyrWVljYpfWX
         LqbPmbwdK+CRiTkabFp8VgS3X4zlfDrjLjx9qAL8NlikLnk6eomcISGJJOXSrm37e+MT
         iLdd29ga5yLPHjnh/MMgFn3TAUEsV0EKZ3MfVE9R+tlKkAdf9jDhO202WVlKzfZiRa+g
         Sz6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5whUSi8KAmuIHHfju4XzyJjxS2rFkZ3eJlyu7GpHMr4=;
        b=uEqh+0bBlKPliDJr2ynuDbN0WxmPVQLRozNhndPXvD3uFMFSd5oNJkHMyu8WrGXWwt
         jBM726cWZomzxK1UH+JhUzVWBlL4ZZ2ysBdPqj8vLMtzyVfRW9sXNxAYZubnPhgTQPYD
         fSZtVNzl3oAze8tR5cKoxul18IjpT67JkFKRjTdx1YVyfbm8IP1IA0V+xJjV5MzLdg7l
         ek4u0hMf0nOwrMyZCtN6V2rAEUJV8Q4B7OwGAt8Cd1rCMwkgllQUdDb+HiuinDAZwK8J
         g6bu9TvxobYweML91VOozOYWPLvKxIlk5RZOlzpwHp0xrIsRlaWbG0Nyg8VgGoOEp8rS
         y95A==
X-Gm-Message-State: APjAAAUlnZ8SD8YgrDbvVuM0g5iUL5nSxqYsuZttk69VdykrywwDX4f5
        eiYmwzbodCaHx4/FDlyInBRC9QegrBRtxbFeHb8ifw==
X-Google-Smtp-Source: APXvYqxr6LzV3bJSM4XLRnUv7Pzujmt+riQshJzNUj3hPy8acHYQwZNPi2H5JDWsEBGqJzu0UoqwCEW73bziYOdxjpo=
X-Received: by 2002:a2e:89d0:: with SMTP id c16mr23639017ljk.228.1579800385023;
 Thu, 23 Jan 2020 09:26:25 -0800 (PST)
MIME-Version: 1.0
References: <20200123005504.3291378-1-ast@kernel.org>
In-Reply-To: <20200123005504.3291378-1-ast@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 23 Jan 2020 09:26:12 -0800
Message-ID: <CAADnVQJTLVe0ESf_JQfPbDpx88yz7P3Br3Vvia6CYmLv2URCMA@mail.gmail.com>
Subject: Re: pull-request: bpf-next 2020-01-22
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 5:42 AM Alexei Starovoitov <ast@kernel.org> wrote:
> The following pull-request contains BPF updates for your *net-next* tree.

fb mail server was misbehaving yesterday. Sorry for the spam.
