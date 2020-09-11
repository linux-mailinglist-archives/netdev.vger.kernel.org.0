Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE902665F9
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgIKRTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:19:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgIKO6X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 10:58:23 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EF6F22273;
        Fri, 11 Sep 2020 14:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599836236;
        bh=TK4U8owjl52oAep/pDQXHQZGNE3L6dqkJQwtQ8iqGU8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i7HsNsv+ShyWOmsroaXum+mewOIj3dzHNkvlz01wtgOTqV5SFwGGbdbW95QmZHe7+
         vp3de4CBDKDRovOkg7U1N0SesZ++sReSkqUzytWDxdyQGzTzgAXDFr/LT1JeuqZ0bf
         CT/5Vtc0fsyoeIxER4nIGScKG7BcyggVuPh1YDXE=
Date:   Fri, 11 Sep 2020 07:57:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH net-next] net/socket.c: Remove an unused header file
 <linux/if_frad.h>
Message-ID: <20200911075715.4e1e5649@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200911060720.81033-1-xie.he.0141@gmail.com>
References: <20200911060720.81033-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 23:07:20 -0700 Xie He wrote:
> This header file is not actually used in this file. Let's remove it.
>=20
> Information about this header file:
>=20
> This header file comes from the "Frame Relay" module at
>   drivers/net/wan/dlci.c
>=20
> The "Frame Relay" module is used by only one hardware driver, at:
>   drivers/net/wan/sdla.c
>=20
> Note that the "Frame Relay" module is different from and unrelated to the
> "HDLC Frame Relay" module at:
>   drivers/net/wan/hdlc_fr.c
>=20
> I think maybe we can deprecate the "Frame Relay" module because we already
> have the (newer) "HDLC Frame Relay" module.
>=20
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

net/socket.c:1032:6: warning: no previous prototype for =E2=80=98dlci_ioctl=
_set=E2=80=99 [-Wmissing-prototypes]
 1032 | void dlci_ioctl_set(int (*hook) (unsigned int, void __user *))
      |      ^~~~~~~~~~~~~~
net/socket.c:1032:6: warning: symbol 'dlci_ioctl_set' was not declared. Sho=
uld it be static?
