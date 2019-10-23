Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59302E1AAA
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 14:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390002AbfJWMeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 08:34:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389633AbfJWMeq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 08:34:46 -0400
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E84721906;
        Wed, 23 Oct 2019 12:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571834085;
        bh=3xClPV0s8v1ghovR/t6BdoidIe58oeMF5znszPjzKNA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=K+FVun+77VqMLQ8nGcATn/0yVi1n3inqEhcZQ4rc1jdyiC0PppVQiJ4PjjMWOeePi
         R5cWGYkK6sklP/GF/ctr02RjRgDoGLhJ2YMCyRcPSWJegkegNIcZ4HLkDeMlK5mCAU
         XqBCMNPVp04XqBvWpTT/Lo3vtifZpJPKPEmbtCbY=
Received: by mail-qt1-f176.google.com with SMTP id t20so31960766qtr.10;
        Wed, 23 Oct 2019 05:34:45 -0700 (PDT)
X-Gm-Message-State: APjAAAWBTzWdKLusNjbjMhpPLVm4yhnVOfberGeOlBIlfY57bTJ75k5f
        BjngGOGhtL1z0hKV6F2b96FgvGtv87cotZMUas4=
X-Google-Smtp-Source: APXvYqyCz6o6W8wU2Uf+XdH/NAI350kbDLwzoeIzLourookteh+cPAzdgEuPCvwPhO3ppnfaxZ6DwridLx/5ufit4D0=
X-Received: by 2002:ac8:714c:: with SMTP id h12mr8873761qtp.231.1571834084324;
 Wed, 23 Oct 2019 05:34:44 -0700 (PDT)
MIME-Version: 1.0
References: <20191022140154.436-1-skalluru@marvell.com>
In-Reply-To: <20191022140154.436-1-skalluru@marvell.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Wed, 23 Oct 2019 08:34:32 -0400
X-Gmail-Original-Message-ID: <CA+5PVA7ka1ar1nX4TFhx0yJvm6i0+gPaZs8s5d667x4ksPjVFQ@mail.gmail.com>
Message-ID: <CA+5PVA7ka1ar1nX4TFhx0yJvm6i0+gPaZs8s5d667x4ksPjVFQ@mail.gmail.com>
Subject: Re: [PATCH linux-firmware] bnx2x: Add FW 7.13.15.0.
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc:     Linux Firmware <linux-firmware@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-scsi@vger.kernel.org,
        arahman@marvell.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 10:02 AM Sudarsana Reddy Kalluru
<skalluru@marvell.com> wrote:
>
> This patch adds new FW for bnx2x, which addresses the following issues:
> - TCP packet with padding can open TPA aggregation in GRO mode.
> - Tx Silent Drops could cause HW error when statistics is not enabled for client.
> - Transmission of tunneled packets over tx-only clients (with cos>0 in this case) followed by load/unload with DCB update (for instance), resulted in a Tx path halt.
> - FORWARD_SETUP ramrod yielded a FW assert (x_eth_fp_hsi_ver_invalid).
>
> The FW also adds support for direct update of RSS indirection table entry.
>
> Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Signed-off-by: Ameen Rahman <arahman@marvell.com>
> ---
>  WHENCE                       |   3 +++
>  bnx2x/bnx2x-e1-7.13.15.0.fw  | Bin 0 -> 170168 bytes
>  bnx2x/bnx2x-e1h-7.13.15.0.fw | Bin 0 -> 178608 bytes
>  bnx2x/bnx2x-e2-7.13.15.0.fw  | Bin 0 -> 323360 bytes
>  4 files changed, 3 insertions(+)
>  create mode 100644 bnx2x/bnx2x-e1-7.13.15.0.fw
>  create mode 100644 bnx2x/bnx2x-e1h-7.13.15.0.fw
>  create mode 100644 bnx2x/bnx2x-e2-7.13.15.0.fw

Applied and pushed out.

josh
