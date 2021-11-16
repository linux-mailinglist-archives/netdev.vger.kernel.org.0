Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328ED4527C0
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 03:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243806AbhKPCbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 21:31:37 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:36188 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S242639AbhKPC3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 21:29:35 -0500
X-UUID: baf703149f4441858234c0962757ad8f-20211116
X-UUID: baf703149f4441858234c0962757ad8f-20211116
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 380987042; Tue, 16 Nov 2021 10:26:35 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 16 Nov 2021 10:26:34 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 16 Nov 2021 10:26:33 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     <dsahern@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <Rocco.Yue@gmail.com>,
        <chao.song@mediatek.com>, <zhuoliang.zhang@mediatek.com>,
        Rocco Yue <rocco.yue@mediatek.com>
Subject: Re: [PATCH net-next] ipv6: don't generate link-local addr in random or privacy mode
Date:   Tue, 16 Nov 2021 10:21:45 +0800
Message-ID: <20211116022145.31322-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <de051ecb-0efe-27e2-217c-60a502f4415f@gmail.com>
References: <de051ecb-0efe-27e2-217c-60a502f4415f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Sun, 2021-11-14 at 00:34 +0800, David Ahern wrote:
>> On 11/13/21 1:46 AM, Rocco Yue wrote:
>> 
>> Gentle ping on this patch. :-)
>> 
> 
> you sent the patch in the merge window; I believe it has been dropped
> from patchworks.
>

Hi David,

Thanks for your reply.

Due to I can see this patch from the link below, I'm not sure why this
happened, could you kindly tell me what the merge window is, so I can
avoid such problem next time.
  https://lore.kernel.org/netdev/20211113084636.11685-1-rocco.yue@mediatek.com/t/
  https://lore.kernel.org/lkml/20211113084636.11685-1-rocco.yue@mediatek.com/T/

> Also, you did not add v2 (or whatever version this is) with a summary
> of
> changes between all versions, and you did not cc all the people who
> responded to previous versions.
> 

ok, I will resend a patch that meets the above requirements.

Thanks,

Rocco

