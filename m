Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C763093AF
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbhA3JtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:49:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:33780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233092AbhA3DIA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 22:08:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD03A64E1B;
        Sat, 30 Jan 2021 03:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611976059;
        bh=GejzH7uKnlSpHI4iUjEp0kfCfZ8IqzQMWAvcVg5TSAk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gqrUvrK0UjJKeqTISJCc+LnwYmRBXPiFdEyTnn+Ph645oX98/AzVLtWvH7HN0vfsn
         3/5nzfrf1Cwj7DyTXRLlNnlxLYHv2DQfPMtVDMF2cXRnAel5tvMFqWJp/0EoDb540H
         QXiqdy7phyM4u7+Bo9lZr+ElHgeuongOkM3L7GG3h/bNnFyjocdxYwlWoEo08oKlg+
         OfCGa4dlWtv9yWz96ndEVXDv7WRaHEKse/9+TiWFTmaSd6BhEKaIt3qEEpsiCn1uZk
         oM3p8ymKez6YmSok1bJdeimDqB97T/HTRrFv4uuQB4e1m3TfLPqbG215mKTMDYSgki
         Fy4nK8Bh70UVg==
Date:   Fri, 29 Jan 2021 19:07:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rocco Yue <rocco.yue@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>
Subject: Re: [PATCH net-next 2/2] net: ipv6: don't generate link local
 address on PUREIP device
Message-ID: <20210129190737.78834c9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210128055809.31199-1-rocco.yue@mediatek.com>
References: <20210128055809.31199-1-rocco.yue@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 13:58:09 +0800 Rocco Yue wrote:
> PUREIP device such as ccmni does not need kernel to generate
> link-local address in any addr_gen_mode, generally, it shall
> use the IPv6 Interface Identifier, as provided by the GGSN,
> to create its IPv6 link-ocal Unicast Address.
> 
> Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>

There is no ccmni driver in the tree - is this for non-upstream
driver?
