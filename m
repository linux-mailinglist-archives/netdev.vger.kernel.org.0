Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7BC41CC01
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 20:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346310AbhI2SkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 14:40:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346308AbhI2SkA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 14:40:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E5D861216;
        Wed, 29 Sep 2021 18:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632940699;
        bh=D1OW1odBQV/5U8jRZ04+ORhf0sZ+4cKzL42iq1jdVe8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rUVPB0YavgvNxSo4VHX6JeqndeB7O8eFEN8fEguCnEqY+Zbk7z0ekW+3VS0PrSVss
         +1btiZtII4sWf3qTGqwLJUEEZrctsSUL+09b0ko94/3lWDMyGKPnjZuzt60TnKrznT
         d4NJs8lV5vvSrNaYZszzvDhrwETdLcTXXFpL/31FIs5zWW3zkQKUXfSA0jKXqrNiJU
         eGzloGW0iwnSmSxAnen08lVBJnxV9yTCyIHuoy6+VcfakPNmqf/nf0tERjh9ddcjHY
         ZfW8iUOVbwlCTzVM3ZEg/pwdUPYdXn9tkm6ihCK/Wk+mb2k5/V1q6v4/GawsZJ4feA
         s3cSYELdS662g==
Date:   Wed, 29 Sep 2021 11:38:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Prabhakar Kushwaha <pkushwaha@marvell.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <linux-rdma@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <aelior@marvell.com>,
        <smalin@marvell.com>, <jhasan@marvell.com>,
        <mrangankar@marvell.com>, <prabhakar.pkin@gmail.com>,
        <malin1024@gmail.com>, Omkar Kulkarni <okulkarni@marvell.com>
Subject: Re: [PATCH 04/12] qed: Update qed_mfw_hsi.h for FW ver 8.59.1.0
Message-ID: <20210929113817.06da736a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210929121215.17864-5-pkushwaha@marvell.com>
References: <20210929121215.17864-1-pkushwaha@marvell.com>
        <20210929121215.17864-5-pkushwaha@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Sep 2021 15:12:07 +0300 Prabhakar Kushwaha wrote:
> The qed_mfw_hsi.h contains HSI (Hardware Software Interface) changes
> related to management firmware. It has been updated to support new FW
> version 8.59.1.0 with below changes.
>  - New defines for VF bitmap.
>  - fec_mode and extended_speed defines updated in struct eth_phy_cfg.
>  - Updated structutres lldp_system_tlvs_buffer_s, public_global,
>    public_port, public_func, drv_union_data, public_drv_mb
>    with all dependent new structures.
>  - Updates in NVM related structures and defines.
>  - Msg defines are added in enum drv_msg_code and fw_msg_code.
>  - Updated/added new defines.
>=20
> This patch also fixes the existing checkpatch warnings and few important
> checks.
>=20
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>

drivers/net/ethernet/qlogic/qed/qed_main.c:102:18: warning: =E2=80=98qed_mf=
w_ext_20g=E2=80=99 defined but not used [-Wunused-const-variable=3D]
  102 | static const u32 qed_mfw_ext_20g[] __initconst =3D {
      |                  ^~~~~~~~~~~~~~~


Plus you add a whole bunch on kdoc warnings with those patches.
Please make sure no new kdoc warnings and no new compilation warnings
(with C=3D1 W=3D1 flags!)
