Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A72B1266255
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 17:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgIKPlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 11:41:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726206AbgIKPi1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 11:38:27 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78C8A2073E;
        Fri, 11 Sep 2020 15:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599838706;
        bh=1TJNDk0xAOMjFGiWY1ZuK/p0447AYGrttVbGr6hFLps=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aMPq+EsPCqlwrEfENy02pSgs7cfmRMdwr//SfLBwWggO37sXei//myacnHRM70l38
         jOyCJGCTlbx8zre1H1varU1wNLs8e/LTu607QUBU5oNqsrM//QpBgsTLRV0+5rbqSt
         3fDMfRTPqS3hvQB8FqQtAi/DaUbrxVRSZrNA3ov4=
Date:   Fri, 11 Sep 2020 08:38:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo Jiaxing <luojiaxing@huawei.com>, <mcoquelin.stm32@gmail.com>
Cc:     <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: Re: [PATCH net-next] net: stmmac: set get_rx_header_len() as void
 for it didn't have any error code to return
Message-ID: <20200911083825.55eb2f49@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1599796558-45818-1-git-send-email-luojiaxing@huawei.com>
References: <1599796558-45818-1-git-send-email-luojiaxing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Sep 2020 11:55:58 +0800 Luo Jiaxing wrote:
> We found the following warning when using W=3D1 to build kernel:
>=20
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:3634:6: warning: variab=
le =E2=80=98ret=E2=80=99 set but not used [-Wunused-but-set-variable]
> int ret, coe =3D priv->hw->rx_csum;
>=20
> When digging stmmac_get_rx_header_len(), dwmac4_get_rx_header_len() and
> dwxgmac2_get_rx_header_len() return 0 only, without any error code to
> report. Therefore, it's better to define get_rx_header_len() as void.
>=20
> Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
