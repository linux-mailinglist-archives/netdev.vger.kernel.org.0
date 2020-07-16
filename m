Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B382226E0
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbgGPPXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 11:23:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728150AbgGPPXB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 11:23:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DAEB2063A;
        Thu, 16 Jul 2020 15:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594912980;
        bh=0KOsAGDlyjL10nw8GkoXdEM39Y7GR/xzRunce7+0ZM0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CalCSH68LxHalcZAFoeaS74Nol1NtkkX8+dmN1mffM92qmH13dMeQk/cvuRdVdv4S
         +PKtlwY+7VigrcBMItAaAVzOlnUG3uw+6jq1OqmU5RVJdaM3viMTuDwmeVyXYNKib9
         tEmj7rIH6JvrmJ3Ujf6TbyZcZgTzDtU0qrlHTgLo=
Date:   Thu, 16 Jul 2020 08:22:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <dsahern@gmail.com>,
        <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 9/9] bpf, xdp: remove XDP_QUERY_PROG and
 XDP_QUERY_PROG_HW XDP commands
Message-ID: <20200716082259.40600e03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200716045602.3896926-10-andriin@fb.com>
References: <20200716045602.3896926-1-andriin@fb.com>
        <20200716045602.3896926-10-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 21:56:01 -0700 Andrii Nakryiko wrote:
> Now that BPF program/link management is centralized in generic net_device
> code, kernel code never queries program id from drivers, so
> XDP_QUERY_PROG/XDP_QUERY_PROG_HW commands are unnecessary.
>=20
> This patch removes all the implementations of those commands in kernel, a=
long
> the xdp_attachment_query().
>=20
> This patch was compile-tested on allyesconfig.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c: In function =E2=80=98dpaa=
2_eth_xdp=E2=80=99:
drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2079:25: warning: unused v=
ariable =E2=80=98priv=E2=80=99 [-Wunused-variable]
 2079 |  struct dpaa2_eth_priv *priv =3D netdev_priv(dev);
      |                         ^~~~

