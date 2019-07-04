Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 909B05FDCA
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 22:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfGDUae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 16:30:34 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46621 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbfGDUae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 16:30:34 -0400
Received: by mail-lj1-f195.google.com with SMTP id v24so7164783ljg.13
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 13:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dev-mellanox-co-il.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hDvNGTfpzti9ZMevfZxr+UUXUVHDJdSxhTZfmsWYqHo=;
        b=YXrdw14IN06jCfqJuiPtx6MNvsbgBbkbmODggNSGKWmam4qcQNQseuibRExwBcmYDn
         n4kEZbNr29QiFYWuH8YF4i92HEhNHTVoqm0w3wz7BIsf+MCW5F8tBx1jnda9qSsXE3re
         hO+FXQRWsxqNUx5EJyz+4GqFaak9jqc0G7ci6IVlqCmRTGV2Ds0Iye5/P4s+tKWUpuN3
         ZZtNzgIvuoD+1aH6dlnUQL7cvHpGXr0hA+53GJW6w6+zGsAfxabTejr+UcL5Jjh+umE2
         LjmPjZd3fyAiycgS2KBd+qK+WBhZ03vvPeuQVnOmU+54yyckh8s/+lrAwxeQWJN/bvVE
         UEKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hDvNGTfpzti9ZMevfZxr+UUXUVHDJdSxhTZfmsWYqHo=;
        b=d6XfqdghIqfYGIlYq6WHRf6jUg395rHj6eQuyli3zqbA74jQQBC2Q5Ncjxi1P6XRQS
         ys2iVlfDGxbvpBAfPxkKKe8oBog108aQaN7RgMTy0MmZJ3uyLA8BBk2RJkoC6jO0akv3
         2Y93+vMmfWQat+0upiRZnUuXMLD69ln1KJaqSSudMgI8nSfiitmwrP9+kiTgnZujjygi
         H9hVVUip47dUNoSy26gojFfvBKn6OTukKKDZIG+V9aFswTqPkyzsUkiXiXHIJtyoOBXY
         7w4vNtOlcsTK22VPjYFoPFfH6cU1R3eKhbHkoOcNosBrc9GYix0kyeGyZ+r7pG+543oC
         1mTQ==
X-Gm-Message-State: APjAAAVdUqw2OdxfNaKanbjOX+xCLOKVb0puFF7bnRcbdMx2Iav2npNO
        M+jOu0wy05ZZJkmQD1c7epukMYkOeRhSmLBTY35jJA==
X-Google-Smtp-Source: APXvYqxUK4CXo1PSxZL0K6TwnIt+O4gKyM24+nKJY/xOhFN0YFBbgoi2kUkZs4sv0uW6KkhridDbcJDYKzl6r6KkDqQ=
X-Received: by 2002:a2e:2b8f:: with SMTP id r15mr32732ljr.210.1562272232034;
 Thu, 04 Jul 2019 13:30:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190704181235.8966-1-saeedm@mellanox.com> <20190704181235.8966-15-saeedm@mellanox.com>
 <20190704131237.239bfa56@cakuba.netronome.com>
In-Reply-To: <20190704131237.239bfa56@cakuba.netronome.com>
From:   Saeed Mahameed <saeedm@dev.mellanox.co.il>
Date:   Thu, 4 Jul 2019 16:30:21 -0400
Message-ID: <CALzJLG_qF=Yv58_EpV0bRm8_=Kn2AtsOywDDMjhwxSUOW44EAQ@mail.gmail.com>
Subject: Re: [net-next 14/14] net/mlx5e: Add kTLS TX HW offload support
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 4, 2019 at 4:12 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Thu, 4 Jul 2019 18:16:15 +0000, Saeed Mahameed wrote:
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> > index 483d321d2151..6854f132d505 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> > @@ -50,6 +50,15 @@ static const struct counter_desc sw_stats_desc[] = {
> >  #ifdef CONFIG_MLX5_EN_TLS
> >       { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_ooo) },
> >       { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_resync_bytes) },
> > +
> > +     { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ooo) },
>
> Why do you call this stat tx_ktls_ooo, and not tx_tls_ooo (extra 'k')?
>
> For nfp I used the stats' names from mlx5 FPGA to make sure we are all
> consistent.  I've added them to the tls-offload.rst doc and Boris has
> reviewed it.
>
>  * ``rx_tls_decrypted`` - number of successfully decrypted TLS segments
>  * ``tx_tls_encrypted`` - number of in-order TLS segments passed to device
>    for encryption
>  * ``tx_tls_ooo`` - number of TX packets which were part of a TLS stream
>    but did not arrive in the expected order
>  * ``tx_tls_drop_no_sync_data`` - number of TX packets dropped because
>    they arrived out of order and associated record could not be found
>
> Why can't you use the same names for the stats as you used for your mlx5
> FPGA?
>

Actually i agree here, I asked tariq to have FPGA TLS and new mlx5
embedded TLS  mutually exclusive.
so there shouldn't be any reason to have new counter names for non FPGA tls.

> > +     { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ooo_drop_no_sync_data) },
> > +     { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ooo_drop_bypass_req) },
> > +     { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ooo_dump_bytes) },
> > +     { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ooo_dump_packets) },
> > +     { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_enc_packets) },
> > +     { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_enc_bytes) },
> > +     { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ctx) },
> >  #endif
> >
> >       { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_lro_packets) },
>
> Dave, please don't apply this, I will review in depth once I get
> through the earlier 200 emails ;)

Jakub can you please expedite ?
Dave if it is ok with you i will re-spin and push a  new pull request
with  mlx5-next dependencies + 2 Devlink fw version patches,
and independently, i will post the TLS series for Jakub to review ?
