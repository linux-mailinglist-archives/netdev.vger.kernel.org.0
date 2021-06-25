Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D343B3C8A
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 08:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbhFYGSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 02:18:37 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:57156 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230192AbhFYGSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 02:18:36 -0400
X-UUID: 81f0045238004a81bdd54952ca6ea636-20210625
X-UUID: 81f0045238004a81bdd54952ca6ea636-20210625
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 266820426; Fri, 25 Jun 2021 14:16:10 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 25 Jun 2021 14:16:03 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 25 Jun 2021 14:15:55 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <bpf@vger.kernel.org>,
        <wsd_upstream@mediatek.com>, <chao.song@mediatek.com>,
        <kuohong.wang@mediatek.com>, Rocco Yue <rocco.yue@mediatek.com>
Subject: Re: [PATCH 1/4] net: if_arp: add ARPHRD_PUREIP type
Date:   Fri, 25 Jun 2021 14:01:07 +0800
Message-ID: <20210625060107.14098-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <YNSDQbp/h/aadpmV@kroah.com>
References: <YNSDQbp/h/aadpmV@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Does changelog mean adding these details to the commit message ?
> 
> Yes please.
> 

will do.

> > > And are these user-visable flags documented in a man page or something
> > > else somewhere?  If not, how does userspace know about them?
> > > 
> > 
> > There are mappings of these device types value in the libc:
> > "/bionic/libc/kernel/uapi/linux/if_arp.h".
> > userspace can get it from here.
> 
> Yes, they will show up in a libc definition, but where is it documented
> in text form what the flag does?

Judging from the changes of ARPHRD_xxx submitted before, I am sorry
I could not find the corresponding doucuments to describe their 
respective behaviors in details. Perhaps the best way to understand
their behaviors is to read the code directly.

Thanks,
Rocco

