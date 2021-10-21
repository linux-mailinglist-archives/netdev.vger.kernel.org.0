Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7794363FC
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 16:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhJUOXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 10:23:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229878AbhJUOXT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 10:23:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD58E6120F;
        Thu, 21 Oct 2021 14:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634826063;
        bh=K1mVAiZY3QCzsEqJRt030f++/FB2ceg7vQK1ngPW9mc=;
        h=In-Reply-To:References:Cc:To:From:Subject:Date:From;
        b=fd6x3EBem2qsGLGzJo+RvH5GDOvHwzRAoxigEvnczby9yRlQnwOjWgiUhY0MxZhGP
         PhM2FXkDpNRC5zeFBUg6wBWqx0zotVy3wQnpcjdGpaP/ZjYgSH4EwmJX+20ch8xyvA
         MBBM1sfJAuvbMvXhFOVNRUQ8n+OLD8/beAhAqfLg7gsmM+SMi4dEbYBt5Mej24QXwW
         UNvhoU/Ijo6tB9Ns9Hzocmjietvlb09sEVwbRYsS4Qpsc96FfXCJ2LIqBWvuNJI2xY
         J1sGiyvUWD1YeLqTamolmEQnorWejiidMH+d1rouHUj00Cz5eWEojlS3hxFnn9LNMh
         sLZpD8Lm+cgZA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20211021140247.29691-1-fw@strlen.de>
References: <20211021140247.29691-1-fw@strlen.de>
Cc:     dsahern@kernel.org, Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net] fcnal-test: kill hanging ping/nettest binaries on cleanup
Message-ID: <163482605999.3319.3686668821047509926@kwain>
Date:   Thu, 21 Oct 2021 16:20:59 +0200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

Quoting Florian Westphal (2021-10-21 16:02:47)
> =20
> +               ip netns pids ${NSA} | xargs kill 2>/dev/null
>                 ip netns del ${NSA}
>         fi
> =20
> +       ip netns pids ${NSB} | xargs kill 2>/dev/null
>         ip netns del ${NSB}
> +       ip netns pids ${NSC} | xargs kill 2>/dev/null
>         ip netns del ${NSC} >/dev/null 2>&1

Alternatively you can use `xargs -r` (`--no-run-if-empty`) to avoid
redirecting stderr to /dev/null.

Thanks!
Antoine
