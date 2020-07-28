Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C60230E80
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 17:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731145AbgG1Px6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 11:53:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731040AbgG1Px5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 11:53:57 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C89CE2065C;
        Tue, 28 Jul 2020 15:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595951637;
        bh=gWJFQ7KbXU4CB3E5IPadofiuBeWM1QedR1jU6yv1biM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=heA20mt5mf/z6pFz72zn89Qr++Gzwv2c4eygc0T76bA2GbHXJl+94jkV9+XbuLMGE
         zm3Z3xbwiQzuP8FngT8FZuTQDC4SvJ77wBYuyG4jb1KRSbC7Oaehy1+JH169usMnVB
         ouDqP4k17TtZIOLH/o8P9w/kx5JswzclkDTAPBjI=
Date:   Tue, 28 Jul 2020 08:53:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     linux-mediatek@lists.infradead.org,
        Landen Chao <landen.chao@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>
Subject: Re: [PATCH v3] net: ethernet: mtk_eth_soc: fix mtu warning
Message-ID: <20200728085355.7de7c14e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200728122743.78489-1-frank-w@public-files.de>
References: <20200728122743.78489-1-frank-w@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jul 2020 14:27:43 +0200 Frank Wunderlich wrote:
> From: Landen Chao <landen.chao@mediatek.com>

Hi gents,

if the patch is from Landen we need his sign-off on it.

> in recent Kernel-Versions there are warnings about incorrect MTU-Size
> like these:
>=20
> eth0: mtu greater than device maximum
> mtk_soc_eth 1b100000.ethernet eth0: error -22 setting MTU to include DSA =
overhead
>=20
> Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
> Fixes: 72579e14a1d3 ("net: dsa: don't fail to probe if we couldn't set th=
e MTU")
> Fixes: 7a4c53bee332 ("net: report invalid mtu value via netlink extack")
> Signed-off-by: Ren=C3=A9 van Dorst <opensource@vdorst.com>
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>

