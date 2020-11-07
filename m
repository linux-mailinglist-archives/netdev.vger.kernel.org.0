Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F89F2AA747
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbgKGRqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:46:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727305AbgKGRqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 12:46:14 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D29B220878;
        Sat,  7 Nov 2020 17:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604771174;
        bh=qfZ3VmMYwVntgdcYb/LX3LnhnzFyi7oFus8Cl8eq+yI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q88sDzz6oM+Ef5DcBkyrpWq0FxdRHAMj7skajZDkCDsr/ub+5g7fCnlZWnOkTwtDl
         b1dqpnSq5vBcsDF6WsQVe/rXMU619oav/BghRvfZ+4RKiBz4N4TZjLQUAO7Z9Wxmh9
         Y19l9IX8B137vdXYK3szji8BLINXxGgQKjSzYEyY=
Date:   Sat, 7 Nov 2020 09:46:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH net-next 02/11] net: hns3: add support for 1us unit GL
 configuration
Message-ID: <20201107094613.261fe05b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604730681-32559-3-git-send-email-tanhuazhong@huawei.com>
References: <1604730681-32559-1-git-send-email-tanhuazhong@huawei.com>
        <1604730681-32559-3-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 7 Nov 2020 14:31:12 +0800 Huazhong Tan wrote:
> For device whose version is above V3(include V3), the GL
> configuration can set as 1us unit, so adds support for
> configuring this field.
>=20
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

Doesn't build.

drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c: In function =E2=80=98hn=
s3_check_gl_coalesce_para=E2=80=99:
drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c:1152:6: error: =E2=80=98=
ae_dev=E2=80=99 undeclared (first use in this function); did you mean =E2=
=80=98netdev=E2=80=99?
 1152 |  if (ae_dev->dev_version >=3D HNAE3_DEVICE_VERSION_V3)
      |      ^~~~~~
      |      netdev
drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c:1152:6: note: each undec=
lared identifier is reported only once for each function it appears in
make[6]: *** [drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.o] Error 1
make[5]: *** [drivers/net/ethernet/hisilicon/hns3] Error 2
make[4]: *** [drivers/net/ethernet/hisilicon] Error 2
make[4]: *** Waiting for unfinished jobs....
make[3]: *** [drivers/net/ethernet] Error 2
make[2]: *** [drivers/net] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [drivers] Error 2
make: *** [__sub-make] Error 2
