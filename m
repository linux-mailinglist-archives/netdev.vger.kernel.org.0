Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F51C3DEDAC
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 14:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235782AbhHCMOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 08:14:49 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:59112 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S234524AbhHCMOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 08:14:48 -0400
X-UUID: 7f656b4bb18d4a438c61284aaf3787e5-20210803
X-UUID: 7f656b4bb18d4a438c61284aaf3787e5-20210803
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 709433756; Tue, 03 Aug 2021 20:14:35 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 3 Aug 2021 20:14:33 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 3 Aug 2021 20:14:33 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     David Ahern <dsahern@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <rocco.yue@gmail.com>,
        <chao.song@mediatek.com>, <zhuoliang.zhang@mediatek.com>,
        Rocco Yue <rocco.yue@mediatek.com>
Subject: Re: [PATCH net-next v2] ipv6: add IFLA_INET6_RA_MTU to expose mtu value in the RA message
Date:   Tue, 3 Aug 2021 19:57:59 +0800
Message-ID: <20210803115759.4342-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <f66750af-cbda-6d49-2b39-860c10357e95@gmail.com>
References: <f66750af-cbda-6d49-2b39-860c10357e95@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-08-02 at 07:35 -0600, David Ahern wrote:
> On 8/2/21 6:40 AM, Rocco Yue wrote:
>> 
>> Regarding setting "reject_message" in the policy, after reviewing
>> the code, I fell that it is unnecessary, because the cost of
>> implementing it seems to be a bit high, which requires modifying
>> the function interface. The reasons is as follows:
> 
> The policy can be setup now to do the right thing once the extack
> argument is available.
> 
> do_setlink() has an extack argument. It calls validate_linkmsg which
> calls validate_link_af meaning support can be added in a single patch.
> If you decide to do it, then it should be a separate patch preceding
> this one.
> 

Hi David,

Thanks for your advice,
I will send a separate patch to add extack arg firstly.

> Then userspace should get a link notification when ra_mtu is set so it
> does not have to poll.

It make sense, I will do it.

Thanks
Rocco
