Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506A62E2544
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 08:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgLXHiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 02:38:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgLXHiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 02:38:09 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DD2C061282
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 23:37:29 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id z11so1527572qkj.7
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 23:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7S1VNj0uTb/MJfvKq1LUlvfvpbeOc2dUFGeGmoStAm8=;
        b=y2mAMKLBvkKfyhdrzexVASAiK4vVWCJCZ1hJFltArLr3X1Jhz324nsnHE0Wxu7AGxF
         WIJhWKqkDLQKQjswtS0LBcPfkDId7FmhXya+y9k0gjUCuVMvutc9Ow/zxNrd8e+HmCEd
         /cTqjKf9/xenfIRkxwMQkoR8gmSpIrFtVSqzv4szfTC7xVKInGpy69Sfy7rbYzp+SOdW
         DqJhOaoIPepTc7To14a5hcr0B4fwSjruYLh0zcEY9H0C5SiNhgsXDRp4HjrVnXccHMz9
         qEh8HOWFDuCC2ayKu8FDr9fevYARazKo7YQLnxKInxu94x4Py+fTPWLRSlT3/E3TuOzl
         f6QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7S1VNj0uTb/MJfvKq1LUlvfvpbeOc2dUFGeGmoStAm8=;
        b=nUhPNoRDS7p1U9b+Q5d2lleUsCL3Q2e9IZblO945ritH8UHIMtcY/YpOqGX6dnnA+7
         swISclbp76o1wcn1zILy19H0RDtwt0e2qnXUhdcGRNm9PtEZig1Zo2jTfA2wfaSaXN/x
         RCzCuHAS0Zb8DxwH5kGkCKRobCytbY6u6kQMydqdgs7muxLmGR/j1mSj8I6kzZtU2wFm
         f02x3Pxj8HBBITv2KuXbmz2aOHS+gavAWHtV/AFYr2VgXA6NAO1Mh9H5SB6Bu1Xc11JF
         o/FiPI6Ix1q+iGit3tSkJHTZocUOeI31DCJSaVjcIS/6vvuCiK9E1r2ZXVNoF9n2cupa
         pKZg==
X-Gm-Message-State: AOAM532kWYeAuzzbEfwRmbMlYyVWF5T6McTwCDniyT0lZjod0VAqny/x
        sn5Deegx9LeWrIgSpZ+bargeJrQj1K7NIlJ8lYFUpA==
X-Google-Smtp-Source: ABdhPJzQQ4GzEZTmGKjmIbLIe0upxe08WCOP6ndJIIbMwHsp06H66JTTLqM7gjsRc84WYR0Wz7EQdFZ/EVzv53erssA=
X-Received: by 2002:a37:7981:: with SMTP id u123mr21185427qkc.360.1608795448285;
 Wed, 23 Dec 2020 23:37:28 -0800 (PST)
MIME-Version: 1.0
References: <cover.1608670965.git.lorenzo@kernel.org>
In-Reply-To: <cover.1608670965.git.lorenzo@kernel.org>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 24 Dec 2020 08:37:17 +0100
Message-ID: <CAPv3WKd-OFco5E56RtzO3QgJg-b5+s7ukVazUYSOtNBczQOViw@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 0/2] introduce xdp_init_buff/xdp_prepare_buff
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, Jesper Dangaard Brouer <brouer@redhat.com>,
        lorenzo.bianconi@redhat.com, alexander.duyck@gmail.com,
        maciej.fijalkowski@intel.com, saeed@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo,


wt., 22 gru 2020 o 22:13 Lorenzo Bianconi <lorenzo@kernel.org> napisa=C5=82=
(a):
>
> Introduce xdp_init_buff and xdp_prepare_buff utility routines to initiali=
ze
> xdp_buff data structure and remove duplicated code in all XDP capable
> drivers.
>
> Changes since v4:
> - fix xdp_init_buff/xdp_prepare_buff (natural order is xdp_init_buff() fi=
rst
>   and then xdp_prepare_buff())
>
> Changes since v3:
> - use __always_inline instead of inline for xdp_init_buff/xdp_prepare_buf=
f
> - add 'const bool meta_valid' to xdp_prepare_buff signature to avoid
>   overwriting data_meta with xdp_set_data_meta_invalid()
> - introduce removed comment in bnxt driver
>
> Changes since v2:
> - precompute xdp->data as hard_start + headroom and save it in a local
>   variable to reuse it for xdp->data_end and xdp->data_meta in
>   xdp_prepare_buff()
>
> Changes since v1:
> - introduce xdp_prepare_buff utility routine
>
> Lorenzo Bianconi (2):
>   net: xdp: introduce xdp_init_buff utility routine
>   net: xdp: introduce xdp_prepare_buff utility routine
>
> Acked-by: Shay Agroskin <shayagr@amazon.com>
> Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
> Acked-by: Camelia Groza <camelia.groza@nxp.com>
>

For Marvell mvpp2:
Acked-by: Marcin Wojtas <mw@semihalf.com>

Thanks,
Marcin
