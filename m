Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54D42B4F02
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 19:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731944AbgKPSRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 13:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728871AbgKPSRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 13:17:21 -0500
Received: from latitanza.investici.org (latitanza.investici.org [IPv6:2001:888:2000:56::19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C76EFC0613CF;
        Mon, 16 Nov 2020 10:17:20 -0800 (PST)
Received: from mx3.investici.org (unknown [127.0.0.1])
        by latitanza.investici.org (Postfix) with ESMTP id 4CZcjp2T7Pz8sfb;
        Mon, 16 Nov 2020 18:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=privacyrequired.com;
        s=stigmate; t=1605550638;
        bh=uc1Wm5D0OU00srpljMegtsK6Y7/ABDMEJyUfoFFR/NU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hVbP4f96mHto7QeXLoyP5rmrzSTV/uFr8hBQCatAtR0/1dqVI0pRamCqF+7AsUyHf
         PXSM0LQKeL961lv/AtaJXO2ZbByZpZLc0jtptmbRpraPkO/VkyIPvWmaU+13J/0WG9
         V2dCACFDVF492uMWh377fWD5xMyceeKtJHhfRwb8=
Received: from [82.94.249.234] (mx3.investici.org [82.94.249.234]) (Authenticated sender: laniel_francis@privacyrequired.com) by localhost (Postfix) with ESMTPSA id 4CZcjn5yPQz8sfZ;
        Mon, 16 Nov 2020 18:17:17 +0000 (UTC)
From:   Francis Laniel <laniel_francis@privacyrequired.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-hardening@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, keescook@chromium.org
Subject: Re: [RESEND,net-next,PATCH v5 0/3] Fix inefficiences and rename nla_strlcpy
Date:   Mon, 16 Nov 2020 19:17:17 +0100
Message-ID: <2952773.LrNCO7Tzqc@machine>
In-Reply-To: <20201116092247.608b4f0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201115170806.3578-1-laniel_francis@privacyrequired.com> <20201116092247.608b4f0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le lundi 16 novembre 2020, 18:22:47 CET Jakub Kicinski a =E9crit :
> On Sun, 15 Nov 2020 18:08:03 +0100 laniel_francis@privacyrequired.com
>=20
> wrote:
> > This patch set answers to first three issues listed in:
> > https://github.com/KSPP/linux/issues/110
> >=20
> > To sum up, the patch contributions are the following:
> > 1. the first patch fixes an inefficiency where some bytes in dst were
> > written twice, one with 0 the other with src content.
> > 2. The second one modifies nla_strlcpy to return the same value as
> > strscpy,
> > i.e. number of bytes written or -E2BIG if src was truncated.
> > It also modifies code that calls nla_strlcpy and checks for its return
> > value. 3. The third renames nla_strlcpy to nla_strscpy.
> >=20
> > Unfortunately, I did not find how to create struct nlattr objects so I
> > tested my modifications on simple char* and with GDB using tc to get to
> > tcf_proto_check_kind.
> >=20
> > If you see any way to improve the code or have any remark, feel free to
> > comment.
> >=20
> >=20
> > Best regards and take care of yourselves.
>=20
> Applied, thank you!

Perfect! You are welcome!



