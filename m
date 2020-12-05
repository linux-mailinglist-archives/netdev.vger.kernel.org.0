Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF33B2CF8EC
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 03:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgLECWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 21:22:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:32894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgLECWy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 21:22:54 -0500
Date:   Fri, 4 Dec 2020 18:22:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607134934;
        bh=m4fv/GovOSRxqSKBEUYbjWPCH4hVjjssWeJUEQxQi24=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=fQkZat9jAKEvzSKDkuKQbyDKe1aAx0DvkydUGBT9VQSkVVhFqqfngeNYM51rfqnXP
         BeglzFiPf4QrRSVxB0QRebulwAM3dcvfpd9VLj15pCpUvkuY7hD8umkSAamGTm91Ro
         ZXDK8XoSCbQGp2CAGWUjrdiBzYdOW1DbF/QAwFgFb5qc6FIW5fGGcUwSQ+S6F+DvhO
         r3N7QAvZX4gT6K0G0+QUmNODc6Hw8WrcYYEg0zCfWYRdnGyI2+FqalShxObpunaXjL
         d+6e3HE/xwXGSBA0HgLKp3evFXuDL8nyk119RJ3MJExNhBt57h+c9J22kRQeWVn+ld
         TPDOvBISvsOTQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>,
        <huangdaode@huawei.com>, Guojia Liao <liaoguojia@huawei.com>
Subject: Re: [PATCH net-next 3/3] net: hns3: refine the VLAN tag handle for
 port based VLAN
Message-ID: <20201204182212.602b6c03@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <1606997936-22166-4-git-send-email-tanhuazhong@huawei.com>
References: <1606997936-22166-1-git-send-email-tanhuazhong@huawei.com>
        <1606997936-22166-4-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Dec 2020 20:18:56 +0800 Huazhong Tan wrote:
> tranmist

Please spell check the commit messages and comments.
