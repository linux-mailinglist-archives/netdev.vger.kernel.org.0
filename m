Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39117289D44
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 03:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730003AbgJJBxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 21:53:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729890AbgJJBsq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 21:48:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 684B22225B;
        Sat, 10 Oct 2020 01:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602294524;
        bh=+S4AwTVejzLXJQ+REMHSCNgbnBALyU0EGIeco38/zZ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=03tBycevUxykUwNbMejZ6wE7ARX7Bm9b44UkxhcspblbFUhLZ/tgXJtlaY9ydLyIs
         jR+FnGLMs799rX9H06D019SOFDMGc3a/7LS4pQPZ2uiRL1e12LnijBk3syK1k7f6yM
         h8PAwiTAcRSF4SO+CozR0/qZcI9AS4WljRAoGfAc=
Date:   Fri, 9 Oct 2020 18:48:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, hemantk@codeaurora.org,
        netdev@vger.kernel.org, manivannan.sadhasivam@linaro.org
Subject: Re: [PATCH] net: Add mhi-net driver
Message-ID: <20201009184842.0efa8db7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1602275611-7440-1-git-send-email-loic.poulain@linaro.org>
References: <1602275611-7440-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  9 Oct 2020 22:33:31 +0200 Loic Poulain wrote:
> This patch adds a new network driver implementing MHI transport for
> network packets. Packets can be in any format, though QMAP (rmnet)
> is the usual protocol (flow control + PDN mux).
>=20
> It support two MHI devices, IP_HW0 which is, the path to the IPA
> (IP accelerator) on qcom modem, And IP_SW0 which is the software
> driven IP path (to modem CPU).
>=20
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

Does not appear to build in net-next - presumably you have some
dependency in another tree?

make: *** [__sub-make] Error 2
../drivers/net/mhi_net.c: In function =E2=80=98mhi_net_probe=E2=80=99:
../drivers/net/mhi_net.c:234:8: error: too many arguments to function =E2=
=80=98mhi_prepare_for_transfer=E2=80=99
  234 |  err =3D mhi_prepare_for_transfer(mhi_dev, 0);
      |        ^~~~~~~~~~~~~~~~~~~~~~~~
In file included from ../drivers/net/mhi_net.c:8:
../include/linux/mhi.h:669:5: note: declared here
  669 | int mhi_prepare_for_transfer(struct mhi_device *mhi_dev);
      |     ^~~~~~~~~~~~~~~~~~~~~~~~
make[3]: *** [drivers/net/mhi_net.o] Error 1
make[2]: *** [drivers/net] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [drivers] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [__sub-make] Error 2
New errors added
