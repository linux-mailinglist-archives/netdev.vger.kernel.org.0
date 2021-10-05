Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDEDD421CF3
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 05:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbhJED0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 23:26:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232164AbhJED0T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 23:26:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E7586140A;
        Tue,  5 Oct 2021 03:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633404270;
        bh=laRg3KPWKyFjqTSczNcZ9YhAyw4MU2cJfvWv/ZhBpN0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O05M2kThbWNVvyIlhZCeVDSXIWrsegaxeNdZ8QvvkorK8w4n6GzmBWsdDKtvx7Cxs
         fXtbHwRQIwgKCKQIBR7UChOfUCNAMa8MiiG9ox4I2HwzyyeVxGZwNweYPPteagHl+B
         5QL1sBTBE/3xBOTyG+zyw5psX7iNv5D3aPgBM8Tl8bIyv0rkSw7lUpKIxeL4PDZCMf
         3Irx1odG69PB2faqUcXWiDEC40ZpBomKe6ITX1WWJV2NYO5b+T4TGWrqDPkOqBZofu
         TxlIgdiZE3mxh84z/WUxSjOoXWJki2sZcc2oMwzAILCVb2SlDyRvdoLJ8fA/M+DB3q
         Q0e3PuyoarGtw==
Date:   Tue, 5 Oct 2021 11:24:23 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Marcel Ziswiler <marcel@ziswiler.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Fabio Estevam <festevam@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andreas Kemnade <andreas@kemnade.info>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Otavio Salvador <otavio@ossystems.com.br>,
        Pascal Zimmermann <pzimmermann@dh-electronics.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 6/9] ARM: imx_v6_v7_defconfig: enable bpf syscall and
 cgroup bpf
Message-ID: <20211005032422.GE20743@dragon>
References: <20210920144938.314588-1-marcel@ziswiler.com>
 <20210920144938.314588-7-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920144938.314588-7-marcel@ziswiler.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 04:49:35PM +0200, Marcel Ziswiler wrote:
> From: Marcel Ziswiler <marcel.ziswiler@toradex.com>
> 
> Enable CONFIG_BPF_SYSCALL and CONFIG_CGROUP_BPF to allow for systemd
> interoperability. This avoids the following failure on boot:
> 
> [   10.615914] systemd[1]: system-getty.slice: unit configures an IP
>  firewall, but the local system does not support BPF/cgroup firewalling.
> 
> Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
> Reviewed-by: Fabio Estevam <festevam@gmail.com>

Applied, thanks!
