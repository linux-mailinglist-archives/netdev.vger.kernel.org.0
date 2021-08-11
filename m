Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229093E9AF1
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 00:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbhHKWb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 18:31:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232456AbhHKWb6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 18:31:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87ED26023F;
        Wed, 11 Aug 2021 22:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628721093;
        bh=cbLZhMCunRftN+0qtTxXu/Neje1zHLSrfulBju4+9Ks=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tTST61q4nb7YrADf99RiMpwdCqt0SRL6PLbj85WQP67Zr2jxaKlnmCS4b8sNF9zXS
         BS1ABZrNYcNS1iUUUK3yQNenN76qMvNnQr9VW4z2Ou5pxVml9DFisEnhTFbb17ZB+z
         asQfhVeB9Eel65oXIx0FJ0Dj9IylvuInMa1TUqlJWAdwcyRwuUWpV2ToAkS9tl5lTS
         8TXNd3CYrXjgu1Hx2JH871Ovyf0CLGf6w3LrPQj6mHAyRvW0fjaV/M/LuWksIY3iML
         E6+x4l1ZdPBFEOHpCHS82zMFUdxHxj1vE9B1viPp3eIfW/ccieFIF9Y5VXrm4Vv/6i
         6JD0LwkdWzxdQ==
Date:   Wed, 11 Aug 2021 15:31:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [PATCH net-next 1/2] net: sparx5: switchdev: adding frame DMA
 functionality
Message-ID: <20210811153132.63480934@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210811075909.543633-2-steen.hegelund@microchip.com>
References: <20210811075909.543633-1-steen.hegelund@microchip.com>
        <20210811075909.543633-2-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Aug 2021 09:59:08 +0200 Steen Hegelund wrote:
> This add frame DMA functionality to the Sparx5 platform.
>=20
> Ethernet frames can be extracted or injected autonomously to or from the
> device=E2=80=99s DDR3/DDR3L memory and/or PCIe memory space. Linked list =
data
> structures in memory are used for injecting or extracting Ethernet frames.
> The FDMA generates interrupts when frame extraction or injection is done
> and when the linked lists need updating.

Something to fix:

drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c: In function =E2=80=98s=
parx5_fdma_start=E2=80=99:
drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c:544:6: warning: variabl=
e =E2=80=98proc_ctrl=E2=80=99 set but not used [-Wunused-but-set-variable]
  544 |  u32 proc_ctrl;
      |      ^~~~~~~~~
