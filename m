Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8EC52605FF
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 22:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgIGU6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 16:58:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726853AbgIGU6p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 16:58:45 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 561CA215A4;
        Mon,  7 Sep 2020 20:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599512324;
        bh=XXdJdrXSDXXRuKqiD07l3whQ+kMfrHo1hVSzCvy3FBU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f6w0qWtwCnfg0gdQDKslSFNp8X6yyTJYQ0jJMUW7IVqQp+HyMVb+7MHVpr6tZgfFu
         530Ri/dV1aaN2AuwAX8veEqNb975usJT5jVm5bPMRHqQye6Q8zy6/P5APn6e/aRgVg
         QEpRYUxy8eRfCoIkG8vBbLqfNWrr+fJBg/wpMN+k=
Date:   Mon, 7 Sep 2020 13:58:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     <davem@davemloft.net>, <f.fainelli@gmail.com>, <timur@kernel.org>,
        <zhengdejin5@gmail.com>, <hkallweit1@gmail.com>, <leon@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: ethernet: dnet: Remove set but unused
 variable 'len'
Message-ID: <20200907135842.38f0c211@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200907141207.11778-1-wanghai38@huawei.com>
References: <20200907141207.11778-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Sep 2020 22:12:07 +0800 Wang Hai wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
>=20
> drivers/net/ethernet/dnet.c: In function dnet_start_xmit
> drivers/net/ethernet/dnet.c:511:15: warning: variable =E2=80=98len=E2=80=
=99 set but not used [-Wunused-but-set-variable]
>=20
> commit 4796417417a6 ("dnet: Dave DNET ethernet controller driver (updated=
)")
> involved this unused variable, remove it.
>=20
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

tx_status is also not used. But I guess one change per commit,=20
so applied. Thanks!
