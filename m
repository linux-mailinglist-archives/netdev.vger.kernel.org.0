Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACD62042E0
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 23:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730745AbgFVVq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 17:46:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730594AbgFVVq6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 17:46:58 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFC2F2075A;
        Mon, 22 Jun 2020 21:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592862417;
        bh=XrZl/vVQWaiQPTxpVNlEe6VlmB1jEXGxRHg5FbzoxMA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JDnfB2iRafLkgHmRvlGUj0k+vNxNQMs1lY12U9FapM45OcfpQ76IL/Giv/l25E2FZ
         RAhb0WYRnxr0zEXRKpZWhmF1JVEC31xtyGrpy44Q0hhtahRqygF5D6QZ0U7KHZvQrs
         D6tgJV6OuXsqQ942GYVhLixo4yijI9jaQchrv59g=
Date:   Mon, 22 Jun 2020 14:46:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florinel Iordache <florinel.iordache@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, corbet@lwn.net,
        shawnguo@kernel.org, leoyang.li@nxp.com, madalin.bucur@oss.nxp.com,
        ioana.ciornei@nxp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/7] net: phy: add backplane kr driver
 support
Message-ID: <20200622144655.49ee2fe2@kicinski-fedora-PC1C0HJN>
In-Reply-To: <1592832924-31733-5-git-send-email-florinel.iordache@nxp.com>
References: <1592832924-31733-1-git-send-email-florinel.iordache@nxp.com>
        <1592832924-31733-5-git-send-email-florinel.iordache@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Jun 2020 16:35:21 +0300 Florinel Iordache wrote:
> Add support for backplane kr generic driver including link training
> (ieee802.3ap/ba) and fixed equalization algorithm
>=20
> Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>

drivers/net/phy/backplane/backplane.c:60:11: warning: symbol 'backplane_com=
mon_features_array' was not declared. Should it be static?
drivers/net/phy/backplane/backplane.c:66:11: warning: symbol 'backplane_pro=
tocol_features_array' was not declared. Should it be static?
drivers/net/phy/backplane/backplane.c:1204:40: warning: incorrect type in a=
ssignment (different address spaces)
drivers/net/phy/backplane/backplane.c:1204:40:    expected void *[assigned]=
 reg_base
drivers/net/phy/backplane/backplane.c:1204:40:    got void [noderef] <asn:2=
> *reg_base
drivers/net/phy/backplane/backplane.c: In function =C3=A2=E2=82=AC=CB=9Cbp_=
kr_state_machine=C3=A2=E2=82=AC=E2=84=A2:
drivers/net/phy/backplane/backplane.c:590:27: warning: variable =C3=A2=E2=
=82=AC=CB=9Cbpdev=C3=A2=E2=82=AC=E2=84=A2 set but not used [-Wunused-but-se=
t-variable]
  590 |  struct backplane_device *bpdev;
      |                           ^~~~~
drivers/net/phy/backplane/link_training.c: In function =C3=A2=E2=82=AC=CB=
=9Clt_train_remote_tx=C3=A2=E2=82=AC=E2=84=A2:
drivers/net/phy/backplane/link_training.c:557:6: warning: variable =C3=A2=
=E2=82=AC=CB=9Clp_resp_time=C3=A2=E2=82=AC=E2=84=A2 set but not used [-Wunu=
sed-but-set-variable]
  557 |  u64 lp_resp_time;
      |      ^~~~~~~~~~~~
drivers/net/phy/backplane/link_training.c: In function =C3=A2=E2=82=AC=CB=
=9Clt_train_local_tx=C3=A2=E2=82=AC=E2=84=A2:
drivers/net/phy/backplane/link_training.c:1143:15: warning: variable =C3=A2=
=E2=82=AC=CB=9Cold_ld_status=C3=A2=E2=82=AC=E2=84=A2 set but not used [-Wun=
used-but-set-variable]
 1143 |  int request, old_ld_status;
      |               ^~~~~~~~~~~~~
