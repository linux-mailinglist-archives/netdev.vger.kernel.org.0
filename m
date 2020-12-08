Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBCA82D3467
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbgLHUj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:39:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:45014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgLHUj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:39:27 -0500
Date:   Tue, 8 Dec 2020 11:22:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607455347;
        bh=0hoIplBhL2TPhrhpgcVbMyxg8H17FzeKx+l9ZHZK0r0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=AWKrbTQP49oNKAXiA4uPh3YzudRhdOK14Op9O74N37SqW+g9n8py37Fjg9ZcDE9BO
         BQXmmkCblG5xxZsRRw2dKmrtR74Lad9VCDjL8LDjXJJJ146QpmEeQJ0git1MoPdvx7
         XyiGgrfsPs+1DgpppxLYzSeIbD02mekyJrsmoqdvA00S/hYdWEeHj58Q3GMV8iVLR9
         uoPXH5aVRB+3fOz47BK5NP7ZvRCpRnhdM7hae3PrfiEoq9ac3OyDdg8VFRGg3rHuBF
         QNg9zVqse7kSWdem9XkdflYKxVhVJ6OzcebjrjLGvE+acdPwDwSBirGe5Hgawjlse4
         3Ue1xNPo9ZraA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zou Wei <zou_wei@huawei.com>
Cc:     <saeedm@nvidia.com>, <leon@kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] net/mlx5_core: remove unused including
 <generated/utsrelease.h>
Message-ID: <20201208112226.1bb31229@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <1607343240-39155-1-git-send-email-zou_wei@huawei.com>
References: <1607343240-39155-1-git-send-email-zou_wei@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Dec 2020 20:14:00 +0800 Zou Wei wrote:
> Remove including <generated/utsrelease.h> that don't need it.
>=20
> Signed-off-by: Zou Wei <zou_wei@huawei.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_rep.c
> index 989c70c..82ecc161 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> @@ -30,7 +30,6 @@
>   * SOFTWARE.
>   */
> =20
> -#include <generated/utsrelease.h>
>  #include <linux/mlx5/fs.h>
>  #include <net/switchdev.h>
>  #include <net/pkt_cls.h>


drivers/net/ethernet/mellanox/mlx5/core/en_rep.c: In function =E2=80=98mlx5=
e_rep_get_drvinfo=E2=80=99:
drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:66:28: error: =E2=80=98UTS=
_RELEASE=E2=80=99 undeclared (first use in this function); did you mean =E2=
=80=98CSS_RELEASED=E2=80=99?
   66 |  strlcpy(drvinfo->version, UTS_RELEASE, sizeof(drvinfo->version));
      |                            ^~~~~~~~~~~
      |                            CSS_RELEASED
drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:66:28: note: each undeclar=
ed identifier is reported only once for each function it appears in
make[6]: *** [drivers/net/ethernet/mellanox/mlx5/core/en_rep.o] Error 1
make[5]: *** [drivers/net/ethernet/mellanox/mlx5/core] Error 2
make[4]: *** [drivers/net/ethernet/mellanox] Error 2
make[3]: *** [drivers/net/ethernet] Error 2
make[2]: *** [drivers/net] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [drivers] Error 2
make: *** [__sub-make] Error 2
