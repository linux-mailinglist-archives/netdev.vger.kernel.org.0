Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E2D3FB643
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 14:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236402AbhH3Mna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 08:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbhH3Mn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 08:43:29 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15F8C061575;
        Mon, 30 Aug 2021 05:42:35 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id n27so30848853eja.5;
        Mon, 30 Aug 2021 05:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/y2g9rn9wt5yjW/SBXP8IWmwro5UmCGX/CodZW4eBgc=;
        b=Mr2kTkdxRbciqEVlRnoacRmau33ZNX+QAN06nGpXy8NgHRjI1as+Ygh4MtDznwyT09
         No+0Ed5y1sQMIZJot7mDMO2Tm2QsAh+ZhNzls9dqp6p/nIRwyDMfMwrTzkQlnopxRfaC
         GkCNQhySbi57TfU0YsxQgYPGCD5E3KF55++w/u3NxGfeHy0TU81QCmgZ71nb8MODj2lb
         ReerPD83Z5pidzKRayYD3VYxq0c0Ymee3iknIihuaKEeACo7BVIhnM8780S5/gxkTKE2
         QkgOXMoDAbAa/N6nczGr6m+26Ox01J+hLhv+FnHaIYK+jw/IyJLw4o0A68QJE5jQsstK
         uhHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/y2g9rn9wt5yjW/SBXP8IWmwro5UmCGX/CodZW4eBgc=;
        b=pwqFLKdUScoEWxGFb9bBDX+UgYwpAcmyRzDorY5Nxyag9jTKOaUWtmA/+1nMLyRX2U
         ScWgpDfCYPDDeRYeCqcnnGmJArHmeMP1KwZ5dj0DTIagniDEsGlqMtURTa6G0uILcbqU
         WEbrhMrYt7ZXbR82eb3APGQYyxDkLCm5/kJ5pfn3z8k5hakOwX7ew8+aEXcgTqDZvQgP
         kHrUp5UTL1ihBJ0brKLhyy8aZuccEMvMSUpC37j3H06rZYzGk2qWLUE6S/WyeftrkbxH
         spla7IbfmlFlnqe5KV6EnIK+KRrk6oVrREH4NArIvBZMDSkOU49ulT4L0JogJU5hHQlg
         4Frg==
X-Gm-Message-State: AOAM5332qgILl4Vcgy8Klh3YtEolLhczjh2RCa+KluVEaFnrL837kKee
        x2MmStkqN8RDhh7HzsalLfgs/aHQ71cfimOWQ4Y=
X-Google-Smtp-Source: ABdhPJxLsU1VpQW2C5CLwFCRKDZxkKyXVnbDoc74eSqeDsOw9goTMJEktW3Hwcg/qINw7EDeyKOq6f2LeB5ngfp/vUQ=
X-Received: by 2002:a17:906:a3c3:: with SMTP id ca3mr24873332ejb.337.1630327354264;
 Mon, 30 Aug 2021 05:42:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210830115942.1017300-1-sashal@kernel.org> <20210830115942.1017300-13-sashal@kernel.org>
In-Reply-To: <20210830115942.1017300-13-sashal@kernel.org>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Mon, 30 Aug 2021 20:42:08 +0800
Message-ID: <CAD-N9QUXXjEMtdDniuqcNSAtaOhKtHE=hLMchtCJgbvxQXdABQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.13 13/14] net: fix NULL pointer reference in cipso_v4_doi_free
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org,
        =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>,
        Abaci <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 8:01 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: =E7=8E=8B=E8=B4=87 <yun.wang@linux.alibaba.com>
>
> [ Upstream commit 733c99ee8be9a1410287cdbb943887365e83b2d6 ]
>

Hi Sasha,

Michael Wang has sent a v2 patch [1] for this bug and it is merged
into netdev/net-next.git. However, the v1 patch is already in the
upstream tree.

How do you guys handle such a issue?

[1] https://lkml.org/lkml/2021/8/30/229

> In netlbl_cipsov4_add_std() when 'doi_def->map.std' alloc
> failed, we sometime observe panic:
>
>   BUG: kernel NULL pointer dereference, address:
>   ...
>   RIP: 0010:cipso_v4_doi_free+0x3a/0x80
>   ...
>   Call Trace:
>    netlbl_cipsov4_add_std+0xf4/0x8c0
>    netlbl_cipsov4_add+0x13f/0x1b0
>    genl_family_rcv_msg_doit.isra.15+0x132/0x170
>    genl_rcv_msg+0x125/0x240
>
> This is because in cipso_v4_doi_free() there is no check
> on 'doi_def->map.std' when 'doi_def->type' equal 1, which
> is possibe, since netlbl_cipsov4_add_std() haven't initialize
> it before alloc 'doi_def->map.std'.
>
> This patch just add the check to prevent panic happen for similar
> cases.
>
> Reported-by: Abaci <abaci@linux.alibaba.com>
> Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  net/ipv4/cipso_ipv4.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
>
> diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
> index e0480c6cebaa..16bbd62db791 100644
> --- a/net/ipv4/cipso_ipv4.c
> +++ b/net/ipv4/cipso_ipv4.c
> @@ -466,14 +466,16 @@ void cipso_v4_doi_free(struct cipso_v4_doi *doi_def=
)
>         if (!doi_def)
>                 return;
>
> -       switch (doi_def->type) {
> -       case CIPSO_V4_MAP_TRANS:
> -               kfree(doi_def->map.std->lvl.cipso);
> -               kfree(doi_def->map.std->lvl.local);
> -               kfree(doi_def->map.std->cat.cipso);
> -               kfree(doi_def->map.std->cat.local);
> -               kfree(doi_def->map.std);
> -               break;
> +       if (doi_def->map.std) {
> +               switch (doi_def->type) {
> +               case CIPSO_V4_MAP_TRANS:
> +                       kfree(doi_def->map.std->lvl.cipso);
> +                       kfree(doi_def->map.std->lvl.local);
> +                       kfree(doi_def->map.std->cat.cipso);
> +                       kfree(doi_def->map.std->cat.local);
> +                       kfree(doi_def->map.std);
> +                       break;
> +               }
>         }
>         kfree(doi_def);
>  }
> --
> 2.30.2
>
