Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3082A3262
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 18:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgKBRzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 12:55:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:37158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725817AbgKBRzA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 12:55:00 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2824221D91;
        Mon,  2 Nov 2020 17:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604339699;
        bh=8/mUrAxnZZrM1RFaXGsbb/nCz+p4v9A2HQqXXh5kCvc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kIcYCVy4ADziEoDl32si94cKoiihbeDvIFkg1X2O1UyiRXcj1mZ3uQsKt58dg5Ypr
         cukYTY9HbZhq4NAmX4tFEG4Ra5cdaHpU9ZRAw7uHtqFO2StHpbkaN6h7tl0f4ZeajE
         58M/lY+CLlp6Nu9u1nlS/1ksxdwq9AaM2ix/cGoo=
Date:   Mon, 2 Nov 2020 09:54:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Naveen Mamindlapalli <naveenm@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>,
        Tomasz Duszynski <tduszynski@marvell.com>
Subject: Re: [PATCH net-next 10/13] octeontx2-pf: Add support for SR-IOV
 management functions
Message-ID: <20201102095458.024ab1e9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201102061122.8915-11-naveenm@marvell.com>
References: <20201102061122.8915-1-naveenm@marvell.com>
        <20201102061122.8915-11-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Nov 2020 11:41:19 +0530 Naveen Mamindlapalli wrote:
> This patch adds support for ndo_set_vf_mac, ndo_set_vf_vlan
> and ndo_get_vf_config handlers. The traffic redirection
> based on the VF mac address or vlan id is done by installing
> MCAM rules. Reserved RX_VTAG_TYPE7 in each NIXLF for VF VLAN
> which strips the VLAN tag from ingress VLAN traffic. The NIX PF
> allocates two MCAM entries for VF VLAN feature, one used for
> ingress VTAG strip and another entry for egress VTAG insertion.
>=20
> This patch also updates the MAC address in PF installed VF VLAN
> rule upon receiving nix_lf_start_rx mbox request for VF since
> Administrative Function driver will assign a valid MAC addr
> in nix_lf_start_rx function.
>=20
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> Co-developed-by: Tomasz Duszynski <tduszynski@marvell.com>
> Signed-off-by: Tomasz Duszynski <tduszynski@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>

drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c:2097:31: warning: cast=
 to restricted __be16
drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c:2097:31: warning: cast=
 to restricted __be16
drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c:2097:31: warning: cast=
 to restricted __be16
drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c:2097:31: warning: cast=
 to restricted __be16
drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c:2158:55: warning: inco=
rrect type in argument 5 (different base types)
drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c:2158:55:    expected u=
nsigned short [usertype] proto
drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c:2158:55:    got restri=
cted __be16 [usertype] proto
203a211,214
drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c: In function =E2=80=
=98npc_update_dmac_value=E2=80=99:
drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c:1236:24: warning: im=
plicit conversion from =E2=80=98enum header_fields=E2=80=99 to =E2=80=98enu=
m key_fields=E2=80=99 [-Wenum-conversion]
 1236 |  npc_update_entry(rvu, NPC_DMAC, entry,
      |                        ^~~~~~~~
