Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39AA397F8D
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 05:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhFBDaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 23:30:35 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:41729 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229593AbhFBDaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 23:30:35 -0400
X-UUID: 6dbe05f1bc844db29dd4987ffec5c7dc-20210602
X-UUID: 6dbe05f1bc844db29dd4987ffec5c7dc-20210602
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1566125578; Wed, 02 Jun 2021 11:28:48 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 2 Jun 2021 11:28:47 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Jun 2021 11:28:46 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     David Ahern <dsahern@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
        <rocco.yue@gmail.com>, Rocco Yue <rocco.yue@mediatek.com>
Subject: Re: [PATCH] ipv6: create ra_mtu proc file to only record mtu in RA
Date:   Wed, 2 Jun 2021 11:15:02 +0800
Message-ID: <20210602031502.31600-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <7087f518-f86e-58fb-6f32-a7cda77fb065@gmail.com>
References: <7087f518-f86e-58fb-6f32-a7cda77fb065@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-06-01 at 18:38 -0600, David Ahern wrote:
On 6/1/21 3:16 AM, Rocco Yue wrote:
> > For this patch set, if RA message carries the mtu option,
> > "proc/sys/net/ipv6/conf/<iface>/ra_mtu" will be updated to the
> > mtu value carried in the last RA message received, and ra_mtu
> > is an independent proc file, which is not affected by the update
> > of interface mtu value.
> 
> I am not a fan of more /proc/sys files.
> 
> You are adding it to devconf which is good. You can add another link
> attribute, e.g., IFLA_RA_MTU, and have it returned on link queries.
> 
> Make sure the attribute can not be sent in a NEWLINK or SETLINK request;
> it should be read-only for GETLINK.

Thanks for your review and advice.
Do you mean that I should keep the ra_mtu proc and add an another extra netlink msg?
Or only use netlink msg instead of ra_mtu proc?
I will do it.

Thanks,
Rocco
