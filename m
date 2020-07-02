Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34D92129D2
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 18:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgGBQiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 12:38:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726892AbgGBQiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 12:38:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 159BE207D4;
        Thu,  2 Jul 2020 16:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593707901;
        bh=SnvR6YCEdGhse12Lv18aXcm8R8v5i42+tIGHaNzBsQc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S4oL1qIq6MAnZTsorO8YKXKva9BNzqtYJl9yG8yhqSrABqKc4070dVq0/mDnBRFor
         v7fflKSzpM1GJP0NpLiCqqOBeieEFpPci2joQO/xsmBbtz3ruRTYoDMo63VH5Sflv7
         nLtRsSoeK1WBDHUQdjX+nQNNXtANvBsmaTCj9QeQ=
Date:   Thu, 2 Jul 2020 09:38:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <aelior@marvell.com>, <irusskikh@marvell.com>,
        <mkalderon@marvell.com>
Subject: Re: [PATCH net-next 2/4] bnx2x: Populate database for Idlechk
 tests.
Message-ID: <20200702093819.195ed0e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1593699029-18937-3-git-send-email-skalluru@marvell.com>
References: <1593699029-18937-1-git-send-email-skalluru@marvell.com>
        <1593699029-18937-3-git-send-email-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Jul 2020 19:40:27 +0530 Sudarsana Reddy Kalluru wrote:
> This patch populates the database of idlecck tests (registers and
> predicates) used in the idlechk dump implementation.
>=20
> Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>

drivers/net/ethernet/broadcom/bnx2x/bnx2x_self_test.c:114:18: warning: symb=
ol 'st_database' was not declared. Should it be static?
In file included from ../drivers/net/ethernet/broadcom/bnx2x/bnx2x_self_tes=
t.c:4:
drivers/net/ethernet/broadcom/bnx2x/bnx2x.h:2433:18: warning: =E2=80=98dmae=
_reg_go_c=E2=80=99 defined but not used [-Wunused-const-variable=3D]
 2433 | static const u32 dmae_reg_go_c[] =3D {
      |                  ^~~~~~~~~~~~~
